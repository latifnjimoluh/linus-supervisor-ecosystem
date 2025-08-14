module.exports = (sequelize, DataTypes) => {
  console.log('📦 Initialisation du modèle UserSetting');
  const UserSetting = sequelize.define('UserSetting', {
    user_id: {
      type: DataTypes.INTEGER,
      allowNull: false,
    },
    cloudinit_user: {
      type: DataTypes.STRING,
    },
    cloudinit_password: {
      type: DataTypes.STRING,
    },
    proxmox_api_url: {
      type: DataTypes.STRING,
    },
    proxmox_api_token_id: {
      type: DataTypes.STRING,
    },
    proxmox_api_token_name: {
      type: DataTypes.STRING,
    },
    proxmox_api_token_secret: {
      type: DataTypes.STRING,
    },
    pm_user: {
      type: DataTypes.STRING,
    },
    pm_password: {
      type: DataTypes.STRING,
    },
    proxmox_node: {
      type: DataTypes.STRING,
    },
    vm_storage: {
      type: DataTypes.STRING,
    },
    vm_bridge: {
      type: DataTypes.STRING,
    },
    ssh_public_key_path: {
      type: DataTypes.STRING,
    },
    ssh_private_key_path: {
      type: DataTypes.STRING,
    },
    statuspath: {
      type: DataTypes.STRING,
    },
    servicespath: {
      type: DataTypes.STRING,
    },
    instanceinfopath: {
      type: DataTypes.STRING,
    },
    proxmox_host: {
      type: DataTypes.STRING,
    },
    proxmox_ssh_user: {
      type: DataTypes.STRING,
    },
    alert_cpu_threshold: {
      type: DataTypes.INTEGER,
    },
    alert_ram_threshold: {
      type: DataTypes.INTEGER,
    },
  }, {
    tableName: 'user_settings',
    underscored: true,
  });

  UserSetting.associate = (models) => {
    console.log('🔗 Association UserSetting -> User');
    UserSetting.belongsTo(models.User, { foreignKey: 'user_id', as: 'user' });
  };

  return UserSetting;
};
