// alertEvaluator.js
// Gestion complète de la détection, de la persistance et de la notification e-mail
// pour les alertes CPU/RAM, avec anti-spam/cooldown et calcul de sévérité.

require('dotenv').config();

const { Alert } = require('../models'); // adaptez le chemin si besoin: '../../models'
const mailQueue = require('../utils/notificationQueue'); // adaptez le chemin si besoin

/**
 * Seuils par défaut (peuvent être surchargés par process.env ou via options).
 * - cpu, ram : en pourcentage
 * - freshnessMinutes : âge max d'une métrique pour être considérée "fraîche"
 * - notifyCooldownMinutes : délai minimal avant de renvoyer un mail pour une alerte équivalente
 */
const DEFAULTS = {
  cpu: Number(process.env.ALERT_CPU_THRESHOLD) || 80,
  ram: Number(process.env.ALERT_RAM_THRESHOLD) || 85,
  freshnessMinutes: Number(process.env.ALERT_FRESHNESS_MINUTES) || 5,
  notifyCooldownMinutes: Number(process.env.ALERT_NOTIFY_COOLDOWN_MINUTES) || 30,
};

/**
 * Calcule la sévérité en fonction de l'écart au seuil.
 * - critique : >= seuil + 20%
 * - majeure  : >= seuil + 10%
 * - mineure  : >= seuil
 */
function computeSeverity(valuePercent, threshold) {
  const diff = valuePercent - threshold;
  if (diff >= 20) return 'critique';
  if (diff >= 10) return 'majeure';
  return 'mineure';
}

/**
 * Transforme RAM utilisée/total (en KB) en pourcentage.
 */
function toMemPercent(usedKb = 0, totalKb = 0) {
  if (!totalKb || totalKb <= 0) return 0;
  return Number(((usedKb / totalKb) * 100).toFixed(2));
}

/**
 * Détermine si les données sont "fraîches".
 */
function isFresh(lastMonitoring, freshnessMinutes) {
  if (!lastMonitoring) return false;
  const last = new Date(lastMonitoring).getTime();
  if (Number.isNaN(last)) return false;
  return Date.now() - last <= freshnessMinutes * 60 * 1000;
}

/**
 * Évalue CPU/RAM vs seuils.
 * Retourne un tableau d'objets { type, value_percent, threshold, freshness } pour chaque alerte.
 */
function evaluateResourceAlerts(metrics, overrides = {}) {
  const cfg = { ...DEFAULTS, ...overrides };
  const { cpu_usage = 0, memory_usage = 0, memory_total = 0, last_monitoring } = metrics;

  const alerts = [];
  const fresh = isFresh(last_monitoring, cfg.freshnessMinutes);

  // CPU
  if (cpu_usage > cfg.cpu) {
    alerts.push({
      type: 'CPU',
      value_percent: Number(Number(cpu_usage).toFixed(2)),
      threshold: cfg.cpu,
      freshness: fresh ? 'fresh' : 'stale',
    });
  }

  // RAM
  const memPct = toMemPercent(memory_usage, memory_total);
  if (memPct > cfg.ram) {
    alerts.push({
      type: 'RAM',
      value_percent: Number(memPct.toFixed(2)),
      threshold: cfg.ram,
      freshness: fresh ? 'fresh' : 'stale',
    });
  }

  return alerts;
}

/**
 * Cherche une alerte récente (même couple server/service, encore "open") pour anti-spam.
 * On considère "équivalente" si type et sévérité sont identiques.
 */
async function findRecentEquivalentOpenAlert({ server, service, severity, type }, cooldownMinutes) {
  const since = new Date(Date.now() - cooldownMinutes * 60 * 1000);
  return Alert.findOne({
    where: {
      server,
      service,
      severity,
      status: 'open',
      // Sequelize "created_at >= since"
      created_at: { gte: since },
    },
    order: [['created_at', 'DESC']],
  });
}

/**
 * Formate une petite description textuelle de l’alerte créée.
 */
function buildDescription({ server, service, metricType, valuePercent, threshold, freshnessLabel }) {
  const freshnessTxt = freshnessLabel === 'fresh' ? 'données fraîches' : 'données anciennes';
  return `${metricType} élevé sur ${server} (${service}) : ${valuePercent}% (seuil ${threshold}%) - ${freshnessTxt}.`;
}

/**
 * Détermine les destinataires à partir de l'env ou de l'override.
 */
function resolveRecipients(customRecipients) {
  if (Array.isArray(customRecipients) && customRecipients.length > 0) return customRecipients;
  const fallback = (process.env.ALERT_EMAIL_TO || '')
    .split(',')
    .map((s) => s.trim())
    .filter(Boolean);
  return fallback;
}

/**
 * Enfile la notification email dans la mailQueue (idempotente).
 */
