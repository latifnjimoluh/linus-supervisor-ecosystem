-- SQL table for caching AI responses
CREATE TABLE ai_cache (
  id SERIAL PRIMARY KEY,
  type VARCHAR(255) NOT NULL,
  hash VARCHAR(64) NOT NULL UNIQUE,
  input_text TEXT NOT NULL,
  response_text TEXT NOT NULL,
  entity_type VARCHAR(255),
  entity_id INTEGER,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
