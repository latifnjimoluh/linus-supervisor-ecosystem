// mailer.js
'use strict';

const nodemailer = require('nodemailer');
require('dotenv').config();

const ns = '[MAILER]';

// ---------- Helpers ----------
const toBool = (v, def = false) =>
  typeof v === 'string' ? ['1', 'true', 'yes', 'on'].includes(v.toLowerCase()) : (v ?? def);

const toInt = (v, def) => {
  const n = parseInt(v, 10);
  return Number.isFinite(n) ? n : def;
};

const maskEmail = (addr) => {
  if (!addr) return '';
  const [local, domain = ''] = String(addr).split('@');
  if (!domain) return addr;
  const maskedLocal = local.length <= 2 ? local[0] + '*' : local[0] + '*'.repeat(Math.max(1, local.length - 2)) + local.slice(-1);
  return `${maskedLocal}@${domain}`;
};

const maskRecipients = (to) => {
  if (!to) return '';
  const list = Array.isArray(to) ? to : String(to).split(',');
  return list.map((e) => maskEmail(String(e).trim())).join(', ');
};

const ensureRecipients = (to) => {
  const list = Array.isArray(to) ? to : String(to || '').split(',');
  const cleaned = list.map((e) => String(e).trim()).filter(Boolean);
  if (cleaned.length === 0) throw new Error('Aucun destinataire fourni');
  return cleaned;
};

const fromIdentity = () => {
  const name = process.env.SMTP_FROM_NAME || 'Linusupervision';
  const email = process.env.SMTP_FROM_EMAIL || process.env.SMTP_USER;
  if (!email) throw new Error('SMTP_FROM_EMAIL ou SMTP_USER manquant');
  return `"${name}" <${email}>`;
};

// ---------- Transporter factory ----------
function buildTransport() {
  const cfg = {
    host: process.env.SMTP_HOST || 'smtp.gmail.com',
    port: toInt(process.env.SMTP_PORT, 587),
    secure: toBool(process.env.SMTP_SECURE, false), // true pour 465
    auth: {
      user: process.env.SMTP_USER,
      pass: process.env.SMTP_PASS,
    },
    pool: true,
    maxConnections: toInt(process.env.SMTP_POOL_MAX_CONN, 5),
    maxMessages: toInt(process.env.SMTP_POOL_MAX_MSG, 100),
    connectionTimeout: toInt(process.env.SMTP_CONN_TIMEOUT_MS, 10_000),
    greetingTimeout: toInt(process.env.SMTP_GREETING_TIMEOUT_MS, 10_000),
    socketTimeout: toInt(process.env.SMTP_SOCKET_TIMEOUT_MS, 20_000),
    tls: {
      // garde la souplesse en dev; en prod, mets à true et configure ton cert
      rejectUnauthorized: toBool(process.env.SMTP_TLS_REJECT_UNAUTHORIZED, false) 
    },
  };

  // Option DKIM (facultative)
  const dkimDomain = process.env.DKIM_DOMAIN;
  const dkimSelector = process.env.DKIM_SELECTOR;
  const dkimKey = process.env.DKIM_PRIVATE_KEY;
  if (dkimDomain && dkimSelector && dkimKey) {
    cfg.dkim = {
      domainName: dkimDomain,
      keySelector: dkimSelector,
      privateKey: dkimKey,
    };
    console.log(`${ns} DKIM activé pour ${dkimSelector}._domainkey.${dkimDomain}`);
  }

  if (!cfg.auth.user || !cfg.auth.pass) {
    console.warn(`${ns} ATTENTION: SMTP_USER ou SMTP_PASS manquant. Les envois échoueront.`);
  }

  const transporter = nodemailer.createTransport(cfg);

  transporter.verify((err, success) => {
    if (err) {
      console.error(`${ns} Échec vérification du transport SMTP:`, err.message || err);
    } else {
      console.log(`${ns} Transport SMTP prêt (secure=${cfg.secure}, host=${cfg.host}:${cfg.port})`);
    }
  });

  return transporter;
}

const transporter = buildTransport();

// ---------- TEMPLATES ----------
function tplResetCode({ code }) {
  const subject = '🔐 Code de réinitialisation de mot de passe';
  const html = `
  <div style="font-family:Arial,sans-serif;line-height:1.6;color:#111">
    <h2 style="margin:0 0 12px">Réinitialisation de mot de passe</h2>
    <p>Bonjour,</p>
    <p>Voici votre code de réinitialisation&nbsp;:</p>
    <div style="font-size:28px;font-weight:700;margin:16px 0;letter-spacing:2px">${String(code).trim()}</div>
    <p>Ce code est valable <strong>15 minutes</strong>.</p>
    <hr style="border:none;border-top:1px solid #eee;margin:20px 0" />
    <p style="font-size:12px;color:#666">Si vous n'êtes pas à l’origine de cette demande, vous pouvez ignorer cet email.</p>
    <p style="margin-top:28px">L'équipe Linusupervision</p>
  </div>
  `;
  const text =
    `Réinitialisation de mot de passe\n\n` +
    `Code: ${String(code).trim()}\n` +
    `Valable 15 minutes.\n\n` +
    `--\nL'équipe Linusupervision`;
  return { subject, html, text };
}

