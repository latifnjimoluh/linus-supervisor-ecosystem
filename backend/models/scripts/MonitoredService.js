module.exports = (sequelize, DataTypes) => {
  const MonitoredService = sequelize.define('MonitoredService', {
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
    tableName: 'monitored_services',
    underscored: true,
  });

  return MonitoredService;
};
