"use strict";

module.exports = (sequelize, DataTypes) => {
  const ConfigTemplate = sequelize.define("ConfigTemplate", {
    name: {
      type: DataTypes.STRING,
      allowNull: false,
      unique: true
    },
    service_type: {
      type: DataTypes.STRING,
      allowNull: false
    },
    category: {
      type: DataTypes.ENUM("configuration", "monitoring"),
      allowNull: false,
      defaultValue: "configuration"
    },
    description: {
      type: DataTypes.TEXT,
      allowNull: true
    },
    template_path: {
      type: DataTypes.STRING,
      allowNull: false
    }
  }, {
    tableName: "config_templates",
    timestamps: true,
    createdAt: "created_at",
    updatedAt: "updated_at",
  });

  return ConfigTemplate;
};
