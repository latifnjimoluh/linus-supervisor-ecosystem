// models/user.js

module.exports = (sequelize, DataTypes) => {
  const User = sequelize.define("User", {
    // 🧍 Informations personnelles
    first_name: {
      type: DataTypes.STRING,
      allowNull: false,
    },
    last_name: {
      type: DataTypes.STRING,
      allowNull: false,
    },

    // 📧 Contact
    email: {
      type: DataTypes.STRING,
      allowNull: false,
      unique: true,
      validate: {
        isEmail: true,
      },
    },
    phone: {
      type: DataTypes.STRING,
      allowNull: true,
    },

    // 🔐 Authentification
    password: {
      type: DataTypes.TEXT,
      allowNull: false,
    },
    status: {
      type: DataTypes.STRING,
      defaultValue: "active", // 'active' | 'inactif'
    },

    // 🔁 Réinitialisation mot de passe
    reset_token: {
      type: DataTypes.STRING(10),
      allowNull: true,
    },
    reset_expires_at: {
      type: DataTypes.DATE,
      allowNull: true,
    },
    last_password_reset_at: {
      type: DataTypes.DATE,
      allowNull: true,
    },

    // 🔗 Rôle associé
    role_id: {
      type: DataTypes.INTEGER,
      allowNull: false,
      references: {
        model: "roles",
        key: "id",
      },
    },
  }, {
    tableName: "users",
    timestamps: true,
    createdAt: "created_at",
    updatedAt: "updated_at",
  });

  // 🔗 Association avec la table Role
  User.associate = (models) => {
    User.belongsTo(models.Role, {
      foreignKey: "role_id",
      as: "role",
    });
  };

  return User;
};
