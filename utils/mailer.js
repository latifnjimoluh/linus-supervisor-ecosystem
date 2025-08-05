const nodemailer = require('nodemailer');
require('dotenv').config();

console.log('📧 Initialisation du transporteur Nodemailer');

const transporter = nodemailer.createTransport({
  host: process.env.MAIL_HOST,
  port: parseInt(process.env.MAIL_PORT, 10) || 587,
  secure: false,
  auth: {
    user: process.env.MAIL_USER,
    pass: process.env.MAIL_PASS,
  },
});

transporter.verify((err, success) => {
  if (err) {
    console.error('❌ Échec vérification transporteur:', err);
  } else {
    console.log('✅ Transporteur prêt:', success);
  }
});

const sendResetCode = async (to, code) => {
  console.log('✉️ Envoi du code de réinitialisation à:', to);
  try {
    const info = await transporter.sendMail({
      from: process.env.MAIL_FROM || process.env.MAIL_USER,
      to,
      subject: 'Code de réinitialisation',
      text: `Votre code de réinitialisation est: ${code}`,
    });
    console.log('📤 Email envoyé:', info.messageId);
  } catch (error) {
    console.error('❌ Erreur envoi email:', error);
    throw error;
  }
};

module.exports = { sendResetCode };
