"use strict";

module.exports = (sequelize, DataTypes) => {
  const Deployment = sequelize.define("Deployment", {
    user_id: DataTypes.INTEGER,
    user_email: DataTypes.STRING,
    vm_name: DataTypes.STRING,
    service_name: DataTypes.STRING,
    started_at: DataTypes.DATE,
    ended_at: DataTypes.DATE,
    duration: DataTypes.STRING,
    success: DataTypes.BOOLEAN,
    log_path: DataTypes.STRING,
  }, {
    tableName: "deployments", // 🔥 ceci force Sequelize à utiliser le bon nom
    timestamps: true,
    createdAt: "created_at",
    updatedAt: "updated_at",
  });

  return Deployment;
};
