# Frontend Linusupervisor

Cette interface web d'administration repose désormais sur **Next.js** (App Router) et **Tailwind CSS**. La migration depuis l'ancien stack React Router/Vite est encore en cours.

## Démarrage rapide

```bash
cd frontend
npm install
npm run dev
```

Créez un fichier `.env.local` dans `frontend` et ajoutez la variable `NEXT_PUBLIC_API_URL` pointant vers l'URL de l'API backend (par exemple `http://localhost:3000`).

## Interfaces à implémenter

Les routes suivantes existent comme squelettes dans `app/(app)` mais doivent encore être complétées avec leur logique métier et leur design :

- Tableau de bord et carte (`/dashboard`, `/dashboard/map`)
- Gestion des utilisateurs : liste, ajout, édition, détail
- Gestion des rôles et des permissions
- Historique des réinitialisations de mot de passe
- Consultation des logs système
- Paramètres généraux et notifications
- Modèles de scripts et tests de modèles
- Supervision et détails de monitoring, alertes
- Profil utilisateur (`/account`)
- Gestion des serveurs : liste, ajout, édition, détail
- Prévisualisation de scripts et déploiement
- Assistant IA
- Machines virtuelles et conversions
- Outils Terraform
- Outils IA et cache IA

## Scripts utiles

- `npm run dev` : démarre le serveur de développement
- `npm run build` : génère la version de production
- `npm start` : lance la version de production

