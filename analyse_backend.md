# Analyse du backend

Ce document résume les routes exposées dans la collection Postman de l'API *Linusupervisor*. Chaque section correspond à un groupe de fonctionnalités principal.

## Authentification
- **POST /auth/login** : connexion d'un utilisateur avec email et mot de passe.
- **POST /auth/register** : création d'un utilisateur (protégé par un token).
- **POST /auth/request-reset** : demande d'envoi d'un code de réinitialisation de mot de passe.
- **POST /auth/reset-password** : réinitialisation du mot de passe via un code reçu.
- **GET /auth/reset-history** : historique des demandes de réinitialisation pour l'utilisateur authentifié.

## Gestion des utilisateurs
- **POST /users** : création d'un utilisateur.
- **DELETE /users/:id** : suppression d'un utilisateur.
- **GET /users/:id** : récupération d'un utilisateur spécifique.
- **GET /users** : liste complète des utilisateurs.
- **PATCH /users/:id** : modification partielle d'un utilisateur.
- **GET /users/search?query=** : recherche d'utilisateurs.
- **PUT /users/:id** : mise à jour complète d'un utilisateur.

## Rôles
- **GET /roles** : liste des rôles.
- **GET /roles/:id** : détail d'un rôle.
- **POST /roles** : création d'un rôle.
- **PUT /roles/:id** : mise à jour d'un rôle.
- **DELETE /roles/:id** : suppression d'un rôle.

## Permissions
- **GET /permissions** : liste des permissions.
- **POST /permissions** : création d'une permission.
- **POST /permissions/assign** : assignation de permissions à un rôle.
- **POST /permissions/unassign** : retrait de permissions d'un rôle.
- **GET /permissions/role/:role_id** : permissions associées à un rôle.
- **GET /permissions/:id** : détail d'une permission.
- **PUT /permissions/:id** : mise à jour d'une permission.
- **DELETE /permissions/:id** : suppression d'une permission.

## Logs
- **GET /logs** : récupération des logs du système.

## Paramètres utilisateurs
- **GET /settings/me** : obtention des paramètres de l'utilisateur connecté.
- **POST /settings/me** : création des paramètres personnels.
- **PUT /settings/me** : mise à jour des paramètres personnels.
- **GET /settings** : liste de tous les paramètres enregistrés.

## Proxmox
- **GET /vms** : liste des machines virtuelles.
- **POST /vms/:id/start** : démarrage d'une VM.
- **POST /vms/:id/stop** : arrêt d'une VM.
- **POST /vms/delete** : suppression d'une VM avec `vm_id` et `instance_id` dans le corps.
- **POST /vms/check-status** : vérification de l'état d'une VM.
- **POST /vms/convert** : conversion d'une VM en template.
- **GET /vms/conversions** : historique des conversions de VM.

## Templates de services
- **GET /templates** : liste des templates disponibles.
- **POST /templates** : création d'un template.
- **GET /templates/:id** : obtention d'un template.
- **PUT /templates/:id** : mise à jour d'un template.
- **DELETE /templates/:id** : suppression d'un template.
- **POST /templates/generate** : génération d'un script à partir d'un template.

## Monitoring
- **GET /monitoring** : liste les enregistrements de monitoring.
- **GET /monitoring/:id** : détail d'un enregistrement précis.
- **POST /monitoring/collect** : récupère les fichiers de monitoring d'une VM et les enregistre en base avec l'heure de collecte.
- **POST /monitoring/sync-ip** : met à jour l'IP d'une VM dans la table des déploiements si elle a changé.

## Terraform
- **POST /terraform/deploy** : déclenchement d'un déploiement Terraform avec une liste dynamique de scripts.

Ce résumé se base sur la collection `postman_collection.json` et peut servir de référence rapide pour le développement backend.
