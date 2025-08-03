# 📘 Documentation API - Linusupervisor Backend

## 🔐 Authentification

Toutes les routes marquées comme protégées nécessitent un jeton JWT envoyé via l'en-tête :

```
Authorization: Bearer <token>
```

---

## 📚 Endpoints

### Auth

#### `POST /api/auth/login`
**Description** : Authentifie un utilisateur et retourne un token JWT.
**Contrôleur** : `userAuthController.login`
**Middleware** : `logUserAction`
**Modèles** : `User`, `Role`

**Requête**
```json
{
  "email": "admin@example.com",
  "password": "admin123"
}
```

**Réponse (200)**
```json
{
  "message": "Connexion réussie",
  "token": "<jwt>",
  "user": { "id": 1, "first_name": "Super", "last_name": "Admin", "email": "latifnjimoluh@gmail.com", "role": "superadmin" }
}
```

#### `POST /api/auth/register`
**Description** : Crée un nouvel utilisateur (superadmin uniquement).
**Contrôleur** : `userAuthController.register`
**Middleware** : `verifyToken`, `checkPermission('auth.register')`, `logUserAction`
**Modèles** : `User`, `Role`
**Auth** : ✅

**Requête**
```json
{
  "first_name": "Alice",
  "last_name": "Example",
  "email": "alice@example.com",
  "phone": "123456789",
  "password": "secret",
  "role_id": 2
}
```

**Réponse (201)**
```json
{ "message": "✅ Utilisateur créé avec succès", "user": { "id": 2, "email": "alice@example.com" } }
```

#### `POST /api/auth/request-reset`
**Description** : Demande un code de réinitialisation de mot de passe.
**Contrôleur** : `userResetPasswordController.requestReset`
**Middleware** : `logUserAction`
**Modèles** : `User`

**Requête**
```json
{ "email": "user@example.com" }
```

**Réponse (200)**
```json
{ "message": "Code de réinitialisation envoyé" }
```

#### `POST /api/auth/reset-password`
**Description** : Réinitialise le mot de passe via un code.
**Contrôleur** : `userResetPasswordController.resetPassword`
**Middleware** : `logUserAction`
**Modèles** : `User`

**Requête**
```json
{ "code": "123456", "password": "newPass" }
```

**Réponse (200)**
```json
{ "message": "Mot de passe mis à jour" }
```

#### `GET /api/auth/with-reset-history`
**Description** : Liste les utilisateurs avec historique de réinitialisation.
**Contrôleur** : `userResetPasswordController.getUsersWithResetHistory`
**Middleware** : `verifyToken`, `checkPermission('auth.reset.history')`
**Modèles** : `User`
**Auth** : ✅

**Réponse (200)**
```json
[ { "id": 1, "email": "latifnjimoluh@gmail.com", "reset_history": [] } ]
```

---

### Utilisateurs

#### `GET /api/users`
**Description** : Liste paginée des utilisateurs.
**Contrôleur** : `userController.getAllUsers`
**Middleware** : `verifyToken`, `checkPermission('users.read')`
**Modèles** : `User`, `Role`
**Auth** : ✅

**Query** : `page`, `limit`, `sort`, `order`, `role`, `status`, `q`

**Réponse (200)**
```json
{
  "data": [],
  "pagination": { "total": 0, "page": 1, "pages": 0, "limit": 10 }
}
```

#### `GET /api/users/search`
**Description** : Recherche d’utilisateurs par mot clé.
**Contrôleur** : `userController.searchUsers`
**Middleware** : `verifyToken`, `checkPermission('users.read')`
**Modèles** : `User`, `Role`
**Auth** : ✅

**Query** : `q`

**Réponse (200)**
```json
[ { "id": 2, "email": "alice@example.com" } ]
```

#### `GET /api/users/:id`
**Description** : Récupère un utilisateur par son identifiant.
**Contrôleur** : `userController.getUserById`
**Middleware** : `verifyToken`, `checkPermission('users.read')`
**Modèles** : `User`, `Role`
**Auth** : ✅

