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

INSERT INTO dwreporting.dim_country (name, continent_id, subregion_id, population, code, capital, tree_cover, grassland, wetland, shrubland, sparse_vegetation, cropland, artificial_surfaces, bare_area, inland_water)
SELECT
    Country_Territory AS name,
    get_continent_id(Continent) AS continent_id,
    get_subregion_id(New_Subregion) AS subregion_id,
    Population AS population,
    Code AS code,
    Capital AS capital,
    tree_cover,
    grassland,
    wetland,
    shrubland,
    sparse_vegetation,
    cropland,
    artificial_surfaces,
    bare_area,
    inland_water
FROM countries
ON CONFLICT(name) DO UPDATE
SET
    continent_id = excluded.continent_id,
    subregion_id = excluded.subregion_id,
    population = excluded.population,
    code = excluded.code,
    capital = excluded.capital,
    tree_cover = excluded.tree_cover,
    grassland = excluded.grassland,
    wetland = excluded.wetland,
    shrubland = excluded.shrubland,
    sparse_vegetation = excluded.sparse_vegetation,
    cropland = excluded.cropland,
    artificial_surfaces = excluded.artificial_surfaces,
    bare_area = excluded.bare_area,
    inland_water = excluded.inland_water;
