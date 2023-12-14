INSERT INTO dwreporting.fct_disasters (
    disaster_id,
    country_id,
    city_id,
    month,
    year,
    magnitude_value,
    total_affected,
	subregion_id
)
SELECT
    dd.id AS disaster_id,
    dc.id AS country_id,
    dci.id AS city_id,
    nd.Start_Month AS month,
    nd.Start_Year AS year,
    nd.Magnitude AS magnitude_value,
    nd.total_affected AS total_affected,
	ds.id as subregion_id
FROM
    dwreporting.stg_natural_disasters_emdat nd
JOIN 
    dwreporting.dim_disaster dd ON nd.Disaster_Type = dd.disaster_name
JOIN 
    dwreporting.dim_country dc ON nd.Country = dc.name
JOIN
    dwreporting.dim_city dci ON nd.Location = dci.name
JOIN
	dwreporting.dim_subregion ds ON nd.Subregion = ds.name


ON CONFLICT (disaster_id, country_id, city_id, month, year)
DO NOTHING;