**Réponse (200)**
```json
{ "id": 1, "first_name": "Super", "email": "latifnjimoluh@gmail.com" }
```

#### `POST /api/users`
**Description** : Crée un utilisateur.
**Contrôleur** : `userController.createUser`
**Middleware** : `verifyToken`, `checkPermission('users.create')`, `logUserAction`
**Modèles** : `User`
**Auth** : ✅

**Requête**
```json
{ "first_name": "Bob", "last_name": "Dupont", "email": "bob@example.com", "password": "secret", "role_id": 2 }
```

**Réponse (201)**
```json
{ "message": "Utilisateur créé avec succès", "user": { "id": 3 } }
```

#### `PUT /api/users/:id`
**Description** : Met à jour toutes les informations d’un utilisateur.
**Contrôleur** : `userController.updateUser`
**Middleware** : `verifyToken`, `checkPermission('users.update')`, `logUserAction`
**Modèles** : `User`
**Auth** : ✅

**Requête**
```json
{ "first_name": "Bob", "status": "active" }
```

**Réponse (200)**
```json
{ "message": "Utilisateur mis à jour avec succès" }
```

#### `PATCH /api/users/:id`
**Description** : Met à jour partiellement un utilisateur.
**Contrôleur** : `userController.patchUser`
**Middleware** : `verifyToken`, `checkPermission('users.update')`, `logUserAction`
**Modèles** : `User`
**Auth** : ✅

**Requête**
```json
{ "phone": "987654321" }
```

**Réponse (200)**
```json
{ "message": "Utilisateur mis à jour avec succès" }
```

#### `DELETE /api/users/:id`
**Description** : Désactive un utilisateur (suppression logique).
**Contrôleur** : `userController.softDeleteUser`
**Middleware** : `verifyToken`, `checkPermission('users.delete')`, `logUserAction`
**Modèles** : `User`
**Auth** : ✅

**Réponse (200)**
```json
{ "message": "Utilisateur désactivé (suppression logique) avec succès." }
```

---

### Rôles

#### `GET /api/user-roles`
**Description** : Liste tous les rôles.
**Contrôleur** : `userRoleController.getAllRoles`
**Middleware** : `verifyToken`, `checkPermission('roles.read')`, `logUserAction`
**Modèles** : `Role`
**Auth** : ✅

**Réponse (200)**
```json
[ { "id": 1, "name": "superadmin" } ]
```

#### `GET /api/user-roles/:id`
**Description** : Rôle par identifiant.
**Contrôleur** : `userRoleController.getRoleById`
**Middleware** : `verifyToken`, `checkPermission('roles.read')`, `logUserAction`
**Modèles** : `Role`
**Auth** : ✅

**Réponse (200)**
```json
{ "id": 2, "name": "operator" }
```

#### `POST /api/user-roles`
**Description** : Crée un rôle.
**Contrôleur** : `userRoleController.createRole`
**Middleware** : `verifyToken`, `checkPermission('roles.create')`, `logUserAction`
**Modèles** : `Role`
**Auth** : ✅

**Requête**
```json
{ "name": "viewer", "description": "lecture seule" }
```

**Réponse (201)**
```json
{ "id": 3, "name": "viewer" }
```

#### `PUT /api/user-roles/:id`
**Description** : Met à jour un rôle.
**Contrôleur** : `userRoleController.updateRole`
**Middleware** : `verifyToken`, `checkPermission('roles.update')`, `logUserAction`
**Modèles** : `Role`
**Auth** : ✅

**Réponse (200)**
```json
{ "message": "Rôle mis à jour" }
```

#### `DELETE /api/user-roles/:id`
**Description** : Supprime un rôle.
**Contrôleur** : `userRoleController.deleteRole`
**Middleware** : `verifyToken`, `checkPermission('roles.delete')`, `logUserAction`
**Modèles** : `Role`
**Auth** : ✅

