module.exports = (sequelize, DataTypes) => {
  console.log('📦 Initialisation du modèle ServiceTemplate');
  const ServiceTemplate = sequelize.define('ServiceTemplate', {
    name: {
      type: DataTypes.STRING,
      allowNull: false,
    },
    service_type: {
      type: DataTypes.STRING,
      allowNull: false,
    },
    category: {
      type: DataTypes.STRING,
      allowNull: false,
    },
    description: {
      type: DataTypes.TEXT,
    },
    template_content: {
      type: DataTypes.TEXT('long'),
      allowNull: false,
    },
    script_path: {
      type: DataTypes.STRING,
      allowNull: true,
    },
    fields_schema: {
      type: DataTypes.JSON,
      allowNull: true,
    },
    status: {
      type: DataTypes.ENUM('actif', 'inactif'),
      defaultValue: 'actif',
    },
  }, {
    tableName: 'service_templates',
    underscored: true,
  });

  return ServiceTemplate;
};
