-- this table does not need distinct and conflict as ive manually done the csv for it
INSERT INTO dim_city (city_id, name, population, country)
SELECT
    id AS city_id,
    city AS name,
    population,
    country
FROM worldcities
ON CONFLICT(city_id)
DO UPDATE SET
    name = excluded.name,
    population = excluded.population,
    country = excluded.country;
