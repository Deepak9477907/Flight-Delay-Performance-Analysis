USE airline_db;

-- Check if any header/bad row was imported
SELECT *
FROM flights
WHERE YEAR = 0
   OR MONTH = 0
   OR AIRLINE = 'AIRLINE'
   OR ORIGIN_AIRPORT = 'ORIGIN_AIRPORT'
LIMIT 10;
USE airline_db;

SELECT
    SUM(CASE WHEN DEPARTURE_DELAY IS NULL THEN 1 ELSE 0 END) AS null_departure_delay,
    SUM(CASE WHEN ARRIVAL_DELAY IS NULL THEN 1 ELSE 0 END) AS null_arrival_delay,
    SUM(CASE WHEN AIR_SYSTEM_DELAY IS NULL THEN 1 ELSE 0 END) AS null_air_system_delay,
    SUM(CASE WHEN SECURITY_DELAY IS NULL THEN 1 ELSE 0 END) AS null_security_delay,
    SUM(CASE WHEN AIRLINE_DELAY IS NULL THEN 1 ELSE 0 END) AS null_airline_delay,
    SUM(CASE WHEN LATE_AIRCRAFT_DELAY IS NULL THEN 1 ELSE 0 END) AS null_late_aircraft_delay,
    SUM(CASE WHEN WEATHER_DELAY IS NULL THEN 1 ELSE 0 END) AS null_weather_delay
FROM flights;
USE airline_db;

CREATE OR REPLACE VIEW vw_flight_cleaned AS
SELECT
    f.YEAR,
    f.MONTH,
    f.DAY,
    STR_TO_DATE(CONCAT(f.YEAR, '-', f.MONTH, '-', f.DAY), '%Y-%m-%d') AS flight_date,

    f.DAY_OF_WEEK,
    CASE f.DAY_OF_WEEK
        WHEN 1 THEN 'Monday'
        WHEN 2 THEN 'Tuesday'
        WHEN 3 THEN 'Wednesday'
        WHEN 4 THEN 'Thursday'
        WHEN 5 THEN 'Friday'
        WHEN 6 THEN 'Saturday'
        WHEN 7 THEN 'Sunday'
    END AS day_name,

    f.AIRLINE,
    a.AIRLINE AS airline_name,

    f.FLIGHT_NUMBER,
    f.TAIL_NUMBER,

    f.ORIGIN_AIRPORT,
    oa.AIRPORT AS origin_airport_name,
    oa.CITY AS origin_city,
    oa.STATE AS origin_state,

    f.DESTINATION_AIRPORT,
    da.AIRPORT AS destination_airport_name,
    da.CITY AS destination_city,
    da.STATE AS destination_state,

    f.SCHEDULED_DEPARTURE,
    FLOOR(CAST(f.SCHEDULED_DEPARTURE AS UNSIGNED) / 100) AS scheduled_departure_hour,

    f.DEPARTURE_DELAY,
    f.ARRIVAL_DELAY,

    f.DISTANCE,
    f.DIVERTED,
    f.CANCELLED,

    f.CANCELLATION_REASON,
    CASE f.CANCELLATION_REASON
        WHEN 'A' THEN 'Airline/Carrier'
        WHEN 'B' THEN 'Weather'
        WHEN 'C' THEN 'National Air System'
        WHEN 'D' THEN 'Security'
        ELSE 'Not Cancelled'
    END AS cancellation_reason_desc,

    f.AIR_SYSTEM_DELAY,
    f.SECURITY_DELAY,
    f.AIRLINE_DELAY,
    f.LATE_AIRCRAFT_DELAY,
    f.WEATHER_DELAY,

    CASE
        WHEN f.CANCELLED = 0 AND f.DIVERTED = 0 THEN 1
        ELSE 0
    END AS completed_flag,

    CASE
        WHEN f.CANCELLED = 0
         AND f.DIVERTED = 0
         AND f.ARRIVAL_DELAY <= 15 THEN 1
        ELSE 0
    END AS on_time_flag

FROM flights f
LEFT JOIN airlines a
    ON f.AIRLINE = a.IATA_CODE
LEFT JOIN airports oa
    ON f.ORIGIN_AIRPORT = oa.IATA_CODE
LEFT JOIN airports da
    ON f.DESTINATION_AIRPORT = da.IATA_CODE;
    
SELECT *
FROM vw_flight_cleaned
LIMIT 10;    

USE airline_db;

SELECT
    CASE CANCELLATION_REASON
        WHEN 'A' THEN 'Airline/Carrier'
        WHEN 'B' THEN 'Weather'
        WHEN 'C' THEN 'National Air System'
        WHEN 'D' THEN 'Security'
        ELSE 'Not Cancelled'
    END AS cancellation_reason_desc,
    COUNT(*) AS total_flights
FROM flights
GROUP BY cancellation_reason_desc
ORDER BY total_flights DESC;

SELECT
    CASE
        WHEN CANCELLED = 0
         AND DIVERTED = 0
         AND ARRIVAL_DELAY <= 15 THEN 'On Time'
        ELSE 'Not On Time'
    END AS arrival_status,
    COUNT(*) AS total_flights
FROM flights
GROUP BY arrival_status;