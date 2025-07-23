# 🔧 Linusupervisor Backend

Ce dépôt contient l'API Node.js de la plateforme **Linusupervisor**. Elle permet l'authentification via JWT, la gestion des utilisateurs et le déclenchement d'opérations Terraform pour provisionner ou détruire des services sur Proxmox. Les informations de déploiement sont enregistrées dans PostgreSQL.

## Pré-requis
- Node.js
- PostgreSQL
- Terraform (pour les commandes de déploiement)

## Installation
```bash
npm install
```

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
- `controllers/` : logique métier (auth et déploiement).
- `models/` : modèles Sequelize `User` et `Deployment`.
- `routes/` : définitions des routes.
- `middlewares/` : vérification des JWT et des rôles.
- `utils/terraformRunner.js` : exécution de Terraform.
- `terraform/` : fichiers Terraform utilisés pour le provisionnement.

## Licence
Ce projet est distribué sous licence ISC.
