module.exports = (sequelize, DataTypes) => {
  console.log('📦 Initialisation du modèle Permission');
  const Permission = sequelize.define('Permission', {
    key: {
      type: DataTypes.STRING,
      allowNull: false,
      unique: true,
    },
    name: {
      type: DataTypes.STRING,
      allowNull: false,
    },
    description: {
      type: DataTypes.STRING,
    },
    status: {
      type: DataTypes.ENUM('actif', 'inactif'),
      defaultValue: 'actif',
    },
  }, {
    tableName: 'permissions',
    underscored: true,
  });

  Permission.associate = (models) => {
    console.log('🔗 Association Permission -> Roles');
    Permission.belongsToMany(models.Role, {
      through: models.AssignedPermission,
      foreignKey: 'permission_id',
      otherKey: 'role_id',
      as: 'roles',
    });
  };

  return Permission;
};
