// 📁 controllers/permissions/permissionController.js
const { Permission, Role, RolePermission } = require("../../models");

exports.getAllPermissions = async (req, res) => {
  try {
    const permissions = await Permission.findAll();
    res.json(permissions);
  } catch (error) {
    console.error("Erreur getAllPermissions:", error);
    res.status(500).json({ message: "Erreur serveur." });
  }
};

exports.createPermission = async (req, res) => {
  try {
    let permissions = req.body;

    if (!Array.isArray(permissions)) {
      permissions = [permissions]; // si un seul objet
    }

    const created = [];

    for (const p of permissions) {
      if (!p.name || !p.description) {
        return res.status(400).json({ message: "Champs 'name' et 'description' requis." });
      }

      const existing = await Permission.findOne({ where: { name: p.name } });
      if (existing) {
        console.log(`🔁 Permission '${p.name}' déjà existante`);
        created.push(existing);
        continue;
      }

      const newPerm = await Permission.create({
        name: p.name,
        description: p.description,
      });

      created.push(newPerm);
    }

    res.status(201).json({ message: "✅ Permissions enregistrées", data: created });
  } catch (error) {
    console.error("Erreur createPermission:", error);
    res.status(500).json({ message: "Erreur serveur lors de l'enregistrement des permissions." });
  }
};

exports.assignPermissionsToRole = async (req, res) => {
  try {
    const assignments = req.body; // tableau [{ role_id, permission_ids }]

    for (const assign of assignments) {
      const { role_id, permission_ids } = assign;

      if (!role_id || !Array.isArray(permission_ids)) {
        return res.status(400).json({ message: "role_id ou permission_ids manquants ou invalides." });
      }

      // Supprimer les anciennes permissions
      await RolePermission.destroy({ where: { role_id } });

      // Ajouter les nouvelles permissions
      const bulkInsert = permission_ids.map(pid => ({
        role_id,
        permission_id: pid,
      }));
      await RolePermission.bulkCreate(bulkInsert);
    }

    res.json({ message: "Permissions attribuées avec succès." });
  } catch (error) {
    console.error("Erreur assignPermissionsToRole:", error);
    res.status(500).json({ message: "Erreur serveur lors de l’attribution des permissions." });
  }
};


exports.getPermissionsByRole = async (req, res) => {
  try {
    const { role_id } = req.params;
    const role = await Role.findByPk(role_id, {
      include: [{ model: Permission, as: "permissions" }],
    });

    if (!role) return res.status(404).json({ message: "Rôle introuvable." });
    res.json(role.permissions);
  } catch (error) {
    console.error("Erreur getPermissionsByRole:", error);
    res.status(500).json({ message: "Erreur serveur." });
  }
};