**Réponse (200)**
```json
{ "message": "Rôle supprimé" }
```

---

### Permissions

#### `GET /api/permissions`
**Description** : Liste toutes les permissions.
**Contrôleur** : `userPermissionController.getAllPermissions`
**Middleware** : `verifyToken`, `logUserAction`
**Modèles** : `Permission`
**Auth** : ✅

#### `GET /api/permissions/:id`
**Description** : Détail d’une permission.
**Contrôleur** : `userPermissionController.getPermissionById`
**Middleware** : `verifyToken`, `logUserAction`
**Modèles** : `Permission`
**Auth** : ✅

#### `POST /api/permissions`
**Description** : Crée une permission (superadmin).
**Contrôleur** : `userPermissionController.createPermission`
**Middleware** : `verifyToken`, `isSuperAdmin`, `logUserAction`
**Modèles** : `Permission`
**Auth** : ✅

#### `POST /api/permissions/assign`
**Description** : Assigne des permissions à un rôle.
**Contrôleur** : `userPermissionController.assignPermissionsToRole`
**Middleware** : `verifyToken`, `isSuperAdmin`, `logUserAction`
**Modèles** : `AssignedPermission`
**Auth** : ✅

#### `GET /api/permissions/role/:role_id`
**Description** : Permissions d’un rôle.
**Contrôleur** : `userPermissionController.getPermissionsByRole`
**Middleware** : `verifyToken`, `logUserAction`
**Modèles** : `Permission`
**Auth** : ✅

#### `PUT /api/permissions/:id`
**Description** : Met à jour une permission.
**Contrôleur** : `userPermissionController.updatePermission`
**Middleware** : `verifyToken`, `isSuperAdmin`, `logUserAction`
**Modèles** : `Permission`
**Auth** : ✅

#### `DELETE /api/permissions/unassign`
**Description** : Retire des permissions d’un rôle.
**Contrôleur** : `userPermissionController.unassignPermissionsFromRole`
**Middleware** : `verifyToken`, `isSuperAdmin`, `logUserAction`
**Modèles** : `AssignedPermission`
**Auth** : ✅

#### `DELETE /api/permissions/:id`
**Description** : Supprime une permission.
**Contrôleur** : `userPermissionController.deletePermission`
**Middleware** : `verifyToken`, `isSuperAdmin`, `logUserAction`
**Modèles** : `Permission`
**Auth** : ✅

---

### Logs d’activité

#### `GET /api/user-activity-logs`
**Description** : Liste tous les journaux d’activité.
**Contrôleur** : `userActivityLogController.getAllLogs`
**Middleware** : `verifyToken`, `checkPermission('userActivityLogs.view')`, `logUserAction`
**Modèles** : `UserActivityLog`
**Auth** : ✅

#### `GET /api/user-activity-logs/users/:id`
**Description** : Journaux d’activité pour un utilisateur.
**Contrôleur** : `userActivityLogController.getLogsByUser`
**Middleware** : `verifyToken`, `checkPermission('userActivityLogs.view')`, `logUserAction`
**Modèles** : `UserActivityLog`
**Auth** : ✅

---

### Paramètres utilisateur

#### `GET /api/settings`
**Description** : Récupère les paramètres de l’utilisateur courant.
**Contrôleur** : `userSettingsController.getUserSettings`
**Middleware** : `verifyToken`, `checkPermission('userSettings.read')`, `logUserAction`
**Modèles** : `UserSetting`
**Auth** : ✅

#### `GET /api/settings/all`
**Description** : Liste de tous les paramètres utilisateurs.
**Contrôleur** : `userSettingsController.listAllSettings`
**Middleware** : `verifyToken`, `checkPermission('userSettings.list')`, `logUserAction`
**Modèles** : `UserSetting`
**Auth** : ✅

