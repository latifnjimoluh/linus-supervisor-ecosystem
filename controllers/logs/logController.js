const { Log, User } = require('../../models');
const { Op } = require('sequelize');

// Get logs with pagination and search
exports.getAllLogs = async (req, res) => {
  console.log('📥 Requête getAllLogs reçue');
  try {
    const page = parseInt(req.query.page) || 1;
    const limit = parseInt(req.query.limit) || 10;
    const offset = (page - 1) * limit;
    const { q } = req.query;

    const where = {};
    if (q) {
      where[Op.or] = [
        { action: { [Op.iLike]: `%${q}%` } },
        { details: { [Op.iLike]: `%${q}%` } },
      ];
    }

    const { count, rows } = await Log.findAndCountAll({
      where,
      include: [{ model: User, as: 'user' }],
      order: [['created_at', 'DESC']],
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
  } catch (err) {
    console.error('❌ Erreur getAllLogs:', err);
    res.status(500).json({ message: "Erreur serveur." });
  }
};
