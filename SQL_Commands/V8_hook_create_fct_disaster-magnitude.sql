-- this table does not need distinct and conflict as ive manually done the csv for it
INSERT INTO fct_disaster_magnitude (id, disaster_id, magnitude_scale_id)
SELECT
    id,
    disaster_id,
    magnitude_scale_id
FROM fct_disaster_magnitude_stg
ON CONFLICT (id) DO UPDATE SET
    disaster_id = EXCLUDED.disaster_id,
    magnitude_scale_id = EXCLUDED.magnitude_scale_id;