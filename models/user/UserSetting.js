"use strict";

module.exports = (sequelize, DataTypes) => {
  const UserSetting = sequelize.define("UserSetting", {
    user_id: {
      type: DataTypes.INTEGER,
      allowNull: false
    },
    cloudinit_user: {
      type: DataTypes.STRING,
      defaultValue: "nexus"
    },
    cloudinit_password: {
      type: DataTypes.STRING
    },
    proxmox_api_url: {
      type: DataTypes.STRING,
      defaultValue: "https://192.168.24.134:8000/api2/json"
    },
    proxmox_api_token_id: {
      type: DataTypes.STRING,
      defaultValue: "root@pam"
    },
    proxmox_api_token_name: {
      type: DataTypes.STRING,
      defaultValue: "delete"
    },
    proxmox_api_token_secret: {
      type: DataTypes.STRING
    },
    pm_user: {
      type: DataTypes.STRING,
      defaultValue: "root@pam"
    },
    pm_password: {
      type: DataTypes.STRING
    },
    proxmox_node: {
      type: DataTypes.STRING,
      defaultValue: "pve"
    },
    vm_storage: {
      type: DataTypes.STRING,
      defaultValue: "local-lvm"
    },
    vm_bridge: {
      type: DataTypes.STRING,
      defaultValue: "vmbr0"
    },
    ssh_public_key_path: {
      type: DataTypes.STRING,
      defaultValue: "C:/Users/Nexus-PC/.ssh/id_rsa.pub"
    },
    ssh_private_key_path: {
      type: DataTypes.STRING,
      defaultValue: "C:/Users/Nexus-PC/.ssh/id_rsa"
    },
    statuspath: {
      type: DataTypes.STRING,
      defaultValue: "/tmp/status.json"
    },
    servicespath: {
      type: DataTypes.STRING,
      defaultValue: "/tmp/services_status.json"
    },
    instanceinfopath: {
      type: DataTypes.STRING,
      defaultValue: "/etc/instance-info.conf"
    },
    proxmox_host: {
      type: DataTypes.STRING,
      defaultValue: "192.168.24.134"
    },
    proxmox_ssh_user: {
      type: DataTypes.STRING,
      defaultValue: "root"
    },

  }, {
    tableName: "user_settings",
    timestamps: true,
    createdAt: "created_at",
    updatedAt: "updated_at",
  });

  return UserSetting;
};
