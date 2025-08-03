# ANALYSE_BACKEND

## 1. 📊 ROUTES ACTUELLES

| Méthode | Chemin | Contrôleur | Middleware | Modèle lié | Statut |
|---------|--------|------------|------------|------------|--------|
| GET | /api/auth/with-reset-history | userResetPasswordController.getUsersWithResetHistory | verifyToken, checkPermission('auth.reset.history') | User | ✅ |
| POST | /api/auth/reset-password | userResetPasswordController.resetPassword | logUserAction | User | ✅ |
| POST | /api/auth/request-reset | userResetPasswordController.requestReset | logUserAction | User | ✅ |
| POST | /api/auth/register | userAuthController.register | verifyToken, checkPermission('auth.register'), logUserAction | User, Role | ✅ |
| POST | /api/auth/login | userAuthController.login | logUserAction | User | ✅ |
| GET | /api/users | userController.getAllUsers | verifyToken, checkPermission('users.read') | User | ✅ |
| GET | /api/users/:id | userController.getUserById | verifyToken, checkPermission('users.read') | User | ✅ |
| PUT | /api/users/:id | userController.updateUser | verifyToken, checkPermission('users.update') | User | ✅ |
| DELETE | /api/users/:id | userController.softDeleteUser | verifyToken, checkPermission('users.delete') | User | ✅ |
| GET | /api/settings | userSettingsController.getUserSettings | verifyToken, checkPermission('userSettings.read') | UserSetting | ✅ |
| PATCH | /api/settings | userSettingsController.updateUserSettings | verifyToken, checkPermission('userSettings.update') | UserSetting | ✅ |
| POST | /api/settings | userSettingsController.createUserSettings | verifyToken, checkPermission('userSettings.create') | UserSetting | ✅ |
| GET | /api/user-roles | userRoleController.getAllRoles | verifyToken, checkPermission('roles.read') | Role | ✅ |
| POST | /api/user-roles | userRoleController.createRole | verifyToken, checkPermission('roles.create') | Role | ✅ |
| PUT | /api/user-roles/:id | userRoleController.updateRole | verifyToken, checkPermission('roles.update') | Role | ✅ |
| DELETE | /api/user-roles/:id | userRoleController.deleteRole | verifyToken, checkPermission('roles.delete') | Role | ✅ |
| GET | /api/permissions | userPermissionController.getAllPermissions | verifyToken | Permission | ✅ |
| POST | /api/permissions | userPermissionController.createPermission | verifyToken, isSuperAdmin | Permission | ✅ |
| POST | /api/permissions/assign | userPermissionController.assignPermissionsToRole | verifyToken, isSuperAdmin | AssignedPermission | ✅ |
| GET | /api/permissions/role/:role_id | userPermissionController.getPermissionsByRole | verifyToken | Permission, Role | ✅ |
| GET | (non monté) /user-activity-logs/users/:id | userActivityLogController.getLogsByUser | verifyToken, checkPermission('userActivityLogs.view') | UserActivityLog | ⚠️ non monté |
| POST | /api/vm/deploy-vm | deployVMController.deployVMDirect | verifyToken, checkPermission('vm.deploy') | Deployment, ServiceTemplate, InitializationScript, MonitoringScript, MonitoredService, UserSetting | ✅ |
| POST | /api/vm/delete-vm | deleteVMController.deleteVMDirect | verifyToken, checkPermission('vm.delete') | Deployment, Delete, UserSetting | ✅ |
| POST | /api/vm/check-vm-status | checkVMStatusController.checkVMStatus | verifyToken, checkPermission('vm.status') | UserSetting | ✅ |
| POST | /api/vm/start | startVMController.startVM | verifyToken, checkPermission('vm.start') | UserSetting | ✅ |
| POST | /api/vm/stop | stopVMController.stopVM | verifyToken, checkPermission('vm.stop') | UserSetting | ✅ |
| POST | /api/service-templates | serviceTemplateController.generateServiceTemplate | verifyToken, checkPermission('serviceTemplate.create') | ConfigTemplate, ServiceTemplate | ✅ |
| POST | /api/monitoring/generate | generateMonitoringDNSController.generateMonitoringScript | verifyToken, checkPermission('monitoringScript.generate') | MonitoringScript, ScriptTemplate | ✅ |
| POST | /api/monitoring/monitored-services/generate | generateMonitoredServiceController.generateMonitoredServiceScript | verifyToken, checkPermission('monitoredService.generate') | MonitoredService, ScriptTemplate | ✅ |
| POST | /api/initialization-scripts/generate | generateInitializationScriptController.generateInitializationScript | verifyToken, checkPermission('initializationScript.generate') | InitializationScript | ✅ |
| POST | /api/supervision/fetch | supervisionFetchController.fetchFromDynamicVM | verifyToken, checkPermission('supervision.fetch') | StatusSnapshot, ServiceStatus, VMInstance, UserSetting | ✅ |
| POST | /api/supervision/status | supervisionFetchController.saveStatus | verifyToken, checkPermission('supervision.save') | SupervisionStatus (absent) | 🛠️ modèle manquant |
| POST | /api/supervision/services | supervisionFetchController.saveServices | verifyToken, checkPermission('supervision.save') | ServiceStatus | ✅ |
| GET | /api/supervision/status | supervisionRoutes (inline) | – | SupervisionStatus | 🛠️ modèle manquant |
| GET | /api/supervision/services | supervisionRoutes (inline) | – | ServiceStatus | ✅ |
| POST | /api/templates/create | configTemplateController.createTemplate | verifyToken, checkPermission('configTemplate.create') | ConfigTemplate | ✅ |
| POST | /api/convert-template/convert | templateVmController.convertToTemplate | verifyToken, checkPermission('template.convert') | UserSetting | ✅ |

