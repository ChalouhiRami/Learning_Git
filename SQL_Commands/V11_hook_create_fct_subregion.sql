INSERT INTO dwreporting.fct_subregion (
    subregion_id,
    year,
    perc_malnourishment,
    perc_pop_without_water
)
SELECT
    dsr.id AS subregion_id,
    pou.Year AS year,
    pou.Prevalence_of_undernourishment_percentage_of_population AS perc_malnourishment,
    siw.wat_imp_without
FROM
    dwreporting.stg_prevalence_of_undernourishment_ourworldindata pou
JOIN
    dwreporting.dim_subregion dsr ON pou.Entity = dsr.name
JOIN
    dwreporting.stg_share_without_improved_water_kaggle siw ON pou.Entity = siw.Entity AND pou.year = siw.year

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
	order by dsr.id
ON CONFLICT (subregion_id, year) DO NOTHING;
		