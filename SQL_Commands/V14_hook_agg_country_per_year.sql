CREATE TABLE IF NOT EXISTS dwreporting.fct_country_yearly_summary (
    id SERIAL PRIMARY KEY,
    country_id INT REFERENCES dim_country(id),
    year INT,
    total_population DECIMAL(20, 2),
    average_malnourishment NUMERIC(10,4),
    total_affected_by_disasters INT,
    total_disasters INT,  -- Add more aggregated columns as needed
    total_affected INT
);

INSERT INTO dwreporting.fct_country_yearly_summary (
    country_id,
    year,
    total_population,
    average_malnourishment,
    total_affected_by_disasters,
    total_disasters,
    total_affected
)
SELECT
    dc.id AS country_id,
    fcd.year,
    fcd.population AS total_population,
    AVG(fcd.perc_malnourishment) AS average_malnourishment,
    COUNT(fd.id) AS total_disasters,
    SUM(fd.total_affected) AS total_affected_by_disasters,
    SUM(fd.total_affected) AS total_affected  -- Example, modify based on your data
FROM
    dwreporting.fct_country_details fcd
JOIN
    dwreporting.dim_country dc ON fcd.country_id = dc.id
LEFT JOIN
    dwreporting.fct_disasters fd ON fd.country_id = dc.id AND fd.year = fcd.year
GROUP BY
    dc.id, fcd.year;

