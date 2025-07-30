// models/vmInstance.js
"use strict";
const { Model, DataTypes } = require("sequelize");
const { v4: uuidv4 } = require("uuid");

module.exports = (sequelize) => {
  class VMInstance extends Model {}

  VMInstance.init(
    {
      id: {
        type: DataTypes.UUID,
        primaryKey: true,
        defaultValue: uuidv4
      },
      instance_id: DataTypes.UUID,
      hostname: DataTypes.STRING,
      ip_address: DataTypes.STRING,
      fetched_at: {
        type: DataTypes.DATE,
        defaultValue: DataTypes.NOW
      }
    },
    {
      sequelize,
      modelName: "VMInstance",
      tableName: "vm_instances",
      underscored: true,
      timestamps: false
    }
  );

  return VMInstance;
};
