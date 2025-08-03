module.exports = (sequelize, DataTypes) => {
  const AssignedPermission = sequelize.define("AssignedPermission", {
    role_id: {
      type: DataTypes.INTEGER,
      references: {
        model: "roles",
        key: "id",
      },
    },
    permission_id: {
      type: DataTypes.INTEGER,
      references: {
        model: "permissions",
        key: "id",
      },
    },
  }, {
    tableName: "assigned_permissions",
    timestamps: true,
    createdAt: "created_at",
    updatedAt: "updated_at",
    indexes: [
      {
        unique: true,
        fields: ["role_id", "permission_id"],
      },
    ],
  });

  return AssignedPermission;
};
