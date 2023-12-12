DO $$
DECLARE
  query_text text;
  result_cursor REFCURSOR;
  result_row RECORD;
BEGIN
  FOR query_text IN
    SELECT
      'SELECT Country_Name, ''' || column_name || ''' AS year, ' || column_name || ' AS population FROM dwreporting.stg_world_population_kaggle'
    FROM
      information_schema.columns
    WHERE
      table_schema = 'dwreporting'
      AND table_name = 'stg_world_population_kaggle'
      AND column_name LIKE 'year_%'
    ORDER BY
      ordinal_position
  LOOP
    OPEN result_cursor FOR EXECUTE query_text;

     LOOP
      FETCH NEXT FROM result_cursor INTO result_row;
      EXIT WHEN NOT FOUND;

       INSERT INTO dwreporting.fct_population (country_name, year, population)
      VALUES (result_row.Country_Name, substring(result_row.year from 6)::VARCHAR, result_row.population::BIGINT);
    END LOOP;

    CLOSE result_cursor;
  END LOOP;
END $$;