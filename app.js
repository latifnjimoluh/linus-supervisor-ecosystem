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

const corsOptions = {
  origin: (origin, callback) => {
    // autorise aussi les requêtes sans Origin (monitoring, curl…)
    if (!origin || allowedOrigins.includes(origin)) return callback(null, true);
    return callback(new Error('Not allowed by CORS'));
  },
  methods: ['GET','POST','PUT','PATCH','DELETE','OPTIONS'],
  allowedHeaders: ['Content-Type','Authorization'],
  // Tu n’utilises pas de cookies cross-site → false est plus simple
  credentials: false,
  maxAge: 86400, // cache du préflight 24h
};

// ⚠️ CORS AVANT tout
app.use(cors(corsOptions));
// Répondre aux préflights
app.options('*', cors(corsOptions));

app.use(express.json());

// Optionnel : /health pour tester rapidement depuis le front
app.get('/health', (req, res) => res.status(200).send('ok'));

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

if (require.main === module) start();
module.exports = app;
