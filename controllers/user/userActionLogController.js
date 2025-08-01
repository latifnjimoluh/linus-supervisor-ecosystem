const db = require("../../models");
const { UserActionLog, User } = db;

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
