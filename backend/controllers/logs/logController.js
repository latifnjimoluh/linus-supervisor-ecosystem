const { Log, User } = require('../../models');
const { Op } = require('sequelize');

// Get logs with pagination and search
exports.getAllLogs = async (req, res) => {
  try {
    const { q, page = 1, pageSize = 10 } = req.query;
    const limit = parseInt(pageSize, 10);
    const offset = (parseInt(page, 10) - 1) * limit;

    const where = q
      ? {
          [Op.or]: [
            { action: { [Op.iLike]: `%${q}%` } },
            { details: { [Op.iLike]: `%${q}%` } },
            { '$user.email$': { [Op.iLike]: `%${q}%` } },
          ],
        }
      : {};

    const options = {
      where,
      include: [{ model: User, as: 'user', attributes: ['email'] }],
      order: [['created_at', 'DESC']],
      distinct: true,
    };

    if (!q) {
      options.limit = limit;
      options.offset = offset;
    }

    const { rows, count } = await Log.findAndCountAll(options);

    const deriveType = (action = '') => {
      if (/deploy/i.test(action)) return 'deployment';
      if (/delete|destroy/i.test(action)) return 'deletion';
      if (/restart|reboot/i.test(action)) return 'restart';
      if (/user/i.test(action)) return 'user_creation';
      if (/role/i.test(action)) return 'role_change';
      return 'vm_action';
    };

    const deriveStatus = (details = '') => (/error|fail/i.test(details) ? 'error' : 'success');

    const mapped = rows.map((log) => ({
      id: log.id,
      action: log.action,
      type: deriveType(log.action),
      timestamp: log.created_at,
      user: log.user ? log.user.email : null,
      entity: null,
      status: deriveStatus(log.details),
      description: log.details || '',
      details: log.details || '',
      ip_address: null,
      vm_id: null,
    }));

    if (q) {
      return res.json({ results: mapped, total: count, paginationDisabled: true });
    }

    return res.json({
      results: mapped,
      total: count,
      page: parseInt(page, 10),
      pageSize: limit,
    });
  } catch (err) {
    console.error('❌ Erreur getAllLogs:', err);
    res.status(500).json({ message: 'Erreur serveur.' });
  }
};
