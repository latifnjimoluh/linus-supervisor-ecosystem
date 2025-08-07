const logger = require('../utils/logger');

function errorHandler(err, req, res, next) {
  logger.error(err.message, { stack: err.stack });
  const status = err.status || 500;
  res.status(status).json({ message: err.message || 'Erreur serveur' });
}

module.exports = errorHandler;
