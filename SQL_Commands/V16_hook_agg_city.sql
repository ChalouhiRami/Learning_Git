SELECT 
    city_id,
    SUM(
    CASE WHEN 
        disaster_type = 'FLOOD'
    THEN 1
    ELSE 0
    END) total_flood_disasters,
    SUM(
    CASE WHEN 
        disaster_type = 'DISASTER'
    THEN 1
    ELSE 0
    END) total_flood_disasters,
FROM {target_schema}.fct_disasters