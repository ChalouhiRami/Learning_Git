INSERT INTO dwreporting.fct_country_details (
    country_id,
    year,
    perc_malnourishment,
    population,
    GDP_per_year,
    perc_pop_without_water,
    avg_temp
)
SELECT
    get_country_id(pou.Entity) AS country_id,
    pou.Year AS year,
    pou.Prevalence_of_undernourishment_percentage_of_population AS perc_malnourishment,
    fp.Population AS population,
    gdp.Value AS GDP_per_year,
    siw.wat_imp_without,
    avg_temp.AvgTemperature AS avg_temp
FROM
    dwreporting.stg_prevalence_of_undernourishment_ourworldindata pou
JOIN 
    dwreporting.fct_population fp ON pou.Entity = fp.country_name AND pou.Year = fp.year::int
JOIN
    dwreporting.stg_gdp_undata gdp ON pou.Entity = gdp.Country_or_Area AND pou.Year = gdp.Year
JOIN
    dwreporting.stg_avg_temperature_kaggle avg_temp ON pou.Entity = avg_temp.Country AND pou.Year = avg_temp.Year
JOIN
    dwreporting.stg_share_without_improved_water_kaggle siw ON pou.Entity = siw.Entity
WHERE
    pou.Year BETWEEN 2001 AND 2019
    AND (pou.Code IS NOT NULL AND pou.Code <> '')
    AND (siw.Code IS NOT NULL AND siw.Code <> '')
	order by country_id,year
ON CONFLICT (country_id, year) DO nothing