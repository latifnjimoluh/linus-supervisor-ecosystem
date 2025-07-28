"use strict";

module.exports = (sequelize, DataTypes) => {
  const Deployment = sequelize.define("Deployment", {
    user_id: DataTypes.INTEGER,
    user_email: DataTypes.STRING,
    vm_name: DataTypes.STRING,
    service_name: DataTypes.STRING,
    operation_type: {
      type: DataTypes.STRING,
      allowNull: false,
      validate: {
        isIn: [["apply", "destroy"]], // facultatif mais conseillé
      }
    },
    started_at: DataTypes.DATE,
    ended_at: DataTypes.DATE,
    duration: DataTypes.STRING,
    success: DataTypes.BOOLEAN,
    log_path: DataTypes.STRING,

    // 🔥 Champs ajoutés
    vm_id: {
      type: DataTypes.INTEGER,
      allowNull: true,
    },
    vm_ip: {
      type: DataTypes.STRING(50),
      allowNull: true,
    },

  }, {
    tableName: "deployments",
    timestamps: true,
    createdAt: "created_at",
    updatedAt: "updated_at",
  });

  return Deployment;
};
