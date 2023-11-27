CREATE TABLE IF NOT EXISTS dwreporting.agg_subregion_summary (
    id SERIAL PRIMARY KEY,
    subregion_id INT REFERENCES dim_subregion(id),
    total_population DECIMAL(20, 2),
    average_malnourishment NUMERIC(10,4),
    average_perc_pop_without_water NUMERIC(10,4),
    total_affected_by_disasters INT,
    total_OFDA_responses INT,

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

    total_disasters INT
);

INSERT INTO dwreporting.agg_subregion_summary (
    subregion_id,
    total_population,
    average_malnourishment,
    average_perc_pop_without_water,
    total_affected_by_disasters,
    total_OFDA_responses,

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
    dsr.id AS subregion_id,
    AVG(dc.population) AS total_population,
    AVG(fcs.perc_malnourishment) AS average_malnourishment,
    AVG(fcs.perc_pop_without_water) AS average_perc_pop_without_water,
    SUM(fd.total_affected) AS total_affected_by_disasters,
    COUNT(fd.id) FILTER (WHERE fd.OFDA) AS total_OFDA_responses,
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
    
    COUNT(fd.id) AS total_disasters
FROM
    dwreporting.fct_subregion fcs
JOIN
    dwreporting.dim_subregion dc ON fcs.subregion_id = dc.id
LEFT JOIN
    dwreporting.fct_disasters fd ON fd.subregion_id = dc.id
GROUP BY
    dc.id;
