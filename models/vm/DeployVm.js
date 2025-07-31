"use strict";

module.exports = (sequelize, DataTypes) => {
  const Deployment = sequelize.define("Deployment", {
    user_id: {
      type: DataTypes.INTEGER,
      allowNull: false
    },
    user_email: {
      type: DataTypes.STRING,
      allowNull: false
    },
    vm_name: {
      type: DataTypes.STRING,
      allowNull: false
    },
    service_name: {
      type: DataTypes.STRING,
      allowNull: false
    },
    operation_type: {
      type: DataTypes.STRING,
      allowNull: false,
      validate: {
        isIn: [["apply", "destroy"]]
      }
    },
    started_at: {
      type: DataTypes.DATE,
      allowNull: false
    },
    ended_at: {
      type: DataTypes.DATE,
      allowNull: false
    },
    duration: {
      type: DataTypes.STRING
    },
    success: {
      type: DataTypes.BOOLEAN,
      defaultValue: false
    },
    log_path: {
      type: DataTypes.STRING
    },
    vm_id: {
      type: DataTypes.INTEGER,
      allowNull: true
    },
    vm_ip: {
      type: DataTypes.STRING(50),
      allowNull: true
    },

    instance_id: {
      type: DataTypes.UUID,
      allowNull: false
    },
    injected_files: {
      type: DataTypes.JSONB,
      allowNull: true
    },
    vm_specs: {
      type: DataTypes.JSONB,
      allowNull: true
    },
    status: {
      type: DataTypes.STRING,
      allowNull: false,
      defaultValue: "deployed",
      validate: {
        isIn: [["deployed", "destroyed"]]
      }
    }

  }, {
    tableName: "deployments",
    timestamps: true,
    createdAt: "created_at",
    updatedAt: "updated_at"
  });

  return Deployment;
};
