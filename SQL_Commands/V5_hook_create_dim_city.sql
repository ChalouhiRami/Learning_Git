-- Define the get_country_id function
CREATE OR REPLACE FUNCTION get_country_id(country_name VARCHAR)
RETURNS INT
AS $$
DECLARE
    country_id INT;
BEGIN
    SELECT id INTO country_id
    FROM dim_country
    WHERE name = country_name;

    RETURN country_id;
END;
$$ LANGUAGE plpgsql;

-- Insert into dim_city using the get_country_id function
INSERT INTO dim_city (name, population, country_id)
SELECT
    city AS name,
    population,
    get_country_id(country) AS country_id
FROM worldcities
ON CONFLICT(name)
DO UPDATE SET
    name = excluded.name,
    population = excluded.population,
    country_id = excluded.country_id;
