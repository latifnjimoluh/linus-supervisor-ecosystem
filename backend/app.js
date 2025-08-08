const express = require('express');
const cors = require('cors');
require('dotenv').config();
const { sequelize } = require('./models');
const routes = require('./routes');
const logger = require('./utils/logger');
const errorHandler = require('./middlewares/errorHandler');

const app = express();
logger.info("Initialisation de l'application Express");

const allowedOrigins = (process.env.CORS_ORIGINS || 'http://localhost:3001')
  .split(',')
  .map((o) => o.trim());

// ✅ CORS doit venir AVANT les routes
app.use(
  cors({
    origin: (origin, callback) => {
      if (!origin || allowedOrigins.includes(origin)) {
        return callback(null, true);
      }
      return callback(new Error('Not allowed by CORS'));
    },
    credentials: true,
  })
);

app.use(express.json());
app.use(routes);

const PORT = process.env.PORT || 3000;

app.use(errorHandler);

async function start() {
  app.listen(PORT, async () => {
    logger.info(`Serveur démarré sur le port ${PORT}`);
    try {
      await sequelize.authenticate();
      logger.info('Connexion à la base de données réussie');
    } catch (err) {
      logger.error('Erreur de connexion à la base de données', err);
    }
  });
}

if (require.main === module) {
  start();
}

module.exports = app;
