CREATE TABLE IF NOT EXISTS dwreporting.etl_watermark 
(
    ID PRIMARY SERIAL NOT NULL,
    etl_last_execution_time TIMESTAMP
);