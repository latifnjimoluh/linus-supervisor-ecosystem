module.exports = (sequelize, DataTypes) => {
  const MonitoringScript = sequelize.define('MonitoringScript', {
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
    tableName: 'monitoring_scripts',
    underscored: true,
  });

  return MonitoringScript;
};
