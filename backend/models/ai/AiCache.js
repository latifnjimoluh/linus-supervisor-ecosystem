module.exports = (sequelize, DataTypes) => {
  console.log('📦 Initialisation du modèle AiCache');
  const AiCache = sequelize.define('AiCache', {
    type: {
      type: DataTypes.STRING,
      allowNull: false,
    },
    hash: {
      type: DataTypes.STRING,
      allowNull: false,
      unique: true,
    },
    input_text: {
      type: DataTypes.TEXT('long'),
      allowNull: false,
    },
    response_text: {
      type: DataTypes.TEXT('long'),
      allowNull: false,
    },
    entity_type: {
      type: DataTypes.STRING,
      allowNull: true,
    },
    entity_id: {
      type: DataTypes.INTEGER,
      allowNull: true,
    },
  }, {
    tableName: 'ai_cache',
    underscored: true,
  });

  return AiCache;
};
