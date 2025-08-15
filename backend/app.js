// Charge les .env selon NODE_ENV (.env, .env.development, .env.production, etc.)
require('dotenv-flow').config({ silent: true });

const express = require('express');
const cors = require('cors');
const logger = require('./utils/logger');
const errorHandler = require('./middlewares/errorHandler');

// (Optionnel) petit patch debug des routes — garde si utile
const _App = express.application;
['get','post','put','patch','delete','use','all','options'].forEach((m) => {
  const orig = _App[m];
  _App[m] = function (path, ...rest) {
    try {
      if (typeof path !== 'string') return orig.call(this, path, ...rest);
      return orig.call(this, path, ...rest);
    } catch (e) {
      console.error(`[APP ROUTE ERROR] method=${m} path="${path}"`, e?.message || e);
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
        console.error(`[ROUTER ERROR] method=${m} path="${path}"`, e?.message || e);
        throw e;
      }
    };
  }
  return r;
};

// ⚠️ Import APRÈS le patch
// NB: models/index.js importe ../config/db, initialise les modèles et exporte { sequelize, Sequelize }
const { sequelize } = require('./models');
const routes = require('./routes');
const { init: initTerminalWs } = require('./ws/terminal');

const app = express();
logger.info("Initialisation de l'application Express");

// Default API cache policy: prevent storing user-specific data
app.use((req, res, next) => {
  res.setHeader('Cache-Control', 'private, no-store');
  next();
});

// ------------------ 🔍 LOG ENV & CONFIG DB ------------------
function mask(str) {
  if (!str) return '(unset)';
  const s = String(str);
  if (s.length <= 6) return '*'.repeat(s.length);
  return s.slice(0, 2) + '***' + s.slice(-2);
}

(function logDbEnv() {
  console.log('[ENV] NODE_ENV=', process.env.NODE_ENV || '(unset)');
  console.log(
    '[ENV CHECK]',
    `DB_DIALECT=${process.env.DB_DIALECT || '(unset)'}`,
    `DB_HOST=${process.env.DB_HOST || '(unset)'}`,
    `DB_PORT=${process.env.DB_PORT || '(unset)'}`,
    `DB_NAME=${process.env.DB_NAME || '(unset)'}`,
    `DB_USER=${process.env.DB_USER || '(unset)'}`,
    `DB_SSL=${process.env.DB_SSL || '(unset)'}`,
    `DB_PASS=${process.env.DB_PASS ? mask(process.env.DB_PASS) : '(unset)'}`
  );

  try {
    const cfg = {
      dialect: sequelize.getDialect?.() || sequelize?.options?.dialect,
      host: sequelize?.options?.host,
      port: sequelize?.options?.port,
      database: sequelize?.config?.database,
      username: sequelize?.config?.username,
      ssl: !!(sequelize?.options?.dialectOptions?.ssl?.require || sequelize?.options?.dialectOptions?.ssl),
      rejectUnauthorized: sequelize?.options?.dialectOptions?.ssl?.rejectUnauthorized ?? null,
    };
    console.log('[SEQUELIZE CONFIG]', cfg);
  } catch (e) {
    console.error('[SEQUELIZE CONFIG] lecture impossible:', e?.message || e);
  }
})();
// ------------------------------------------------------------

const allowedOrigins = (process.env.CORS_ORIGINS || 'http://localhost:3001')
  .split(',')
  .map((o) => o.trim())
  .filter(Boolean);

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

// Healthcheck simple
app.get('/health', (req, res) => res.status(200).send('ok'));

// 🔧 Ping DB + aperçu config
app.get('/db/ping', async (req, res) => {
  try {
    await sequelize.query('SELECT 1');
    const cfg = {
      dialect: sequelize.getDialect?.() || sequelize?.options?.dialect,
      host: sequelize?.options?.host,
      port: sequelize?.options?.port,
      database: sequelize?.config?.database,
      username: sequelize?.config?.username,
      ssl: !!(sequelize?.options?.dialectOptions?.ssl?.require || sequelize?.options?.dialectOptions?.ssl),
      rejectUnauthorized: sequelize?.options?.dialectOptions?.ssl?.rejectUnauthorized ?? null,
      env: {
        DB_HOST: process.env.DB_HOST || '(unset)',
        DB_PORT: process.env.DB_PORT || '(unset)',
        DB_NAME: process.env.DB_NAME || '(unset)',
        DB_USER: process.env.DB_USER || '(unset)',
        DB_SSL: process.env.DB_SSL || '(unset)',
        DB_PASS: process.env.DB_PASS ? mask(process.env.DB_PASS) : '(unset)',
      }
    };
    res.status(200).json({ ok: true, cfg });
  } catch (e) {
    console.error('[DB PING] erreur:', e?.message || e);
    res.status(503).json({ ok: false, error: e?.message || 'db error' });
  }
});

// Routes applicatives
app.use(routes);

// 404 catch-all
app.use((req, res) => res.status(404).json({ message: 'Not found' }));

// Error handler global
app.use(errorHandler);

const PORT = process.env.PORT || 3000;

async function start() {
  const server = app.listen(PORT, async () => {
    logger.info(`Serveur démarré sur le port ${PORT}`);
    try {
      console.log('[DB AUTH] Tentative sequelize.authenticate() …');
      await sequelize.authenticate();
      logger.info('Connexion à la base de données réussie');
    } catch (err) {
      console.error('[DB AUTH] échec authenticate():', err?.message || err);
      logger.error('Erreur de connexion à la base de données', err);
    }
  });
  initTerminalWs(server);
}

if (require.main === module) start();
module.exports = app;
module.exports.start = start;
