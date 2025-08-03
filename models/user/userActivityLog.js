module.exports = (sequelize, DataTypes) => {
  const UserActivityLog = sequelize.define("UserActivityLog", {
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
    tableName: "user_activity_logs",
    timestamps: false,
  });

  UserActivityLog.associate = models => {
    UserActivityLog.belongsTo(models.User, {
      foreignKey: "user_id",
      as: "user",
    });
  };

  return UserActivityLog;
};
