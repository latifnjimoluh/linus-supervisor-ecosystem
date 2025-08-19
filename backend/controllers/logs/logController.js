const { Log, User, Deployment } = require('../../models');
const { Op } = require('sequelize');

// Get logs with search/sort applied before pagination
exports.getAllLogs = async (req, res) => {
  try {
    const {
      search = '',
      sort = 'timestamp',
      order = 'desc',
      page = 1,
      limit = 10,
      from,
      to,
    } = req.query;

    const sortFields = {
      timestamp: 'created_at',
      host: 'host',
      level: 'level',
      source: 'source',
    };

    const orderField = sortFields[sort] || 'created_at';
    const orderDirection = order.toUpperCase() === 'ASC' ? 'ASC' : 'DESC';
    const pageInt = parseInt(page, 10);
    const limitInt = parseInt(limit, 10);
    const offset = (pageInt - 1) * limitInt;

    const where = {};
    if (search) {
      where[Op.or] = [
        { action: { [Op.iLike]: `%${search}%` } },
        { details: { [Op.iLike]: `%${search}%` } },
        { '$user.email$': { [Op.iLike]: `%${search}%` } },
      ];
    }
    if (from || to) {
      where.created_at = {};
      if (from) where.created_at[Op.gte] = new Date(from);
      if (to) where.created_at[Op.lte] = new Date(to);
    }

    const { rows, count } = await Log.findAndCountAll({
      where,
      include: [{ model: User, as: 'user', attributes: ['email'] }],
      order: [[orderField, orderDirection]],
      limit: limitInt,
      offset,
      distinct: true,
    });

    const deriveType = (action = '') => {
      if (/deploy/i.test(action)) return 'deployment';
      if (/delete|destroy/i.test(action)) return 'deletion';
      if (/restart|reboot/i.test(action)) return 'restart';
      if (/user/i.test(action)) return 'user_creation';
      if (/role/i.test(action)) return 'role_change';
      return 'vm_action';
    };

    const deriveStatus = (details = '') => (/error|fail/i.test(details) ? 'error' : 'success');

    const items = rows.map((log) => ({
      id: log.id,
      action: log.action,
      type: deriveType(log.action),
      timestamp: log.created_at,
      user: log.user ? log.user.email : null,
      entity: null,
      status: deriveStatus(log.details),
      description: log.details || '',
      details: log.details || '',
      host: log.host || null,
      level: log.level || null,
      source: log.source || null,
      ip_address: null,
      vm_id: null,
    }));

    return res.json({
      items,
      total_after_filter: count,
      page: pageInt,
      limit: limitInt,
    });
  } catch (err) {
    console.error('❌ Erreur getAllLogs:', err);
    res.status(500).json({ message: 'Erreur serveur.' });
  }
};

// List deployment logs with server-side pagination
exports.getDeploymentLogs = async (req, res) => {
  try {
    const {
      search = '',
      sort = 'date',
      order = 'desc',
      page = 1,
      limit = 25,
    } = req.query;

    const sortFields = {
      date: 'started_at',
      instance_id: 'instance_id',
      status: 'status',
    };

    const orderField = sortFields[sort] || 'started_at';
    const orderDirection = order.toUpperCase() === 'ASC' ? 'ASC' : 'DESC';
    const pageInt = parseInt(page, 10);
    const limitInt = parseInt(limit, 10);
    const offset = (pageInt - 1) * limitInt;

    const where = {};
    if (search) {
      where[Op.or] = [
        { vm_name: { [Op.iLike]: `%${search}%` } },
        { instance_id: { [Op.iLike]: `%${search}%` } },
        { status: { [Op.iLike]: `%${search}%` } },
        { '$user.email$': { [Op.iLike]: `%${search}%` } },
      ];
    }

    const { rows, count } = await Deployment.findAndCountAll({
      where,
      include: [{ model: User, as: 'user', attributes: ['email'] }],
      order: [[orderField, orderDirection]],
      limit: limitInt,
      offset,
      distinct: true,
    });

    const items = rows.map((dep) => ({
      id: dep.id,
      instance_id: dep.instance_id,
      vm_name: dep.vm_name,
      status: dep.status || (dep.success === null ? 'pending' : dep.success ? 'success' : 'failed'),
      started_at: dep.started_at,
      ended_at: dep.ended_at,
      user: dep.user ? dep.user.email : null,
    }));

    return res.json({
      items,
      total_after_filter: count,
      page: pageInt,
      limit: limitInt,
    });
  } catch (err) {
    console.error('❌ Erreur getDeploymentLogs:', err);
    res.status(500).json({ message: 'Erreur serveur.' });
  }
};

// Export filtered logs as NDJSON
exports.exportLogs = async (req, res) => {
  try {
    const {
      search = '',
      sort = 'timestamp',
      order = 'desc',
      from,
      to,
      type,
      status,
    } = req.query;

    const sortFields = {
      timestamp: 'created_at',
      host: 'host',
      level: 'level',
      source: 'source',
    };

    const orderField = sortFields[sort] || 'created_at';
    const orderDirection = order.toUpperCase() === 'ASC' ? 'ASC' : 'DESC';

    const where = {};
    if (search) {
      where[Op.or] = [
        { action: { [Op.iLike]: `%${search}%` } },
        { details: { [Op.iLike]: `%${search}%` } },
        { '$user.email$': { [Op.iLike]: `%${search}%` } },
      ];
    }
    if (from || to) {
      where.created_at = {};
      if (from) where.created_at[Op.gte] = new Date(from);
      if (to) where.created_at[Op.lte] = new Date(to);
    }
    const MAX_EXPORT = 10000;
    const limitInt = Math.min(parseInt(req.query.limit, 10) || MAX_EXPORT, MAX_EXPORT);

    const logs = await Log.findAll({
      where,
      include: [{ model: User, as: 'user', attributes: ['email'] }],
      order: [[orderField, orderDirection]],
      limit: limitInt,
    });

    const deriveType = (action = '') => {
      if (/deploy/i.test(action)) return 'deployment';
      if (/delete|destroy/i.test(action)) return 'deletion';
      if (/restart|reboot/i.test(action)) return 'restart';
      if (/user/i.test(action)) return 'user_creation';
      if (/role/i.test(action)) return 'role_change';
      return 'vm_action';
    };

    const deriveStatus = (details = '') => (/error|fail/i.test(details) ? 'error' : 'success');

    let items = logs.map((log) => ({
      id: log.id,
      action: log.action,
      type: deriveType(log.action),
      timestamp: log.created_at,
      user: log.user ? log.user.email : null,
      entity: null,
      status: deriveStatus(log.details),
      description: log.details || '',
      details: log.details || '',
      host: log.host || null,
      level: log.level || null,
      source: log.source || null,
      ip_address: null,
      vm_id: null,
    }));

    if (type) items = items.filter((l) => l.type === type);
    if (status) items = items.filter((l) => l.status === status);

    const payload = items.map((l) => JSON.stringify(l)).join('\n');

    const buffer = Buffer.from(payload, 'utf8');

    res.setHeader('Content-Type', 'application/x-ndjson');
    res.setHeader('Content-Disposition', 'attachment; filename="logs.ndjson"');
    res.setHeader('Content-Length', buffer.length);

    if (req.method === 'HEAD') {
      return res.status(200).end();
    }
    return res.send(buffer);
  } catch (err) {
    console.error('❌ Erreur exportLogs:', err);
    res.status(500).json({ message: 'Erreur serveur.' });
  }
};
