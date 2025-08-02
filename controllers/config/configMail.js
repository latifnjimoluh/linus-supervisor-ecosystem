const nodemailer = require("nodemailer");

const transporter = nodemailer.createTransport({
  service: "gmail",
  auth: {
    user: process.env.SMTP_USER,
    pass: process.env.SMTP_PASS,
  },
  tls: {
    rejectUnauthorized: false // ✅ Accepter les certificats auto-signés
  }
});

const sendResetCode = async (email, code) => {
  const mailOptions = {
    from: `"Linusupervision" <${process.env.SMTP_USER}>`,
    to: email,
    subject: "🔐 Code de réinitialisation de mot de passe",
    text: `Voici votre code de réinitialisation : ${code} (valide 15 minutes)`,
  };

  await transporter.sendMail(mailOptions);
};

module.exports = { sendResetCode };
