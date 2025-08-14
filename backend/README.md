# Linusupervisor Backend

Node.js backend with Express and Sequelize providing user, role, and permission management secured by JWT authentication and verbose console logging.

## Monorepo structure

The repository uses **npm workspaces** to host both the backend API and the Next.js frontend.

```
.
├── app.js             # Express entry point
├── frontend/          # Next.js application
├── controllers/       # Express route handlers
├── services/          # Business logic separated from controllers
└── tests/             # Jest and supertest tests
```

Run scripts from the repository root so shared dependencies are reused by both applications.

## Prerequisites
- Node.js 18+
- MySQL server

## Setup
1. Install dependencies:
   ```bash
   npm install
   ```
2. Copy `.env.example` to `.env` and adjust values. Include SMTP settings for password reset emails.
3. Start the applications:
   ```bash
   npm run dev:backend   # API
   npm run dev:frontend  # Frontend
   ```

## Database schema
The SQL schema used by the backend is documented in [sql/schema.sql](sql/schema.sql). It defines tables for users, roles, permissions, deployments, and monitoring records.

### Manual SQL upgrade
For existing deployments, run the commands in [sql/add_logs_and_alerts.sql](sql/add_logs_and_alerts.sql) to add the `logs_status` column to `monitorings` and create the `alerts` table.


### Deployment flow

1. Build both apps from the root:
   ```bash
   npm --workspace . run build    # backend (if applicable)
   npm --workspace frontend run build
   ```
2. Deploy the `app.js` server with the built frontend served by your preferred web server or CDN.
3. Set environment variables documented below on the server.

### Environment variables

| Name | Description | Default |
|------|-------------|---------|
| `PORT` | Port HTTP du serveur | `3000` |
| `JWT_SECRET` | Clé pour signer les jetons JWT | _none_ |
| `DB_HOST`, `DB_PORT`, `DB_NAME`, `DB_USER`, `DB_PASS` | Paramètres de connexion base de données | _required_ |
| `CORS_ORIGINS` | Liste d'origines autorisées séparées par des virgules | `http://localhost:5173` |
| `SMTP_USER`, `SMTP_PASS` | Identifiants SMTP pour l'envoi de mails | _optional_ |
| `ALERT_CPU_THRESHOLD` | Seuil CPU pour déclencher une alerte (%) | `10` |
| `ALERT_RAM_THRESHOLD` | Seuil RAM pour déclencher une alerte (%) | `10` |
| `ALERT_FRESHNESS_MINUTES` | Âge max des métriques avant d'être considérées obsolètes | `5` |
| `ALERT_EMAIL_TO` | Destinataires email supplémentaires séparés par des virgules pour les nouvelles alertes | _optional_ |

Les alertes sont automatiquement envoyées à l'utilisateur connecté. `ALERT_EMAIL_TO` permet simplement d'ajouter des destinataires supplémentaires.

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

Templates include utilities for deploying web servers. For example, NGINX and Apache scripts automatically detect the VM's IP address and inject it into the generated homepage.

## Terraform Deployment
Use `POST /terraform/deploy` to launch a Terraform run that clones a template VM and executes initialization, configuration, monitoring, and service-detection scripts. Script paths are stored in the database and selected by ID at deployment time.
The base Terraform configuration lives in the `terraform/` directory (`main.tf`, `variables.tf`, `outputs.tf`). The backend copies these files for each run, generates a `variables.tfvars.json`, and executes `terraform init` and `terraform apply` inside a run-specific folder.

Use `GET /deployments/:id` to retrieve deployment metadata and the log contents generated during the run.

