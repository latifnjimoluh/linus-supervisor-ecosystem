const { DataTypes } = require("sequelize")
const sequelize = require("../config/db")

const User = sequelize.define(
  "User",
  {
    first_name: { type: DataTypes.STRING(100), allowNull: true },
    last_name: { type: DataTypes.STRING(100), allowNull: true },
    email: { type: DataTypes.STRING(255), allowNull: false, unique: true },
    phone: { type: DataTypes.STRING(30), allowNull: true },
    password: { type: DataTypes.TEXT, allowNull: false },
    role: {
      type: DataTypes.STRING(30),
      allowNull: false,
      defaultValue: "technicien",
    },
    status: {
      type: DataTypes.STRING(20),
      defaultValue: "active",
    },
  },
  {
    tableName: "users",
    timestamps: true,
    createdAt: "created_at",
    updatedAt: "updated_at",
  }
)

module.exports = User