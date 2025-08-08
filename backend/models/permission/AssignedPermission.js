module.exports = (sequelize, DataTypes) => {
  console.log('📦 Initialisation du modèle AssignedPermission');
  const AssignedPermission = sequelize.define('AssignedPermission', {
    role_id: {
      type: DataTypes.INTEGER,
      allowNull: false,
      references: {
        model: 'roles',
        key: 'id',
      },
    },
    permission_id: {
      type: DataTypes.INTEGER,
      allowNull: false,
      references: {
        model: 'permissions',
        key: 'id',
      },
    },
  }, {
    tableName: 'assigned_permissions',
    timestamps: false,
    underscored: true,
  });

  return AssignedPermission;
};

