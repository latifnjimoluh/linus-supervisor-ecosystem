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
    const html = `
      <div style="font-family:Arial,sans-serif;line-height:1.6">
        <h2 style="margin-bottom:16px">Réinitialisation de mot de passe</h2>
        <p>Bonjour,</p>
        <p>Voici votre code de réinitialisation&nbsp;:</p>
        <div style="font-size:24px;font-weight:bold;margin:16px 0">${code}</div>
        <p>Ce code est valable 15 minutes.</p>
        <p style="margin-top:32px">L'équipe LinuSupervisor</p>
      </div>`;
    const info = await transporter.sendMail({
      from: `"Linusupervision" <${process.env.SMTP_USER}>`,
      to,
      subject: '🔐 Code de réinitialisation de mot de passe',
      html,
    });
    console.log(`📤 Email envoyé avec succès. ID: ${info.messageId}`);
  } catch (error) {
    console.error('❌ Erreur lors de l’envoi du mail :', error.message || error);
    throw error;
  }
};

/**
 * Envoie un email lorsqu'une alerte est déclenchée.
 * @param {string|string[]} to - Destinataires séparés par des virgules ou tableau
 * @param {object} alert - Détails de l'alerte
 * @param {string} alert.server - Nom du serveur ou IP
 * @param {string} alert.service - Type d'alerte (CPU, RAM...)
 * @param {number} alert.value - Valeur mesurée
 * @param {number} alert.threshold - Seuil configuré
 * @param {string} alert.description - Description détaillée
 */
const sendAlertEmail = async (to, alert) => {
  const recipients = Array.isArray(to) ? to.join(',') : to;
  if (!recipients) return;
  const subject = `Alerte ${alert.service} sur ${alert.server}`;
  const html = `
      <div style="font-family:Arial,sans-serif;line-height:1.6">
        <h2 style="background:#dc2626;color:#fff;padding:12px">Alerte ${alert.service}</h2>
        <p>Une alerte a été déclenchée sur <strong>${alert.server}</strong>.</p>
        <p><strong>Valeur&nbsp;:</strong> ${alert.value}% (seuil ${alert.threshold}%)</p>
        <p>${alert.description}</p>
        <p style="margin-top:32px">L'équipe LinuSupervisor</p>
      </div>`;
  try {
    await transporter.sendMail({
      from: `"Linusupervision" <${process.env.SMTP_USER}>`,
      to: recipients,
      subject,
      html,
    });
  } catch (err) {
    console.error('❌ Échec envoi mail alerte :', err.message || err);
  }
};

module.exports = { sendResetCode, sendAlertEmail };
