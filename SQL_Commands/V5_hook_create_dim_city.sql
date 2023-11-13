INSERT INTO dim_city (name, population, country)
SELECT
    city_ascii AS name,
    population,
    country
FROM worldcities
ON CONFLICT(name)
DO UPDATE SET
    name = excluded.name,
    population = excluded.population,
    country = excluded.country;
