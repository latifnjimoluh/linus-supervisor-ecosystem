module.exports = (sequelize, DataTypes) => {
  const Permission = sequelize.define("Permission", {
    name: {
      type: DataTypes.STRING(100),
      allowNull: false,
      unique: true,
    },
    description: DataTypes.TEXT,
    status: { type: DataTypes.STRING(10), defaultValue: "actif" },
  }, {
    tableName: "permissions",
    timestamps: true,
    createdAt: "created_at",
    updatedAt: "updated_at",
  });

  Permission.associate = (models) => {
    Permission.belongsToMany(models.Role, {
      through: models.RolePermission,
      foreignKey: "permission_id",
      otherKey: "role_id",
      as: "roles",
    });
  };

  return Permission;
};
