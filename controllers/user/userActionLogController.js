const db = require("../../models");
const { Op } = require("sequelize");
const { UserActionLog, User } = db;

exports.getAllLogs = async (req, res) => {
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

    const { count, rows } = await UserActionLog.findAndCountAll({
      where,
      include: [{ model: User, as: "user", attributes: ["first_name", "last_name", "email"] }],
      order: [["created_at", "DESC"]],
      limit,
      offset,
    });

    res.status(200).json({
      data: rows,
      pagination: { total: count, page, limit },
    });
  } catch (err) {
    console.error("Erreur récupération logs :", err);
    res.status(500).json({ message: "Erreur interne serveur." });
  }
};

exports.getLogsByUser = async (req, res) => {
  try {
    const logs = await UserActionLog.findAll({
      where: { user_id: req.params.id },
      include: [{ model: User, as: "user", attributes: ["first_name", "last_name", "email"] }],
      order: [["created_at", "DESC"]],
    });
    res.status(200).json(logs);
  } catch (err) {
    console.error("Erreur récupération logs utilisateur :", err);
    res.status(500).json({ message: "Erreur interne serveur." });
  }
};
