const express = require('express');
require('dotenv').config();
const { sequelize } = require('./models');
const authRoutes = require('./routes/auth/authRoutes');
const permissionRoutes = require('./routes/permissions/permissionRoutes');
const roleRoutes = require('./routes/roles/roleRoutes');
const userRoutes = require('./routes/users/userRoutes');
const logRoutes = require('./routes/logs/logRoutes');
const userSettingRoutes = require('./routes/settings/userSettingRoutes');
const proxmoxRoutes = require('./routes/proxmox/proxmoxRoutes');
const templateRoutes = require('./routes/templates/serviceTemplateRoutes');
const terraformRoutes = require('./routes/terraform/terraformRoutes');

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
app.use('/templates', templateRoutes);
app.use('/terraform', terraformRoutes);

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
