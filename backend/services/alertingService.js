// services/alertingService.js
const { Alert } = require('../models');
const { evaluateResourceAlerts } = require('../services/alertEvaluator'); // ton fichier existant
const mailQueue = require('../utils/notificationQueue');
const { sendSlackMessage } = require('./slackService');

function recipientsFromEnv(extraEmail) {
  const list = (process.env.ALERT_EMAIL_TO || '')
    .split(',')
    .map((s) => s.trim())
    .filter(Boolean);
  if (extraEmail) list.unshift(extraEmail);
  return [...new Set(list)];
}

/**
 * Génère la description lisible d'une alerte.
 */
function buildDescription(vm, a) {
  const what = a.type === 'CPU' ? 'CPU' : 'RAM';
  return `${what} usage ${a.value_percent}% (seuil ${a.threshold}%)`;
}

/**
 * Transforme une alerte évaluée en enregistrement DB + notification e-mail.
 * Idempotence: si une alerte identique "ouverte" existe dans la fenêtre récente, on évite le spam.
 */
async function persistAndNotify(vm, a, opts = {}) {
  const severity = a.value_percent >= 90 ? 'critique'
                   : a.value_percent >= 75 ? 'majeure'
                   : 'mineure';

  const description = buildDescription(vm, a);

  // 1) Persistance
  const alert = await Alert.create({
    server: vm.hostname || vm.name || vm.ip || vm.id,
    service: a.type,                  // "CPU" ou "RAM"
    severity,                         // "critique", "majeure", "mineure"
    status: 'open',
    description,
    started_at: new Date(),
  });

  // 2) Enqueue e-mail
  const recipients = recipientsFromEnv(opts.userEmail);
  if (recipients.length > 0) {
    mailQueue.enqueue(alert.id, recipients, {
      server: alert.server,
      service: alert.service,
      value: a.value_percent,
      threshold: a.threshold,
      description: alert.description,
    });
  } else {
    console.warn('[ALERTING] ALERT_EMAIL_TO non défini: aucune notification e-mail ne sera envoyée.');
  }

  // Slack notification
  const slackText = `[ALERT] ${alert.server} ${alert.service}: ${alert.description}`;
  await sendSlackMessage(slackText);

  return alert;
}

/**
 * Point d’entrée: traite les métriques d’une VM, crée les alertes et envoie les mails si nécessaire.
 * @param {object} vm - Objet VM tel que reçu (id, name, hostname, cpu_usage, memory_usage, memory_total, last_monitoring, ...)
 * @param {object} [overrides] - pour forcer des seuils (facultatif)
 * @param {object} [options] - options supplémentaires
 * @param {string} [options.userEmail] - email de l'utilisateur déclenchant l'ingestion
 * @returns {Promise<{created:number, alerts:any[]}>}
 */
async function handleResourceMetrics(vm, overrides = {}, options = {}) {
  // Sécurité: calcul RAM% uniquement si total > 0 (sinon 0)
  const memory_total = Number(vm.memory_total || 0);
  const memory_usage = Number(vm.memory_usage || 0);
  const cpu_usage = Number(vm.cpu_usage || 0);

  const metrics = {
    cpu_usage,
    memory_usage,
    memory_total,
    last_monitoring: vm.last_monitoring || null,
  };

  const evaluated = evaluateResourceAlerts(metrics, overrides); // renvoie [{type:'CPU'|'RAM', value_percent, threshold, state, freshness}, ...]
  const created = [];
  for (const a of evaluated) {
    // Option: si fraicheur "stale", tu peux choisir d'envoyer quand même — ici on envoie toujours
    const al = await persistAndNotify(vm, a, { userEmail: options.userEmail });
    created.push(al);
  }

  return { created: created.length, alerts: created.map(a => a.toJSON()) };
}

module.exports = { handleResourceMetrics };
