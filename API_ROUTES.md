# Documentation API - Linusupervisor Backend

Toutes les routes exposées par l'API. L'URL de base utilisée dans les exemples est `http://localhost:5000`.

## Authentification

### `POST /api/auth/login`
**Description**: Connecte un utilisateur existant et renvoie un token JWT.

**Corps attendu (`req.body`)** :
```json
{
  "email": "admin@example.com",
  "password": "motdepasse"
}
```
Exemple de test avec Postman :

Méthode : POST

URL : http://localhost:5000/api/auth/login

Headers : Content-Type: application/json

Body (raw JSON) : (corps JSON ci-dessus)

---

### `POST /api/auth/register`
**Description**: Crée un nouvel utilisateur. Réservé aux comptes disposant de la permission `auth.register`.

**Corps attendu (`req.body`)** :
```json
{
  "first_name": "Alice",
  "last_name": "Dupont",
  "email": "alice@example.com",
  "phone": "+33123456789",
  "password": "motdepasse",
  "role_id": 2,
  "status": "active"
}
```
Exemple de test avec Postman :

Méthode : POST

URL : http://localhost:5000/api/auth/register

Headers : Content-Type: application/json, Authorization: Bearer <token>

Body (raw JSON) : (corps JSON ci-dessus)

Route protégée : JWT + permission `auth.register`.

---

### `POST /api/auth/request-reset`
**Description**: Envoie un code de réinitialisation de mot de passe à l'adresse e-mail fournie.

**Corps attendu (`req.body`)** :
```json
{
  "email": "user@example.com"
}
```
Exemple de test avec Postman :

Méthode : POST

URL : http://localhost:5000/api/auth/request-reset

Headers : Content-Type: application/json

Body (raw JSON) : (corps JSON ci-dessus)

---

### `POST /api/auth/reset-password`
**Description**: Réinitialise le mot de passe à l'aide d'un code valide.

**Corps attendu (`req.body`)** :
```json
{
  "code": "123456",
  "password": "nouveauMDP"
}
```
Exemple de test avec Postman :

Méthode : POST

URL : http://localhost:5000/api/auth/reset-password

Headers : Content-Type: application/json

Body (raw JSON) : (corps JSON ci-dessus)

---

### `GET /api/auth/with-reset-history`
**Description**: Récupère les utilisateurs ayant une historique de réinitialisation de mot de passe.

Paramètres : aucun.

Exemple de test avec Postman :

Méthode : GET

URL : http://localhost:5000/api/auth/with-reset-history

Headers : Authorization: Bearer <token>

Route protégée : JWT + permission `auth.reset.history`.

---

## Gestion des utilisateurs

### `GET /api/users/`
**Description**: Liste tous les utilisateurs.

Paramètres : aucun.

Exemple de test avec Postman :

Méthode : GET

URL : http://localhost:5000/api/users/

Headers : Authorization: Bearer <token>

Route protégée : JWT + permission `users.read`.

---

### `GET /api/users/:id`
**Description**: Récupère les détails d'un utilisateur par son ID.

Paramètres URL (`req.params`) :
- `id` : identifiant de l'utilisateur

Exemple de test avec Postman :

Méthode : GET

URL : http://localhost:5000/api/users/1

Headers : Authorization: Bearer <token>

Route protégée : JWT + permission `users.read`.

---

### `PUT /api/users/:id`
**Description**: Met à jour les informations d'un utilisateur.

Paramètres URL (`req.params`) :
- `id` : identifiant de l'utilisateur

**Corps attendu (`req.body`)** :
```json
{
  "first_name": "Alice",
  "last_name": "Durand",
  "phone": "+33111222333",
  "status": "active",
  "role_id": 2
}
```
Exemple de test avec Postman :

Méthode : PUT

URL : http://localhost:5000/api/users/1

Headers : Content-Type: application/json, Authorization: Bearer <token>

Body (raw JSON) : (corps JSON ci-dessus)

Route protégée : JWT + permission `users.update`.

---

### `DELETE /api/users/:id`
**Description**: Désactive un utilisateur (suppression logique).

Paramètres URL (`req.params`) :
- `id` : identifiant de l'utilisateur

Exemple de test avec Postman :

Méthode : DELETE

URL : http://localhost:5000/api/users/1

Headers : Authorization: Bearer <token>

Route protégée : JWT + permission `users.delete`.

---

## Logs utilisateurs (non monté)

