# Linu Supervisor

## Description
Une solution complète de supervision de serveurs Linux et de gestion d'infrastructure, comprenant un backend robuste avec Express/Sequelize et un frontend moderne en Next.js.

## Structure du Projet
- `backend/` : API REST Node.js, Express, Sequelize (MySQL). Gère l'authentification JWT, les rôles, les permissions et la surveillance.
- `frontend/` : Dashboard Next.js pour visualiser les métriques, gérer les utilisateurs et les déploiements.
- `terraform/` : Configuration Infrastructure as Code (IaC) pour le déploiement.

## Stack Technique
- **Backend :** Node.js, Express, Sequelize, MySQL, JWT, Winston (Logs), Socket.io (Surveillance en temps réel).
- **Frontend :** Next.js 14+, Tailwind CSS, Radix UI.
- **DevOps :** Terraform, Scripts Shell.

## Prérequis
- Node.js 18+
- MySQL Server

## Installation
1. Installez les dépendances à la racine (npm workspaces) :
   ```bash
   npm install
   ```

## Configuration
1. Configurez les fichiers `.env` dans `backend/` et `frontend/` en vous basant sur leurs fichiers `.env.example` respectifs.
2. Initialisez la base de données avec les scripts SQL fournis dans `backend/sql/`.

## Lancement
- Backend : `npm run dev:backend` (depuis la racine)
- Frontend : `npm run dev:frontend` (depuis la racine)
