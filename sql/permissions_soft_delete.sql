-- Add a status column to manage soft deletes for permissions
ALTER TABLE permissions
  ADD COLUMN IF NOT EXISTS status VARCHAR(10) DEFAULT 'actif';

-- Existing records can be initialized as active
UPDATE permissions SET status = 'actif' WHERE status IS NULL;
