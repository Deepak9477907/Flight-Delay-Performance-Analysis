
-- STEP 1: Create the database (schema)
-- ============================================================

CREATE DATABASE IF NOT EXISTS airline_db;
USE airline_db;


-- ============================================================
-- STEP 2: Create the AIRLINES table
-- (Small lookup table — ~15 rows)
-- ============================================================



CREATE TABLE airlines (
    IATA_CODE   VARCHAR(5)   NOT NULL,   -- e.g. AA, DL, UA
    AIRLINE     VARCHAR(100) NOT NULL,   -- Full airline name
    PRIMARY KEY (IATA_CODE)
);


-- ============================================================
-- STEP 3: Create the AIRPORTS table
-- (Lookup table — ~322 rows)
-- ============================================================


CREATE TABLE airports (
    IATA_CODE   VARCHAR(5)    NOT NULL,  -- Airport code e.g. ATL, LAX
    AIRPORT     VARCHAR(200)  NOT NULL,  -- Full airport name
    CITY        VARCHAR(100),
    STATE       VARCHAR(50),
    COUNTRY     VARCHAR(50),
    LATITUDE    DECIMAL(10,6),           -- For map visuals in Power BI
    LONGITUDE   DECIMAL(10,6),
    PRIMARY KEY (IATA_CODE)
);


-- ============================================================
-- STEP 4: Create the FLIGHTS table
-- (Main fact table — ~5.8 million rows)
-- ============================================================



CREATE TABLE flights (
    YEAR                    SMALLINT,
    MONTH                   TINYINT,
    DAY                     TINYINT,
    DAY_OF_WEEK             TINYINT,        -- 1=Monday … 7=Sunday
    AIRLINE                 VARCHAR(5),     -- FK → airlines.IATA_CODE
    FLIGHT_NUMBER           INT,
    TAIL_NUMBER             VARCHAR(10),
    ORIGIN_AIRPORT          VARCHAR(5),     -- FK → airports.IATA_CODE
    DESTINATION_AIRPORT     VARCHAR(5),     -- FK → airports.IATA_CODE
    SCHEDULED_DEPARTURE     VARCHAR(6),     -- Raw HHMM string e.g. '855','2359'
    DEPARTURE_TIME          VARCHAR(6),     -- Actual departure HHMM
    DEPARTURE_DELAY         FLOAT,          -- Minutes (negative = early)
    TAXI_OUT                FLOAT,
    WHEELS_OFF              VARCHAR(6),
    SCHEDULED_TIME          FLOAT,          -- Scheduled flight duration (mins)
    ELAPSED_TIME            FLOAT,          -- Actual elapsed time (mins)
    AIR_TIME                FLOAT,
    DISTANCE                FLOAT,          -- Miles
    WHEELS_ON               VARCHAR(6),
    TAXI_IN                 FLOAT,
    SCHEDULED_ARRIVAL       VARCHAR(6),     -- HHMM string
    ARRIVAL_TIME            VARCHAR(6),     -- Actual arrival HHMM
    ARRIVAL_DELAY           FLOAT,          -- Minutes (negative = early)
    DIVERTED                TINYINT,        -- 0 or 1
    CANCELLED               TINYINT,        -- 0 or 1
    CANCELLATION_REASON     VARCHAR(2),     -- A, B, C, D or NULL
    AIR_SYSTEM_DELAY        FLOAT,
    SECURITY_DELAY          FLOAT,
    AIRLINE_DELAY           FLOAT,
    LATE_AIRCRAFT_DELAY     FLOAT,
    WEATHER_DELAY           FLOAT

);
SET GLOBAL local_infile = 1;
SELECT COUNT(*) FROM flights;
-- ============================================================
-- STEP 6: Verification queries — run these after import
LOAD DATA LOCAL INFILE 'C:/Users/akan2/Downloads/Final_project_data_archive/flights.csv'
INTO TABLE flights
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;
SHOW VARIABLES LIKE 'local_infile';
-- ============================================================

-- 6A: Check row counts
SELECT 'airlines'  AS table_name, COUNT(*) AS row_count FROM airlines
UNION ALL
SELECT 'airports'  AS table_name, COUNT(*) AS row_count FROM airports
UNION ALL
SELECT 'flights'   AS table_name, COUNT(*) AS row_count FROM flights;

-- Expected results:
--   airlines  →  ~14 rows
--   airports  →  ~322 rows
--   flights   →  ~5,819,079 rows


-- 6B: Preview each table
SELECT * FROM airlines  LIMIT 5;
SELECT * FROM airports  LIMIT 5;
SELECT * FROM flights   LIMIT 5;


-- 6C: Check for completely empty key columns
SELECT
    SUM(CASE WHEN AIRLINE              IS NULL THEN 1 ELSE 0 END) AS null_airline,
    SUM(CASE WHEN ORIGIN_AIRPORT       IS NULL THEN 1 ELSE 0 END) AS null_origin,
    SUM(CASE WHEN DESTINATION_AIRPORT  IS NULL THEN 1 ELSE 0 END) AS null_dest,
    SUM(CASE WHEN SCHEDULED_DEPARTURE  IS NULL THEN 1 ELSE 0 END) AS null_sched_dep,
    SUM(CASE WHEN CANCELLED            IS NULL THEN 1 ELSE 0 END) AS null_cancelled
FROM flights;


-- 6D: Quick look at airlines in the flights table
SELECT DISTINCT f.AIRLINE, a.AIRLINE AS airline_name
FROM flights f
LEFT JOIN airlines a ON f.AIRLINE = a.IATA_CODE
ORDER BY f.AIRLINE;


-- 6E: Basic stats — total flights, cancelled, diverted
SELECT
    COUNT(*)                                          AS total_flights,
    SUM(CANCELLED)                                    AS total_cancelled,
    SUM(DIVERTED)                                     AS total_diverted,
    ROUND(SUM(CANCELLED) / COUNT(*) * 100, 2)         AS cancellation_rate_pct,
    ROUND(AVG(DEPARTURE_DELAY), 2)                    AS avg_departure_delay_mins,
    ROUND(AVG(ARRIVAL_DELAY), 2)                      AS avg_arrival_delay_mins
FROM flights;

USE airline_db;

SELECT COUNT(*) FROM flights;