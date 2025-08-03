// 📁 controllers/permissions/permissionController.js
const { Permission, Role, RolePermission } = require("../../models");
const { Op } = require("sequelize");

exports.getAllPermissions = async (req, res) => {
  try {
    const page = parseInt(req.query.page) || 1;
    const limit = parseInt(req.query.limit) || 10;
    const offset = (page - 1) * limit;
    const sort = req.query.sort || "name";
    const direction = req.query.order === "desc" ? "DESC" : "ASC";
    const where = {};
    if (req.query.q) {
      const q = req.query.q;
      where[Op.or] = [
        { name: { [Op.iLike]: `%${q}%` } },
        { description: { [Op.iLike]: `%${q}%` } },
      ];
    }
    const { count, rows } = await Permission.findAndCountAll({
      where,
      order: [[sort, direction]],
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
    console.error("Erreur getAllPermissions:", error);
    res.status(500).json({ message: "Erreur serveur." });
  }
};

exports.getPermissionById = async (req, res) => {
  try {
    const { id } = req.params;
    const permission = await Permission.findByPk(id);
    if (!permission) {
      return res.status(404).json({ message: "Permission non trouvée" });
    }
    res.json(permission);
  } catch (error) {
    console.error("Erreur getPermissionById:", error);
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

exports.updatePermission = async (req, res) => {
  try {
    const { id } = req.params;
    const { name, description } = req.body;
    const permission = await Permission.findByPk(id);
    if (!permission) {
      return res.status(404).json({ message: "Permission non trouvée" });
    }
    if (name) permission.name = name;
    if (description) permission.description = description;
    await permission.save();
    res.json({ message: "Permission mise à jour", permission });
  } catch (error) {
    console.error("Erreur updatePermission:", error);
    res.status(500).json({ message: "Erreur serveur." });
  }
};

exports.deletePermission = async (req, res) => {
  try {
    const { id } = req.params;
    const permission = await Permission.findByPk(id);
    if (!permission) {
      return res.status(404).json({ message: "Permission non trouvée" });
    }
    // Soft delete: mark permission as inactive instead of removing it
    permission.status = "inactif";
    await permission.save();
    res.json({ message: "Permission désactivée" });
  } catch (error) {
    console.error("Erreur deletePermission:", error);
    res.status(500).json({ message: "Erreur serveur." });
  }
};

exports.assignPermissionsToRole = async (req, res) => {
  try {
    const assignments = req.body; // tableau [{ role_id, permission_ids }]

    for (const assign of assignments) {
      const { role_id, permission_ids } = assign;

      if (!role_id || !Array.isArray(permission_ids)) {
        return res
          .status(400)
          .json({ message: "role_id ou permission_ids manquants ou invalides." });
      }

      // Récupérer les permissions déjà attribuées
      const existing = await RolePermission.findAll({ where: { role_id } });
      const existingIds = new Set(existing.map((rp) => rp.permission_id));

      // Ne créer que les nouvelles associations
      const toInsert = permission_ids
        .filter((pid) => !existingIds.has(pid))
        .map((pid) => ({ role_id, permission_id: pid }));

      if (toInsert.length) {
        await RolePermission.bulkCreate(toInsert);
      }
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

exports.unassignPermissionsFromRole = async (req, res) => {
  try {
    const { role_id, permission_ids } = req.body;
    if (!role_id || !Array.isArray(permission_ids)) {
      return res.status(400).json({ message: "role_id ou permission_ids manquants ou invalides." });
    }
    await RolePermission.destroy({
      where: { role_id, permission_id: permission_ids },
    });
    res.json({ message: "Permissions retirées avec succès." });
  } catch (error) {
    console.error("Erreur unassignPermissionsFromRole:", error);
    res.status(500).json({ message: "Erreur serveur lors du retrait des permissions." });
  }
};
