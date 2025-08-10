# Linusupervisor

Monorepo containing the Linusupervisor backend API and Next.js frontend.

## Projects
- **backend/** – Express + Sequelize API
- **frontend/** – Next.js dashboard

## Setup
Install dependencies and run both apps in development:
```bash
npm install
npm run dev:backend
npm run dev:frontend
```

Backend environment variables and database schema are documented in [backend/README.md](backend/README.md). The SQL schema is available under [backend/sql/schema.sql](backend/sql/schema.sql).

The frontend setup and usage are described in [frontend/README.md](frontend/README.md).