### `GET /api/user-logs/users/:id` (À compléter manuellement)
**Description**: Récupère les logs d'actions d'un utilisateur. Cette route est définie dans `routes/user/userActionLogRoutes.js` mais n'est pas enregistrée dans `routes/index.js`.

Paramètres URL (`req.params`) :
- `id` : identifiant de l'utilisateur

Exemple de test avec Postman :

Méthode : GET

URL : À compléter manuellement (route non montée)

Headers : Authorization: Bearer <token>

Route protégée : JWT + permission `userLogs.view`.

---

## Permissions

### `GET /api/permissions/`
**Description**: Liste toutes les permissions disponibles.

Exemple de test avec Postman :

Méthode : GET

URL : http://localhost:5000/api/permissions/

Headers : Authorization: Bearer <token>

Route protégée : JWT.

---

### `POST /api/permissions/`
**Description**: Crée une ou plusieurs permissions. Réservé aux superadmins.

**Corps attendu (`req.body`)** :
```json
[
  { "name": "users.read", "description": "Lecture des utilisateurs" }
]
```
Exemple de test avec Postman :

Méthode : POST

URL : http://localhost:5000/api/permissions/

Headers : Content-Type: application/json, Authorization: Bearer <token>

Body (raw JSON) : (corps JSON ci-dessus)

Route protégée : JWT + rôle superadmin.

---

### `POST /api/permissions/assign`
**Description**: Associe des permissions à un rôle. Réservé aux superadmins.

**Corps attendu (`req.body`)** :
```json
[
  {
    "role_id": 2,
    "permission_ids": [1, 2, 3]
  }
]
```
Exemple de test avec Postman :

Méthode : POST

URL : http://localhost:5000/api/permissions/assign

Headers : Content-Type: application/json, Authorization: Bearer <token>

Body (raw JSON) : (corps JSON ci-dessus)

Route protégée : JWT + rôle superadmin.

---

### `GET /api/permissions/role/:role_id`
**Description**: Récupère les permissions associées à un rôle donné.

Paramètres URL (`req.params`) :
- `role_id` : identifiant du rôle

Exemple de test avec Postman :

Méthode : GET

URL : http://localhost:5000/api/permissions/role/2

Headers : Authorization: Bearer <token>

Route protégée : JWT.

---

## Rôles utilisateurs

### `GET /api/user-roles/`
**Description**: Liste tous les rôles disponibles.

Exemple de test avec Postman :

Méthode : GET

URL : http://localhost:5000/api/user-roles/

Headers : Authorization: Bearer <token>

Route protégée : JWT + permission `roles.read`.

---

### `POST /api/user-roles/`
**Description**: Crée un nouveau rôle.

**Corps attendu (`req.body`)** :
```json
{
  "name": "opérateur",
  "description": "Utilisateur standard"
}
```
Exemple de test avec Postman :

Méthode : POST

URL : http://localhost:5000/api/user-roles/

Headers : Content-Type: application/json, Authorization: Bearer <token>

Body (raw JSON) : (corps JSON ci-dessus)

Route protégée : JWT + permission `roles.create`.

---

### `PUT /api/user-roles/:id`
**Description**: Met à jour un rôle existant.

Paramètres URL (`req.params`) :
- `id` : identifiant du rôle

**Corps attendu (`req.body`)** :
```json
{
  "name": "admin",
  "description": "Administrateur"
}
```
Exemple de test avec Postman :

Méthode : PUT

URL : http://localhost:5000/api/user-roles/2

Headers : Content-Type: application/json, Authorization: Bearer <token>

Body (raw JSON) : (corps JSON ci-dessus)

Route protégée : JWT + permission `roles.update`.

---

### `DELETE /api/user-roles/:id`
**Description**: Désactive un rôle (statut inactif).

Paramètres URL (`req.params`) :
- `id` : identifiant du rôle

Exemple de test avec Postman :

Méthode : DELETE

URL : http://localhost:5000/api/user-roles/2

Headers : Authorization: Bearer <token>

Route protégée : JWT + permission `roles.delete`.

---

## Paramètres utilisateur

### `GET /api/settings/`
**Description**: Récupère les paramètres de l'utilisateur connecté.

Exemple de test avec Postman :

Méthode : GET

URL : http://localhost:5000/api/settings/

Headers : Authorization: Bearer <token>

Route protégée : JWT + permission `userSettings.read`.

---

### `PATCH /api/settings/`
**Description**: Met à jour les paramètres de l'utilisateur connecté.

**Corps attendu (`req.body`)** (exemple) :
```json
{
  "proxmox_api_url": "https://192.168.0.10:8006/api2/json",
  "proxmox_node": "pve"
}
```
Exemple de test avec Postman :

