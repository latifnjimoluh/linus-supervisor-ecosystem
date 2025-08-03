// models/serviceStatus.js
"use strict";
const { Model, DataTypes } = require("sequelize");
const { v4: uuidv4 } = require("uuid");

module.exports = (sequelize) => {
  class ServiceStatus extends Model {}

  ServiceStatus.init(
    {
      id: {
        type: DataTypes.UUID,
        primaryKey: true,
        defaultValue: uuidv4
      },
      instance_id: {
        type: DataTypes.UUID,
        allowNull: true
      },
      hostname: DataTypes.STRING,
      timestamp: DataTypes.DATE,
      formatted_data: {
        type: DataTypes.JSONB,
        allowNull: false
      }
    },
    {
      sequelize,
      modelName: "ServiceStatus",
      tableName: "service_statuses",
      underscored: true,
      timestamps: true
    }
  );

  return ServiceStatus;
};
