# LinSupervisor Backend

Node.js backend with Express and Sequelize providing user, role, and permission management secured by JWT authentication.

**Note :** Le frontend (`linusupervisor-front`) est un projet séparé qui n'est pas inclus dans ce dépôt suite à une séparation des services.

## Stack Technique
- **Runtime :** Node.js 18+
- **Framework :** Express.js
- **DB :** MySQL / PostgreSQL (Sequelize ORM)
- **Authentification :** JWT
- **Infrastructure :** Terraform templates inclus

## Installation

```bash
npm install
```

## Configuration
1. Copiez le fichier `.env.example` en `.env`.
2. Ajustez les valeurs pour la base de données (`DB_HOST`, `DB_NAME`, etc.).
3. Configurez les paramètres SMTP pour l'envoi de mails si nécessaire.

## Lancement

```bash
npm run dev:backend
```

## Structure du Projet
- `controllers/` : Logique des endpoints API.
- `models/` : Définition des modèles de données Sequelize.
- `services/` : Logique métier et interactions services.
- `terraform/` : Configuration Terraform pour le déploiement de VMs Proxmox.
- `scripts/` : Scripts utilitaires pour l'automatisation.
- `sql/` : Schémas SQL initiaux.

## Documentation API
Consultez le fichier [docs/API.md](docs/API.md) pour la liste des points d'entrée disponibles.

## Tests
Les tests unitaires et d'intégration sont situés dans le dossier `tests/`.
```bash
npm test
```

