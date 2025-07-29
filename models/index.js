"use strict";
const fs = require("fs");
const path = require("path");
const Sequelize = require("sequelize");
const basename = path.basename(__filename);
const config = require(__dirname + "/../config/config.json")["development"];
const db = {};

const sequelize = new Sequelize(
  config.database,
  config.username,
  config.password,
  config
);

// 🔥 Charger tous les modèles
fs.readdirSync(__dirname)
  .filter((file) => {
    return file.indexOf(".") !== 0 && file !== basename && file.slice(-3) === ".js";
  })
  .forEach((file) => {
    const model = require(path.join(__dirname, file))(sequelize, Sequelize.DataTypes);
    db[model.name] = model;
  });

db.sequelize = sequelize;
db.Sequelize = Sequelize;

// 🔧 Si le chargement auto ne suffit pas :
db.Deployment = require("./deployment")(sequelize, Sequelize.DataTypes);
db.User = require("./user")(sequelize, Sequelize.DataTypes);
db.InitScript = require("./initScript")(sequelize, Sequelize.DataTypes);
db.serviceConfiguration = require("./ServiceConfiguration")(sequelize, Sequelize.DataTypes);
db.MonitoringScript = require("./monitoringScript")(sequelize, Sequelize.DataTypes);
db.ServiceTemplate = require("./serviceTemplate")(sequelize, Sequelize.DataTypes); 
db.MonitoringService = require("./monitoringService")(sequelize, Sequelize.DataTypes);


module.exports = db;
