-- Table to store reusable script templates for monitoring generation
CREATE TABLE IF NOT EXISTS script_templates (
  id SERIAL PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  service_type VARCHAR(50) NOT NULL,
  template_path TEXT NOT NULL,
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);

