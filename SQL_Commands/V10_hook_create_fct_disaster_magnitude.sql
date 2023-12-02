-- Insert into fct_disaster_magnitude
INSERT INTO dwreporting.fct_disaster_magnitude (disaster_id, magnitude_scale_id)
SELECT
    dm.disaster_id,
    ms.id AS magnitude_scale_id
FROM disaster_magnitude dm
JOIN dwreporting.dim_magnitude_scale ms ON dm.magnitude_scale_id = ms.type
ON CONFLICT (disaster_id, magnitude_scale_id) 
    disaster_id = EXCLUDED.disaster_id,
    magnitude_scale_id = EXCLUDED.magnitude_scale_id;