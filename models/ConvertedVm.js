module.exports = (sequelize, DataTypes) => {
  const ConvertedVm = sequelize.define('ConvertedVm', {
    vm_name: {
      type: DataTypes.STRING,
      allowNull: false,
    },
    vm_id: {
      type: DataTypes.STRING,
      allowNull: false,
    },
    user_id: {
      type: DataTypes.INTEGER,
      allowNull: false,
    },
  }, {
    tableName: 'converted_vms',
    underscored: true,
  });

  ConvertedVm.associate = (models) => {
    ConvertedVm.belongsTo(models.User, { foreignKey: 'user_id', as: 'user' });
  };

  return ConvertedVm;
};
