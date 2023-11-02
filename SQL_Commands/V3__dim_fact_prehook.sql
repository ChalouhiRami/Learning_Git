-- table name convention:
-- dim / fct / stg_ sourcename_tablename

-- access_to_water_per_country_2000_2020_dim
-- dim_country_water_access


 --access_to_water_per_country_2000_2020.csv
CREATE TABLE IF NOT EXISTS access_to_water_per_country_2000_2020_dim (
    Entity VARCHAR(255),
    Code VARCHAR(255)
);

 
CREATE TABLE IF NOT EXISTS access_to_water_per_country_2000_2020_fact (
    Year INT,
    _pop_without_water FLOAT
);

-- Dimension Table ,density_per_city.csv
CREATE TABLE IF NOT EXISTS density_per_city_dim (
    city VARCHAR(255),
    city_ascii VARCHAR(255),
    lat FLOAT,
    lng FLOAT,
    country VARCHAR(255),
    iso2 VARCHAR(2),
    iso3 VARCHAR(3),
    admin_name VARCHAR(255),
    capital VARCHAR(255),
    population INT,
    identifier INT
);

--population per country 
CREATE TABLE IF NOT EXISTS population_per_country_dim (
    Rank INT,
    CCA3 VARCHAR(255),
    Country_Territory VARCHAR(255),
    Capital VARCHAR(255),
    Continent VARCHAR(255)
);

 
CREATE TABLE IF NOT EXISTS population_per_country_fact (
    _2022Population INT,
    _2020Population INT,
    _2015Population INT,
    _2010Population INT,
    _2000Population INT,
    _1990Population INT,
    _1980Population INT,
    _1970Population INT,
    Area FLOAT,
    Density FLOAT,
    Growth_Rate FLOAT,
    World_Population_Percentage FLOAT
);
-- malnourishment_per_country.csv

 CREATE TABLE IF NOT EXISTS  malnourishment_per_country_dim (
     
    country VARCHAR(255),
    Code VARCHAR(255)
    
);

CREATE TABLE IF NOT EXISTS  malnourishment_per_country_fact (
    Year INT,
    Disaster_Subgroup VARCHAR(255),
    Disaster_Type VARCHAR(255),
    Disaster_Subtype VARCHAR(255),
    country VARCHAR(255),
    Code VARCHAR(255),
    Prevalence_of_undernourishment_percentage_of_population FLOAT
);

 --avg_temperature_per_city.csv
CREATE TABLE IF NOT EXISTS avg_temperature_per_city_dim (
    Region VARCHAR(255),
    Country VARCHAR(255),
    State VARCHAR(255),
    City VARCHAR(255)
    
);
 
CREATE TABLE  IF NOT EXISTS avg_temperature_per_city_fact (
	Month INT,
    Day INT,
    Year INT,
    AvgTemperature FLOAT
);

