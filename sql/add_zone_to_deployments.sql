ALTER TABLE deployments
    ADD COLUMN IF NOT EXISTS zone VARCHAR(3) NOT NULL DEFAULT 'LAN';

UPDATE deployments
    SET zone = 'LAN'
    WHERE zone IS NULL;
