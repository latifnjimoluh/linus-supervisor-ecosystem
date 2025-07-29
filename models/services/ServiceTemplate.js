"use strict";

module.exports = (sequelize, DataTypes) => {
  const ServiceTemplate = sequelize.define("ServiceTemplate", {
    name: {
      type: DataTypes.STRING,
      allowNull: false,
      unique: true
    },
    service_type: {
      type: DataTypes.STRING,
      allowNull: false
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
    tableName: "service_templates",
    timestamps: true,
    createdAt: "created_at",
    updatedAt: "updated_at",
  });

  return ServiceTemplate;
};
