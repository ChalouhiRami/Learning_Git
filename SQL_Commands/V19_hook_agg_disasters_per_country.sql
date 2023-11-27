CREATE TABLE IF NOT EXISTS dwreporting.agg_country_disasters (
    id SERIAL PRIMARY KEY,
    country_name VARCHAR(255),
    disaster_name VARCHAR(255),
    total_OFDA_responses INT,
    avg_magnitude_value NUMERIC(10,4),
    most_occured_in_month INT
);

INSERT INTO dwreporting.agg_country_disasters(
    country_name,
    disaster_name,
    total_OFDA_responses,
    avg_magnitude_value,
    most_occured_in_month
)
SELECT
    dcd.name AS country_name,
    d.disaster_name,
    COUNT(fd.id) FILTER (WHERE fd.OFDA) AS total_OFDA_responses,
    CASE
        WHEN fd.magnitude_scale_id IN (SELECT id FROM dim_magnitude_scale WHERE type IN ('°C', 'Km2', 'Kph', 'Richter'))
            THEN AVG(fd.magnitude_value)::NUMERIC(10,4)
    END AS avg_magnitude_value,
    (
        SELECT month
        FROM (
            SELECT month, COUNT(*) AS occurrence
            FROM dwreporting.fct_disasters
            WHERE country_id = fd.country_id AND disaster_id = fd.disaster_id
            GROUP BY month
            ORDER BY occurrence DESC
            LIMIT 1
        ) AS subquery
    ) AS most_occured_in_month
FROM
    dwreporting.fct_disasters fd
JOIN
    dwreporting.dim_country_details dcd ON fd.country_id = dcd.id
JOIN
    dwreporting.dim_disaster d ON fd.disaster_id = d.id
GROUP BY
    dcd.name, d.disaster_name;
