CREATE TABLE IF NOT EXISTS dim_country (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255),
    Code VARCHAR(255),
    population DECIMAL(20, 2),

);


 
CREATE TABLE IF NOT EXISTS dim_city (
    id INT AUTO_INCREMENT PRIMARY KEY,
    city_id INT,
    name INT,
    population INT,
    country VARCHAR(255),

);

CREATE TABLE IF NOT EXISTS dim_disaster (
    id INT AUTO_INCREMENT PRIMARY KEY,
    disaster_subgroup VARCHAR(255),
    disaster_name VARCHAR(255),

);


 
CREATE TABLE IF NOT EXISTS dim_magnitude-scale (
    id INT AUTO_INCREMENT PRIMARY KEY,
    type VARCHAR(255)
);

CREATE TABLE IF NOT EXISTS fct_disaster-magnitude (
    id INT PRIMARY KEY,
    disaster_id INT,
    magnitude-scale_id INT
);

CREATE TABLE IF NOT EXISTS fct_country (
    id INT AUTO_INCREMENT PRIMARY KEY,
    country_id INT,
    year INT,
    perc_malnourishment NUMERIC(10,4),
    GDP_per_year NUMERIC(5,4),
    perc_pop_without_wter NUMERIC(10,4)
);

CREATE TABLE IF NOT EXISTS fct_disasters (
    id INT AUTO_INCREMENT PRIMARY KEY,
    disaster_id INT,
    country_id INT,
    city_id INT,
    month INT,
    year INT,
    OFDA BOOLEAN,
    magnitude-scale_id INT,
    manitude_value VARCHAR,   #???????????

);






