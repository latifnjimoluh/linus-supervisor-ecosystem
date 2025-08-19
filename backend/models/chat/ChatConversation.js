module.exports = (sequelize, DataTypes) => {
  const ChatConversation = sequelize.define('ChatConversation', {
    system_prompt: {
      type: DataTypes.TEXT('long'),
    },
    summary: {
      type: DataTypes.TEXT('long'),
      defaultValue: '',
    },
    user_id: {
      type: DataTypes.INTEGER,
      allowNull: false,
    },
  }, {
    tableName: 'chat_conversations',
    underscored: true,
  });

  ChatConversation.associate = (models) => {
    ChatConversation.belongsTo(models.User, { foreignKey: 'user_id', as: 'user' });
    ChatConversation.hasMany(models.ChatMessage, { foreignKey: 'conversation_id', as: 'messages' });
  };

  return ChatConversation;
};
