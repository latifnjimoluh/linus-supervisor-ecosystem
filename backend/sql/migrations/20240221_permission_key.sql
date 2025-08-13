ALTER TABLE permissions RENAME COLUMN name TO key;
ALTER TABLE permissions ADD COLUMN name VARCHAR(255) NOT NULL DEFAULT '';
UPDATE permissions SET name = key;
ALTER TABLE permissions ALTER COLUMN name DROP DEFAULT;
ALTER TABLE permissions DROP CONSTRAINT IF EXISTS permissions_name_key;
ALTER TABLE permissions ADD CONSTRAINT permissions_key_key UNIQUE (key);
