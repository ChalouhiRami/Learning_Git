-- CREATE TABLE 
INSERT INTO FROM STG
SELECT DISTINCT
    city_id
    disaster_name
FROM country_city
ON CONFLICT(city_id)
DO UPDATE SET
    city_name = excluded.city_name