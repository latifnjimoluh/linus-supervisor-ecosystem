const { sendAlertEmail } = require('./mailer');

// In-memory queue for alert notifications
const queue = [];
const statuses = new Map(); // notificationId -> { status, retries, error }
const processed = new Set();

function enqueue(notificationId, recipients, alert) {
  if (processed.has(notificationId) || statuses.get(notificationId)?.status === 'queued' || statuses.get(notificationId)?.status === 'sending') {
    return; // idempotent: already sent or in progress
  }
  queue.push({ id: notificationId, recipients, alert, retries: 0 });
  statuses.set(notificationId, { status: 'queued', retries: 0 });
}

async function processQueue() {
  if (queue.length === 0) return;
  const job = queue.shift();
  statuses.set(job.id, { status: 'sending', retries: job.retries });
  try {
    await sendAlertEmail(job.recipients, job.alert);
    statuses.set(job.id, { status: 'sent', retries: job.retries });
    processed.add(job.id);
  } catch (err) {
    job.retries += 1;
    if (job.retries < 3) {
      statuses.set(job.id, { status: 'queued', retries: job.retries, error: err.message });
      const delay = Math.pow(2, job.retries) * 1000; // exponential backoff
      setTimeout(() => queue.push(job), delay);
    } else {
      statuses.set(job.id, { status: 'failed', retries: job.retries, error: err.message });
    }
  }
}

setInterval(processQueue, 1000);

function getStatus(id) {
  return statuses.get(id)?.status || 'unknown';
}

function getAllStatuses() {
  const res = [];
  statuses.forEach((val, key) => res.push({ notification_id: key, ...val }));
  return res;
}

module.exports = { enqueue, getStatus, getAllStatuses };
