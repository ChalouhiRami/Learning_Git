-- insert lal population

INSERT INTO dwreporting.fct_country_details (
    country_id,
    subregion_id,
    year,
    perc_malnourishment,
    population,
    GDP_per_year,
    perc_pop_without_water,
    avg_temp
)
SELECT
    get_country_id(pou.Entity) AS country_id,
    get_subregion_id(dsr.name) AS subregion_id,
    pou.Year AS year,
    pou.Prevalence_of_undernourishment_percentage_of_population AS perc_malnourishment,
    pou.Population AS population,
    gdp.Value AS GDP_per_year,
    vcd.Perc_pop_without_water,
    avg_temp.AvgTemperature AS avg_temp
FROM
    prevalence_of_undernourishment pou
JOIN
    dim_subregion dsr ON pou.Entity = dsr.name
JOIN
    gdp ON pou.Entity = gdp.Country_or_Area AND pou.Year = gdp.Year
JOIN
    avg_temperature avg_temp ON pou.Entity = avg_temp.Country AND pou.Year = avg_temp.Year
JOIN
    valuable_country_data vcd ON pou.Entity = vcd.Country
WHERE
    pou.Year BETWEEN 2001 AND 2019
    AND (pou.Code IS NOT NULL AND pou.Code <> '')
    AND (vcd.Code IS NOT NULL AND vcd.Code <> '')
ON CONFLICT (subregion_id, country_id, year) DO UPDATE
SET
    population = EXCLUDED.population,
    perc_malnourishment = EXCLUDED.perc_malnourishment,
    GDP_per_year = EXCLUDED.GDP_per_year,
    perc_pop_without_water = EXCLUDED.perc_pop_without_water,
    avg_temp = EXCLUDED.avg_temp;
