-- this table does not need distinct and conflict as ive manually done the csv for it
INSERT INTO dim_disaster (id, disaster_subgroup, disaster_name)
SELECT
    id,
    disaster_subgroup,
    disaster_name
FROM dim_disaster_stg
ON CONFLICT (id) DO UPDATE SET
    disaster_subgroup = EXCLUDED.disaster_subgroup,
    disaster_name = EXCLUDED.disaster_name;