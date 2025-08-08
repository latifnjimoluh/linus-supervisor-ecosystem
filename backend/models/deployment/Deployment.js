module.exports = (sequelize, DataTypes) => {
  const Deployment = sequelize.define('Deployment', {
    user_id: { type: DataTypes.INTEGER, allowNull: false },
    user_email: { type: DataTypes.STRING },
    vm_name: { type: DataTypes.STRING },
    service_name: { type: DataTypes.STRING },
    zone: { type: DataTypes.STRING },
    operation_type: { type: DataTypes.STRING },
    started_at: { type: DataTypes.DATE },
    ended_at: { type: DataTypes.DATE },
    duration: { type: DataTypes.STRING },
    success: { type: DataTypes.BOOLEAN },
    log_path: { type: DataTypes.STRING },
    vm_id: { type: DataTypes.STRING },
    vm_ip: { type: DataTypes.STRING },
    instance_id: { type: DataTypes.STRING },
    injected_files: { type: DataTypes.JSON },
    vm_specs: { type: DataTypes.JSON },
    status: { type: DataTypes.STRING },
  }, {
    tableName: 'deployments',
    underscored: true,
  });

  Deployment.associate = (models) => {
    Deployment.belongsTo(models.User, { foreignKey: 'user_id', as: 'user' });
  };

  return Deployment;
};