#### `PATCH /api/settings`
**Description** : Met à jour les paramètres de l’utilisateur courant.
**Contrôleur** : `userSettingsController.updateUserSettings`
**Middleware** : `verifyToken`, `checkPermission('userSettings.update')`, `logUserAction`
**Modèles** : `UserSetting`
**Auth** : ✅

**Requête**
```json
{ "cloudinit_user": "nexus" }
```

#### `POST /api/settings`
**Description** : Crée des paramètres pour l’utilisateur.
**Contrôleur** : `userSettingsController.createUserSettings`
**Middleware** : `verifyToken`, `checkPermission('userSettings.create')`, `logUserAction`
**Modèles** : `UserSetting`
**Auth** : ✅

---

### VM

#### `POST /api/vm/deploy-vm`
**Description** : Déploie une VM via Terraform.
**Contrôleur** : `deployVMController.deployVMDirect`
**Middleware** : `verifyToken`, `checkPermission('vm.deploy')`, `logUserAction`
**Modèles** : `Deployment`, `ServiceTemplate`, `InitializationScript`, `MonitoringScript`, `MonitoredService`, `UserSetting`
**Auth** : ✅

**Requête**
```json
{
  "vm_names": ["web1"],
  "service_type": "web"
}
```

#### `POST /api/vm/delete-vm`
**Description** : Arrête et supprime une VM.
**Contrôleur** : `deleteVMController.deleteVMDirect`
**Middleware** : `verifyToken`, `checkPermission('vm.delete')`, `logUserAction`
**Modèles** : `Deployment`, `Delete`, `UserSetting`
**Auth** : ✅

#### `POST /api/vm/check-vm-status`
**Description** : Vérifie le statut d’une VM.
**Contrôleur** : `checkVMStatusController.checkVMStatus`
**Middleware** : `verifyToken`, `checkPermission('vm.status')`, `logUserAction`
**Modèles** : `Deployment`
**Auth** : ✅

#### `POST /api/vm/start`
**Description** : Démarre une VM.
**Contrôleur** : `startVMController.startVM`
**Middleware** : `verifyToken`, `checkPermission('vm.start')`, `logUserAction`
**Modèles** : `Deployment`
**Auth** : ✅

#### `POST /api/vm/stop`
**Description** : Arrête une VM.
**Contrôleur** : `stopVMController.stopVM`
**Middleware** : `verifyToken`, `checkPermission('vm.stop')`, `logUserAction`
**Modèles** : `Deployment`
**Auth** : ✅

#### `GET /api/vm/deployed`
**Description** : Liste des VMs déployées.
**Contrôleur** : `listVMController.listDeployed`
**Middleware** : `verifyToken`, `checkPermission('vm.list')`, `logUserAction`
**Modèles** : `Deployment`
**Auth** : ✅

#### `GET /api/vm/destroyed`
**Description** : Historique des VMs supprimées.
**Contrôleur** : `listVMController.listDestroyed`
**Middleware** : `verifyToken`, `checkPermission('vm.list')`, `logUserAction`
**Modèles** : `Delete`
**Auth** : ✅

---

### Templates de configuration

#### `POST /api/templates/create`
**Description** : Crée un modèle de configuration.
**Contrôleur** : `configTemplateController.createTemplate`
**Middleware** : `verifyToken`, `checkPermission('configTemplate.create')`, `logUserAction`
**Modèles** : `ConfigTemplate`
**Auth** : ✅

#### `GET /api/templates/create`
**Description** : Liste les modèles de configuration.
**Contrôleur** : `configTemplateController.listTemplates`
**Middleware** : `verifyToken`, `checkPermission('configTemplate.list')`, `logUserAction`
**Modèles** : `ConfigTemplate`
**Auth** : ✅

#### `PUT /api/templates/create/:id`
**Description** : Met à jour un modèle de configuration.
**Contrôleur** : `configTemplateController.updateTemplate`
**Middleware** : `verifyToken`, `checkPermission('configTemplate.update')`, `logUserAction`
**Modèles** : `ConfigTemplate`
**Auth** : ✅

