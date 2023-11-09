-- table name convention:
-- dim / fct / stg_ sourcename_tablename

-- access_to_water_per_country_2000_2020_dim
-- dim_country_water_access


 --access_to_water_per_country_2000_2020.csv
CREATE TABLE IF NOT EXISTS fct_country (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255),
    ISO VARCHAR(255),
    continent VARCHAR(255),
    land_area DECIMAL(20, 2),
    climate VARCHAR(255),
    inland_water DECIMAL(20, 2),
    cropland DECIMAL(20, 2),
    sparse_vegetation DECIMAL(20, 2),
    wetland DECIMAL(20, 2),
    tree_cover DECIMAL(20, 2),
    grassland DECIMAL(20, 2),
    shrubland DECIMAL(20, 2)
);


 
CREATE TABLE IF NOT EXISTS dim_country (
    id INT AUTO_INCREMENT PRIMARY KEY,
    country_id INT,
    year INT,
    gdp DECIMAL(20, 2),
    avg_temperature DECIMAL(20, 2),
    water_access DECIMAL(20, 2),
    population INT
);

CREATE TABLE IF NOT EXISTS dim_city (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255),
    country_id INT,
    healthcare_facilities INT,
    density_per_city DECIMAL(8, 2)
);


 
CREATE TABLE IF NOT EXISTS fct_naturaldisasters (
    id INT AUTO_INCREMENT PRIMARY KEY,
    disaster_subgroup VARCHAR(255),
    disaster_type VARCHAR(255),
    country VARCHAR(255),
    ofda_response VARCHAR(255),
    scale VARCHAR(255),
    start_year INT
);


