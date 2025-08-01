const { User, Role } = require("../../models");

// 🔍 Voir tous les utilisateurs (avec rôle)
exports.getAllUsers = async (req, res) => {
  try {
    const users = await User.findAll({
      include: [{ model: Role, as: "role" }],
      order: [["created_at", "DESC"]],
    });

    res.json(users);
  } catch (error) {
    console.error("Erreur récupération utilisateurs:", error);
    res.status(500).json({ message: "Erreur serveur lors de la récupération des utilisateurs." });
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
