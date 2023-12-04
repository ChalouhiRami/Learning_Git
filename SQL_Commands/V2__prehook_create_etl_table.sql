CREATE TABLE IF NOT EXISTS dwreporting.etl_watermark 
(
    ID SERIAL PRIMARY KEY NOT NULL,
    last_update_timestamp TIMESTAMP DEFAULT '1800-01-01 00:00:00',
    table_name varchar(255)
   

);
 ALTER TABLE dwreporting.etl_watermark
ADD CONSTRAINT unique_table_name UNIQUE (table_name);