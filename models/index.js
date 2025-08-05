const { Sequelize } = require('sequelize');
const fs = require('fs');
const path = require('path');
require('dotenv').config();

console.log('🚀 Initialisation de Sequelize');

const sequelize = new Sequelize(
  process.env.DB_NAME || 'database',
  process.env.DB_USER || 'root',
  process.env.DB_PASS || '',
  {
    host: process.env.DB_HOST || 'localhost',
    dialect: process.env.DB_DIALECT || 'mysql',
    logging: (msg) => console.log(`📝 [Sequelize] ${msg}`),
  }
);

const db = {};

db.Sequelize = Sequelize;
db.sequelize = sequelize;

const basename = path.basename(__filename);

function loadModels(dir) {
  fs.readdirSync(dir).forEach((file) => {
    const fullPath = path.join(dir, file);
    if (fs.statSync(fullPath).isDirectory()) {
      loadModels(fullPath);
      return;
    }
    if (file === basename || !file.endsWith('.js')) return;
    console.log(`📁 Chargement du modèle '${path.relative(__dirname, fullPath)}'`);
    const model = require(fullPath)(sequelize, Sequelize.DataTypes);
    db[model.name] = model;
  });
}

loadModels(__dirname);

Object.keys(db).forEach((modelName) => {
  if (db[modelName].associate) {
    console.log(`🔗 Association du modèle '${modelName}'`);
    db[modelName].associate(db);
  }
});

module.exports = db;