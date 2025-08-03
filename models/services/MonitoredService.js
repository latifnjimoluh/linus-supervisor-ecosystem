module.exports = (sequelize, DataTypes) => {
  const MonitoredService = sequelize.define("MonitoredService", {
    name: {
      type: DataTypes.STRING,
      allowNull: false,
    },
    service_type: {
      type: DataTypes.STRING,
      allowNull: false,
    },
    config_data: {
      type: DataTypes.JSONB,
      allowNull: true,
    },
    script_path: {
      type: DataTypes.TEXT,
      allowNull: false,
    }
  }, {
    tableName: "monitored_services",  // 👈 important : nom explicite en base
    underscored: true                  // facultatif : pour created_at vs createdAt
  });

  return MonitoredService;
};
