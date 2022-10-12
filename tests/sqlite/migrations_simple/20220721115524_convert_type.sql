-- Perform a tricky conversion of the payload.
--
-- This script will only succeed once and will fail if executed twice.

-- set up temporary target column
ALTER TABLE migrations_simple_test
ADD some_payload_tmp TEXT;

-- perform conversion
-- This will fail if `some_payload` is already a string column due to the addition.
-- We add a suffix after the addition to ensure that the SQL database does not silently cast the string back to an 
-- integer.
UPDATE migrations_simple_test
SET some_payload_tmp = CAST((some_payload + 10) AS TEXT) || '_suffix';

-- remove original column including the content
ALTER TABLE migrations_simple_test
DROP COLUMN some_payload;

-- prepare new payload column (nullable, so we can copy over the data)
ALTER TABLE migrations_simple_test
ADD some_payload TEXT;

-- copy new values
UPDATE migrations_simple_test
SET some_payload = some_payload_tmp;

-- clean up
ALTER TABLE migrations_simple_test
DROP COLUMN some_payload_tmp;
