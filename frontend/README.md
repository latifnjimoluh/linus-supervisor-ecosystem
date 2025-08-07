# Frontend Linusupervisor

Ce dossier contient l'interface web d'administration de Linusupervisor. L'application est développée en React avec Vite et stylisée par Tailwind CSS.

## Démarrage rapide

```bash
cd frontend
npm install
npm run dev
```

Créez un fichier `.env` à la racine du dossier `frontend` et ajoutez la variable `VITE_API_URL` pointant vers l'URL de l'API backend (par exemple `http://localhost:3000`).

## Fonctionnalités

- Authentification avec gestion du token JWT
- Tableau de bord récapitulatif
- Gestion des utilisateurs, rôles et permissions
- Consultation des logs système
- Paramètres personnels pour l'accès Proxmox
- Supervision des machines virtuelles Proxmox
- Templates de services avec assistance IA et génération de scripts
- Monitoring des instances et synchronisation des IP
- Déploiement Terraform et outils IA divers

## Scripts utiles

- `npm run dev` : démarre le serveur de développement
- `npm run build` : génère la version de production
- `npm run preview` : sert la version de production localement

