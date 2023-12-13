CREATE TABLE IF NOT EXISTS dwreporting.dim_continent (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) UNIQUE
);

CREATE TABLE IF NOT EXISTS dwreporting.dim_subregion (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) UNIQUE
);

CREATE TABLE IF NOT EXISTS dwreporting.dim_country (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) UNIQUE,
    continent_id INT REFERENCES dwreporting.dim_continent(id),
    subregion_id INT REFERENCES dwreporting.dim_subregion(id),
    population INT,
    code VARCHAR(255),
    capital VARCHAR(255),
    tree_cover DECIMAL(5, 2),
    grassland DECIMAL(5, 2),
    wetland DECIMAL(5, 2),
    shrubland DECIMAL(5, 2),
    sparse_vegetation DECIMAL(5, 2),
    cropland DECIMAL(5, 2),
    artificial_surfaces DECIMAL(5, 2),
    bare_area DECIMAL(5, 2),
    inland_water DECIMAL(5, 2)
);

CREATE TABLE IF NOT EXISTS dwreporting.dim_city (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) ,
    population INT,
    country_id INT REFERENCES dwreporting.dim_country(id)
);
ALTER TABLE dwreporting.dim_city
ADD CONSTRAINT unique_dim_city_name UNIQUE (name);
CREATE TABLE IF NOT EXISTS dwreporting.dim_disaster (
    id SERIAL   PRIMARY KEY,
    disaster_name VARCHAR(255) ,
    disaster_subgroup VARCHAR(255)  
);
ALTER TABLE dwreporting.dim_disaster
ADD CONSTRAINT unique_disaster_name_subgroup UNIQUE (disaster_name, disaster_subgroup);
CREATE TABLE IF NOT EXISTS dwreporting.dim_magnitude_scale (
    id SERIAL PRIMARY KEY,
    type VARCHAR(255) UNIQUE
);


CREATE TABLE IF NOT EXISTS dwreporting.fct_disaster_magnitude (
    id SERIAL PRIMARY KEY,
    disaster_id INT REFERENCES dwreporting.dim_disaster(id)  ,
    magnitude_scale_id INT REFERENCES dwreporting.dim_magnitude_scale(id) 
);

ALTER TABLE dwreporting.fct_disaster_magnitude
ADD CONSTRAINT unique_disaster_magnitude
UNIQUE (disaster_id, magnitude_scale_id);



  CREATE TABLE IF NOT EXISTS dwreporting.fct_subregion (
    id serial  PRIMARY KEY,
    subregion_id INT REFERENCES dwreporting.dim_subregion(id) ,
    year INT ,
    perc_malnourishment NUMERIC(10,4),
    perc_pop_without_water NUMERIC(10,4)
     
);
 
ALTER TABLE dwreporting.fct_subregion
ADD CONSTRAINT unique_subregion_year
UNIQUE (subregion_id, year);
CREATE table if not EXISTS dwreporting.fct_population(


  country_name VARCHAR,
  year INT,
  population BIGINT

);
--
CREATE TABLE IF NOT EXISTS dwreporting.fct_country_details (
    id SERIAL PRIMARY KEY,
    country_id INT REFERENCES dwreporting.dim_country(id)  ,
    subregion_id INT REFERENCES dwreporting.fct_subregion(id),
    year INT  ,
    perc_malnourishment NUMERIC(10,4),
    population DECIMAL(20, 2),     --mush am tezbat l insert
    GDP_per_year NUMERIC(5,4),
    perc_pop_without_water NUMERIC(10,4),
    avg_temp NUMERIC(10,4)

);

--
CREATE TABLE IF NOT EXISTS dwreporting.fct_disasters (
    id SERIAL PRIMARY KEY,
    disaster_id INT REFERENCES dwreporting.dim_disaster(id), --disaster 
    country_id INT REFERENCES dwreporting.dim_country(id),
    city_id INT REFERENCES dwreporting.dim_city(id),--probably mush lah tezbat
    subregion_id INT REFERENCES dwreporting.dim_subregion(id),
    month INT,
    year INT,
    OFDA BOOLEAN,
    magnitude_value VARCHAR(255),
    magnitude_scale_id INT REFERENCES dwreporting.dim_magnitude_scale(id),
    total_affected INT
);