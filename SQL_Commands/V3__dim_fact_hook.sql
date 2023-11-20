--!!data from 2001 to 2019

CREATE TABLE IF NOT EXISTS dim_continent (
    id INT PRIMARY KEY,
    name VARCHAR(255),
);

CREATE TABLE IF NOT EXISTS dim_subregion (
    id INT PRIMARY KEY,
    name VARCHAR(255),
    continent VARCHAR(255)
);

CREATE TABLE IF NOT EXISTS dim_country (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255),
    population INT,
    code VARCHAR(255),
    capital VARCHAR(255)
    continent_id INT --foreign key to dim continent
);

CREATE TABLE IF NOT EXISTS dim_city (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255),
    population INT,
    country_id INT, -- from dim_country
);

CREATE TABLE IF NOT EXISTS dwreporting.dim_disaster (
    id INT PRIMARY KEY,
    disaster_name VARCHAR(255),
    disaster_subgroup VARCHAR(255),
);

CREATE TABLE IF NOT EXISTS dwreporting.dim_magnitude_scale (
    id INT PRIMARY KEY,
    type VARCHAR(255)
);

CREATE TABLE IF NOT EXISTS fct_disaster_magnitude (
    id INT PRIMARY KEY,
    disaster_id INT,    --foreign key from dim_disaster
    magnitude_scale_id INT  --foreign key from dim_magnitude_scale
);

CREATE TABLE IF NOT EXISTS fct_subregion (
    id INT PRIMARY KEY,
    subregion_id INT, --foreign key from dim_subregion
    year INT,
    perc_malnourishment NUMERIC(10,4),
    perc_pop_without_water NUMERIC(10,4)
    population DECIMAL(20, 2),

    );

CREATE TABLE IF NOT EXISTS dwreporting.fct_country_details (
    id SERIAL PRIMARY KEY,
    country_id INT,
    year INT,
    population DECIMAL(20, 2),
    perc_malnourishment NUMERIC(10,4),
    GDP_per_year NUMERIC(5,4),
    perc_pop_without_water NUMERIC(10,4)
    avg_temp NUMERIC(10,4)
    tree_cover NUMERIC(10,4),
    grassland NUMERIC(10,4),
    wetland NUMERIC(10,4),
    shrubland NUMERIC(10,4),
    sparse_vegetation NUMERIC(10,4),
    cropland NUMERIC(10,4),
    artificial_surfaces NUMERIC(10,4),
    bare_area NUMERIC(10,4),
    inland_water NUMERIC(10,4)
);

CREATE TABLE IF NOT EXISTS dwreporting.fct_disasters (
    id SERIAL PRIMARY KEY,
    disaster_id INT, --foreign key dim_disaster
    country_id INT, --foreign key dim_country
    city_id INT, --foreign key dim_city
    subregion_id INT, --foreign key to dim_country
    month INT,
    year INT,
    OFDA BOOLEAN,
    magnitude_scale_id INT, --foreign key to dim_magnitude_scale
    manitude_value VARCHAR(255),
);
