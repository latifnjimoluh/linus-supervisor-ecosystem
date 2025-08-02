const bcrypt = require("bcrypt");
const { Op } = require("sequelize");
const { User, Role } = require("../../models");

// 🔍 Voir tous les utilisateurs avec pagination/tri/filtre/recherche
exports.getAllUsers = async (req, res) => {
  try {
    const page = parseInt(req.query.page) || 1;
    const limit = parseInt(req.query.limit) || 10;
    const offset = (page - 1) * limit;
    const sort = req.query.sort || "created_at";
    const order = [[sort, req.query.order === "asc" ? "ASC" : "DESC"]];

    const where = {};
    if (req.query.role) where.role_id = req.query.role;
    if (req.query.status) where.status = req.query.status;
    if (req.query.q) {
      const q = req.query.q;
      where[Op.or] = [
        { first_name: { [Op.iLike]: `%${q}%` } },
        { last_name: { [Op.iLike]: `%${q}%` } },
        { email: { [Op.iLike]: `%${q}%` } },
      ];
    }

    const { count, rows } = await User.findAndCountAll({
      where,
      include: [{ model: Role, as: "role" }],
      order,
      limit,
      offset,
    });

    res.json({
      data: rows,
      pagination: {
        total: count,
        page,
        pages: Math.ceil(count / limit),
        limit,
      },
    });
  } catch (error) {
    console.error("Erreur récupération utilisateurs:", error);
    res
      .status(500)
      .json({ message: "Erreur serveur lors de la récupération des utilisateurs." });
  }
};

// 🔍 Voir un utilisateur par ID
exports.getUserById = async (req, res) => {
  const { id } = req.params;
  try {
    const user = await User.findByPk(id, {
      include: [{ model: Role, as: "role" }],
    });

    if (!user) return res.status(404).json({ message: "Utilisateur introuvable." });

    res.json(user);
  } catch (error) {
    console.error("Erreur récupération utilisateur:", error);
    res.status(500).json({ message: "Erreur serveur." });
  }
};

// 🔎 Recherche utilisateurs
exports.searchUsers = async (req, res) => {
  const { q } = req.query;
  if (!q) return res.status(400).json({ message: "Paramètre 'q' requis." });
  try {
    const users = await User.findAll({
      where: {
        [Op.or]: [
          { first_name: { [Op.iLike]: `%${q}%` } },
          { last_name: { [Op.iLike]: `%${q}%` } },
          { email: { [Op.iLike]: `%${q}%` } },
        ],
      },
      include: [{ model: Role, as: "role" }],
      order: [["created_at", "DESC"]],
    });
    res.json(users);
  } catch (error) {
    console.error("Erreur recherche utilisateurs:", error);
    res.status(500).json({ message: "Erreur serveur." });
  }
};

// ➕ Créer un utilisateur
exports.createUser = async (req, res) => {
  try {
    const {
      first_name,
      last_name,
      email,
      phone,
      password,
      role_id,
      status,
    } = req.body;

    if (!first_name || !last_name || !email || !password || !role_id) {
      return res.status(400).json({ message: "Champs requis manquants." });
    }

    const existing = await User.findOne({ where: { email } });
    if (existing)
      return res.status(400).json({ message: "Email déjà utilisé." });

    const hashedPassword = await bcrypt.hash(password, 10);

    const user = await User.create({
      first_name,
      last_name,
      email,
      phone,
      password: hashedPassword,
      role_id,
      status: status || "active",
    });

    res.status(201).json({ message: "Utilisateur créé avec succès", user });
  } catch (error) {
    console.error("Erreur création utilisateur:", error);
    res.status(500).json({ message: "Erreur serveur lors de la création." });
  }
};

// ✏️ Modifier un utilisateur
exports.updateUser = async (req, res) => {
  const { id } = req.params;
  const { first_name, last_name, phone, status, role_id } = req.body;

  try {
    const user = await User.findByPk(id);
    if (!user) return res.status(404).json({ message: "Utilisateur introuvable." });

    // Mise à jour autorisée uniquement sur ces champs
    user.first_name = first_name ?? user.first_name;
    user.last_name = last_name ?? user.last_name;
    user.phone = phone ?? user.phone;
    user.status = status ?? user.status;
    user.role_id = role_id ?? user.role_id;

    await user.save();
    res.json({ message: "Utilisateur mis à jour avec succès", user });
  } catch (error) {
    console.error("Erreur modification utilisateur:", error);
    res.status(500).json({ message: "Erreur serveur." });
  }
};

// 🩹 Mise à jour partielle
exports.patchUser = async (req, res) => {
  const { id } = req.params;
  try {
    const user = await User.findByPk(id);
    if (!user) return res.status(404).json({ message: "Utilisateur introuvable." });

    const allowed = ["first_name", "last_name", "phone", "status", "role_id"];
    allowed.forEach((field) => {
      if (req.body[field] !== undefined) {
        user[field] = req.body[field];
      }
    });

    await user.save();
    res.json({ message: "Utilisateur mis à jour avec succès", user });
  } catch (error) {
    console.error("Erreur patch utilisateur:", error);
    res.status(500).json({ message: "Erreur serveur." });
  }
};

// ❌ Suppression logique (status = inactif)
exports.softDeleteUser = async (req, res) => {
  const { id } = req.params;

  try {
    const user = await User.findByPk(id);
    if (!user) return res.status(404).json({ message: "Utilisateur introuvable." });

    user.status = "inactif";
    await user.save();

    res.json({ message: "Utilisateur désactivé (suppression logique) avec succès." });
  } catch (error) {
    console.error("Erreur suppression utilisateur:", error);
    res.status(500).json({ message: "Erreur serveur." });
  }
};
