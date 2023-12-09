INSERT INTO dwreporting.dim_continent (name)
SELECT DISTINCT continent FROM stg_continents_manual
ON CONFLICT(name) DO UPDATE
SET name = excluded.name;