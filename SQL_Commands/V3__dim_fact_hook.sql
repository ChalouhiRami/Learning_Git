CREATE SCHEMA IF NOT EXISTS dwreporting;

CREATE TABLE IF NOT EXISTS dwreporting.dim_country (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255),
    Code VARCHAR(255),
    Capital VARCHAR(255)
);

CREATE TABLE IF NOT EXISTS dwreporting.dim_city (
    id SERIAL PRIMARY KEY, 
    name INT,
    population INT,
    country VARCHAR(255)
);

CREATE TABLE IF NOT EXISTS dwreporting.dim_disaster (
    id INT PRIMARY KEY,
    disaster_subgroup VARCHAR(255),
    disaster_name VARCHAR(255)
);

CREATE TABLE IF NOT EXISTS dwreporting.dim_magnitude_scale (
    id INT PRIMARY KEY,
    type VARCHAR(255)
);

CREATE TABLE IF NOT EXISTS dwreporting.fct_disaster_magnitude (
    id INT PRIMARY KEY,
    disaster_id INT,
    magnitude_scale_id INT
);

CREATE TABLE IF NOT EXISTS dwreporting.fct_country (
    id SERIAL PRIMARY KEY,
    country_id INT,
    year INT,
    population DECIMAL(20, 2),
    perc_malnourishment NUMERIC(10,4),
    GDP_per_year NUMERIC(5,4),
    perc_pop_without_water NUMERIC(10,4),
    avg_temp NUMERIC(10,4)  
);

CREATE TABLE IF NOT EXISTS dwreporting.fct_disasters (
    id SERIAL PRIMARY KEY,
    disaster_id INT,
    country_id INT,
    city_id INT,
    month INT,
    year INT,
    OFDA BOOLEAN,
    magnitude_scale_id INT,
    magnitude_value VARCHAR  
);
