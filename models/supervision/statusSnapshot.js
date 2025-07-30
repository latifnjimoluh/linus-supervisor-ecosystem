"use strict";
const { Model, DataTypes } = require("sequelize");
const { v4: uuidv4 } = require("uuid");

module.exports = (sequelize) => {
  class StatusSnapshot extends Model {}

  StatusSnapshot.init(
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
      modelName: "StatusSnapshot",
      tableName: "status_snapshots",
      timestamps: true
    }
  );

  return StatusSnapshot;
};