Méthode : PATCH

URL : http://localhost:5000/api/settings/

Headers : Content-Type: application/json, Authorization: Bearer <token>

Body (raw JSON) : (corps JSON ci-dessus)

Route protégée : JWT + permission `userSettings.update`.

---

### `POST /api/settings/`
**Description**: Crée les paramètres globaux d'un utilisateur.

**Corps attendu (`req.body`)** (exemple) :
```json
{
  "cloudinit_user": "nexus",
  "ssh_private_key_path": "/home/nexus/.ssh/id_rsa"
}
```
Exemple de test avec Postman :

Méthode : POST

URL : http://localhost:5000/api/settings/

Headers : Content-Type: application/json, Authorization: Bearer <token>

Body (raw JSON) : (corps JSON ci-dessus)

Route protégée : JWT + permission `userSettings.create`.

---

## Gestion des VMs

### `POST /api/vm/deploy-vm`
**Description**: Déploie une nouvelle VM via Terraform.

**Corps attendu (`req.body`)** (exemple minimal) :
```json
{
  "vm_names": ["dns01"],
  "service_type": "dns"
}
```
Exemple de test avec Postman :

Méthode : POST

URL : http://localhost:5000/api/vm/deploy-vm

Headers : Content-Type: application/json, Authorization: Bearer <token>

Body (raw JSON) : (corps JSON ci-dessus)

Route protégée : JWT + permission `vm.deploy`. Paramètres Proxmox supplémentaires à compléter selon le contexte.

---

### `POST /api/vm/delete-vm`
**Description**: Supprime une VM existante après l'avoir arrêtée.

**Corps attendu (`req.body`)** :
```json
{
  "vm_id": 101,
  "instance_id": "uuid-instance",
  "node": "pve"
}
```
Exemple de test avec Postman :

Méthode : POST

URL : http://localhost:5000/api/vm/delete-vm

Headers : Content-Type: application/json, Authorization: Bearer <token>

Body (raw JSON) : (corps JSON ci-dessus)

Route protégée : JWT + permission `vm.delete`.

---

### `POST /api/vm/check-vm-status`
**Description**: Vérifie l'état d'une VM et effectue un ping.

**Corps attendu (`req.body`)** :
```json
{
  "vm_id": 101,
  "ip_address": "192.168.0.20"
}
```
Exemple de test avec Postman :

Méthode : POST

URL : http://localhost:5000/api/vm/check-vm-status

Headers : Content-Type: application/json, Authorization: Bearer <token>

Body (raw JSON) : (corps JSON ci-dessus)

Route protégée : JWT + permission `vm.status`.

---

### `POST /api/vm/start`
**Description**: Démarre une VM arrêtée.

**Corps attendu (`req.body`)** :
```json
{
  "vm_id": 101
}
```
Exemple de test avec Postman :

Méthode : POST

URL : http://localhost:5000/api/vm/start

Headers : Content-Type: application/json, Authorization: Bearer <token>

Body (raw JSON) : (corps JSON ci-dessus)

Route protégée : JWT + permission `vm.start`.

---

### `POST /api/vm/stop`
**Description**: Arrête une VM en cours d'exécution.

**Corps attendu (`req.body`)** :
```json
{
  "vm_id": 101
}
```
Exemple de test avec Postman :

Méthode : POST

URL : http://localhost:5000/api/vm/stop

Headers : Content-Type: application/json, Authorization: Bearer <token>

Body (raw JSON) : (corps JSON ci-dessus)

Route protégée : JWT + permission `vm.stop`.

---

## Génération de scripts

### `POST /api/init-scripts/generate`
**Description**: Génère et enregistre un script d'initialisation.

**Corps attendu (`req.body`)** :
```json
{
  "name": "Init DNS",
  "description": "Installation BIND9",
  "content": "#!/bin/bash\napt update && apt install bind9"
}
```
Exemple de test avec Postman :

Méthode : POST

URL : http://localhost:5000/api/init-scripts/generate

Headers : Content-Type: application/json, Authorization: Bearer <token>

Body (raw JSON) : (corps JSON ci-dessus)

Route protégée : JWT + permission `initScript.generate`.

---

### `POST /api/monitoring/generate`
**Description**: Génère un script de monitoring DNS à partir d'un template.

**Corps attendu (`req.body`)** :
```json
{
  "template_id": 1,
  "zone_name": "example.com",
  "check_domain": "ns1.example.com",
  "ports_to_scan": "53,80",
  "cron_interval": "*/5 * * * *"
}
```
Exemple de test avec Postman :

