"use strict";

module.exports = (sequelize, DataTypes) => {
  const ServiceConfiguration = sequelize.define(
    "ServiceConfiguration",
    {
      service_type: {
        type: DataTypes.STRING,
        allowNull: false,
      },
      config_data: {
        type: DataTypes.JSONB,
        allowNull: false,
      },
      script_path: {
        type: DataTypes.STRING,
        allowNull: false,
      },
    },
    {
      tableName: "service_configurations",
      timestamps: true,
      createdAt: "created_at",
      updatedAt: "updated_at",
    }
  );

  return ServiceConfiguration;
};
