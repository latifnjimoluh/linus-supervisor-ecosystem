"use strict";
const fs = require("fs");
const path = require("path");
const { sequelize, Sequelize } = require("../config/db");

const basename = path.basename(__filename);
const db = { Sequelize, sequelize };

function loadModels(dir) {
  fs.readdirSync(dir, { withFileTypes: true }).forEach((entry) => {
    const fullPath = path.join(dir, entry.name);

    if (entry.isDirectory()) {
      loadModels(fullPath);
    } else if (
      entry.isFile() &&
      entry.name.endsWith(".js") &&
      entry.name !== basename
    ) {
      const model = require(fullPath)(sequelize, Sequelize.DataTypes);
      db[model.name] = model;
      console.log(`📁 Modèle chargé : ${model.name}`);
    }
  });
}

loadModels(__dirname);

Object.keys(db).forEach((modelName) => {
  if (db[modelName].associate) {
    db[modelName].associate(db);
    console.log(`🔗 Associations configurées pour : ${modelName}`);
  }
});

module.exports = db;
