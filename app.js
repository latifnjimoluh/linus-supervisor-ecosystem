const express = require('express');
const cors = require('cors');
require('dotenv').config();
const logger = require('./utils/logger');
const errorHandler = require('./middlewares/errorHandler');

// ---------------------------------------------
// 🔎 DEBUG path-to-regexp : log la route qui casse
// (doit être AVANT tout require de routes)
// ---------------------------------------------
const _App = express.application;
['get','post','put','patch','delete','use','all','options'].forEach((m) => {
  const orig = _App[m];
  _App[m] = function (path, ...rest) {
    try {
      if (typeof path !== 'string') return orig.call(this, path, ...rest);
      return orig.call(this, path, ...rest);
    } catch (e) {
      console.error(`[APP ROUTE ERROR] method=${m} path="${path}"`);
      throw e;
    }
  };
});

const _Router = express.Router;
express.Router = function (...args) {
  const r = _Router.apply(this, args);
  for (const m of ['get','post','put','patch','delete','use','all','options']) {
    const orig = r[m];
    r[m] = function (path, ...rest) {
      try {
        if (typeof path !== 'string') return orig.call(this, path, ...rest);
        return orig.call(this, path, ...rest);
      } catch (e) {
        console.error(`[ROUTER ERROR] method=${m} path="${path}"`);
        throw e;
      }
    };
  }
  return r;
};
// ---------------------------------------------

// ⚠️ Import après patch
const { sequelize } = require('./models');
const routes = require('./routes');

const app = express();
logger.info("Initialisation de l'application Express");

const allowedOrigins = (process.env.CORS_ORIGINS || 'http://localhost:3001')
  .split(',')
  .map((o) => o.trim());

const corsOptions = {
  origin: (origin, callback) => {
    if (!origin || allowedOrigins.includes(origin)) return callback(null, true);
    return callback(new Error('Not allowed by CORS'));
  },
  methods: ['GET','POST','PUT','PATCH','DELETE','OPTIONS'],
  allowedHeaders: ['Content-Type','Authorization'],
  credentials: false,
  maxAge: 86400,
};

// ✅ CORS avant tout
app.use(cors(corsOptions));

// Body parser
app.use(express.json());

// Healthcheck
app.get('/health', (req, res) => res.status(200).send('ok'));

// Routes
app.use(routes);

// 404 catch-all (sans chemin, compatible v6)
app.use((req, res) => res.status(404).json({ message: 'Not found' }));

// Error handler global
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
