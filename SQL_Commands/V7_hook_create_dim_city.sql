-- Define the get_country_id function
CREATE OR REPLACE FUNCTION get_country_id(country_name VARCHAR)
RETURNS INT
AS $$
DECLARE
    country_id INT;
BEGIN
    SELECT id INTO country_id
    FROM dwreporting.dim_country
    WHERE name = country_name;

    RETURN country_id;
END;
$$ LANGUAGE plpgsql;

INSERT INTO dwreporting.dim_city (name, population, country_id)
SELECT
    city AS name,
    population,
    get_country_id(country) AS country_id
FROM worldcities
ON CONFLICT(name) DO UPDATE
SET
    population = excluded.population,
    country_id = excluded.country_id;
