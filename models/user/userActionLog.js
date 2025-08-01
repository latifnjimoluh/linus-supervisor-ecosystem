module.exports = (sequelize, DataTypes) => {
  const UserActionLog = sequelize.define("UserActionLog", {
    id: {
      type: DataTypes.UUID,
      primaryKey: true,
      defaultValue: DataTypes.UUIDV4,
    },
    user_id: {
      type: DataTypes.INTEGER,
      allowNull: false,
    },
    action: {
      type: DataTypes.STRING,
      allowNull: false,
    },
    details: {
      type: DataTypes.TEXT,
      allowNull: true,
    },
    created_at: {
      type: DataTypes.DATE,
      defaultValue: DataTypes.NOW,
    },
  }, {
    tableName: "user_action_logs",
    timestamps: false,
  });

  UserActionLog.associate = models => {
    UserActionLog.belongsTo(models.User, {
      foreignKey: "user_id",
      as: "user",
    });
  };

  return UserActionLog;
};
