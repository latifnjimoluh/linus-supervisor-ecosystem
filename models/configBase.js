module.exports = (sequelize, DataTypes) => {
  const ConfigBase = sequelize.define("ConfigBase", {
    service_type: {
      type: DataTypes.STRING,
      allowNull: false,
    },
    description: {
      type: DataTypes.STRING,
      allowNull: true,
    },
    script_path: {
      type: DataTypes.STRING,
      allowNull: false,
    },
  }, {
    tableName: "config_de_base",
    underscored: true,
  });

  return ConfigBase;
};
