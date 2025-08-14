/**
 * Alert model storing monitoring alert records.
 */
module.exports = (sequelize, DataTypes) => {
  const Alert = sequelize.define(
    'Alert',
    {
      server: DataTypes.STRING,
      service: DataTypes.STRING,
      severity: DataTypes.STRING,
      status: {
        type: DataTypes.STRING,
        defaultValue: 'en_cours',
      },
      description: DataTypes.STRING,
      comment: DataTypes.TEXT,
      started_at: {
        type: DataTypes.DATE,
        defaultValue: DataTypes.NOW,
      },
    },
    {
      tableName: 'alerts',
      underscored: true,
      timestamps: true,
      createdAt: 'created_at',
      updatedAt: 'updated_at',
    }
  );

  return Alert;
};
