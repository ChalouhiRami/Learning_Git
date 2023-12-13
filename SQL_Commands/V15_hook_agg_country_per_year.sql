CREATE TABLE IF NOT EXISTS dwreporting.agg_country_yearly_summary (
    id SERIAL PRIMARY KEY,
    country_id INT REFERENCES dim_country(id),
    year INT,
    total_population DECIMAL(20, 2),
    average_malnourishment NUMERIC(10,4),
    GDP_per_year NUMERIC(5,4),
    perc_pop_without_water NUMERIC(10,4),
    avg_temp NUMERIC(10,4),
    total_affected_by_disasters INT,

    storm INT,
    flood INT,
    epidemic INT,
    volcanic_activity INT,
    earthquake INT,
    drought INT,
    mass_movement_dry INT,
    infestation INT,
    mass_movement_wet INT,
    extreme_temperature INT,
    animal_incident INT,
    wildfire INT,
    fog INT,
    glacial_lake_outburst_flood INT,
    impact INT,

    total_disasters INT,
);

INSERT INTO dwreporting.agg_country_yearly_summary (
    country_id,
    year,
    total_population,
    average_malnourishment,
    GDP_per_year,
    perc_pop_without_water,
    avg_temp,
    total_affected_by_disasters,

    storm,
    flood,
    epidemic,
    volcanic_activity,
    earthquake,
    drought,
    mass_movement_dry,
    infestation,
    mass_movement_wet,
    extreme_temperature,
    animal_incident,
    wildfire,
    fog,
    glacial_lake_outburst_flood,
    impact,

    total_disasters
)
SELECT
    dc.id AS country_id,
    fcd.year,
    fcd.population AS total_population,
    fcd.perc_malnourishment AS average_malnourishment,
    fcd.GDP_per_year AS GDP_per_year,
    fcd.perc_pop_without_water AS perc_pop_without_water,
    fcd.avg_temp AS avg_temp,
    SUM(fd.total_affected) AS total_affected_by_disasters,

    COUNT(fd.id) FILTER (WHERE fd.disaster_name = 'Storm') AS storm,
    COUNT(fd.id) FILTER (WHERE fd.disaster_name = 'Flood') AS flood,
    COUNT(fd.id) FILTER (WHERE fd.disaster_name = 'Epidemic') AS epidemic,
    COUNT(fd.id) FILTER (WHERE fd.disaster_name = 'Volcanic activity') AS volcanic_activity,
    COUNT(fd.id) FILTER (WHERE fd.disaster_name = 'Earthquake') AS earthquake,
    COUNT(fd.id) FILTER (WHERE fd.disaster_name = 'Drought') AS drought,
    COUNT(fd.id) FILTER (WHERE fd.disaster_name = 'Mass movement (dry)') AS mass_movement_dry,
    COUNT(fd.id) FILTER (WHERE fd.disaster_name = 'Infestation') AS infestation,
    COUNT(fd.id) FILTER (WHERE fd.disaster_name = 'Mass movement (wet)') AS mass_movement_wet,
    COUNT(fd.id) FILTER (WHERE fd.disaster_name = 'Extreme temperature') AS extreme_temperature,
    COUNT(fd.id) FILTER (WHERE fd.disaster_name = 'Animal incident') AS animal_incident,
    COUNT(fd.id) FILTER (WHERE fd.disaster_name = 'Wildfire') AS wildfire,
    COUNT(fd.id) FILTER (WHERE fd.disaster_name = 'Fog') AS fog,
    COUNT(fd.id) FILTER (WHERE fd.disaster_name = 'Glacial lake outburst flood') AS glacial_lake_outburst_flood,
    COUNT(fd.id) FILTER (WHERE fd.disaster_name = 'Impact') AS impact,

    COUNT(fd.id) AS total_disasters,
FROM
    dwreporting.fct_country_details fcd
JOIN
    dwreporting.dim_country dc ON fcd.country_id = dc.id
LEFT JOIN
    dwreporting.fct_disasters fd ON fd.country_id = dc.id AND fd.year = fcd.year
GROUP BY
    dc.id, fcd.year;
