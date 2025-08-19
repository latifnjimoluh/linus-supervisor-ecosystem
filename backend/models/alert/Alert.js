'use strict';

/**
 * Alert model storing monitoring alert records.
 */
module.exports = (sequelize, DataTypes) => {
  const Alert = sequelize.define(
    'Alert',
    {
      server: {
        type: DataTypes.STRING,
        allowNull: false,
      },
      service: {
        type: DataTypes.STRING, // CPU, RAM, etc.
        allowNull: false,
      },
      severity: {
        type: DataTypes.STRING, // critique | majeure | mineure
        allowNull: true,
      },
      status: {
        type: DataTypes.STRING, // open | acknowledged | resolved
        defaultValue: 'open',
      },
      description: {
        type: DataTypes.STRING,
        allowNull: true,
      },
      comment: {
        type: DataTypes.TEXT,
        allowNull: true,
      },
      // ✅ Optionnel : persister la valeur et le seuil au moment de l’alerte
      value_percent: {
        type: DataTypes.DECIMAL(5, 2),
        allowNull: true,
      },
      threshold: {
        type: DataTypes.DECIMAL(5, 2),
        allowNull: true,
      },
      // ✅ Optionnel : moment où l’alerte est résolue
      ended_at: {
        type: DataTypes.DATE,
        allowNull: true,
      },
      // ✅ Optionnel : stocker des métadonnées brutes (payload métriques, agent, etc.)
      source: {
        type: DataTypes.JSONB || DataTypes.JSON, // selon le dialecte
        allowNull: true,
      },
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
      indexes: [
        { fields: ['server'] },
        { fields: ['service'] },
        { fields: ['severity'] },
        { fields: ['status'] },
        { fields: ['created_at'] },
      ],
    }
  );

  return Alert;
};