Méthode : POST

URL : http://localhost:5000/api/monitoring/generate

Headers : Content-Type: application/json, Authorization: Bearer <token>

Body (raw JSON) : (corps JSON ci-dessus)

Route protégée : JWT + permission `monitoringScript.generate`.

---

### `POST /api/monitoring/monitoring-services/generate`
**Description**: Génère un script de surveillance de services.

**Corps attendu (`req.body`)** :
```json
{
  "template_id": 1,
  "services": ["nginx", "ssh"],
  "cron_interval": "0 * * * *"
}
```
Exemple de test avec Postman :

Méthode : POST

URL : http://localhost:5000/api/monitoring/monitoring-services/generate

Headers : Content-Type: application/json, Authorization: Bearer <token>

Body (raw JSON) : (corps JSON ci-dessus)

Route protégée : JWT + permission `monitoringService.generate`.

---

### `POST /api/services/config-template`
**Description**: Génère un script de configuration depuis un template de service.

**Corps attendu (`req.body`)** :
```json
{
  "template_id": 1,
  "config_data": {
    "records": [
      { "name": "@", "type": "A", "value": "192.168.0.10" }
    ]
  }
}
```
Exemple de test avec Postman :

Méthode : POST

URL : http://localhost:5000/api/services/config-template

Headers : Content-Type: application/json, Authorization: Bearer <token>

Body (raw JSON) : (corps JSON ci-dessus)

Route protégée : JWT + permission `serviceConfig.configure`.

---

## Templates et conversion

### `POST /api/templates/create`
**Description**: Crée un nouveau template de configuration.

**Corps attendu (`req.body`)** :
```json
{
  "name": "Template BIND9",
  "service_type": "dns",
  "category": "reseau",
  "description": "Template de configuration DNS",
  "template_content": "#!/bin/bash\necho 'config'"
}
```
Exemple de test avec Postman :

Méthode : POST

URL : http://localhost:5000/api/templates/create

Headers : Content-Type: application/json, Authorization: Bearer <token>

Body (raw JSON) : (corps JSON ci-dessus)

Route protégée : JWT + permission `configTemplate.create`.

---

### `POST /api/convert-template/convert`
**Description**: Convertit une VM en template Cloud-Init via SSH.

**Corps attendu (`req.body`)** :
```json
{
  "vm_id": 100,
  "host": "192.168.0.20",
  "username": "root",
  "privateKeyPath": "/root/.ssh/id_rsa"
}
```
Exemple de test avec Postman :

Méthode : POST

URL : http://localhost:5000/api/convert-template/convert

Headers : Content-Type: application/json, Authorization: Bearer <token>

Body (raw JSON) : (corps JSON ci-dessus)

Route protégée : JWT + permission `template.convert`.

---

## Supervision

### `POST /api/supervision/fetch`
**Description**: Récupère les fichiers JSON de statut et services depuis une VM distante via SSH et les enregistre.

**Corps attendu (`req.body`)** :
```json
{
  "host": "192.168.0.20",
  "username": "root"
}
```
Exemple de test avec Postman :

Méthode : POST

URL : http://localhost:5000/api/supervision/fetch

Headers : Content-Type: application/json, Authorization: Bearer <token>

Body (raw JSON) : (corps JSON ci-dessus)

Route protégée : JWT + permission `supervision.fetch`.

---

### `POST /api/supervision/status`
**Description**: Sauvegarde un état de supervision envoyé manuellement.

**Corps attendu (`req.body`)** (exemple) :
```json
{
  "hostname": "dns01",
  "timestamp": "2025-01-01T10:00:00Z",
  "bind9_status": "running",
  "cpu_load": "0.2",
  "ram_usage": "512MB",
  "disk_usage": "2GB"
}
```
Exemple de test avec Postman :

Méthode : POST

URL : http://localhost:5000/api/supervision/status

Headers : Content-Type: application/json, Authorization: Bearer <token>

Body (raw JSON) : (corps JSON ci-dessus)

Route protégée : JWT + permission `supervision.save`.

---

### `POST /api/supervision/services`
**Description**: Enregistre un tableau de services surveillés.

**Corps attendu (`req.body`)** :
```json
{
  "hostname": "dns01",
  "timestamp": "2025-01-01T10:00:00Z",
  "services": [
    { "name": "bind9", "enabled": true, "active": true }
  ]
}
```
Exemple de test avec Postman :

Méthode : POST