#### `DELETE /api/templates/create/:id`
**Description** : Supprime un modèle de configuration.
**Contrôleur** : `configTemplateController.deleteTemplate`
**Middleware** : `verifyToken`, `checkPermission('configTemplate.delete')`, `logUserAction`
**Modèles** : `ConfigTemplate`
**Auth** : ✅

---

### Conversion en template VM

#### `POST /api/convert-template/convert`
**Description** : Convertit une VM existante en template.
**Contrôleur** : `templateVmController.convertToTemplate`
**Middleware** : `verifyToken`, `checkPermission('template.convert')`, `logUserAction`
**Modèles** : `ConvertedVM`
**Auth** : ✅

#### `GET /api/convert-template/history`
**Description** : Historique des conversions.
**Contrôleur** : `templateVmController.getConversionHistory`
**Middleware** : `verifyToken`, `checkPermission('convert.history.view')`, `logUserAction`
**Modèles** : `ConvertedVM`
**Auth** : ✅

---

### Service Templates

#### `POST /api/service-templates`
**Description** : Crée un service template.
**Contrôleur** : `serviceTemplateController.generateServiceTemplate`
**Middleware** : `verifyToken`, `checkPermission('serviceTemplate.create')`, `logUserAction`
**Modèles** : `ServiceTemplate`, `ConfigTemplate`
**Auth** : ✅

#### `GET /api/service-templates`
**Description** : Liste les service templates.
**Contrôleur** : `serviceTemplateController.listServiceTemplates`
**Middleware** : `verifyToken`, `checkPermission('serviceTemplate.read')`, `logUserAction`
**Modèles** : `ServiceTemplate`
**Auth** : ✅

#### `PUT /api/service-templates/:id`
**Description** : Met à jour un service template.
**Contrôleur** : `serviceTemplateController.updateServiceTemplate`
**Middleware** : `verifyToken`, `checkPermission('serviceTemplate.update')`, `logUserAction`
**Modèles** : `ServiceTemplate`
**Auth** : ✅

#### `DELETE /api/service-templates/:id`
**Description** : Supprime un service template.
**Contrôleur** : `serviceTemplateController.deleteServiceTemplate`
**Middleware** : `verifyToken`, `checkPermission('serviceTemplate.delete')`, `logUserAction`
**Modèles** : `ServiceTemplate`
**Auth** : ✅

---

### Scripts de monitoring DNS

#### `POST /api/monitoring/generate`
**Description** : Génère un script de monitoring DNS.
**Contrôleur** : `generateMonitoringDNSController.generateMonitoringScript`
**Middleware** : `verifyToken`, `checkPermission('monitoringScript.generate')`, `logUserAction`
**Modèles** : `MonitoringScript`, `ScriptTemplate`
**Auth** : ✅

#### `GET /api/monitoring/generate`
**Description** : Liste les scripts de monitoring DNS.
**Contrôleur** : `generateMonitoringDNSController.listMonitoringScripts`
**Middleware** : `verifyToken`, `checkPermission('monitoringScript.list')`, `logUserAction`
**Modèles** : `MonitoringScript`
**Auth** : ✅

#### `PUT /api/monitoring/generate/:id`
**Description** : Met à jour un script de monitoring DNS.
**Contrôleur** : `generateMonitoringDNSController.updateMonitoringScript`
**Middleware** : `verifyToken`, `checkPermission('monitoringScript.update')`, `logUserAction`
**Modèles** : `MonitoringScript`
**Auth** : ✅

#### `DELETE /api/monitoring/generate/:id`
**Description** : Supprime un script de monitoring DNS.
**Contrôleur** : `generateMonitoringDNSController.deleteMonitoringScript`
**Middleware** : `verifyToken`, `checkPermission('monitoringScript.delete')`, `logUserAction`
**Modèles** : `MonitoringScript`
**Auth** : ✅

