module.exports = (sequelize, DataTypes) => {
  const InitializationScript = sequelize.define('InitializationScript', {
    name: {
      type: DataTypes.STRING,
      allowNull: false,
    },
    script_path: {
      type: DataTypes.STRING,
      allowNull: false,
    },
    description: {
      type: DataTypes.TEXT,
    },
  }, {
    tableName: 'initialization_scripts',
    underscored: true,
  });

  return InitializationScript;
};
