CREATE TABLE IF NOT EXISTS dwreporting.dim_continent (
    id INT PRIMARY KEY,
    name VARCHAR(255)
);

CREATE TABLE IF NOT EXISTS dwreporting.dim_subregion (
    id INT PRIMARY KEY,
    name VARCHAR(255)
   
);

CREATE TABLE IF NOT EXISTS dwreporting.dim_country (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255),
    population INT,
    code VARCHAR(255),
    capital VARCHAR(255),
    continent_id INT REFERENCES dim_continent(id)
    subregion_id INT REFERENCES dim_subregion(id)
);

CREATE TABLE IF NOT EXISTS dwreporting.dim_city (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255),
    population INT,
    country_id INT REFERENCES dim_country(id)
);

CREATE TABLE IF NOT EXISTS dwreporting.dim_disaster (
    id SERIAL INT PRIMARY KEY,
    disaster_name VARCHAR(255),
    disaster_subgroup VARCHAR(255)
);

CREATE TABLE IF NOT EXISTS dwreporting.dim_magnitude_scale (
    id SERIAL INT PRIMARY KEY,
    type VARCHAR(255)
);

CREATE TABLE IF NOT EXISTS dwreporting.fct_disaster_magnitude (
    id SERIAL INT PRIMARY KEY,
    disaster_id INT REFERENCES dim_disaster(id),
    magnitude_scale_id INT REFERENCES dim_magnitude_scale(id)
);

CREATE TABLE IF NOT EXISTS dwreporting.fct_subregion (
    id SERIAL INT PRIMARY KEY,
    subregion_id INT REFERENCES dim_subregion(id),
    year INT,
    perc_malnourishment NUMERIC(10,4),
    perc_pop_without_water NUMERIC(10,4),
    population DECIMAL(20, 2)
);

CREATE TABLE IF NOT EXISTS dwreporting.fct_country_details (
    id SERIAL PRIMARY KEY,
    country_id INT REFERENCES dim_country(id),
    year INT,
    population DECIMAL(20, 2),
    perc_malnourishment NUMERIC(10,4),
    GDP_per_year NUMERIC(5,4),
    perc_pop_without_water NUMERIC(10,4),
    avg_temp NUMERIC(10,4),
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
    disaster_id INT REFERENCES dim_disaster(id),
    country_id INT REFERENCES dim_country(id),
    city_id INT REFERENCES dim_city(id),
    subregion_id INT REFERENCES dim_subregion(id),
    month INT,
    year INT,
    OFDA BOOLEAN,
    magnitude_scale_id INT REFERENCES dim_magnitude_scale(id),
    manitude_value VARCHAR(255)
);
