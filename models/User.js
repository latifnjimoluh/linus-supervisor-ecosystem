module.exports = (sequelize, DataTypes) => {
  console.log('📦 Initialisation du modèle User');
  const User = sequelize.define('User', {
    first_name: {
      type: DataTypes.STRING,
      allowNull: false,
    },
    last_name: {
      type: DataTypes.STRING,
      allowNull: false,
    },
    email: {
      type: DataTypes.STRING,
      allowNull: false,
      unique: true,
    },
    phone: {
      type: DataTypes.STRING,
    },
    password: {
      type: DataTypes.STRING,
      allowNull: false,
    },
    status: {
      type: DataTypes.ENUM('active', 'inactif', 'blocked'),
      defaultValue: 'active',
    },
    reset_token: {
      type: DataTypes.STRING,
    },
    reset_expires_at: {
      type: DataTypes.DATE,
    },
    last_password_reset_at: {
      type: DataTypes.DATE,
    },
  }, {
    tableName: 'users',
    underscored: true,
  });

  User.associate = (models) => {
    console.log('🔗 Association User -> Role');
    User.belongsTo(models.Role, { foreignKey: 'role_id', as: 'role' });
    console.log('🔗 Association User -> UserSetting');
    User.hasOne(models.UserSetting, { foreignKey: 'user_id', as: 'settings' });
  };

  return User;
};

