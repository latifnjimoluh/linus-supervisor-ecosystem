# API Documentation

All routes except `POST /auth/login` require a Bearer token obtained from the login endpoint.

## Auth
- `POST /auth/login` – authenticate a user and receive a JWT
- `POST /auth/register` – create a new user (requires token)
- `POST /auth/request-reset` – send a password reset code to user email
- `POST /auth/reset-password` – reset password using the provided code
- `GET /auth/reset-history` – list users with recent password resets

## Users
- `GET /users` – list users with pagination and filters
- `GET /users/:id` – retrieve a single user
- `POST /users` – create a user
- `PUT /users/:id` – replace a user
- `PATCH /users/:id` – update fields of a user
- `DELETE /users/:id` – soft delete a user
- `GET /users/search` – search users by query string

## Roles
- `GET /roles` – list roles
- `GET /roles/:id` – retrieve a role
- `POST /roles` – create a role
- `PUT /roles/:id` – update a role
- `DELETE /roles/:id` – deactivate a role

## Permissions
- `GET /permissions` – list permissions
- `GET /permissions/:id` – retrieve a permission
- `POST /permissions` – create permissions (single or batch)
- `PUT /permissions/:id` – update a permission
- `DELETE /permissions/:id` – deactivate a permission
- `POST /permissions/assign` – assign permissions to roles
- `POST /permissions/unassign` – remove permissions from roles
- `GET /permissions/role/:role_id` – list permissions for a role

## Logs
- `GET /logs` – list system logs with pagination and search

## User Settings
- `GET /settings/me` – retrieve settings for the authenticated user
- `POST /settings/me` – create settings for the authenticated user
- `PUT /settings/me` – update settings for the authenticated user
- `GET /settings` – list all user settings (superadmin only)

## Proxmox VMs
- `GET /vms` – list VMs from the configured Proxmox cluster
- `POST /vms/:vmId/start` – start a VM by ID
- `POST /vms/:vmId/stop` – stop a VM by ID
- `POST /vms/check-status` – check VM power state and ping reachability
- `POST /vms/convert` – convert a VM to a template (Cloud-Init)
- `GET /vms/conversions` – list VM template conversion history
