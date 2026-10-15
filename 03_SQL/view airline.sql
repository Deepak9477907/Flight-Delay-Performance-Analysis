SELECT 
    COUNT(*) AS total_flights,
    SUM(CANCELLED) AS total_cancelled,
    ROUND(SUM(CANCELLED)/COUNT(*)*100,2) AS cancel_rate,
    SUM(on_time_flag) AS on_time,
    ROUND(SUM(on_time_flag)/COUNT(*)*100,2) AS otp_rate
FROM vw_flight_cleaned;
use airline_db;
CREATE OR REPLACE VIEW vw_delay_type AS
SELECT 'Airline Delay' AS delay_type, 
        SUM(AIRLINE_DELAY) AS total_minutes
FROM vw_flight_cleaned
UNION ALL
SELECT 'Weather Delay', SUM(WEATHER_DELAY)
FROM vw_flight_cleaned
UNION ALL
SELECT 'Air System Delay', SUM(AIR_SYSTEM_DELAY)
FROM vw_flight_cleaned
UNION ALL
SELECT 'Late Aircraft', SUM(LATE_AIRCRAFT_DELAY)
FROM vw_flight_cleaned
UNION ALL
SELECT 'Security Delay', SUM(SECURITY_DELAY)
FROM vw_flight_cleaned;

use airline_db;
CREATE OR REPLACE VIEW vw_busiest_airports AS
SELECT 
    origin_city,
    COUNT(*) AS total_flights,
    ROUND(AVG(ARRIVAL_DELAY), 2) AS avg_delay
FROM vw_flight_cleaned
GROUP BY origin_city
ORDER BY total_flights DESC
LIMIT 10;

CREATE OR REPLACE VIEW vw_hourly_kpi AS
SELECT 
    scheduled_departure_hour AS dep_hour,
    COUNT(*) AS total_flights,
    ROUND(AVG(ARRIVAL_DELAY), 2) AS avg_delay
FROM vw_flight_cleaned
WHERE scheduled_departure_hour IS NOT NULL
GROUP BY scheduled_departure_hour
ORDER BY scheduled_departure_hour;