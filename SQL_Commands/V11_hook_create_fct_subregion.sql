--insert lal population


INSERT INTO dwreporting.fct_subregion (subregion_id, year, perc_malnourishment)
SELECT
    dsr.id AS subregion_id,
    pou.Year AS year,
    pou.Prevalence_of_undernourishment_percentage_of_population AS perc_malnourishment
FROM
    prevalence_of_undernourishment pou
JOIN
    dim_subregion dsr ON pou.Entity = dsr.name
WHERE
    pou.Year BETWEEN 2001 AND 2019
    AND (pou.Code IS NULL OR pou.Code = '')
ON CONFLICT (subregion_id, year) DO UPDATE
SET
    perc_malnourishment = EXCLUDED.perc_malnourishment;


INSERT INTO dwreporting.fct_subregion (subregion_id, year, perc_pop_without_water)
SELECT
    dsr.id AS subregion_id,
    swiw.Year AS year,
    swiw.wat_imp_without AS perc_pop_without_water
FROM
    share_without_improved_water swiw
JOIN
    dim_subregion dsr ON swiw.Entity = dsr.name
WHERE
    swiw.Year BETWEEN 2001 AND 2019
    AND (swiw.Code IS NULL OR swiw.Code = '')
ON CONFLICT (subregion_id, year) DO UPDATE
SET
    perc_pop_without_water = EXCLUDED.perc_pop_without_water;




