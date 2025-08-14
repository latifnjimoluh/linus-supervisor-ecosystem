ALTER TABLE users
  ADD COLUMN two_factor_secret VARCHAR(255),
  ADD COLUMN two_factor_enabled BOOLEAN DEFAULT FALSE;
