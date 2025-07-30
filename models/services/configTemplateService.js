"use strict";

module.exports = (sequelize, DataTypes) => {
  const ConfigTemplateService = sequelize.define(
    "ConfigTemplateService",
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
      tableName: "config_template_services", // ✅ nom explicite
      timestamps: true,
      createdAt: "created_at",
      updatedAt: "updated_at",
    }
  );

  return ConfigTemplateService;
};
