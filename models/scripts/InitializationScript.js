"use strict";

module.exports = (sequelize, DataTypes) => {
  const InitializationScript = sequelize.define("InitializationScript", {
    name: {
      type: DataTypes.STRING,
      allowNull: false,
    },
    script_path: {
      type: DataTypes.STRING,
      allowNull: false,
    },
    service_type: {
      type: DataTypes.STRING,
      allowNull: false,
    },
    description: {
      type: DataTypes.TEXT,
      allowNull: true,
    }
  }, {
    tableName: "initialization_scripts",
    timestamps: true,
    createdAt: "created_at",
    updatedAt: "updated_at",
  });

  return InitializationScript;
};