## 2. ❌ ROUTES MANQUANTES (selon les modèles)

- **User** : pas de route `POST /users` (création via `/auth/register`).
- **UserSetting** : pas de `DELETE /settings` ni de récupération par ID.
- **Role** : pas de `GET /user-roles/:id`.
- **Permission** : pas de `GET /permissions/:id`, `PUT`, `DELETE`.
- **AssignedPermission** : aucune route dédiée pour retirer des permissions.
- **UserActivityLog** : le routeur n’est pas monté dans `routes/index.js`.
- **InitializationScript**, **MonitoringScript**, **MonitoredService** : seules des routes de création existent (`POST /.../generate`). Pas de liste, détail, mise à jour ou suppression.
- **ConfigTemplate** et **ServiceTemplate** : uniquement création (`POST`), aucune lecture ou modification.
- **Deployment**, **Delete**, **ServiceStatus**, **StatusSnapshot**, **VMInstance** : aucun endpoint REST exposé (liste ou détail).
- **SupervisionStatus** : modèle attendu mais absent ; toute route correspondante est donc inopérante.

Exemple de route à ajouter :
```http
DELETE /api/templates/:id
```

## 3. 🧱 ANALYSE STRUCTURELLE

- Découpage MVC globalement respecté (dossiers `routes`, `controllers`, `models`).
- Duplication ou fichiers résiduels : `monitoringServiceController.js` double d’autres contrôleurs.
- Plusieurs contrôleurs contiennent une logique métier très lourde (ex. `deployVMController`) qui mériterait d’être déplacée vers des services dédiés.
- Absence de couche `services` ou `repositories` pour isoler l’accès aux données.
- Middlewares présents : `verifyToken`, `checkPermission`, `logUserAction`. Pas de middleware global d’erreur ou de validation.
- Certaines routes utilisent des modèles inexistants (`SupervisionStatus`), ce qui provoque des erreurs à l’exécution.

## 4. 🚀 SUGGESTIONS D’AMÉLIORATION DU CODE

- Ajouter une couche de services pour alléger les contrôleurs et centraliser la logique métier.
- Mettre en place une validation des entrées (Joi, Yup, Zod) et un middleware d’erreurs global.
- Documenter l’API via Swagger / OpenAPI et prévoir un versionnement des routes.
- Gérer la pagination / filtrage pour les listes d’objets (`users`, `templates`, `deployments`, etc.).
- Ajouter des tests unitaires et d’intégration (mocha/jest) au lieu du placeholder actuel.
- Mettre en place un logger applicatif (`winston` ou `pino`) et un suivi des erreurs.
- Sécuriser davantage l’API : `express-rate-limit`, `helmet` configuré, CORS finement réglé, sanitisation des inputs.
- Prévoir la suppression logique ou l’archivage pour les scripts et templates générés.

## 5. 🧠 RECOMMANDATIONS MÉTIER

- **Historique des déploiements** : ajouter `GET /deployments` et `GET /deployments/:id` pour suivre et auditer les opérations.
- **Logs SSH & supervision** : exposer `GET /logs` et `GET /supervision/history` afin d’afficher l’historique des statuts.
- **Gestion des scripts** : prévoir des endpoints pour tester, lister et supprimer les scripts générés avant déploiement.
- **Rôles supplémentaires** : inclure un rôle "auditeur" avec accès lecture seule aux journaux et déploiements.
- **Assistance IA** : aucun endpoint n’intègre l’assistant IA décrit dans le projet (suggestions de configuration, aide contextuelle).
- **Sécurité & traçabilité** : ajouter un endpoint de consultation des logs utilisateurs (`GET /user-logs`) et des opérations SSH.

## 6. ✅ SYNTHÈSE

| Zone | Observation / Action recommandée |
|------|---------------------------------|
| Routes | Plusieurs endpoints CRUD manquants (templates, scripts, permissions, historiques). |
| Modèles Sequelize | `SupervisionStatus` inexistant mais utilisé ; modèles comme `Deployment` ou `VMInstance` sans exposition API. |
| Contrôleurs | `deployVMController` et `supervisionFetchController` contiennent trop de logique ; absence de couche service. |
| Sécurité | Manque de validation d’inputs, de rate limiting et de gestion centralisée des erreurs ; tests absents. |
| Documentation | Pas de Swagger/OpenAPI ; routes non décrites officiellement. |
| Fonctionnalités métier | Endpoints pour l’historique des déploiements, les logs d’audit ou l’assistance IA à ajouter. |
