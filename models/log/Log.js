module.exports = (sequelize, DataTypes) => {
  console.log('📦 Initialisation du modèle Log');
  const Log = sequelize.define('Log', {
    user_id: {
      type: DataTypes.INTEGER,
    },
    action: {
      type: DataTypes.STRING,
      allowNull: false,
    },
    details: {
      type: DataTypes.TEXT,
    },
    host: {
      type: DataTypes.STRING,
    },
    level: {
      type: DataTypes.STRING,
    },
    source: {
      type: DataTypes.STRING,
    },
  }, {
    tableName: 'logs',
    underscored: true,
    timestamps: true,
    createdAt: 'created_at',
    updatedAt: false,
  });

  Log.associate = (models) => {
    console.log('🔗 Association Log -> User');
    Log.belongsTo(models.User, { foreignKey: 'user_id', as: 'user' });
  };

  return Log;
};