---

### Scripts d'initialisation

#### `POST /api/initialization-scripts/generate`
**Description** : Génère un script d'initialisation.
**Contrôleur** : `generateInitializationScriptController.generateInitializationScript`
**Middleware** : `verifyToken`, `checkPermission('initializationScript.generate')`, `logUserAction`
**Modèles** : `InitializationScript`
**Auth** : ✅

#### `GET /api/initialization-scripts/generate`
**Description** : Liste les scripts d'initialisation.
**Contrôleur** : `generateInitializationScriptController.listInitializationScripts`
**Middleware** : `verifyToken`, `checkPermission('initializationScript.list')`, `logUserAction`
**Modèles** : `InitializationScript`
**Auth** : ✅

#### `PUT /api/initialization-scripts/generate/:id`
**Description** : Met à jour un script d'initialisation.
**Contrôleur** : `generateInitializationScriptController.updateInitializationScript`
**Middleware** : `verifyToken`, `checkPermission('initializationScript.update')`, `logUserAction`
**Modèles** : `InitializationScript`
**Auth** : ✅

#### `DELETE /api/initialization-scripts/generate/:id`
**Description** : Supprime un script d'initialisation.
**Contrôleur** : `generateInitializationScriptController.deleteInitializationScript`
**Middleware** : `verifyToken`, `checkPermission('initializationScript.delete')`, `logUserAction`
**Modèles** : `InitializationScript`
**Auth** : ✅

---

### Scripts de services surveillés

#### `POST /api/monitoring/monitored-services/generate`
**Description** : Génère un script de détection de services.
**Contrôleur** : `generateMonitoredServiceController.generateMonitoredServiceScript`
**Middleware** : `verifyToken`, `checkPermission('monitoredService.generate')`, `logUserAction`
**Modèles** : `MonitoredService`, `ScriptTemplate`
**Auth** : ✅

#### `GET /api/monitoring/monitored-services/generate`
**Description** : Liste les scripts de services surveillés.
**Contrôleur** : `generateMonitoredServiceController.listMonitoredServiceScripts`
**Middleware** : `verifyToken`, `checkPermission('monitoredService.list')`, `logUserAction`
**Modèles** : `MonitoredService`
**Auth** : ✅

#### `PUT /api/monitoring/monitored-services/generate/:id`
**Description** : Met à jour un script de services surveillés.
**Contrôleur** : `generateMonitoredServiceController.updateMonitoredServiceScript`
**Middleware** : `verifyToken`, `checkPermission('monitoredService.update')`, `logUserAction`
**Modèles** : `MonitoredService`
**Auth** : ✅

#### `DELETE /api/monitoring/monitored-services/generate/:id`
**Description** : Supprime un script de services surveillés.
**Contrôleur** : `generateMonitoredServiceController.deleteMonitoredServiceScript`
**Middleware** : `verifyToken`, `checkPermission('monitoredService.delete')`, `logUserAction`
**Modèles** : `MonitoredService`
**Auth** : ✅

---

### Supervision

#### `POST /api/supervision/fetch`
**Description** : Récupère les statuts de supervision depuis une VM.
**Contrôleur** : `supervisionFetchController.fetchFromDynamicVM`
**Middleware** : `verifyToken`, `checkPermission('supervision.fetch')`, `logUserAction`
**Modèles** : `StatusSnapshot`, `ServiceStatus`
**Auth** : ✅

#### `GET /api/supervision/status`
**Description** : Liste des derniers statuts de supervision.
**Contrôleur** : lecture directe via modèle `StatusSnapshot`
**Middleware** : Aucun
**Modèles** : `StatusSnapshot`
**Auth** : ❌

#### `GET /api/supervision/services`
**Description** : Liste des statuts des services.
**Contrôleur** : lecture directe via modèle `ServiceStatus`
**Middleware** : Aucun
**Modèles** : `ServiceStatus`
**Auth** : ❌

