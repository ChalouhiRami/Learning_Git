CREATE OR REPLACE FUNCTION get_continent_id(continent_name VARCHAR)
RETURNS INT
AS $$
DECLARE
    continent_id INT;
BEGIN
    SELECT id INTO continent_id
    FROM dwreporting.dim_continent
    WHERE name = continent_name;

    RETURN continent_id;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION get_subregion_id(subregion_name VARCHAR)
RETURNS INT
AS $$
DECLARE
    subregion_id INT;
BEGIN
    SELECT id INTO subregion_id
    FROM dwreporting.dim_subregion
    WHERE name = subregion_name;

    RETURN subregion_id;
END;
$$ LANGUAGE plpgsql;

INSERT INTO dwreporting.dim_country (name, population, code, capital, continent_id, subregion_id)
SELECT
    Country_Territory AS name,
    Population AS population,
    Code AS code,
    Capital AS capital,
    get_continent_id(Continent) AS continent_id,
    get_subregion_id(New_Subregion) AS subregion_id
FROM countries
ON CONFLICT(name) DO UPDATE
SET
    population = excluded.population,
    code = excluded.code,
    capital = excluded.capital,
    continent_id = excluded.continent_id,
    subregion_id = excluded.subregion_id;