function queueNotification({ alertId, recipients, server, service, valuePercent, threshold, description }) {
  if (!recipients || recipients.length === 0) return false;
  mailQueue.enqueue(alertId, recipients, {
    server,
    service,
    value: valuePercent,
    threshold,
    description,
  });
  return true;
}

/**
 * Crée une alerte DB et notifie (selon anti-spam et options).
 * @param {object} params
 * @param {string} params.server - nom hôte/IP
 * @param {string} params.service - 'CPU' | 'RAM' | autre
 * @param {number} params.valuePercent
 * @param {number} params.threshold
 * @param {string} params.freshness - 'fresh' | 'stale'
 * @param {object} options
 * @param {boolean} [options.notify=true]
 * @param {string[]} [options.recipients]
 * @param {number} [options.notifyCooldownMinutes]
 */
async function createAndNotifyAlert(params, options = {}) {
  const {
    server,
    service,
    valuePercent,
    threshold,
    freshness,
  } = params;

  const {
    notify = true,
    recipients: customRecipients,
    notifyCooldownMinutes = DEFAULTS.notifyCooldownMinutes,
  } = options;

  const severity = computeSeverity(valuePercent, threshold);
  const description = buildDescription({
    server,
    service,
    metricType: service,
    valuePercent,
    threshold,
    freshnessLabel: freshness,
  });

  // Anti-spam : existe-t-il déjà une alerte "équivalente" très récente et encore ouverte ?
  const dup = await findRecentEquivalentOpenAlert(
    { server, service, severity, type: service },
    notifyCooldownMinutes
  );

  // On persiste toujours l'alerte (traçabilité), mais on ne renvoie pas forcément un mail
  const created = await Alert.create({
    server,
    service,
    severity,
    status: 'open',
    description,
    started_at: new Date(),
  });

  let notified = false;
  if (notify && !dup) {
    const recipients = resolveRecipients(customRecipients);
    notified = queueNotification({
      alertId: created.id,
      recipients,
      server,
      service,
      valuePercent,
      threshold,
      description,
    });
  }

  return { alert: created.toJSON(), emailQueued: notified, duplicateSuppressed: Boolean(dup) };
}

/**
 * Point d'entrée principal :
 * - Évalue CPU/RAM
 * - Crée les alertes nécessaires
 * - Notifie par e-mail via mailQueue (avec anti-spam)
 *
 * @param {object} ctx
 * @param {string} ctx.server - Nom ou IP du serveur
 * @param {object} ctx.metrics - { cpu_usage, memory_usage, memory_total, last_monitoring }
 * @param {object} [ctx.thresholds] - override des seuils { cpu, ram, freshnessMinutes }
 * @param {object} [ctx.options] - { notify=true, recipients, notifyCooldownMinutes }
 *
 * @returns {Promise<{ created: Array, skipped: Array }>}
 */
async function evaluateAndHandle(ctx) {
  const {
    server,
    metrics,
    thresholds = {},
    options = {},
  } = ctx;

  if (!server) throw new Error('evaluateAndHandle: "server" est requis.');
  if (!metrics || typeof metrics !== 'object') throw new Error('evaluateAndHandle: "metrics" est requis.');

  const results = evaluateResourceAlerts(metrics, thresholds);

  const created = [];
  const skipped = []; // pour info/debug

  for (const r of results) {
    const valuePercent = r.value_percent;
    const threshold = r.threshold;
    const freshness = r.freshness;
    const service = r.type; // 'CPU' ou 'RAM'

    try {
      const out = await createAndNotifyAlert(
        { server, service, valuePercent, threshold, freshness },
        options
      );
      created.push(out);
    } catch (e) {
      console.error(`[alertEvaluator] Échec création/notification alerte ${service} pour ${server}:`, e?.message || e);
      skipped.push({ server, service, reason: e?.message || 'unknown' });
    }
  }

  return { created, skipped };
}

/* =======================
   Exemples d’utilisation
   =======================

   // 1) Dans votre collecteur/cron, après avoir calculé les métriques :
   await evaluateAndHandle({
     server: 'srv-app-01',
     metrics: {
       cpu_usage: 92.4,
       memory_usage: 15500000,  // en KB
       memory_total: 16000000,  // en KB
       last_monitoring: new Date(),
     },
     thresholds: {
       cpu: 85,       // override optionnel
       ram: 90,       // override optionnel
     },
     options: {
       notify: true,                 // par défaut true
       recipients: ['ops@example.org','oncall@example.org'], // override optionnel
       notifyCooldownMinutes: 45,    // anti-spam plus long (override)
     },
   });

   // 2) Si vous avez déjà une route API qui reçoit des métriques,
   //    appelez evaluateAndHandle(...) avec les bons champs.

*/

module.exports = {
  evaluateResourceAlerts,
  evaluateAndHandle,
  computeSeverity,
  toMemPercent,
};
