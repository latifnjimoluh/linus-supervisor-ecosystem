module.exports = (sequelize, DataTypes) => {
  const ServiceTemplate = sequelize.define(
    "ServiceTemplate",
    {
      name: {
        type: DataTypes.STRING,
        allowNull: false,
      },
      service_type: {
        type: DataTypes.STRING,
        allowNull: false,
      },
      template_path: {
        type: DataTypes.TEXT,
        allowNull: false,
      },
    },
    {
      tableName: "service_templates",
      timestamps: true,
      createdAt: "created_at",
      updatedAt: "updated_at",
    }
  );

  return ServiceTemplate;
};

