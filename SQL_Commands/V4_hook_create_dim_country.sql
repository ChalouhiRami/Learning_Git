INSERT INTO dim_country (name, code, capital)
SELECT 
    DISTINCT "Country/Territory" AS name,
    Code AS code,
    Capital AS capital
FROM countries
ON CONFLICT(name)  
DO UPDATE SET
    code = excluded.code,
    capital = excluded.capital;
