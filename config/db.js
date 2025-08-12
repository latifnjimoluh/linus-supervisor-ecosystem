const { Sequelize } = require("sequelize");
require("dotenv").config();

console.log("🚀 Initialisation de Sequelize...");

const sequelize = new Sequelize(
  process.env.DB_NAME,
  process.env.DB_USER,
  process.env.DB_PASS,
  {
    host: process.env.DB_HOST,
    port: process.env.DB_PORT || 5432,
    dialect: "postgres",
    logging: false,
  }
);

sequelize
  .authenticate()
  .then(() => console.log("✅ Connexion PostgreSQL établie."))
  .catch((err) => console.error("❌ Erreur de connexion PostgreSQL:", err));

module.exports = {
  sequelize,
  Sequelize
};
