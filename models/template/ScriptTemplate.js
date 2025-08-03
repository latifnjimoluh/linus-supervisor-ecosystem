module.exports = (sequelize, DataTypes) => {
  const ScriptTemplate = sequelize.define(
    "ScriptTemplate",
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
      tableName: "script_templates",
      timestamps: true,
      createdAt: "created_at",
      updatedAt: "updated_at",
    }
  );

  return ScriptTemplate;
};

