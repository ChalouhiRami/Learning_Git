SELECT 
    'DISASTER' AS disaster_type,
    disaster_name
FROM fct_city_disaster
UNION ALL
SELECT 
    'FLOOD' AS disaster_type,
    flood_name
