const { sendAlertEmail } = require('./mailer');

// 📨 File d’attente en mémoire pour les notifications
const queue = [];
const statuses = new Map(); // notificationId -> { status, retries, error, lastUpdate }
const processed = new Set();

/**
 * Ajoute une notification dans la file d’attente.
 * @param {string|number} notificationId - Identifiant unique (ex: ID alerte DB)
 * @param {string[]} recipients - Destinataires de l’alerte
 * @param {object} alert - Objet alerte { server, service, value, threshold, description }
 */
function enqueue(notificationId, recipients, alert) {
  if (
    processed.has(notificationId) ||
    statuses.get(notificationId)?.status === 'queued' ||
    statuses.get(notificationId)?.status === 'sending'
  ) {
    return; // 🔄 Idempotence : déjà en file ou traité
  }

  queue.push({ id: notificationId, recipients, alert, retries: 0 });
  statuses.set(notificationId, {
    status: 'queued',
    retries: 0,
    lastUpdate: new Date().toISOString(),
  });

  console.log(`📥 Notification ${notificationId} ajoutée à la file (alerte ${alert.service} sur ${alert.server})`);
}

/**
 * Traite la file d’attente toutes les secondes.
 */
async function processQueue() {
  if (queue.length === 0) return;

  const job = queue.shift();
  statuses.set(job.id, {
    status: 'sending',
    retries: job.retries,
    lastUpdate: new Date().toISOString(),
  });

  try {
    await sendAlertEmail(job.recipients, job.alert);
    statuses.set(job.id, {
      status: 'sent',
      retries: job.retries,
      lastUpdate: new Date().toISOString(),
    });
    processed.add(job.id);
    console.log(`✅ Notification ${job.id} envoyée avec succès.`);
  } catch (err) {
    job.retries += 1;
    console.error(`❌ Échec envoi notification ${job.id} (tentative ${job.retries}) :`, err.message);

    if (job.retries < 3) {
      statuses.set(job.id, {
        status: 'queued',
        retries: job.retries,
        error: err.message,
        lastUpdate: new Date().toISOString(),
      });
      const delay = Math.pow(2, job.retries) * 1000; // backoff exponentiel
      setTimeout(() => queue.push(job), delay);
    } else {
      statuses.set(job.id, {
        status: 'failed',
        retries: job.retries,
        error: err.message,
        lastUpdate: new Date().toISOString(),
      });
      console.error(`🚨 Notification ${job.id} abandonnée après ${job.retries} tentatives.`);
    }
  }
}

// ⏱️ Boucle d’exécution toutes les secondes
setInterval(processQueue, 1000);

/**
 * Récupère le statut d’une notification.
 * @param {string|number} id - Identifiant de la notification
 * @returns {string} Statut
 */
function getStatus(id) {
  return statuses.get(id)?.status || 'unknown';
}

/**
 * Retourne tous les statuts.
 * @returns {Array<object>} Liste des notifications
 */
function getAllStatuses() {
  const res = [];
  statuses.forEach((val, key) => res.push({ notification_id: key, ...val }));
  return res;
}

module.exports = { enqueue, getStatus, getAllStatuses };
