"use strict";
const { Model, DataTypes } = require("sequelize");
const { v4: uuidv4 } = require("uuid");

module.exports = (sequelize) => {
  class Delete extends Model {}

  Delete.init(
    {
      id: {
        type: DataTypes.UUID,
        primaryKey: true,
        defaultValue: uuidv4
      },
      instance_id: DataTypes.UUID,
      vm_id: DataTypes.INTEGER,
      vm_name: DataTypes.STRING,
      vm_ip: DataTypes.STRING,
      log_path: DataTypes.TEXT,
      user_id: DataTypes.INTEGER,
      user_email: DataTypes.STRING,
      deleted_at: {
        type: DataTypes.DATE,
        defaultValue: DataTypes.NOW
      }
    },
    {
      sequelize,
      modelName: "Delete",
      tableName: "deletes",
      underscored: true,
      timestamps: false
    }
  );

  return Delete;
};
