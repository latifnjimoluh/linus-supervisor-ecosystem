const fs = require('fs');
const path = require('path');
const { Log } = require('../models');

const filePath = path.join(__dirname, '..', 'logs', 'app.log');

// append entry to log file
const writeToFile = (entry) => {
  fs.appendFile(filePath, entry + '\n', (err) => {
    if (err) {
      console.error('❌ Erreur écriture fichier log:', err);
    }
  });
};

// middleware logging request and save to DB
const logRequest = async (req, res, next) => {
  try {
    const entry = {
      user_id: req.user ? req.user.id : null,
      action: `${req.method} ${req.originalUrl}`,
      details: { body: req.body, query: req.query },
    };
    await Log.create({ ...entry, details: JSON.stringify(entry.details) });
    writeToFile(`REQUEST ${entry.user_id || 'anonyme'} ${entry.action} ${JSON.stringify(entry.details)}`);
    console.log('📝 Log sauvegardé:', req.method, req.originalUrl);
  } catch (err) {
    console.error('❌ Erreur sauvegarde log:', err);
  }
  next();
};

// helper to log custom actions from controllers
const logAction = async (req, action, details = {}) => {
  try {
    const entry = {
      user_id: req.user ? req.user.id : null,
      action,
      details,
    };
    await Log.create({ ...entry, details: JSON.stringify(details) });
    writeToFile(`ACTION ${entry.user_id || 'anonyme'} ${action} ${JSON.stringify(details)}`);
    console.log('📝 Log action sauvegardé:', action);
  } catch (err) {
    console.error('❌ Erreur logAction:', err);
  }
};

module.exports = { logRequest, logAction };
