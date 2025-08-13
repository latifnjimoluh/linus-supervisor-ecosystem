"use strict";

const fs = require("fs");
const path = require("path");
const { sequelize, Sequelize } = require("../config/db");

const basename = path.basename(__filename);
const db = { Sequelize, sequelize };

function isModelFile(file) {
  return file.endsWith(".js") && file !== basename && !file.endsWith(".test.js");
}

function loadModels(dir) {
  fs.readdirSync(dir, { withFileTypes: true }).forEach((entry) => {
    const fullPath = path.join(dir, entry.name);

    if (entry.isDirectory()) {
      loadModels(fullPath);
      return;
    }

    if (!entry.isFile() || !isModelFile(entry.name)) return;

    try {
      const mod = require(fullPath);
      // Supporte export CommonJS et export default
      const define =
        (typeof mod === "function" && mod) ||
        (mod && typeof mod.default === "function" && mod.default);

      if (!define) {
        console.warn(`⏭️  Fichier ignoré (pas un modèle valide) : ${fullPath}`);
        return;
      }

      const model = define(sequelize, Sequelize.DataTypes);
      if (!model || !model.name) {
        console.warn(`⏭️  Modèle sans nom ignoré : ${fullPath}`);
        return;
      }

      db[model.name] = model;
      console.log(`📁 Modèle chargé : ${model.name}`);
    } catch (err) {
      console.error(`❌ Erreur lors du chargement du modèle ${fullPath}`, err);
    }
  });
}

// Charge tous les modèles à partir de ce dossier
loadModels(__dirname);

// Configure les associations si définies sur les modèles
Object.keys(db).forEach((modelName) => {
  const model = db[modelName];
  if (model && typeof model.associate === "function") {
    try {
      model.associate(db);
      console.log(`🔗 Associations configurées pour : ${modelName}`);
    } catch (err) {
      console.error(`❌ Erreur association pour ${modelName}`, err);
    }
  }
});

module.exports = db;
