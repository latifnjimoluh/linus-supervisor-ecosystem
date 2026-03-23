// config/db.js
const { Sequelize } = require('sequelize');
require('dotenv-flow').config({ silent: true });

const isProd = process.env.NODE_ENV === 'production';
const dialect = process.env.DB_DIALECT || 'postgres';

// Support DATABASE_URL (DSN) ou variables séparées
const dsn = process.env.DATABASE_URL || process.env.DB_URL;

function buildDialectOptions() {
  // Render/Postgres gèrent souvent SSL → DB_SSL=true ou PGSSLMODE=require
  const sslEnv = String(process.env.DB_SSL || '').toLowerCase();
  const needSSL =
    sslEnv === 'true' ||
    String(process.env.PGSSLMODE || '').toLowerCase() === 'require' ||
    process.env.RENDER === 'true';

  if (!needSSL) return {};
  const reject = String(process.env.DB_SSL_REJECT_UNAUTHORIZED || 'false').toLowerCase() === 'true';
  return {
    ssl: { require: true, rejectUnauthorized: reject }
  };
}

const commonOpts = {
  dialect,
  logging: false,
  dialectOptions: buildDialectOptions(),
};

let sequelize;
if (dsn) {
  sequelize = new Sequelize(dsn, commonOpts);
} else {
  sequelize = new Sequelize(
    process.env.DB_NAME,
    process.env.DB_USER,
    process.env.DB_PASS,
    {
      ...commonOpts,
      host: process.env.DB_HOST,
      port: process.env.DB_PORT || 5432,
    }
  );
}

// Logs de debug (sans password en clair)
const mask = (s) => (s ? String(s).replace(/(.{2}).+(.{2})/, '$1***$2') : '(unset)');
console.log('[ENV] NODE_ENV=', process.env.NODE_ENV || '(unset)');
console.log('[DB] dialect=', dialect,
  ' host=', process.env.DB_HOST || '(from URL)',
  ' port=', process.env.DB_PORT || '(from URL)',
  ' name=', process.env.DB_NAME || '(from URL)',
  ' user=', process.env.DB_USER || '(from URL)',
  ' ssl=', !!commonOpts.dialectOptions.ssl,
  ' url=', dsn ? '(DATABASE_URL/DB_URL)' : '(none)'
);

module.exports = { sequelize, Sequelize };
