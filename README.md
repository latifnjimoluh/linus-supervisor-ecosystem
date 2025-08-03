# Linusupervisor Backend

## Présentation du projet
Plateforme de supervision centralisée des infrastructures Linux du BUNEC. Le backend expose une API REST qui gère l'authentification, l'injection dynamique de scripts et la surveillance des services et machines virtuelles Proxmox.

## Technologies utilisées
- Node.js & Express
- Sequelize (PostgreSQL)
- JWT & bcrypt
- Axios, SSH2
- Terraform

## Arborescence du backend
```text
controllers/
├─ config/
│  └─ configMail.js
├─ generate/
│  ├─ generateAgentController.js
│  ├─ generateInitScriptController.js
│  └─ generateMonitoringDNSController.js
├─ monitoring/
│  └─ monitoringServiceController.js
├─ supervision/
│  └─ supervisionFetchController.js
├─ template/
│  ├─ configTemplateController.js
│  └─ templateServiceController.js
├─ user/
│  └─ userResetPasswordController.js
└─ vm/
   ├─ checkVMStatusController.js
   ├─ deleteVMController.js
   ├─ deployVMController.js
   ├─ startVMController.js
   ├─ stopVMController.js
   └─ templateVmController.js
```

## Description des principaux dossiers
- **controllers/generate** : création de scripts d'initialisation, d'agents et de supervision DNS.
- **controllers/monitoring** : génération des scripts de monitoring des services.
- **controllers/template** : gestion et utilisation des templates de configuration.
- **controllers/supervision** : collecte et sauvegarde des informations de supervision.
- **controllers/vm** : opérations sur les machines virtuelles (statut, démarrage/arrêt, conversion en template).
- **controllers/config** : configuration de l'envoi d'e-mails.

## Endpoints principaux
| Méthode | Route | Contrôleur |
|--------|-------|------------|
| POST | `/api/init-scripts/generate` | generateInitScriptController.generateInitScript |
| POST | `/api/monitoring/generate` | generateMonitoringDNSController.generateMonitoringScript |
| POST | `/api/monitoring/monitoring-services/generate` | monitoringServiceController.generateMonitoringServiceScript |
| POST | `/api/services/config-template` | templateServiceController.configureService |
| POST | `/api/templates/create` | configTemplateController.createTemplate |
| POST | `/api/convert-template/convert` | templateVmController.convertToTemplate |
| POST | `/api/vm/check-vm-status` | checkVMStatusController.checkVMStatus |
| POST | `/api/vm/start` | startVMController.startVM |
| POST | `/api/vm/stop` | stopVMController.stopVM |
| POST | `/api/supervision/fetch` | supervisionFetchController.fetchFromDynamicVM |
| POST | `/api/supervision/status` | supervisionFetchController.saveStatus |
| POST | `/api/supervision/services` | supervisionFetchController.saveServices |
| GET | `/api/supervision/status` | supervisionFetchController (lecture) |
| GET | `/api/supervision/services` | supervisionFetchController (lecture) |

## Lancement du backend
```bash
npm install
npm run dev
```
L'API écoute par défaut sur `http://localhost:5000`.

## Gestion des scripts Terraform sous Windows
Avant de lancer un déploiement depuis un poste Windows, assurez-vous que les fichiers shell utilisent des fins de ligne Unix :

```bash
dos2unix init.sh config.sh monitoring.sh service-detector.sh
```

## Configuration de l'environnement
Créer un fichier `.env` à la racine :
```dotenv
DB_HOST=localhost
DB_PORT=5432
DB_NAME=linusupervision
DB_USER=postgres
DB_PASS=motdepasse
JWT_SECRET=supersecret
SMTP_USER=exemple@gmail.com
SMTP_PASS=motdepasseSMTP
PORT=5000
```
codex/rename-and-restructure-backend-controllers
## Architecture dynamique
Les scripts d'initialisation et de supervision sont générés à partir de templates stockés en base puis injectés automatiquement dans les VMs via SSH. Les actions de démarrage/arrêt et de collecte de supervision communiquent avec l'API Proxmox. Les déploiements d'infrastructure utilisent Terraform et les journaux sont sauvegardés en base PostgreSQL.
=======
## Description détaillée des fichiers
- `app.js` : démarre l'application Express et charge les routes.
- `config/config.json` : configuration Sequelize pour l'environnement de développement.
- `config/db.js` : initialisation de la connexion PostgreSQL.
- `controllers/auth/userAuthController.js` : inscription et connexion des utilisateurs.
- `controllers/deploy/deployController.js` : lance les déploiements Terraform.
- `controllers/generate/generateInitScriptController.js` : gestion des scripts d'initialisation.
- `controllers/generate/generateMonitoringDNSController.js` : gestion des scripts de monitoring.
- `controllers/template/templateServixeController.js` : gère les modèles de configuration de service.
- `controllers/generate/generateMonitoringServiceController.js` : enregistre les services supervisés.
- `controllers/generate/generateAgentController.js` : génère les agents de supervision.
- `controllers/supervision/supervisionFetchController.js` : récupère et enregistre les données de supervision des VMs.
- `controllers/template/configTemplateController.js` : CRUD des modèles de configuration.
- `controllers/templateVMController.js` : conversion d'une VM en template Cloud-Init.
- `controllers/vm/deleteVMController.js` : supprime une machine virtuelle.
- `generated-scripts/` : scripts générés automatiquement lors des déploiements.
- `generated-templates/` : modèles de script générés pour la configuration et la supervision.
- `middlewares/auth.js` : création et validation des JWT ainsi que vérification des rôles.
- `models/auth/User.js` : modèle utilisateur.
- `models/deploy/Deployment.js` : journal des déploiements Terraform.
- `models/scripts/InitScript.js` : modèle des scripts d'initialisation.
- `models/scripts/MonitoringScript.js` : modèle des scripts de monitoring.
- `models/services/MonitoringService.js` : décrit un service supervisé.
- `models/supervision/serviceStatus.js` : état d'un service supervisé.
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

main
