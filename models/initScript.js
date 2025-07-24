"use strict";

module.exports = (sequelize, DataTypes) => {
  const InitScript = sequelize.define("InitScript", {
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
    }
  }, {
    tableName: "init_scripts",
    timestamps: true,
    createdAt: "created_at",
    updatedAt: "updated_at",
  });

  return InitScript;
};
