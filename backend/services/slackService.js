const axios = require('axios');

async function sendSlackMessage(text, webhook = process.env.SLACK_WEBHOOK_URL) {
  if (!webhook) {
    console.warn('[Slack] No webhook configured');
    return;
  }
  try {
    await axios.post(webhook, { text });
  } catch (err) {
    console.error('[Slack] Failed to post message:', err.message);
  }
}

module.exports = { sendSlackMessage };