URL : http://localhost:5000/api/supervision/services

Headers : Content-Type: application/json, Authorization: Bearer <token>

Body (raw JSON) : (corps JSON ci-dessus)

Route protégée : JWT + permission `supervision.save`.

---

### `GET /api/supervision/status`
**Description**: Retourne la liste des statuts de supervision enregistrés.

Exemple de test avec Postman :

Méthode : GET

URL : http://localhost:5000/api/supervision/status

Headers : Aucun (route publique)

---

### `GET /api/supervision/services`
**Description**: Retourne l'historique des statuts de services.

Exemple de test avec Postman :

Méthode : GET

URL : http://localhost:5000/api/supervision/services

Headers : Aucun (route publique)

---

## Route racine

### `GET /`
**Description**: Vérifie que l'API est opérationnelle.

Exemple de test avec Postman :

Méthode : GET

URL : http://localhost:5000/

Headers : Aucun

---

## Tableau récapitulatif

| Méthode | Endpoint | Description | Auth requise |
|--------|----------|-------------|--------------|
| POST | /api/auth/login | Connexion utilisateur | Non |
| POST | /api/auth/register | Création utilisateur | JWT + permission `auth.register` |
| POST | /api/auth/request-reset | Demande de réinitialisation | Non |
| POST | /api/auth/reset-password | Réinitialisation du mot de passe | Non |
| GET | /api/auth/with-reset-history | Historique de réinitialisation | JWT + permission `auth.reset.history` |
| GET | /api/users/ | Liste des utilisateurs | JWT + permission `users.read` |
| GET | /api/users/:id | Détails d'un utilisateur | JWT + permission `users.read` |
| PUT | /api/users/:id | Mise à jour utilisateur | JWT + permission `users.update` |
| DELETE | /api/users/:id | Désactivation utilisateur | JWT + permission `users.delete` |
| GET | (non monté) /api/user-logs/users/:id | Logs utilisateur | À compléter manuellement |
| GET | /api/permissions/ | Liste des permissions | JWT |
| POST | /api/permissions/ | Création permission | JWT + superadmin |
| POST | /api/permissions/assign | Attribution permissions | JWT + superadmin |
| GET | /api/permissions/role/:role_id | Permissions d'un rôle | JWT |
| GET | /api/user-roles/ | Liste des rôles | JWT + permission `roles.read` |
| POST | /api/user-roles/ | Création d'un rôle | JWT + permission `roles.create` |
| PUT | /api/user-roles/:id | Mise à jour d'un rôle | JWT + permission `roles.update` |
| DELETE | /api/user-roles/:id | Désactivation d'un rôle | JWT + permission `roles.delete` |
| GET | /api/settings/ | Récupération paramètres utilisateur | JWT + permission `userSettings.read` |
| PATCH | /api/settings/ | Mise à jour paramètres | JWT + permission `userSettings.update` |
| POST | /api/settings/ | Création paramètres | JWT + permission `userSettings.create` |
| POST | /api/vm/deploy-vm | Déploiement de VM | JWT + permission `vm.deploy` |
| POST | /api/vm/delete-vm | Suppression de VM | JWT + permission `vm.delete` |
| POST | /api/vm/check-vm-status | Vérification d'état VM | JWT + permission `vm.status` |
| POST | /api/vm/start | Démarrage VM | JWT + permission `vm.start` |
| POST | /api/vm/stop | Arrêt VM | JWT + permission `vm.stop` |
| POST | /api/init-scripts/generate | Génération script init | JWT + permission `initScript.generate` |
| POST | /api/monitoring/generate | Génération script monitoring | JWT + permission `monitoringScript.generate` |
| POST | /api/monitoring/monitoring-services/generate | Génération script services | JWT + permission `monitoringService.generate` |
| POST | /api/services/config-template | Génération script de configuration | JWT + permission `serviceConfig.configure` |
| POST | /api/templates/create | Création template | JWT + permission `configTemplate.create` |
| POST | /api/convert-template/convert | Conversion VM en template | JWT + permission `template.convert` |
| POST | /api/supervision/fetch | Import supervision via SSH | JWT + permission `supervision.fetch` |
| POST | /api/supervision/status | Sauvegarde statut supervision | JWT + permission `supervision.save` |
| POST | /api/supervision/services | Sauvegarde services supervision | JWT + permission `supervision.save` |
| GET | /api/supervision/status | Lecture statuts supervision | Non |
| GET | /api/supervision/services | Lecture statuts services | Non |
| GET | / | Vérification API | Non |

