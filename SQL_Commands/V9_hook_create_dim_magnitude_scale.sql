INSERT INTO dwreporting.dim_magnitude_scale (type)
SELECT DISTINCT type
FROM magnitude_scale
ON CONFLICT (type) 
DO UPDATE SET type = EXCLUDED.type;