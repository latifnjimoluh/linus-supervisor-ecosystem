const db = require("../../models");
const User = db.User;
const bcrypt = require("bcrypt");
const { sendResetCode } = require("../../utils/configMail");

const logUserAction = require("../../middlewares/logUserAction");

exports.requestReset = async (req, res) => {
  const { email } = req.body;
  if (!email) return res.status(400).json({ message: "Email requis" });

  const user = await User.findOne({ where: { email } });
  if (!user) return res.status(404).json({ message: "Utilisateur introuvable" });

  const code = Math.floor(100000 + Math.random() * 900000).toString();
  const expires = new Date(Date.now() + 15 * 60 * 1000);

  user.reset_token = code;
  user.reset_expires_at = expires;
  await user.save();

  await sendResetCode(email, code);

  // ✅ Log de l’action
  req.user = { id: user.id };
  await logUserAction("Demande de réinitialisation")({ ...req }, res, () => {});

  res.json({ message: "Code envoyé par email" });
};


exports.resetPassword = async (req, res) => {
  const { code, password } = req.body;
  if (!code || !password) return res.status(400).json({ message: "Champs requis" });

  const user = await User.findOne({
    where: {
      reset_token: code,
      reset_expires_at: { [db.Sequelize.Op.gt]: new Date() },
    },
  });

  if (!user) return res.status(400).json({ message: "Code invalide ou expiré" });

  const hashed = await bcrypt.hash(password, 10);

  user.password = hashed;
  user.reset_token = null;
  user.reset_expires_at = null;
  user.last_password_reset_at = new Date();
  await user.save();

  // ✅ Log de l’action
  req.user = { id: user.id };
  await logUserAction("Réinitialisation de mot de passe")({ ...req }, res, () => {});

  res.json({ message: "Mot de passe réinitialisé avec succès" });
};

exports.getUsersWithResetHistory = async (req, res) => {
  try {
    const users = await User.findAll({
      where: {
        last_password_reset_at: { [db.Sequelize.Op.not]: null },
      },
      attributes: [
        "id",
        "email",
        "first_name",
        "last_name",
        "last_password_reset_at"
      ],
      order: [["last_password_reset_at", "DESC"]],
    });

    // ✅ Log l'action de consultation
    await logUserAction("Consultation de l’historique des réinitialisations")({ ...req }, res, () => {});

    res.json(users);
  } catch (error) {
    console.error("Erreur récupération des utilisateurs avec reset:", error);
    res.status(500).json({ message: "Erreur serveur." });
  }
};
