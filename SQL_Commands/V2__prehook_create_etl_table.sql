from datetime import datetime


CREATE TABLE IF NOT EXISTS dwreporting.etl_watermark 
(
    ID SERIAL PRIMARY KEY NOT NULL,
    etl_last_execution_time TIMESTAMP
);


INSERT INTO dwreporting.etl_watermark (etl_last_execution_time) VALUES (NOW());


