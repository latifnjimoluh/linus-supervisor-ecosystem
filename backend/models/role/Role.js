module.exports = (sequelize, DataTypes) => {
  console.log('📦 Initialisation du modèle Role');
  const Role = sequelize.define('Role', {
    name: {
      type: DataTypes.STRING,
      allowNull: false,
      unique: true,
    },
    status: {
      type: DataTypes.ENUM('actif', 'inactif'),
      defaultValue: 'actif',
    },
  }, {
    tableName: 'roles',
    underscored: true,
  });

  Role.associate = (models) => {
    console.log('🔗 Association Role -> Users & Permissions');
    Role.hasMany(models.User, { foreignKey: 'role_id', as: 'users' });
    Role.belongsToMany(models.Permission, {
      through: models.AssignedPermission,
      foreignKey: 'role_id',
      otherKey: 'permission_id',
      as: 'permissions',
    });
  };

  return Role;
};

