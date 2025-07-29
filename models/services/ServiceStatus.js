
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
      hostname: DataTypes.STRING,
      timestamp: DataTypes.DATE,
      name: DataTypes.STRING,
      enabled: DataTypes.STRING,
      active: DataTypes.STRING
    },
    {
      sequelize,
      modelName: "ServiceStatus",
      tableName: "service_statuses"
    }
  );

  return ServiceStatus;
};
