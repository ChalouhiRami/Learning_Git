CREATE TABLE IF NOT EXISTS dwreporting.agg_country_summary (
    id SERIAL PRIMARY KEY,
    country_id INT REFERENCES dim_country(id),
    code VARCHAR(255),
    capital VARCHAR(255),
    total_population DECIMAL(20, 2),
    average_malnourishment NUMERIC(10,4),
    average_GDP_per_year NUMERIC(5,4),
    average_perc_pop_without_water NUMERIC(10,4),
    average_avg_temp NUMERIC(10,4),
    total_affected_by_disasters INT,
    total_OFDA_responses INT,

    tree_cover NUMERIC(10,4),
    grassland NUMERIC(10,4),
    wetland NUMERIC(10,4),
    shrubland NUMERIC(10,4),
    sparse_vegetation NUMERIC(10,4),
    cropland NUMERIC(10,4),
    artificial_surfaces NUMERIC(10,4),
    bare_area NUMERIC(10,4),
    inland_water NUMERIC(10,4),
    
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


INSERT INTO dwreporting.agg_country_summary (
    country_id,
    code,
    capital,
    total_population,
    average_malnourishment,
    average_GDP_per_year,
    average_perc_pop_without_water,
    average_avg_temp,
    total_affected_by_disasters,
    total_OFDA_responses,

    tree_cover,
    grassland,
    wetland,
    shrubland,
    sparse_vegetation,
    cropland,
    artificial_surfaces,
    bare_area,
    inland_water,
    

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
    dc.code,
    dc.capital,
    AVG(dc.population) AS total_population,
    AVG(fcd.perc_malnourishment) AS average_malnourishment,
    AVG(fcd.GDP_per_year) AS average_GDP_per_year,
    AVG(fcd.perc_pop_without_water) AS average_perc_pop_without_water,
    AVG(fcd.avg_temp) AS average_avg_temp,
    SUM(fd.total_affected) AS total_affected_by_disasters,
    COUNT(fd.id) FILTER (WHERE fd.OFDA) AS total_OFDA_responses,

    dc.tree_cover,
    dc.grassland,
    dc.wetland,
    dc.shrubland,
    dc.sparse_vegetation,
    dc.cropland,
    dc.artificial_surfaces,
    dc.bare_area,
    dc.inland_water,

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
    dwreporting.fct_country_details fcd
JOIN
    dwreporting.dim_country dc ON fcd.country_id = dc.id
LEFT JOIN
    dwreporting.fct_disasters fd ON fd.country_id = dc.id
GROUP BY
    dc.id;
