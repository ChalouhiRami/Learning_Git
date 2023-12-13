CREATE OR REPLACE FUNCTION get_population_by_region(region_name VARCHAR)
RETURNS BIGINT
AS $$
DECLARE
    total_population BIGINT;
BEGIN
    SELECT COALESCE(SUM(population), 0) INTO total_population
    FROM dwreporting.world_population_results
    WHERE country_name = region_name;

    RETURN total_population;
END;
$$ LANGUAGE plpgsql;
 -- Insert for perc_malnourishment
INSERT INTO dwreporting.fct_subregion (subregion_id, year, perc_malnourishment, population)
SELECT
    get_subregion_id(pou.Entity) AS subregion_id,
    pou.Year AS year,
    pou.Prevalence_of_undernourishment_percentage_of_population AS perc_malnourishment,
    get_population_by_region(pou.Entity) AS population
FROM
    stg_prevalence_of_undernourishment_ourworldindata pou
WHERE
    pou.Year BETWEEN 2001 AND 2019
     AND pou.Entity IN (
        'East Asia and South-Eastern Asia and Pacific',
        'South Asia',
        'Central Asia',
        'Arab World',
        'Sub-Saharan Africa',
        'North America',
        'Latin America and the Caribbean',
        'Europe',
        'Australia and New Zealand'
    )
ON CONFLICT (subregion_id, year) DO UPDATE
SET
    perc_malnourishment = EXCLUDED.perc_malnourishment,
    population = EXCLUDED.population;

-- Insert for perc_pop_without_water
INSERT INTO dwreporting.fct_subregion (subregion_id, year, perc_pop_without_water, population)
SELECT
    get_subregion_id(swiw.Entity) AS subregion_id,
    swiw.Year AS year,
    swiw.wat_imp_without AS perc_pop_without_water,
    get_population_by_region(swiw.Entity) AS population
FROM
    stg_share_without_improved_water_kaggle swiw
WHERE
    swiw.Year BETWEEN 2001 AND 2019
     AND swiw.Entity IN (
        'East Asia and South-Eastern Asia and Pacific',
        'South Asia',
        'Central Asia',
        'Arab World',
        'Sub-Saharan Africa',
        'North America',
        'Latin America and the Caribbean',
        'Europe',
        'Australia and New Zealand'
    )
ON CONFLICT (subregion_id, year) DO UPDATE
SET
    perc_pop_without_water = EXCLUDED.perc_pop_without_water,
    population = EXCLUDED.population;

