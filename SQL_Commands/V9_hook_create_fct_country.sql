INSERT INTO fct_country (country_id, year, population, perc_malnourishment, GDP_per_year, perc_pop_without_wter, avg_temp)
SELECT
    c.id AS country_id,
    w.year,
    w.population,
    p.prevalence AS perc_malnourishment,
    gdp.value AS GDP_per_year,
    sww.wat_imp_without AS perc_pop_without_wter,
    at.AvgTemperature AS avg_temp
FROM world_population w
JOIN dim_country c ON w."Country Code" = c.code
JOIN prevalence_of_undernourishment p ON w."Country Code" = p.Code AND w.year = p.Year
JOIN undata_export u ON w."Country Code" = u."Country or Area" AND w.year = u.Year
JOIN share_without_improved_water sww ON w."Country Code" = sww.Code AND w.year = sww.Year
JOIN avg_temperature at ON c.name = at.Country AND w.year = at.Year
WHERE w.year BETWEEN 2001 AND 2019
ON CONFLICT (country_id, year)
DO UPDATE SET
    population = EXCLUDED.population,
    perc_malnourishment = EXCLUDED.perc_malnourishment,
    GDP_per_year = EXCLUDED.GDP_per_year,
    perc_pop_without_wter = EXCLUDED.perc_pop_without_wter,
    avg_temp = EXCLUDED.avg_temp;
