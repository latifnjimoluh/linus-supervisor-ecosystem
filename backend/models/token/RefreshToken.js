module.exports = (sequelize, DataTypes) => {
  const RefreshToken = sequelize.define(
    'RefreshToken',
    {
      jti: {
        type: DataTypes.UUID,
        defaultValue: DataTypes.UUIDV4,
        primaryKey: true,
      },
      user_id: {
        type: DataTypes.INTEGER,
        allowNull: false,
      },
      device_id: {
        type: DataTypes.STRING,
        allowNull: false,
      },
      revoked: {
        type: DataTypes.BOOLEAN,
        defaultValue: false,
      },
      expires_at: {
        type: DataTypes.DATE,
        allowNull: false,
      },
    },
    {
      tableName: 'refresh_tokens',
      underscored: true,
      timestamps: false,
    }
  );

  RefreshToken.associate = (models) => {
    RefreshToken.belongsTo(models.User, { foreignKey: 'user_id', as: 'user' });
  };

  return RefreshToken;
};
