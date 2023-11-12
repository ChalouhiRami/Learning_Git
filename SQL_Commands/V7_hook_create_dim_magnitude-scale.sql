-- this table does not need distinct and conflict as ive manually done the csv for it
INSERT INTO dim_magnitude_scale (id, type)
SELECT
    id,
    type
FROM dim_magnitude_scale_stg
ON CONFLICT (id) DO UPDATE SET
    type = EXCLUDED.type;


--hon wsolot ghayir aseme l sql li ba3doun hasab order l mekhteri3 fyioun l dim w el fact tables.