"use strict";
const { Model, DataTypes } = require("sequelize");
const { v4: uuidv4 } = require("uuid");

module.exports = (sequelize) => {
  class SupervisionStatus extends Model {}

  SupervisionStatus.init(
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
      bind9_status: DataTypes.STRING,
      port_53: DataTypes.STRING,
      named_checkconf: DataTypes.STRING,
      zone_check: DataTypes.STRING,
      dig_test_local: DataTypes.STRING,
      open_ports: DataTypes.STRING,
      scan_duration_seconds: DataTypes.FLOAT,
      cpu_load: DataTypes.STRING,
      ram_usage: DataTypes.STRING,
      disk_usage: DataTypes.STRING
    },
    {
      sequelize,
      modelName: "SupervisionStatus",
      tableName: "supervision_statuses",
      underscored: true,
      timestamps: true
    }
  );

  return SupervisionStatus;
};
