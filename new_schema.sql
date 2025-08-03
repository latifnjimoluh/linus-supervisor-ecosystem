CREATE TABLE assigned_permissions (
  id SERIAL PRIMARY KEY,
  role_id INTEGER REFERENCES roles(id),
  permission_id INTEGER REFERENCES permissions(id),
  created_at TIMESTAMP WITH TIME ZONE NOT NULL,
  updated_at TIMESTAMP WITH TIME ZONE NOT NULL,
  UNIQUE (role_id, permission_id)
);

CREATE TABLE initialization_scripts (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  script_path VARCHAR(255) NOT NULL,
  service_type VARCHAR(255) NOT NULL,
  description TEXT,
  created_at TIMESTAMP WITH TIME ZONE NOT NULL,
  updated_at TIMESTAMP WITH TIME ZONE NOT NULL
);

CREATE TABLE monitored_services (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  service_type VARCHAR(255) NOT NULL,
  config_data JSONB,
  script_path TEXT NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE NOT NULL,
  updated_at TIMESTAMP WITH TIME ZONE NOT NULL
);

CREATE TABLE service_templates (
  id SERIAL PRIMARY KEY,
  service_type VARCHAR(255) NOT NULL,
  config_data JSONB NOT NULL,
  script_path TEXT NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE NOT NULL,
  updated_at TIMESTAMP WITH TIME ZONE NOT NULL
);

CREATE TABLE script_templates (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  service_type VARCHAR(255) NOT NULL,
  template_path TEXT NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE NOT NULL,
  updated_at TIMESTAMP WITH TIME ZONE NOT NULL
);

CREATE TABLE user_activity_logs (
  id UUID PRIMARY KEY,
  user_id INTEGER NOT NULL REFERENCES users(id),
  action VARCHAR(255) NOT NULL,
  details TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);
