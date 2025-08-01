# 🔧 Linusupervisor Backend

Ce dépôt contient l'API Node.js de la plateforme **Linusupervisor**. Elle permet l'authentification via JWT, la gestion des utilisateurs et le déclenchement d'opérations Terraform pour provisionner ou détruire des services sur Proxmox. Les informations de déploiement sont enregistrées dans PostgreSQL.

## Pré-requis
- Node.js (>= 18)
- PostgreSQL
- Terraform (pour les commandes de déploiement)
- npm

## Installation
```bash
npm install
```

### Paquets principaux

- **express**, **cors**, **helmet**, **compression**, **morgan** : base serveur et sécurité
- **sequelize**, **pg**, **pg-hstore** : couche ORM et connexion PostgreSQL
- **bcrypt** et **jsonwebtoken** : gestion des mots de passe et de l'authentification JWT
- **ssh2** et **axios** : communication avec Proxmox ou scripts distants
- **dotenv** et **cookie-parser** : gestion de la configuration et des cookies

Créez ensuite un fichier `.env` à la racine :
```dotenv
DB_HOST=localhost
DB_PORT=5432
DB_NAME=linusupervision
DB_USER=postgres
DB_PASS=motdepasse
JWT_SECRET=supersecret
PORT=5000
# JWT_EXPIRES_IN=1h
```

## Lancement en développement
```bash
npm run dev
```
L'API est accessible sur `http://localhost:5000` par défaut.

## Routes principales
### Authentification
- `POST /api/auth/register` – inscription d'un utilisateur.
- `POST /api/auth/login` – connexion et récupération d'un jeton JWT.

### Déploiement (routes protégées)
- `POST /api/deploy` – exécute Terraform pour créer l'infrastructure.
- `POST /api/destroy` – détruit l'infrastructure créée.

Ces routes nécessitent l'en-tête `Authorization: Bearer <token>`.

## Exemple de payload Terraform
```json
{
  "vm_names": ["dns"],
  "template_name": "ubuntu-template",
  "memory_mb": 2048,
  "vcpu_cores": 2,
  "disk_size": "20G",
  "cloudinit_user": "nexus",
  "cloudinit_password": "password",
  "proxmox_api_url": "https://192.168.24.134:8006/api2/json",
  "proxmox_api_token_id": "root@pam",
  "proxmox_api_token_secret": "token",
  "proxmox_node": "pve",
  "vm_storage": "local-lvm",
  "vm_bridge": "vmbr0",
  "use_static_ip": false
}
```
Pour une IP fixe :
```json
{
  "use_static_ip": true,
  "static_ips": {"dns": "192.168.24.111"},
  "network_cidr": 24,
  "gateway_ip": "192.168.24.2"
}
```

Les journaux de déploiement sont stockés dans le dossier `logs/` et dans la table `deployments`.

## Structure du projet
- `app.js` : point d'entrée de l'application.
- `controllers/` : logique métier organisée par domaine (`auth/`, `deploy/`, `services/`, `scripts/`, `supervision/`).
- `models/` : sous-dossiers identiques pour les modèles Sequelize (`auth/`, `deploy/`, `services/`, `scripts/`, `supervision/`).
- `routes/` : routes Express regroupées de la même façon par domaine.
- `middlewares/` : vérification des JWT et des rôles.
- `utils/` : helpers Proxmox, SSH et exécution de Terraform.
- `terraform/` : fichiers Terraform utilisés pour le provisionnement.

## Arborescence du projet
```text
.
├── README.md
├── app.js
├── config
│   ├── config.json
│   └── db.js
├── controllers
│   ├── auth
│   ├── deploy
│   ├── scripts
│   ├── services
│   ├── supervision
│   ├── template
│   └── vm
├── generated-scripts
│   ├── detect-services-470a1191-819e-4c90-85d1-990dc3c80c46.sh
│   ├── detect-services-9e8277c1-7d33-40cf-af8b-604038d0cfc0.sh
│   ├── dns-install-1753794976726.sh
│   ├── dns-install-1753801451031.sh
│   ├── dns-install-1753832252525.sh
│   ├── dns_config
│   ├── init-Init_Sécurité_Linux_Universel-33a7c859-7acc-4782-9341-5efae2079b0a.sh
│   ├── init-Init_Sécurité_Linux_Universel-d202dbc4-686f-40db-9205-6fba5b1f046e.sh
│   ├── monitor-dns-camer.cm-2925a4e4-20ca-4868-8ce3-43ab8f755fa4.sh
│   └── monitor-dns-camer.cm-d9048681-14e6-4708-8e5a-36124f228bda.sh
├── generated-templates
│   ├── dns_config
│   ├── monitoring_dns
│   └── monitoring_services
├── middlewares
│   └── auth.js
├── models
│   ├── auth
│   ├── deploy
│   ├── index.js
│   ├── scripts
│   ├── services
│   ├── supervision
│   ├── template
│   └── vm
├── nodemon.json
├── package-lock.json
├── package.json
├── routes
│   ├── auth
│   ├── deploy
│   ├── index.js
│   ├── scripts
│   ├── services
│   ├── supervision
│   ├── template
│   └── vm
├── sql
│   └── linusupervision_backup.sql
├── terraform
│   ├── Scripts
│   ├── main.tf
│   ├── outputs.tf
│   ├── terraform.tfstate
│   ├── terraform.tfvars
│   ├── variables.tf
│   └── variables.tfvars.json
└── utils
    ├── proxmoxService.js
    ├── sshClient.js
    └── terraformRunner.js

37 directories, 29 files
```

