const express = require('express');
require('dotenv').config();
const { sequelize } = require('./models');
const routes = require('./routes');

const app = express();
console.log('💻 Initialisation de l\'application Express');

app.use(express.json());
app.use(routes);

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
