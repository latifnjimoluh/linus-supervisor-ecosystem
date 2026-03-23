module.exports = (sequelize, DataTypes) => {
  const Delete = sequelize.define('Delete', {
    vm_id: { type: DataTypes.STRING, allowNull: false },
    instance_id: { type: DataTypes.STRING },
    vm_name: { type: DataTypes.STRING },
    vm_ip: { type: DataTypes.STRING },
    log_path: { type: DataTypes.STRING },
    user_id: { type: DataTypes.INTEGER },
    user_email: { type: DataTypes.STRING },
    deleted_at: { type: DataTypes.DATE },
  }, {
    tableName: 'deletes',
    underscored: true,
  });

  Delete.associate = (models) => {
    Delete.belongsTo(models.User, { foreignKey: 'user_id', as: 'user' });
  };

  return Delete;
};