## Description détaillée des fichiers
- `app.js` : démarre l'application Express et charge les routes.
- `config/config.json` : configuration Sequelize pour l'environnement de développement.
- `config/db.js` : initialisation de la connexion PostgreSQL.
- `controllers/auth/userAuthController.js` : inscription et connexion des utilisateurs.
- `controllers/deploy/deployController.js` : lance les déploiements Terraform.
- `controllers/scripts/initScriptController.js` : gestion des scripts d'initialisation.
- `controllers/scripts/monitoringScriptController.js` : gestion des scripts de monitoring.
- `controllers/services/configTemplateServiceController.js` : gère les modèles de configuration de service.
- `controllers/services/monitoringServiceController.js` : enregistre les services supervisés.
- `controllers/services/generateServiceMonitoringAgent.js` : génère les agents de supervision.
- `controllers/supervision/fetchSupervisionController.js` : récupère les données de supervision des VMs.
- `controllers/supervision/supervisionController.js` : stocke et renvoie les instantanés d'état.
- `controllers/template/configTemplateController.js` : CRUD des modèles de configuration.
- `controllers/vm/deleteVMController.js` : supprime une machine virtuelle.
- `generated-scripts/` : scripts générés automatiquement lors des déploiements.
- `generated-templates/` : modèles de script générés pour la configuration et la supervision.
- `middlewares/auth.js` : création et validation des JWT ainsi que vérification des rôles.
- `models/auth/User.js` : modèle utilisateur.
- `models/deploy/Deployment.js` : journal des déploiements Terraform.
- `models/scripts/InitScript.js` : modèle des scripts d'initialisation.
- `models/scripts/MonitoringScript.js` : modèle des scripts de monitoring.
- `models/services/MonitoringService.js` : décrit un service supervisé.
- `models/services/ServiceStatus.js` : état d'un service supervisé.
- `models/services/configTemplateService.js` : lien entre service et modèle de configuration.
- `models/supervision/statusSnapshot.js` : instantané global de supervision.
- `models/supervision/vmInstance.js` : décrit une VM créée.
- `models/template/configTemplate.js` : modèle de configuration générique.
- `models/vm/deleteVm.js` : traces de suppression de VM.
- `routes/` : fichiers définissant l'ensemble des endpoints REST de l'API.
- `utils/proxmoxService.js` : appels à l'API Proxmox pour gérer les VMs.
- `utils/sshClient.js` : fonctions utilitaires pour lire des fichiers via SSH.
- `utils/terraformRunner.js` : exécution des commandes Terraform.
- `terraform/` : scripts Terraform utilisés lors des déploiements.
- `sql/linusupervision_backup.sql` : sauvegarde de la base PostgreSQL.
- `nodemon.json` : configuration de Nodemon pour le mode développement.
- `package.json` et `package-lock.json` : dépendances Node.js et scripts npm.
- `README.md` : documentation du projet.
## Historique
- 2024 : ajout de l'authentification JWT et du déploiement via Terraform
- 2024 : prise en charge des scripts d'initialisation et de monitoring
- 2024 : gestion des services supervisés et journalisation en base
- 2025 : réorganisation des dossiers (controllers, models, routes)

## Licence
Ce projet est distribué sous licence ISC.

Save
pg_dump -U postgres -d linusupervision -f "D:\backup.sql"
"C:\Program Files\PostgreSQL\17\bin\pg_dump.exe" -U postgres -d linusupervision -f "D:\Keyce_B3\Soutenance\linusupervisor-backend\linusupervisor-backend\sql\linusupervision_backup.sql"

📌 Cas 1 : Tu as un fichier .sql (export normal)
Commande pour restaurer à vide dans une base existante :

psql -U postgres -d linusupervision -f "D:\linusupervision_backup.sql"
Si la base linusupervision n’existe pas encore :

createdb -U postgres linusupervision
psql -U postgres -d linusupervision -f "D:\linusupervision_backup.sql"

