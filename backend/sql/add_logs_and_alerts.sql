-- Adds logs_status column to monitorings and creates alerts table
ALTER TABLE IF EXISTS monitorings
    ADD COLUMN IF NOT EXISTS logs_status json;

CREATE TABLE IF NOT EXISTS alerts (
    id SERIAL PRIMARY KEY,
    server VARCHAR(255),
    service VARCHAR(255),
    severity VARCHAR(50),
    status VARCHAR(50) DEFAULT 'en_cours',
    description VARCHAR(255),
    comment TEXT,
    started_at TIMESTAMPTZ DEFAULT now(),
    created_at TIMESTAMPTZ DEFAULT now() NOT NULL,
    updated_at TIMESTAMPTZ DEFAULT now() NOT NULL
);
