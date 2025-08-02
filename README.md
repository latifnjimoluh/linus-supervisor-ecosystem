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

## Architecture dynamique
Les scripts d'initialisation et de supervision sont générés à partir de templates stockés en base puis injectés automatiquement dans les VMs via SSH. Les actions de démarrage/arrêt et de collecte de supervision communiquent avec l'API Proxmox. Les déploiements d'infrastructure utilisent Terraform et les journaux sont sauvegardés en base PostgreSQL.
