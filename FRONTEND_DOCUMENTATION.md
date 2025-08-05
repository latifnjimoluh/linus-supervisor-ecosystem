# 🖥️ Documentation Frontend – Linusupervisor

## 1. 🎯 Objectif du frontend
L'interface graphique de Linusupervisor permet aux administrateurs et opérateurs de gérer à distance des machines virtuelles Linux. Depuis un tableau de bord centralisé, l'utilisateur peut déployer des modèles prédéfinis, exécuter des scripts, surveiller l'état des VMs et consulter les journaux d'activité. L'objectif principal est d'offrir une vue d'ensemble simple et rapide de l'infrastructure tout en automatisant les tâches récurrentes de supervision.

## 2. 🧰 Technologies utilisées
- React.js avec Vite pour le bundling et le hot reload
- Tailwind CSS pour le style
- React Router DOM pour la navigation côté client
- Axios pour les appels HTTP
- Redux Toolkit pour la gestion d'état globale
- react-hook-form pour la gestion des formulaires
- JSON Web Tokens (JWT) pour l'authentification

## 3. 🗂️ Structure du projet
```bash
src/
├── components/        # Composants réutilisables (Button, Card, ...)
├── pages/             # Pages principales (Login, Dashboard, ...)
├── api/               # Fonctions Axios pour appeler l’API backend
├── hooks/             # Hooks personnalisés (useAuth, useFetch, ...)
├── utils/             # Fonctions utilitaires globales
├── assets/            # Images, icônes, logos
├── App.js             # Point d’entrée de l’application
└── main.js            # Bootstrap React / Vite
```
Chaque dossier est organisé pour favoriser la réutilisation et la lisibilité. Les composants sont découplés des pages, les appels API sont centralisés dans `src/api`, et les hooks encapsulent la logique commune.

## 4. 🔐 Authentification
1. L'utilisateur soumet ses identifiants via la page de login, qui envoie une requête `POST /api/auth/login`.
2. Le backend renvoie un JWT conservé dans `localStorage`.
3. Une instance Axios ajoute automatiquement `Authorization: Bearer <token>` à chaque requête.
4. Les routes protégées utilisent un composant de type `PrivateRoute` pour vérifier la présence du token et rediriger vers `/login` si nécessaire.

## 5. 🔗 Connexion au backend
- **URL du backend** : `http://localhost:5000`
- **Configuration** : définie dans `src/api/axiosInstance.js` via la variable d’environnement `VITE_API_URL`.
- **Appels API** : chaque page importe des fonctions depuis `src/api`.

Exemples :
```javascript
// src/api/auth.js
export const login = (data) => axios.post('/auth/login', data);

// src/api/vm.js
export const fetchVMs = () => axios.get('/vm');
export const startVM = (id) => axios.post(`/vm/${id}/start`);
```
Les erreurs 401 déclenchent une déconnexion automatique, tandis que les erreurs 500 affichent une notification utilisateur.

## 6. 📚 Pages principales et leurs fonctions
| Page        | Fonction principale                              | Route frontend | Endpoints backend utilisés |
|-------------|--------------------------------------------------|----------------|----------------------------|
| Login       | Authentifier l’utilisateur                       | `/login`       | `POST /api/auth/login`     |
| Dashboard   | Vue d’ensemble des VMs et actions rapides        | `/dashboard`   | `GET /api/vm`, `GET /api/scripts` |
| VM Manager  | Démarrer, arrêter ou supprimer une VM            | `/vm/:id`      | `POST /api/vm/:id/start`, `POST /api/vm/:id/stop`, `DELETE /api/vm/:id` |
| Templates   | Gérer les modèles de déploiement                 | `/templates`   | `GET /api/templates`, `POST /api/templates` |
| Supervision | Afficher l’état en temps réel et les journaux    | `/supervision` | `GET /api/vm/:id/logs`, `GET /api/vm/:id/status` |

## 7. ▶️ Lancer le frontend
```bash
git clone <repo_frontend>
cd frontend/
npm install
npm run dev
```
Créer un fichier `.env` à la racine du projet avec :
```
VITE_API_URL=http://localhost:5000
```

## 8. 📌 À faire / améliorations
- Ajouter des animations de chargement et un loader global
- Centraliser la gestion des erreurs Axios
- Implémenter l’expiration automatique du JWT et la déconnexion
- Couvrir le projet par des tests unitaires (Jest, React Testing Library)
- Mettre en place une intégration continue et un déploiement automatisé
- Proposer un thème sombre et une personnalisation de l’interface
