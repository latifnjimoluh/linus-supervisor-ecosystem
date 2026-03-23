const fs = require('fs');
const path = require('path');

const settingsPath = path.join(__dirname, '../../config/notificationSettings.json');

function readSettings() {
  if (fs.existsSync(settingsPath)) {
    try {
      return JSON.parse(fs.readFileSync(settingsPath, 'utf8'));
    } catch (err) {
      console.error('Failed to parse notification settings:', err);
    }
  }
  return {
    channels: {
      email: true,
      webhook: '',
      slack: '',
      telegram: '',
      discord: ''
    },
    rules: [],
    retry: { interval: 5, max: 3, consolidate: false, silence: 10 }
  };
}

exports.getSettings = (req, res) => {
  res.json(readSettings());
};

exports.updateSettings = (req, res) => {
  const data = req.body || {};
  try {
    fs.writeFileSync(settingsPath, JSON.stringify(data, null, 2));
    res.json({ message: 'Notification settings saved.' });
  } catch (err) {
    console.error('Failed to save notification settings:', err);
    res.status(500).json({ message: 'Unable to save settings' });
  }
};

exports.testNotification = (req, res) => {
  res.json({ message: 'Test notification sent (simulated).' });
};

