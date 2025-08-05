# Linusupervisor Backend

Node.js backend with Express and Sequelize providing user, role, and permission management secured by JWT authentication and verbose console logging.

## Prerequisites
- Node.js 18+
- MySQL server

## Setup
1. Install dependencies:
   ```bash
   npm install
   ```
2. Copy `.env.example` to `.env` and adjust values. Include SMTP settings for password reset emails.
3. Start the server:
   ```bash
   node app.js
   ```

## Testing with Postman
A Postman collection is available in `postman_collection.json`. Import it and set the `baseUrl` and `token` variables. Login to obtain a token before accessing protected routes.

## API Documentation
See [docs/API.md](docs/API.md) for the list of available endpoints.

## Logging
All authenticated requests are automatically recorded in the `logs` table. Retrieve them via `GET /logs`.

## Permissions
Routes verify a specific permission string such as `user.list` or `vm.start`. Permissions are stored in the database and linked to roles, keeping authorization fully dynamic.

## Password Reset
Users can request a reset code via `POST /auth/request-reset` and submit a new password with `POST /auth/reset-password`.

## User Settings
Each user can manage their own infrastructure parameters through `/settings/me` endpoints. Superadmins may review all user settings via `GET /settings`.

## Proxmox VM Management
VM operations use the credentials stored in user settings. Available endpoints include:
- `GET /vms` – list VMs from the Proxmox cluster
- `POST /vms/:vmId/start` – start a VM
- `POST /vms/:vmId/stop` – stop a VM
- `POST /vms/check-status` – check VM status and ping reachability
- `POST /vms/convert` – convert a VM to a reusable template
- `GET /vms/conversions` – view template conversion history

## Service Templates
Define reusable service deployment templates. Each template stores its form schema as JSON so the frontend can generate dynamic inputs.
- `GET /templates` – list templates
- `POST /templates` – create a new template
- `GET /templates/:id` – retrieve a template
- `PUT /templates/:id` – update a template
- `DELETE /templates/:id` – deactivate a template
- `POST /templates/generate` – generate a script from stored template content

## Terraform Deployment
Use `POST /terraform/deploy` to launch a Terraform run that clones a template VM and executes initialization, configuration, monitoring, and service-detection scripts. Script paths are stored in the database and selected by ID at deployment time.
The base Terraform configuration lives in the `terraform/` directory (`main.tf`, `variables.tf`, `outputs.tf`). The backend copies these files for each run, generates a `variables.tfvars.json`, and executes `terraform init` and `terraform apply` inside a run-specific folder.

