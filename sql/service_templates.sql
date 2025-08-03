-- Table storing generated service configuration scripts
CREATE TABLE IF NOT EXISTS service_templates (
  id SERIAL PRIMARY KEY,
  service_type VARCHAR(100) NOT NULL,
  config_data JSONB NOT NULL,
  script_path TEXT NOT NULL,
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);
