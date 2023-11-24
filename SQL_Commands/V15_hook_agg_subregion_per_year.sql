







--change it as the last code in chatgpt, but dont forget to change to the disaster_name





CREATE TABLE IF NOT EXISTS dwreporting.fct_country_average_summary (
    id SERIAL PRIMARY KEY,
    country_id INT REFERENCES dim_country(id),
    average_population DECIMAL(20, 2),
    average_gdp NUMERIC(10, 4),
    total_ofda_responses INT,
    average_malnourishment NUMERIC(10,4),
    average_affected_by_disasters NUMERIC(10,4),
    average_disasters_per_year NUMERIC(10,4),
    average_affected_per_disaster NUMERIC(10,4)    
);

INSERT INTO dwreporting.fct_country_average_summary (
    country_id,
    average_population,
    average_malnourishment,
    average_affected_by_disasters,
    average_disasters_per_year,
    average_affected_per_disaster,
    total_ofda_responses,
    average_gdp
)
SELECT
    dc.id AS country_id,
    AVG(fcd.population) AS average_population,
    AVG(fcd.perc_malnourishment) AS average_malnourishment,
    AVG(fcd.total_affected_by_disasters) AS average_affected_by_disasters,
    AVG(fcd.total_disasters) AS average_disasters_per_year,
    AVG(fcd.total_affected / NULLIF(fcd.total_disasters, 0)) AS average_affected_per_disaster,
    SUM(CASE WHEN fcd.total_ofda_responses > 0 THEN 1 ELSE 0 END) AS total_ofda_responses,
    AVG(fcd.gdp) AS average_gdp
FROM
    dwreporting.fct_country_yearly_summary fcd
JOIN
    dwreporting.dim_country dc ON fcd.country_id = dc.id
GROUP BY
    dc.id;
