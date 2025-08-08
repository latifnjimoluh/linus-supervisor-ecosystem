const nodemailer = require('nodemailer');
require('dotenv').config();

console.log('📧 Initialisation du transporteur Nodemailer');

const transporter = nodemailer.createTransport({
  service: 'gmail',
  auth: {
    user: process.env.SMTP_USER,
    pass: process.env.SMTP_PASS,
  },
  tls: {
    rejectUnauthorized: false, // Accepter les certificats auto-signés (utile en dev)
  },
});

transporter.verify((err, success) => {
  if (err) {
    console.error('❌ Échec vérification transporteur :', err.message || err);
  } else {
    console.log('✅ Transporteur prêt à envoyer des emails (Gmail)');
  }
});

/**
 * Envoie un code de réinitialisation à un utilisateur.
 * @param {string} to - Email du destinataire
 * @param {string} code - Code à envoyer
 */
const sendResetCode = async (to, code) => {
  console.log(`📨 Envoi du code de réinitialisation à ${to}`);
  try {
    const info = await transporter.sendMail({
      from: `"Linusupervision" <${process.env.SMTP_USER}>`,
      to,
      subject: '🔐 Code de réinitialisation de mot de passe',
      text: `Voici votre code de réinitialisation : ${code} (valide 15 minutes).`,
    });
    console.log(`📤 Email envoyé avec succès. ID: ${info.messageId}`);
  } catch (error) {
    console.error('❌ Erreur lors de l’envoi du mail :', error.message || error);
    throw error;
  }
};

module.exports = { sendResetCode };