---

## ⚠️ Routes non montées
- `controllers/generate/generateAgentController.js` : présent mais aucune route associée.

---

## 🔁 Tableau récapitulatif

| Méthode | URL | Description | Auth | Contrôleur |
|---|---|---|:---:|---|
| POST | /api/auth/login | Connexion utilisateur | ❌ | userAuthController.login |
| POST | /api/auth/register | Création d'utilisateur | ✅ | userAuthController.register |
| POST | /api/auth/request-reset | Demande reset mot de passe | ❌ | userResetPasswordController.requestReset |
| POST | /api/auth/reset-password | Réinitialisation mot de passe | ❌ | userResetPasswordController.resetPassword |
| GET | /api/auth/with-reset-history | Historique des resets | ✅ | userResetPasswordController.getUsersWithResetHistory |
| GET | /api/users | Liste des utilisateurs | ✅ | userController.getAllUsers |
| GET | /api/users/search | Recherche d'utilisateurs | ✅ | userController.searchUsers |
| GET | /api/users/:id | Détail utilisateur | ✅ | userController.getUserById |
| POST | /api/users | Création utilisateur | ✅ | userController.createUser |
| PUT | /api/users/:id | Mise à jour utilisateur | ✅ | userController.updateUser |
| PATCH | /api/users/:id | Patch utilisateur | ✅ | userController.patchUser |
| DELETE | /api/users/:id | Suppression logique | ✅ | userController.softDeleteUser |
| GET | /api/user-roles | Liste des rôles | ✅ | userRoleController.getAllRoles |
| GET | /api/user-roles/:id | Détail d'un rôle | ✅ | userRoleController.getRoleById |
| POST | /api/user-roles | Création rôle | ✅ | userRoleController.createRole |
| PUT | /api/user-roles/:id | Mise à jour rôle | ✅ | userRoleController.updateRole |
| DELETE | /api/user-roles/:id | Suppression rôle | ✅ | userRoleController.deleteRole |
| GET | /api/permissions | Liste des permissions | ✅ | userPermissionController.getAllPermissions |
| GET | /api/permissions/:id | Détail permission | ✅ | userPermissionController.getPermissionById |
| POST | /api/permissions | Création permission | ✅ | userPermissionController.createPermission |
| POST | /api/permissions/assign | Attribution de permissions | ✅ | userPermissionController.assignPermissionsToRole |
| GET | /api/permissions/role/:role_id | Permissions d'un rôle | ✅ | userPermissionController.getPermissionsByRole |
| PUT | /api/permissions/:id | Mise à jour permission | ✅ | userPermissionController.updatePermission |
| DELETE | /api/permissions/unassign | Retrait de permissions | ✅ | userPermissionController.unassignPermissionsFromRole |
| DELETE | /api/permissions/:id | Suppression permission | ✅ | userPermissionController.deletePermission |
| GET | /api/user-activity-logs | Tous les logs d'activité | ✅ | userActivityLogController.getAllLogs |
| GET | /api/user-activity-logs/users/:id | Logs d'un utilisateur | ✅ | userActivityLogController.getLogsByUser |
| GET | /api/settings | Paramètres de l'utilisateur | ✅ | userSettingsController.getUserSettings |
| GET | /api/settings/all | Tous les paramètres | ✅ | userSettingsController.listAllSettings |
| PATCH | /api/settings | Mise à jour paramètres | ✅ | userSettingsController.updateUserSettings |
| POST | /api/settings | Création paramètres | ✅ | userSettingsController.createUserSettings |
| POST | /api/vm/deploy-vm | Déploiement de VM | ✅ | deployVMController.deployVMDirect |
| POST | /api/vm/delete-vm | Suppression de VM | ✅ | deleteVMController.deleteVMDirect |
| POST | /api/vm/check-vm-status | Vérification statut VM | ✅ | checkVMStatusController.checkVMStatus |
| POST | /api/vm/start | Démarrage VM | ✅ | startVMController.startVM |
| POST | /api/vm/stop | Arrêt VM | ✅ | stopVMController.stopVM |
| GET | /api/vm/deployed | VMs déployées | ✅ | listVMController.listDeployed |
| GET | /api/vm/destroyed | VMs détruites | ✅ | listVMController.listDestroyed |
| POST | /api/service-templates | Création service template | ✅ | serviceTemplateController.generateServiceTemplate |
| GET | /api/service-templates | Liste service templates | ✅ | serviceTemplateController.listServiceTemplates |
| PUT | /api/service-templates/:id | Mise à jour service template | ✅ | serviceTemplateController.updateServiceTemplate |
| DELETE | /api/service-templates/:id | Suppression service template | ✅ | serviceTemplateController.deleteServiceTemplate |
| POST | /api/monitoring/generate | Génération script monitoring DNS | ✅ | generateMonitoringDNSController.generateMonitoringScript |
| GET | /api/monitoring/generate | Liste scripts monitoring DNS | ✅ | generateMonitoringDNSController.listMonitoringScripts |
| PUT | /api/monitoring/generate/:id | Mise à jour script monitoring DNS | ✅ | generateMonitoringDNSController.updateMonitoringScript |
| DELETE | /api/monitoring/generate/:id | Suppression script monitoring DNS | ✅ | generateMonitoringDNSController.deleteMonitoringScript |
| POST | /api/monitoring/monitored-services/generate | Génération script services surveillés | ✅ | generateMonitoredServiceController.generateMonitoredServiceScript |
| GET | /api/monitoring/monitored-services/generate | Liste scripts services surveillés | ✅ | generateMonitoredServiceController.listMonitoredServiceScripts |
| PUT | /api/monitoring/monitored-services/generate/:id | Mise à jour script services surveillés | ✅ | generateMonitoredServiceController.updateMonitoredServiceScript |
| DELETE | /api/monitoring/monitored-services/generate/:id | Suppression script services surveillés | ✅ | generateMonitoredServiceController.deleteMonitoredServiceScript |
| POST | /api/initialization-scripts/generate | Génération script d'initialisation | ✅ | generateInitializationScriptController.generateInitializationScript |
| GET | /api/initialization-scripts/generate | Liste scripts d'initialisation | ✅ | generateInitializationScriptController.listInitializationScripts |
| PUT | /api/initialization-scripts/generate/:id | Mise à jour script d'initialisation | ✅ | generateInitializationScriptController.updateInitializationScript |
| DELETE | /api/initialization-scripts/generate/:id | Suppression script d'initialisation | ✅ | generateInitializationScriptController.deleteInitializationScript |
| POST | /api/templates/create | Création template de configuration | ✅ | configTemplateController.createTemplate |
| GET | /api/templates/create | Liste templates de configuration | ✅ | configTemplateController.listTemplates |
| PUT | /api/templates/create/:id | Mise à jour template de configuration | ✅ | configTemplateController.updateTemplate |
| DELETE | /api/templates/create/:id | Suppression template de configuration | ✅ | configTemplateController.deleteTemplate |
| POST | /api/convert-template/convert | Conversion VM en template | ✅ | templateVmController.convertToTemplate |
| GET | /api/convert-template/history | Historique conversions | ✅ | templateVmController.getConversionHistory |
| POST | /api/supervision/fetch | Récupération statuts supervision | ✅ | supervisionFetchController.fetchFromDynamicVM |
| GET | /api/supervision/status | Statuts de supervision | ❌ | (direct StatusSnapshot) |
| GET | /api/supervision/services | Statuts des services | ❌ | (direct ServiceStatus) |

---

> ⚠️ Certaines routes exposent directement la base sans validation approfondie ni gestion d'erreur uniforme. Ajouter une couche de validation et un middleware global d'erreur est recommandé.
