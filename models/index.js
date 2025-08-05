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

fs.readdirSync(__dirname)
  .filter((file) => file !== basename && file.endsWith('.js'))
  .forEach((file) => {
    console.log(`📁 Chargement du modèle '${file}'`);
    const model = require(path.join(__dirname, file))(sequelize, Sequelize.DataTypes);
    db[model.name] = model;
  });

Object.keys(db).forEach((modelName) => {
  if (db[modelName].associate) {
    console.log(`🔗 Association du modèle '${modelName}'`);
    db[modelName].associate(db);
  }
});

module.exports = db;