function tplAlert({ server, service, value, threshold, severity = 'majeure', description = '' }) {
  const sevColor = severity === 'critique' ? '#b91c1c' : severity === 'majeure' ? '#dc2626' : '#ea580c';
  const subject = `Alerte ${service} sur ${server} • ${severity.toUpperCase()}`;

  const dashboard = process.env.ALERT_DASHBOARD_URL
    ? `<p style="margin:16px 0"><a href="${process.env.ALERT_DASHBOARD_URL}" target="_blank" rel="noopener" style="color:#2563eb">Ouvrir le tableau de bord</a></p>`
    : '';

  const html = `
  <div style="font-family:Arial,sans-serif;line-height:1.6;color:#111">
    <h2 style="margin:0;padding:12px;background:${sevColor};color:#fff">Alerte ${service} • ${severity.toUpperCase()}</h2>
    <p>Une alerte a été déclenchée sur <strong>${server}</strong>.</p>
    <ul style="padding-left:18px">
      <li><strong>Service :</strong> ${service}</li>
      <li><strong>Valeur :</strong> ${value}%</li>
      <li><strong>Seuil :</strong> ${threshold}%</li>
      <li><strong>Gravité :</strong> ${severity}</li>
    </ul>
    ${description ? `<p style="white-space:pre-wrap">${description}</p>` : ''}
    ${dashboard}
    <hr style="border:none;border-top:1px solid #eee;margin:20px 0" />
    <p style="font-size:12px;color:#666">Message envoyé automatiquement par Linusupervision.</p>
  </div>
  `;
  const text =
    `ALERTE ${service} • ${severity.toUpperCase()}\n` +
    `Serveur: ${server}\n` +
    `Valeur: ${value}% | Seuil: ${threshold}%\n` +
    (description ? `\n${description}\n` : '') +
    (process.env.ALERT_DASHBOARD_URL ? `\nDashboard: ${process.env.ALERT_DASHBOARD_URL}\n` : '') +
    `\n--\nLinusupervision (envoi automatique)`;

  return { subject, html, text };
}

// ---------- Core send ----------
async function sendMailSafe({ to, subject, html, text, headers }) {
  const recipients = ensureRecipients(to);
  const masked = maskRecipients(recipients);
  const from = fromIdentity();

  try {
    const info = await transporter.sendMail({
      from,
      to: recipients.join(','),
      subject,
      html,
      text,
      headers: {
        'X-Mailer': 'Linusupervision',
        'List-ID': 'linusupervision <alerts.linusupervision>',
        ...(headers || {}),
      },
      // Idées: attachments: [{ filename, content|path, contentType }]
    });
    console.log(`${ns} ✅ Email envoyé à ${masked} (id: ${info.messageId})`);
    return { ok: true, id: info.messageId, response: info.response };
  } catch (err) {
    console.error(`${ns} ❌ Échec envoi à ${masked}:`, err.message || err);
    // re-propager pour permettre à l’appelant de gérer les retries (ex: dans ta notificationQueue)
    throw err;
  }
}

// ---------- Public API ----------
/**
 * Envoie un code de réinitialisation à un utilisateur.
 * @param {string|string[]} to Destinataire(s)
 * @param {string|number} code Code à envoyer
 */
async function sendResetCode(to, code) {
  const { subject, html, text } = tplResetCode({ code });
  return sendMailSafe({ to, subject, html, text });
}

/**
 * Envoie un email lorsqu'une alerte (CPU/RAM/...) est déclenchée.
 * @param {string|string[]} to Destinataire(s)
 * @param {object} alert Détails de l'alerte
 * @param {string} alert.server
 * @param {string} alert.service
 * @param {number} alert.value
 * @param {number} alert.threshold
 * @param {string} [alert.severity] 'mineure'|'majeure'|'critique'
 * @param {string} [alert.description]
 */
async function sendAlertEmail(to, alert = {}) {
  const { subject, html, text } = tplAlert(alert);
  return sendMailSafe({
    to,
    subject,
    html,
    text,
    headers: {
      'X-Alert-Service': alert.service || '',
      'X-Alert-Server': alert.server || '',
      'X-Alert-Severity': alert.severity || '',
    },
  });
}

/**
 * Test simple pour vérifier la chaîne SMTP.
 * @param {string|string[]} to
 */
async function sendTestEmail(to = process.env.SMTP_USER) {
  const now = new Date().toISOString();
  const subject = `Test SMTP Linusupervision • ${now}`;
  const html = `<div style="font-family:Arial,sans-serif"><p>Ceci est un test d'email SMTP.</p><p>${now}</p></div>`;
  const text = `Ceci est un test d'email SMTP.\n${now}`;
  return sendMailSafe({ to, subject, html, text });
}

module.exports = {
  transporter,       // exposé au cas où (ex: métriques ou fermeture)
  sendResetCode,
  sendAlertEmail,
  sendTestEmail,
};
