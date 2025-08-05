const express = require('express');
require('dotenv').config();
const { sequelize } = require('./models');
const authRoutes = require('./routes/authRoutes');
const permissionRoutes = require('./routes/permissionRoutes');
const roleRoutes = require('./routes/roleRoutes');
const userRoutes = require('./routes/userRoutes');
const logRoutes = require('./routes/logRoutes');
const userSettingRoutes = require('./routes/userSettingRoutes');
const proxmoxRoutes = require('./routes/proxmoxRoutes');

const app = express();
console.log('💻 Initialisation de l\'application Express');

app.use(express.json());
app.use('/auth', authRoutes);
app.use('/permissions', permissionRoutes);
app.use('/roles', roleRoutes);
app.use('/users', userRoutes);
app.use('/logs', logRoutes);
app.use('/settings', userSettingRoutes);
app.use('/vms', proxmoxRoutes);

const PORT = process.env.PORT || 3000;
app.listen(PORT, async () => {
  console.log(`🚀 Serveur démarré sur le port ${PORT}`);
  try {
    await sequelize.authenticate();
    console.log('✅ Connexion à la base de données réussie');
  } catch (err) {
    console.error('❌ Erreur de connexion à la base de données:', err);
  }
});

module.exports = app;
