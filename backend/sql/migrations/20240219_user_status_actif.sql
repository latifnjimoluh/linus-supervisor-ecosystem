-- Normalize user status to French labels
ALTER TYPE enum_users_status RENAME VALUE 'active' TO 'actif';
ALTER TABLE users ALTER COLUMN status SET DEFAULT 'actif';
