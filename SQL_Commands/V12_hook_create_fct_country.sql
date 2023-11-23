-- insert lal population

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

INSERT INTO dwreporting.fct_country_details (
    subregion_id,
    country_id,
    year,
    population,
    perc_malnourishment,
    GDP_per_year,
    perc_pop_without_water,
    avg_temp,
    tree_cover,
    grassland,
    wetland,
    shrubland,
    sparse_vegetation,
    cropland,
    artificial_surfaces,
    bare_area,
    inland_water
)
SELECT
    get_subregion_id(dsr.name) AS subregion_id,
    get_country_id(pou.Entity) AS country_id,
    pou.Year AS year,
    pou.Prevalence_of_undernourishment_percentage_of_population AS perc_malnourishment,
    gdp.Value AS GDP_per_year,
    avg_temp.AvgTemperature AS avg_temp,
    vcd.Tree_cover,
    vcd.Grassland,
    vcd.Wetland,
    vcd.Shrubland,
    vcd.Sparse_vegetation,
    vcd.Cropland,
    vcd.Artificial_surfaces,
    vcd.Bare_area,
    vcd.Inlandwater
FROM
    prevalence_of_undernourishment pou
JOIN
    dwreporting.fct_subregion ON pou.Entity = dwreporting.fct_subregion.name AND pou.Year = dwreporting.fct_subregion.year
JOIN
    gdp ON pou.Entity = gdp.Country_or_Area AND pou.Year = gdp.Year
JOIN
    avg_temperature avg_temp ON pou.Entity = avg_temp.Country AND pou.Year = avg_temp.Year
JOIN
    valuable_country_data vcd ON pou.Entity = vcd.Country
WHERE
    pou.Year BETWEEN 2001 AND 2019
    AND (pou.Code IS NOT NULL AND pou.Code <> '')
    AND (vcd.Code IS NOT NULL AND vcd.Code <> '');
ON CONFLICT (subregion_id, country_id, year) DO UPDATE
    SET
        population = EXCLUDED.population,
        perc_malnourishment = EXCLUDED.perc_malnourishment,
        GDP_per_year = EXCLUDED.GDP_per_year,
        perc_pop_without_water = EXCLUDED.perc_pop_without_water,
        avg_temp = EXCLUDED.avg_temp,
        tree_cover = EXCLUDED.tree_cover,
        grassland = EXCLUDED.grassland,
        wetland = EXCLUDED.wetland,
        shrubland = EXCLUDED.shrubland,
        sparse_vegetation = EXCLUDED.sparse_vegetation,
        cropland = EXCLUDED.cropland,
        artificial_surfaces = EXCLUDED.artificial_surfaces,
        bare_area = EXCLUDED.bare_area,
        inland_water = EXCLUDED.inland_water;