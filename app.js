const express = require('express');
const cors = require('cors');
require('dotenv').config();
const logger = require('./utils/logger');
const errorHandler = require('./middlewares/errorHandler');

// ---------------------------------------------
// 🔎 DEBUG path-to-regexp : log la route qui casse
// (doit être AVANT tout require de fichiers de routes)
// ---------------------------------------------
const _Router = express.Router;
express.Router = function (...args) {
  const r = _Router.apply(this, args);
  for (const m of ['get','post','put','patch','delete','use','all']) {
    const orig = r[m];
    r[m] = function (path, ...rest) {
      try {
        // si le 1er argument n'est pas une string (middleware direct), on passe tel quel
        if (typeof path !== 'string') return orig.call(this, path, ...rest);
        return orig.call(this, path, ...rest);
      } catch (e) {
        console.error(`[ROUTE ERROR] method=${m} path="${path}"`);
        throw e;
      }
    };
  }
  return r;
};
// ---------------------------------------------

// ⚠️ Import des modèles après le patch (si vos modèles déclarent des routes, rares cas)
const { sequelize } = require('./models');

// ⚠️ Import des routes APRÈS le patch debug
const routes = require('./routes');

const app = express();
logger.info('Initialisation de l\'application Express');

const allowedOrigins = (process.env.CORS_ORIGINS || 'http://localhost:3001')
  .split(',')
  .map((o) => o.trim());

const corsOptions = {
  origin: (origin, callback) => {
    if (!origin || allowedOrigins.includes(origin)) return callback(null, true);
    return callback(new Error('Not allowed by CORS'));
  },
  methods: ['GET', 'POST', 'PUT', 'PATCH', 'DELETE', 'OPTIONS'],
  allowedHeaders: ['Content-Type', 'Authorization'],
  credentials: false,
  maxAge: 86400,
};

// CORS avant tout
app.use(cors(corsOptions));
// Préflight
app.options('*', cors(corsOptions));

app.use(express.json());

// Healthcheck simple (utile pour Render et tests CORS/OPTIONS)
app.get('/health', (req, res) => res.status(200).send('ok'));

// Regroupe toutes les routes de l'app
app.use(routes);

// Error handler global (après les routes)
app.use(errorHandler);

const PORT = process.env.PORT || 3000;

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
