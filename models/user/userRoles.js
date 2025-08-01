module.exports = (sequelize, DataTypes) => {
  const Role = sequelize.define("Role", {
    name: { type: DataTypes.STRING(50), allowNull: false, unique: true },
    description: DataTypes.TEXT,
    status: { type: DataTypes.STRING(10), defaultValue: "actif" },
  }, {
    tableName: "roles",
    timestamps: true,
    createdAt: "created_at",
    updatedAt: "updated_at",
  });

  Role.associate = (models) => {
    Role.hasMany(models.User, {
      foreignKey: "role_id",
      as: "users",
    });

    Role.belongsToMany(models.Permission, {
      through: models.RolePermission,
      foreignKey: "role_id",
      otherKey: "permission_id",
      as: "permissions",
    });
  };

  return Role;
};
