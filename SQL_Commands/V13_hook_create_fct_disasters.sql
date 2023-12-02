-- Insert into fct_disasters using functions
INSERT INTO dwreporting.fct_disasters (
    disaster_id,
    country_id,
    city_id,
    subregion_id,
    month,
    year,
    OFDA,
    magnitude_scale_id,
    magnitude_value,
    total_affected
)
SELECT
    get_disaster_id(nd.Disaster_Type) AS disaster_id,
    get_country_id(nd.Country) AS country_id,
    COALESCE(get_city_id(nd.Location), 0) AS city_id,
    COALESCE(get_subregion_id(nd.Subregion), 0) AS subregion_id,
    nd.Start_Month AS month,
    nd.Start_Year AS year,
    CASE WHEN nd.OFDA_Response = 'Yes' THEN TRUE ELSE FALSE END AS OFDA,
    get_magnitude_scale_id(nd.Magnitude_Scale) AS magnitude_scale_id,
    nd.Magnitude AS magnitude_value,
    nd.Total_Affected AS total_affected
FROM
    natural_disasters nd
ON CONFLICT (disaster_id, country_id, city_id, subregion_id, month, year)
DO NOTHING;
