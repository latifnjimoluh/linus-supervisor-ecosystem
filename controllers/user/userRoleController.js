const { Op } = require("sequelize");
const { Role } = require("../../models");

exports.getAllRoles = async (req, res) => {
  try {
    const page = parseInt(req.query.page) || 1;
    const limit = parseInt(req.query.limit) || 10;
    const offset = (page - 1) * limit;
    const sort = req.query.sort || "name";
    const direction = req.query.order === "desc" ? "DESC" : "ASC";
    const where = {};
    if (req.query.status) where.status = req.query.status;
    if (req.query.q) {
      const q = req.query.q;
      where[Op.or] = [
        { name: { [Op.iLike]: `%${q}%` } },
        { description: { [Op.iLike]: `%${q}%` } },
      ];
    }
    const { count, rows } = await Role.findAndCountAll({
      where,
      order: [[sort, direction]],
      limit,
      offset,
    });
    res.status(200).json({
      data: rows,
      pagination: {
        total: count,
        page,
        pages: Math.ceil(count / limit),
        limit,
      },
    });
  } catch (err) {
    res.status(500).json({ message: "Erreur lors de la récupération des rôles", error: err.message });
  }
};

exports.getRoleById = async (req, res) => {
  try {
    const { id } = req.params;
    const role = await Role.findByPk(id);
    if (!role) {
      return res.status(404).json({ message: "Rôle non trouvé" });
    }
    res.status(200).json(role);
  } catch (err) {
    res.status(500).json({
      message: "Erreur lors de la récupération du rôle",
      error: err.message,
    });
  }
};

exports.createRole = async (req, res) => {
  try {
    const { name, description } = req.body;
    if (!name) return res.status(400).json({ message: "Le nom du rôle est requis" });

    const role = await Role.create({ name, description });
    res.status(201).json({ message: "Rôle créé avec succès", role });
  } catch (err) {
    res.status(500).json({ message: "Erreur lors de la création du rôle", error: err.message });
  }
};

exports.updateRole = async (req, res) => {
  try {
    const { id } = req.params;
    const { name, description } = req.body;

    const role = await Role.findByPk(id);
    if (!role) return res.status(404).json({ message: "Rôle non trouvé" });

    role.name = name || role.name;
    role.description = description || role.description;
    await role.save();

    res.status(200).json({ message: "Rôle mis à jour avec succès", role });
  } catch (err) {
    res.status(500).json({ message: "Erreur lors de la mise à jour du rôle", error: err.message });
  }
};

// controllers/roleController.js
exports.deleteRole = async (req, res) => {
  try {
    const id = req.params.id;

    const role = await Role.findByPk(id);
    if (!role) {
      return res.status(404).json({ message: "Rôle non trouvé." });
    }

    role.status = "inactif";
    await role.save();

    res.status(200).json({ message: "Rôle désactivé (inactif)." });
  } catch (err) {
    console.error(err);
    res.status(500).json({ message: "Erreur lors de la désactivation du rôle." });
  }
};
