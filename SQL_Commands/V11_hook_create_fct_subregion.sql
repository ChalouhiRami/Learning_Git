INSERT INTO dwreporting.fct_subregion (subregion_id, year, perc_malnourishment)
SELECT
    get_subregion_id(pou.Entity) AS subregion_id,
    pou.Year AS year,
    pou.Prevalence_of_undernourishment_percentage_of_population AS perc_malnourishment
FROM
    prevalence_of_undernourishment pou
WHERE
    pou.Year BETWEEN 2001 AND 2019
    AND (pou.Code IS NULL OR pou.Code = '')
ON CONFLICT (subregion_id, year) DO UPDATE
SET
    perc_malnourishment = EXCLUDED.perc_malnourishment;

-- Insert for perc_pop_without_water
INSERT INTO dwreporting.fct_subregion (subregion_id, year, perc_pop_without_water)
SELECT
    get_subregion_id(swiw.Entity) AS subregion_id,
    swiw.Year AS year,
    swiw.wat_imp_without AS perc_pop_without_water
FROM
    share_without_improved_water swiw
WHERE
    swiw.Year BETWEEN 2001 AND 2019
    AND (swiw.Code IS NULL OR swiw.Code = '')
ON CONFLICT (subregion_id, year) DO UPDATE
SET
    perc_pop_without_water = EXCLUDED.perc_pop_without_water;
