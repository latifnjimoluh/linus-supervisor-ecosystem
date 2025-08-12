module.exports = (sequelize, DataTypes) => {
  const GeneratedScript = sequelize.define('GeneratedScript', {
    template_id: {
      type: DataTypes.INTEGER,
      allowNull: false,
      references: {
        model: 'generated_scripts',
        key: 'id',
      },
    },
    category: {
      type: DataTypes.STRING,
      allowNull: false,
    },
    service_type: {
      type: DataTypes.STRING,
      allowNull: false,
    },
    abs_path: {
      type: DataTypes.STRING,
      allowNull: true,
    },
    script_path: {
      type: DataTypes.STRING,
      allowNull: false,
    },
    description: {
      type: DataTypes.TEXT,
      allowNull: true,
    },
    status: {
      type: DataTypes.ENUM('actif', 'supprime'),
      defaultValue: 'actif',
    },
  }, {
    tableName: 'generated_scripts',
    underscored: true,
  });

  GeneratedScript.associate = models => {
    GeneratedScript.belongsTo(models.ServiceTemplate, {
      foreignKey: 'template_id',
      as: 'template'
    });
  };

  return GeneratedScript;
};
