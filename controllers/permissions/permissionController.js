const { Permission, Role, AssignedPermission } = require('../../models');
const { Op } = require('sequelize');

exports.getAllPermissions = async (req, res) => {
  console.log('📥 getAllPermissions called', req.query);
  try {
    const page = parseInt(req.query.page) || 1;
    const limit = parseInt(req.query.limit) || 10;
    const offset = (page - 1) * limit;
    const sort = req.query.sort || 'key';
    const direction = req.query.order === 'desc' ? 'DESC' : 'ASC';
    const where = {};
    if (req.query.q) {
      const q = req.query.q;
      where[Op.or] = [
        { key: { [Op.iLike]: `%${q}%` } },
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
    const formatted = rows.map(p => ({
      ...p.toJSON(),
      created_at: p.created_at ? p.created_at.toISOString() : null,
      updated_at: p.updated_at ? p.updated_at.toISOString() : null,
    }));
    console.log(`📤 ${formatted.length} permissions found`);
    res.json({
      data: formatted,
      pagination: {
        total: count,
        page,
        pages: Math.ceil(count / limit),
        limit,
      },
    });
  } catch (error) {
    console.error('Erreur getAllPermissions:', error);
    res.status(500).json({ message: 'Erreur serveur.' });
  }
};

exports.getPermissionById = async (req, res) => {
  console.log('📥 getPermissionById called', req.params.id);
  try {
    const { id } = req.params;
    const permission = await Permission.findByPk(id);
    if (!permission) {
      console.log('⚠️ Permission non trouvée');
      return res.status(404).json({ message: 'Permission non trouvée' });
    }
    const json = permission.toJSON();
    json.created_at = permission.created_at ? permission.created_at.toISOString() : null;
    json.updated_at = permission.updated_at ? permission.updated_at.toISOString() : null;
    console.log('📤 Permission retrieved', permission.key);
    res.json(json);
  } catch (error) {
    console.error('Erreur getPermissionById:', error);
    res.status(500).json({ message: 'Erreur serveur.' });
  }
};

exports.createPermission = async (req, res) => {
  console.log('📥 createPermission called', req.body);
  try {
    let permissions = req.body;

    if (!Array.isArray(permissions)) {
      permissions = [permissions];
    }

    const created = [];

    for (const p of permissions) {
      if (!p.key || !p.name) {
        console.log('❌ key/name manquants');
        return res.status(400).json({ message: "Champs 'key' et 'name' requis." });
      }

      const existing = await Permission.findOne({ where: { key: p.key } });
      if (existing) {
        console.log(`🔁 Permission '${p.key}' déjà existante`);
        created.push(existing);
        continue;
      }

      const newPerm = await Permission.create({
        key: p.key,
        name: p.name,
        description: p.description,
      });

      created.push(newPerm);
    }

    console.log(`✅ ${created.length} permissions créées/récupérées`);
    res.status(201).json({ message: '✅ Permissions enregistrées', data: created });
  } catch (error) {
    console.error('Erreur createPermission:', error);
    res.status(500).json({ message: "Erreur serveur lors de l'enregistrement des permissions." });
  }
};

exports.updatePermission = async (req, res) => {
  console.log('📥 updatePermission called', req.params.id, req.body);
  try {
    const { id } = req.params;
    const { key, name, description } = req.body;
    const permission = await Permission.findByPk(id);
    if (!permission) {
      console.log('⚠️ Permission non trouvée');
      return res.status(404).json({ message: 'Permission non trouvée' });
    }
    if (key) permission.key = key;
    if (name) permission.name = name;
    if (description) permission.description = description;
    await permission.save();
    console.log('✅ Permission mise à jour');
    res.json({ message: 'Permission mise à jour', permission });
  } catch (error) {
    console.error('Erreur updatePermission:', error);
    res.status(500).json({ message: 'Erreur serveur.' });
  }
};

exports.deletePermission = async (req, res) => {
    console.log('📥 deletePermission called', req.params.id);
  try {
    const { id } = req.params;
    const permission = await Permission.findByPk(id);
    if (!permission) {
      console.log('⚠️ Permission non trouvée');
      return res.status(404).json({ message: 'Permission non trouvée' });
    }
    permission.status = 'inactif';
    await permission.save();
    console.log('🗑️ Permission désactivée');
    res.json({ message: 'Permission désactivée' });
  } catch (error) {
    console.error('Erreur deletePermission:', error);
    res.status(500).json({ message: 'Erreur serveur.' });
  }
};

exports.getPermissionsByRole = async (req, res) => {
  console.log('📥 getPermissionsByRole called', req.params.role_id);
  try {
    const { role_id } = req.params;
    const role = await Role.findByPk(role_id, {
      include: [{ model: Permission, as: 'permissions' }],
    });

    if (!role) {
      console.log('⚠️ Rôle introuvable');
      return res.status(404).json({ message: 'Rôle introuvable.' });
    }
    console.log(`📤 ${role.permissions.length} permissions pour le rôle ${role_id}`);
    res.json(role.permissions);
  } catch (error) {
    console.error('Erreur getPermissionsByRole:', error);
    res.status(500).json({ message: 'Erreur serveur.' });
  }
};

exports.assignPermissionsToRole = async (req, res) => {
  console.log('📥 assignPermissionsToRole called', req.body);
  try {
    let assignments = req.body;
    if (!Array.isArray(assignments)) {
      assignments = [assignments];
    }

    for (const assign of assignments) {
      let { role_id, permission_ids } = assign;

      if (!role_id ||
        (!Array.isArray(permission_ids) && typeof permission_ids !== 'number')) {
        console.log('❌ Données invalides');
        return res
          .status(400)
          .json({ message: 'role_id ou permission_ids manquants ou invalides.' });
      }

      if (!Array.isArray(permission_ids)) {
        permission_ids = [permission_ids];
      }

      const existing = await AssignedPermission.findAll({ where: { role_id } });
      const existingIds = new Set(existing.map((rp) => rp.permission_id));

      const toInsert = permission_ids
        .filter((pid) => !existingIds.has(pid))
        .map((pid) => ({ role_id, permission_id: pid }));

      if (toInsert.length) {
        await AssignedPermission.bulkCreate(toInsert);
        console.log(`✅ ${toInsert.length} permissions assignées au rôle ${role_id}`);
      } else {
        console.log(`ℹ️ Aucune nouvelle permission à assigner pour le rôle ${role_id}`);
      }
    }

    res.json({ message: 'Permissions attribuées avec succès.' });
  } catch (error) {
    console.error('Erreur assignPermissionsToRole:', error);
    res.status(500).json({ message: "Erreur serveur lors de l’attribution des permissions." });
  }
};


exports.unassignPermissionsFromRole = async (req, res) => {
  console.log('📥 unassignPermissionsFromRole called', req.body);
  try {
    let assignments = req.body;
    if (!Array.isArray(assignments)) {
      assignments = [assignments];
    }

    for (const assign of assignments) {
      let { role_id, permission_ids } = assign;

      if (!role_id ||
        (!Array.isArray(permission_ids) && typeof permission_ids !== 'number')) {
        console.log('❌ Données invalides');
        return res.status(400).json({ message: 'role_id ou permission_ids manquants ou invalides.' });
      }

      if (!Array.isArray(permission_ids)) {
        permission_ids = [permission_ids];
      }

      await AssignedPermission.destroy({
        where: { role_id, permission_id: permission_ids },
      });
      console.log(`🗑️ Permissions retirées du rôle ${role_id}`);
    }

    res.json({ message: 'Permissions retirées avec succès.' });
  } catch (error) {
    console.error('Erreur unassignPermissionsFromRole:', error);
    res.status(500).json({ message: "Erreur serveur lors du retrait des permissions." });
  }
};