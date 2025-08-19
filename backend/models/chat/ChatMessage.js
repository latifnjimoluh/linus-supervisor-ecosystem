module.exports = (sequelize, DataTypes) => {
  const ChatMessage = sequelize.define('ChatMessage', {
    conversation_id: {
      type: DataTypes.INTEGER,
      allowNull: false,
    },
    role: {
      type: DataTypes.ENUM('user', 'assistant', 'system'),
      allowNull: false,
    },
    content: {
      type: DataTypes.TEXT('long'),
      allowNull: false,
    },
  }, {
    tableName: 'chat_messages',
    underscored: true,
  });

  ChatMessage.associate = (models) => {
    ChatMessage.belongsTo(models.ChatConversation, { foreignKey: 'conversation_id', as: 'conversation' });
  };

  return ChatMessage;
};
