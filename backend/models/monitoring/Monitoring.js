module.exports = (sequelize, DataTypes) => {
  const Monitoring = sequelize.define('Monitoring', {
    vm_ip: {
      type: DataTypes.STRING,
    },
    ip_address: {
      type: DataTypes.STRING,
    },
    instance_id: {
      type: DataTypes.STRING,
    },
    services_status: {
      type: DataTypes.JSONB,
    },
    system_status: {
      type: DataTypes.JSONB,
    },
    retrieved_at: {
      type: DataTypes.DATE,
      allowNull: false,
      defaultValue: DataTypes.NOW,
    },
  }, {
    tableName: 'monitorings',
    underscored: true,
    timestamps: true,
    createdAt: 'created_at',
    updatedAt: 'updated_at',
  });

  return Monitoring;
};
