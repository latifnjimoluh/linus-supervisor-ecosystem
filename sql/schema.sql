-- SQL schema for linusupervisor-back
-- Creates tables for roles, permissions, users, settings, logs, and Proxmox tracking

CREATE TABLE roles (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) UNIQUE NOT NULL,
  status VARCHAR(10) NOT NULL DEFAULT 'actif',
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE permissions (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) UNIQUE NOT NULL,
  description VARCHAR(255),
  status VARCHAR(10) NOT NULL DEFAULT 'actif',
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE assigned_permissions (
  role_id INTEGER NOT NULL REFERENCES roles(id) ON DELETE CASCADE,
  permission_id INTEGER NOT NULL REFERENCES permissions(id) ON DELETE CASCADE,
  PRIMARY KEY (role_id, permission_id)
);

CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  first_name VARCHAR(255) NOT NULL,
  last_name VARCHAR(255) NOT NULL,
  email VARCHAR(255) UNIQUE NOT NULL,
  phone VARCHAR(255),
  password VARCHAR(255) NOT NULL,
  status VARCHAR(10) DEFAULT 'active',
  reset_token VARCHAR(255),
  reset_expires_at TIMESTAMPTZ,
  last_password_reset_at TIMESTAMPTZ,
  role_id INTEGER REFERENCES roles(id),
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE user_settings (
  id SERIAL PRIMARY KEY,
  user_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  cloudinit_user VARCHAR(255),
  cloudinit_password VARCHAR(255),
  proxmox_api_url VARCHAR(255),
  proxmox_api_token_id VARCHAR(255),
  proxmox_api_token_name VARCHAR(255),
  proxmox_api_token_secret VARCHAR(255),
  pm_user VARCHAR(255),
  pm_password VARCHAR(255),
  proxmox_node VARCHAR(255),
  vm_storage VARCHAR(255),
  vm_bridge VARCHAR(255),
  ssh_public_key_path VARCHAR(255),
  ssh_private_key_path VARCHAR(255),
  statuspath VARCHAR(255),
  servicespath VARCHAR(255),
  instanceinfopath VARCHAR(255),
  proxmox_host VARCHAR(255),
  proxmox_ssh_user VARCHAR(255),
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE converted_vms (
  id SERIAL PRIMARY KEY,
  vm_name VARCHAR(255) NOT NULL,
  vm_id VARCHAR(255) NOT NULL,
  user_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE logs (
  id SERIAL PRIMARY KEY,
  user_id INTEGER REFERENCES users(id) ON DELETE SET NULL,
  action VARCHAR(255) NOT NULL,
  details TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE service_templates (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  service_type VARCHAR(255) NOT NULL,
  category VARCHAR(255) NOT NULL,
  description TEXT,
  template_content TEXT NOT NULL,
  script_path VARCHAR(255),
  fields_schema JSON,
  status VARCHAR(10) NOT NULL DEFAULT 'actif',
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE initialization_scripts (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  script_path VARCHAR(255) NOT NULL,
  description TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE monitoring_scripts (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  script_path VARCHAR(255) NOT NULL,
  description TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE monitored_services (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  script_path VARCHAR(255) NOT NULL,
  description TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE deployments (
  id SERIAL PRIMARY KEY,
  user_id INTEGER REFERENCES users(id) ON DELETE SET NULL,
  user_email VARCHAR(255),
  vm_name VARCHAR(255),
  service_name VARCHAR(255),
  zone VARCHAR(50),
  operation_type VARCHAR(50),
  started_at TIMESTAMPTZ,
  ended_at TIMESTAMPTZ,
  duration VARCHAR(50),
  success BOOLEAN,
  log_path VARCHAR(255),
  vm_id VARCHAR(255),
  vm_ip VARCHAR(255),
  instance_id VARCHAR(255),
  injected_files JSON,
  vm_specs JSON,
  status VARCHAR(50),
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE deletes (
  id SERIAL PRIMARY KEY,
  vm_id VARCHAR(255) NOT NULL,
  instance_id VARCHAR(255),
  vm_name VARCHAR(255),
  vm_ip VARCHAR(255),
  log_path VARCHAR(255),
  user_id INTEGER REFERENCES users(id) ON DELETE SET NULL,
  user_email VARCHAR(255),
  deleted_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE monitorings (
  id SERIAL PRIMARY KEY,
  vm_ip VARCHAR(255),
  ip_address VARCHAR(255),
  instance_id VARCHAR(255),
  services_status JSON,
  system_status JSON,
  retrieved_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE "GeneratedScripts" (
  "id" SERIAL PRIMARY KEY,
  "template_id" INTEGER NOT NULL REFERENCES "ServiceTemplates"(id) ON DELETE CASCADE,
  "category" VARCHAR(255) NOT NULL,
  "service_type" VARCHAR(255) NOT NULL,
  "script_path" TEXT NOT NULL,
  "description" TEXT,
  "created_at" TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
  "updated_at" TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);


-- Sample data
INSERT INTO roles (name, status) VALUES ('admin', 'actif');

INSERT INTO permissions (name, description, status) VALUES
  ('auth.reset-history', 'View password reset history', 'actif'),
  ('deployment.run', 'Run deployments', 'actif'),
  ('log.list', 'List logs', 'actif'),
  ('permission.assign', 'Assign permission to roles', 'actif'),
  ('permission.byRole', 'List permissions by role', 'actif'),
  ('permission.create', 'Create permission', 'actif'),
  ('permission.delete', 'Delete permission', 'actif'),
  ('permission.list', 'List permissions', 'actif'),
  ('permission.read', 'Read permission', 'actif'),
  ('permission.unassign', 'Unassign permission from role', 'actif'),
  ('permission.update', 'Update permission', 'actif'),
  ('role.create', 'Create role', 'actif'),
  ('role.delete', 'Delete role', 'actif'),
  ('role.list', 'List roles', 'actif'),
  ('role.read', 'Read role', 'actif'),
  ('role.update', 'Update role', 'actif'),
  ('settings.create', 'Create settings', 'actif'),
  ('settings.get', 'Get settings', 'actif'),
  ('settings.list', 'List settings', 'actif'),
  ('settings.update', 'Update settings', 'actif'),
  ('template.create', 'Create template', 'actif'),
  ('template.delete', 'Delete template', 'actif'),
  ('template.generate', 'Generate template script', 'actif'),
  ('template.list', 'List templates', 'actif'),
  ('template.read', 'Read template', 'actif'),
  ('template.update', 'Update template', 'actif'),
  ('user.create', 'Create user', 'actif'),
  ('user.delete', 'Delete user', 'actif'),
  ('user.list', 'List users', 'actif'),
  ('user.read', 'Read user', 'actif'),
  ('user.search', 'Search users', 'actif'),
  ('user.update', 'Update user', 'actif'),
  ('monitoring.collect', 'Collect monitoring data', 'actif'),
  ('monitoring.list', 'List monitoring records', 'actif'),
  ('monitoring.read', 'Read monitoring record', 'actif'),
  ('monitoring.sync', 'Synchronize deployment IP', 'actif'),
  ('vm.conversion.list', 'List VM conversions', 'actif'),
  ('vm.convert', 'Convert VM to template', 'actif'),
  ('vm.list', 'List VMs', 'actif'),
  ('vm.start', 'Start VM', 'actif'),
  ('vm.status.check', 'Check VM status', 'actif'),
  ('vm.stop', 'Stop VM', 'actif'),
  ('vm.delete', 'Delete VM', 'actif');

INSERT INTO assigned_permissions (role_id, permission_id)
SELECT 1, id FROM permissions;

INSERT INTO users (first_name, last_name, email, phone, password, status, role_id) VALUES
  ('Nexus', 'Latif', 'latifnjimoluh@gmail.com', '555-0100', 'admin123.', 'active', 1);

INSERT INTO user_settings (user_id) VALUES (1);

INSERT INTO converted_vms (vm_name, vm_id, user_id) VALUES ('vm1', '101', 1);

INSERT INTO logs (user_id, action, details) VALUES (1, 'login', 'User logged in');

INSERT INTO service_templates (name, service_type, category, description, template_content, script_path, fields_schema, status)
VALUES (
  'Nginx Basic',
  'web',
  'default',
  'Deploys a hardened Nginx server',
  '{"packages":["nginx"],"config":"/etc/nginx/nginx.conf"}',
  'scripts/service.sh',
  '{"domain":"string","root":"string"}',
  'actif'
);

INSERT INTO initialization_scripts (name, script_path, description)
VALUES ('Ubuntu Base Setup', 'scripts/init.sh', 'Update packages and install base utilities');

INSERT INTO monitoring_scripts (name, script_path, description)
VALUES ('System Metrics Monitor', 'scripts/monitor.sh', 'Collect CPU, memory, disk and network metrics');

INSERT INTO monitored_services (name, script_path, description)
VALUES ('Nginx Provisioning', 'scripts/service.sh', 'Configure Nginx and record service states');

INSERT INTO deployments (user_id, user_email, vm_name, service_name, zone, operation_type, success, instance_id)
VALUES (1, 'latifnjimoluh@gmail.com', 'vm1', 'service1', 'LAN', 'create', true, 'inst-0001');

