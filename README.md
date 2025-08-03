# 📘 Linusupervisor Backend

## 🚀 Présentation

Un backend Express.js modulaire permettant de déployer, superviser, configurer et surveiller des serveurs Linux à distance (via Proxmox/Terraform), dans le cadre du projet "Système centralisé de supervision intelligente du BUNEC".

---

## 🧰 Technologies utilisées

- Node.js
- Express.js
- Sequelize (PostgreSQL)
- JWT Authentication
- dotenv
- SSH2 / Child Process
- Middleware personnalisés (`verifyToken`, `checkPermission`)
- Modularisation par contrôleurs et templates

---

## 🗂️ Arborescence des principaux dossiers

```bash
.
├── controllers/
│   ├── auth/
│   ├── generate/
│   ├── supervision/
│   ├── vm/
│   └── template/
├── models/
├── routes/
├── services/   (optionnel)
├── middlewares/
├── config/
├── scripts/
├── logs/
├── utils/
└── app.js
```

---

## ⚙️ Configuration

Créer un fichier `.env` à la racine avec les variables suivantes :

```dotenv
PORT=5000
DATABASE_URL=postgres://user:password@localhost:5432/linusupervisor
JWT_SECRET=your_jwt_secret
JWT_EXPIRES_IN=1h
```

---

## ▶️ Lancement du projet

```bash
npm install
npm run dev   # Pour lancer en développement
npm start     # Pour lancer en production
```

---

## 📡 API

La documentation complète de l’API est dans `DOCUMENTATION_API.md`
Tu peux aussi utiliser Postman ou Swagger pour tester les routes.

---

## 🔐 Authentification

Toutes les routes sont protégées via JWT et vérification de permissions.
Tu dois inclure ce header :

```http
Authorization: Bearer <your_token>
```

---

## 🛠 Fonctionnalités principales

- Création, démarrage, arrêt et suppression de VMs via Proxmox
- Génération de scripts d’init, de supervision, de monitoring
- Suivi du statut des services installés
- Journalisation des actions utilisateurs
- Rôles & permissions dynamiques
- Template JSON modulaire pour injecter des configurations
- Architecture RESTful prête pour CI/CD et scalabilité

---

## 🧪 Tests

📌 Les tests unitaires ou d’intégration sont à mettre en place avec jest ou mocha.
(Dossier `__tests__` recommandé – à créer)

---

## 📁 Données persistées

Liste des modèles Sequelize utilisés :

- User
- Role, Permission, RolePermission
- InitScript, MonitoringScript, MonitoringService
- ConfigTemplate, ConfigTemplateService
- Deployment, Delete, VMInstance
- StatusSnapshot, ServiceStatus
- UserActionLog, UserSetting

---

## ✨ Recommandations

- Ajouter Swagger/OpenAPI (route `/api-docs`)
- Mettre en place des tests (jest)
- Ajouter sécurité avancée (rate-limit, helmet, input sanitization)
- Créer un vrai système de rollback en cas d’échec VM
- Ajouter supervision IA contextuelle (optionnel)

---

## 🧠 Auteur

Projet de Bachelor 3 – KEYCE School

Nom : [Ton nom ici]
Sujet : Mise en œuvre d’un système centralisé de gestion et de supervision intelligente des infrastructures Linux au BUNEC

