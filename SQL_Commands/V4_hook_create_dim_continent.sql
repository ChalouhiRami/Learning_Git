INSERT INTO dwreporting.dim_continent (name)
SELECT DISTINCT continent FROM continents
ON CONFLICT(name) DO UPDATE
SET name = excluded.name;