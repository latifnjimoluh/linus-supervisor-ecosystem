-- Types ENUM
CREATE TYPE user_status_enum AS ENUM ('actif','inactif','blocked');
CREATE TYPE active_inactive_enum AS ENUM ('actif','inactif');
CREATE TYPE active_supprime_enum AS ENUM ('actif','supprime');

-- Roles​:codex-file-citation[codex-file-citation]{line_range_start=3 line_range_end=19 path=backend/models/role/Role.js git_url="https://github.com/latifnjimoluh/linusupervisor-back/blob/main/backend/models/role/Role.js#L3-L19"}​
CREATE TABLE roles (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) NOT NULL UNIQUE,
  description VARCHAR(255),
  status active_inactive_enum DEFAULT 'actif',
  created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

-- Permissions​:codex-file-citation[codex-file-citation]{line_range_start=3 line_range_end=23 path=backend/models/permission/Permission.js git_url="https://github.com/latifnjimoluh/linusupervisor-back/blob/main/backend/models/permission/Permission.js#L3-L23"}​
CREATE TABLE permissions (
  id SERIAL PRIMARY KEY,
  key VARCHAR(255) NOT NULL UNIQUE,
  name VARCHAR(255) NOT NULL,
  description VARCHAR(255),
  status active_inactive_enum DEFAULT 'actif',
  created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

-- Users​:codex-file-citation[codex-file-citation]{line_range_start=3 line_range_end=44 path=backend/models/user/User.js git_url="https://github.com/latifnjimoluh/linusupervisor-back/blob/main/backend/models/user/User.js#L3-L44"}​​:codex-file-citation[codex-file-citation]{line_range_start=49 line_range_end=53 path=backend/models/user/User.js git_url="https://github.com/latifnjimoluh/linusupervisor-back/blob/main/backend/models/user/User.js#L49-L53"}​
CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  role_id INTEGER REFERENCES roles(id),
  first_name VARCHAR(255) NOT NULL,
  last_name VARCHAR(255) NOT NULL,
  email VARCHAR(255) NOT NULL UNIQUE,
  phone VARCHAR(255),
  password VARCHAR(255) NOT NULL,
  status user_status_enum DEFAULT 'actif',
  reset_token VARCHAR(255),
  reset_expires_at TIMESTAMPTZ,
  last_password_reset_at TIMESTAMPTZ,
  two_factor_secret VARCHAR(255),
  two_factor_enabled BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

-- User settings​:codex-file-citation[codex-file-citation]{line_range_start=3 line_range_end=71 path=backend/models/settings/UserSetting.js git_url="https://github.com/latifnjimoluh/linusupervisor-back/blob/main/backend/models/settings/UserSetting.js#L3-L71"}​
CREATE TABLE user_settings (
  id SERIAL PRIMARY KEY,
  user_id INTEGER NOT NULL REFERENCES users(id),
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
  alert_cpu_threshold INTEGER,
  alert_ram_threshold INTEGER,
  created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

-- Assigned permissions​:codex-file-citation[codex-file-citation]{line_range_start=3 line_range_end=23 path=backend/models/permission/AssignedPermission.js git_url="https://github.com/latifnjimoluh/linusupervisor-back/blob/main/backend/models/permission/AssignedPermission.js#L3-L23"}​
CREATE TABLE assigned_permissions (
  role_id INTEGER NOT NULL REFERENCES roles(id),
  permission_id INTEGER NOT NULL REFERENCES permissions(id),
  PRIMARY KEY (role_id, permission_id)
);

-- AI cache​:codex-file-citation[codex-file-citation]{line_range_start=3 line_range_end=31 path=backend/models/ai/AiCache.js git_url="https://github.com/latifnjimoluh/linusupervisor-back/blob/main/backend/models/ai/AiCache.js#L3-L31"}​
CREATE TABLE ai_cache (
  id SERIAL PRIMARY KEY,
  type VARCHAR(255) NOT NULL,
  hash VARCHAR(255) NOT NULL UNIQUE,
  input_text TEXT NOT NULL,
  response_text TEXT NOT NULL,
  entity_type VARCHAR(255),
  entity_id INTEGER,
  created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

-- Alerts​:codex-file-citation[codex-file-citation]{line_range_start=5 line_range_end=28 path=backend/models/alert/Alert.js git_url="https://github.com/latifnjimoluh/linusupervisor-back/blob/main/backend/models/alert/Alert.js#L5-L28"}​
CREATE TABLE alerts (
  id SERIAL PRIMARY KEY,
  server VARCHAR(255),
  service VARCHAR(255),
  severity VARCHAR(255),
  status VARCHAR(255) DEFAULT 'en_cours',
  description VARCHAR(255),
  comment TEXT,
  started_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
  created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

-- Service templates​:codex-file-citation[codex-file-citation]{line_range_start=3 line_range_end=48 path=backend/models/templates/ServiceTemplate.js git_url="https://github.com/latifnjimoluh/linusupervisor-back/blob/main/backend/models/templates/ServiceTemplate.js#L3-L48"}​
CREATE TABLE service_templates (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) NOT NULL UNIQUE,
  service_type VARCHAR(255) NOT NULL,
  category VARCHAR(255) NOT NULL,
  description TEXT,
  template_content TEXT NOT NULL,
  abs_path VARCHAR(255),
  script_path VARCHAR(255),
  fields_schema JSON,
  status active_supprime_enum DEFAULT 'actif',
  created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
  deleted_at TIMESTAMPTZ
);

-- Generated scripts​:codex-file-citation[codex-file-citation]{line_range_start=2 line_range_end=38 path=backend/models/scripts/GeneratedScript.js git_url="https://github.com/latifnjimoluh/linusupervisor-back/blob/main/backend/models/scripts/GeneratedScript.js#L2-L38"}​​:codex-file-citation[codex-file-citation]{line_range_start=40 line_range_end=44 path=backend/models/scripts/GeneratedScript.js git_url="https://github.com/latifnjimoluh/linusupervisor-back/blob/main/backend/models/scripts/GeneratedScript.js#L40-L44"}​
CREATE TABLE generated_scripts (
  id SERIAL PRIMARY KEY,
  template_id INTEGER NOT NULL REFERENCES service_templates(id),
  category VARCHAR(255) NOT NULL,
  service_type VARCHAR(255) NOT NULL,
  abs_path VARCHAR(255),
  script_path VARCHAR(255) NOT NULL,
  description TEXT,
  status active_supprime_enum DEFAULT 'actif',
  created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

-- Deployments​:codex-file-citation[codex-file-citation]{line_range_start=2 line_range_end=24 path=backend/models/deployment/Deployment.js git_url="https://github.com/latifnjimoluh/linusupervisor-back/blob/main/backend/models/deployment/Deployment.js#L2-L24"}​
CREATE TABLE deployments (
  id SERIAL PRIMARY KEY,
  user_id INTEGER NOT NULL REFERENCES users(id),
  user_email VARCHAR(255),
  vm_name VARCHAR(255),
  service_name VARCHAR(255),
  zone VARCHAR(255),
  operation_type VARCHAR(255),
  started_at TIMESTAMPTZ,
  ended_at TIMESTAMPTZ,
  duration VARCHAR(255),
  success BOOLEAN,
  log_path VARCHAR(255),
  vm_id VARCHAR(255),
  vm_ip VARCHAR(255),
  vm_username VARCHAR(255),
  instance_id VARCHAR(255),
  injected_files JSON,
  vm_specs JSON,
  status VARCHAR(255),
  created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

-- Deletes​:codex-file-citation[codex-file-citation]{line_range_start=2 line_range_end=14 path=backend/models/delete/Delete.js git_url="https://github.com/latifnjimoluh/linusupervisor-back/blob/main/backend/models/delete/Delete.js#L2-L14"}​
CREATE TABLE deletes (
  id SERIAL PRIMARY KEY,
  vm_id VARCHAR(255) NOT NULL,
  instance_id VARCHAR(255),
  vm_name VARCHAR(255),
  vm_ip VARCHAR(255),
  log_path VARCHAR(255),
  user_id INTEGER REFERENCES users(id),
  user_email VARCHAR(255),
  deleted_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

-- Logs (log action)​:codex-file-citation[codex-file-citation]{line_range_start=3 line_range_end=29 path=backend/models/log/Log.js git_url="https://github.com/latifnjimoluh/linusupervisor-back/blob/main/backend/models/log/Log.js#L3-L29"}​
CREATE TABLE logs (
  id SERIAL PRIMARY KEY,
  user_id INTEGER REFERENCES users(id),
  action VARCHAR(255) NOT NULL,
  details TEXT,
  host VARCHAR(255),
  level VARCHAR(255),
  source VARCHAR(255),
  created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

-- Monitorings​:codex-file-citation[codex-file-citation]{line_range_start=5 line_range_end=35 path=backend/models/monitoring/Monitoring.js git_url="https://github.com/latifnjimoluh/linusupervisor-back/blob/main/backend/models/monitoring/Monitoring.js#L5-L35"}​
CREATE TABLE monitorings (
  id SERIAL PRIMARY KEY,
  vm_ip VARCHAR(255),
  ip_address VARCHAR(255),
  instance_id VARCHAR(255),
  services_status JSONB,
  system_status JSONB,
  logs_status JSONB,
  retrieved_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
  created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

-- Converted VMs​:codex-file-citation[codex-file-citation]{line_range_start=2 line_range_end=18 path=backend/models/proxmox/ConvertedVm.js git_url="https://github.com/latifnjimoluh/linusupervisor-back/blob/main/backend/models/proxmox/ConvertedVm.js#L2-L18"}​
CREATE TABLE converted_vms (
  id SERIAL PRIMARY KEY,
  vm_name VARCHAR(255) NOT NULL,
  vm_id VARCHAR(255) NOT NULL,
  user_id INTEGER NOT NULL REFERENCES users(id),
  created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

-- Refresh tokens​:codex-file-citation[codex-file-citation]{line_range_start=2 line_range_end=31 path=backend/models/token/RefreshToken.js git_url="https://github.com/latifnjimoluh/linusupervisor-back/blob/main/backend/models/token/RefreshToken.js#L2-L31"}​
CREATE TABLE refresh_tokens (
  jti UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id INTEGER NOT NULL REFERENCES users(id),
  device_id VARCHAR(255) NOT NULL,
  revoked BOOLEAN DEFAULT FALSE,
  expires_at TIMESTAMPTZ NOT NULL
);
