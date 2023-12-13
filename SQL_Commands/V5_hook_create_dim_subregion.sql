INSERT INTO dwreporting.dim_subregion (name)
SELECT DISTINCT name FROM dwreporting.subregions
ON CONFLICT(name) DO UPDATE
SET name = excluded.name;