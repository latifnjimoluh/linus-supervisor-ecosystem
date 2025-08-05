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

