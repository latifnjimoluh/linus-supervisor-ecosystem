"use strict";

module.exports = (sequelize, DataTypes) => {
  const MonitoringScript = sequelize.define(
    "MonitoringScript",
    {
      name: {
        type: DataTypes.STRING(100),
        allowNull: false,
      },
      script_path: {
        type: DataTypes.TEXT,
        allowNull: false,
      },
      service_type: {
        type: DataTypes.STRING(50),
        allowNull: false,
      },
    },
    {
      tableName: "monitoring_scripts",
      timestamps: true,
      createdAt: "created_at",
      updatedAt: "updated_at",
    }
  );

  return MonitoringScript;
};
