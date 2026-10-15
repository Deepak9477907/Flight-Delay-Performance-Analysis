USE airline_db;

SELECT
    COUNT(*) AS total_flights,
    SUM(CASE WHEN CANCELLED = 0 AND DIVERTED = 0 THEN 1 ELSE 0 END) AS completed_flights,
    SUM(CANCELLED) AS cancelled_flights,
    SUM(DIVERTED) AS diverted_flights,

    ROUND(
        SUM(CASE WHEN CANCELLED = 0 AND DIVERTED = 0 AND ARRIVAL_DELAY <= 15 THEN 1 ELSE 0 END)
        / SUM(CASE WHEN CANCELLED = 0 AND DIVERTED = 0 THEN 1 ELSE 0 END) * 100,
        2
    ) AS on_time_rate_pct,

    ROUND(AVG(DEPARTURE_DELAY), 2) AS avg_departure_delay,
    ROUND(AVG(ARRIVAL_DELAY), 2) AS avg_arrival_delay,

    ROUND(SUM(CANCELLED) / COUNT(*) * 100, 2) AS cancellation_rate_pct,
    ROUND(SUM(DIVERTED) / COUNT(*) * 100, 2) AS diversion_rate_pct
FROM flights;

SELECT
    f.AIRLINE,
    a.AIRLINE AS airline_name,
    COUNT(*) AS total_flights,

    SUM(CASE WHEN f.CANCELLED = 0 AND f.DIVERTED = 0 THEN 1 ELSE 0 END) AS completed_flights,
    SUM(f.CANCELLED) AS cancelled_flights,
    SUM(f.DIVERTED) AS diverted_flights,

    ROUND(
        SUM(CASE WHEN f.CANCELLED = 0 AND f.DIVERTED = 0 AND f.ARRIVAL_DELAY <= 15 THEN 1 ELSE 0 END)
        / SUM(CASE WHEN f.CANCELLED = 0 AND f.DIVERTED = 0 THEN 1 ELSE 0 END) * 100,
        2
    ) AS on_time_rate_pct,

    ROUND(AVG(f.DEPARTURE_DELAY), 2) AS avg_departure_delay,
    ROUND(AVG(f.ARRIVAL_DELAY), 2) AS avg_arrival_delay,

    ROUND(SUM(f.CANCELLED) / COUNT(*) * 100, 2) AS cancellation_rate_pct
FROM flights f
LEFT JOIN airlines a
    ON f.AIRLINE = a.IATA_CODE
GROUP BY f.AIRLINE, a.AIRLINE
ORDER BY on_time_rate_pct DESC;

SELECT
    f.ORIGIN_AIRPORT,
    ap.AIRPORT AS origin_airport_name,
    ap.CITY,
    ap.STATE,
    COUNT(*) AS total_departures,

    ROUND(
        SUM(CASE WHEN f.CANCELLED = 0 AND f.DIVERTED = 0 AND f.ARRIVAL_DELAY <= 15 THEN 1 ELSE 0 END)
        / SUM(CASE WHEN f.CANCELLED = 0 AND f.DIVERTED = 0 THEN 1 ELSE 0 END) * 100,
        2
    ) AS on_time_rate_pct,

    ROUND(AVG(f.DEPARTURE_DELAY), 2) AS avg_departure_delay,
    ROUND(AVG(f.ARRIVAL_DELAY), 2) AS avg_arrival_delay,

    ROUND(SUM(f.CANCELLED) / COUNT(*) * 100, 2) AS cancellation_rate_pct

FROM flights f
LEFT JOIN airports ap
    ON f.ORIGIN_AIRPORT = ap.IATA_CODE
GROUP BY f.ORIGIN_AIRPORT, ap.AIRPORT, ap.CITY, ap.STATE
ORDER BY total_departures DESC
LIMIT 10;

SELECT
    MONTH,
    COUNT(*) AS total_flights,

    SUM(CASE WHEN CANCELLED = 0 AND DIVERTED = 0 THEN 1 ELSE 0 END) AS completed_flights,
    SUM(CANCELLED) AS cancelled_flights,

    ROUND(
        SUM(CASE WHEN CANCELLED = 0 AND DIVERTED = 0 AND ARRIVAL_DELAY <= 15 THEN 1 ELSE 0 END)
        / SUM(CASE WHEN CANCELLED = 0 AND DIVERTED = 0 THEN 1 ELSE 0 END) * 100,
        2
    ) AS on_time_rate_pct,

    ROUND(AVG(DEPARTURE_DELAY), 2) AS avg_departure_delay,
    ROUND(AVG(ARRIVAL_DELAY), 2) AS avg_arrival_delay,

    ROUND(SUM(CANCELLED) / COUNT(*) * 100, 2) AS cancellation_rate_pct

FROM flights
GROUP BY MONTH
ORDER BY MONTH;

SELECT
    DAY_OF_WEEK,
    CASE DAY_OF_WEEK
        WHEN 1 THEN 'Monday'
        WHEN 2 THEN 'Tuesday'
        WHEN 3 THEN 'Wednesday'
        WHEN 4 THEN 'Thursday'
        WHEN 5 THEN 'Friday'
        WHEN 6 THEN 'Saturday'
        WHEN 7 THEN 'Sunday'
    END AS day_name,

    COUNT(*) AS total_flights,

    ROUND(
        SUM(CASE WHEN CANCELLED = 0 AND DIVERTED = 0 AND ARRIVAL_DELAY <= 15 THEN 1 ELSE 0 END)
        / SUM(CASE WHEN CANCELLED = 0 AND DIVERTED = 0 THEN 1 ELSE 0 END) * 100,
        2
    ) AS on_time_rate_pct,

    ROUND(AVG(DEPARTURE_DELAY), 2) AS avg_departure_delay,
    ROUND(AVG(ARRIVAL_DELAY), 2) AS avg_arrival_delay,

    ROUND(SUM(CANCELLED) / COUNT(*) * 100, 2) AS cancellation_rate_pct

FROM flights
GROUP BY DAY_OF_WEEK
ORDER BY DAY_OF_WEEK;

SELECT
    FLOOR(CAST(SCHEDULED_DEPARTURE AS UNSIGNED) / 100) AS scheduled_departure_hour,

    COUNT(*) AS total_flights,

    ROUND(
        SUM(CASE WHEN CANCELLED = 0 AND DIVERTED = 0 AND ARRIVAL_DELAY <= 15 THEN 1 ELSE 0 END)
        / SUM(CASE WHEN CANCELLED = 0 AND DIVERTED = 0 THEN 1 ELSE 0 END) * 100,
        2
    ) AS on_time_rate_pct,

    ROUND(AVG(DEPARTURE_DELAY), 2) AS avg_departure_delay,
    ROUND(AVG(ARRIVAL_DELAY), 2) AS avg_arrival_delay,

    ROUND(SUM(CANCELLED) / COUNT(*) * 100, 2) AS cancellation_rate_pct

FROM flights
GROUP BY scheduled_departure_hour
ORDER BY scheduled_departure_hour;


SELECT
    'Air System Delay' AS delay_type,
    SUM(AIR_SYSTEM_DELAY) AS total_delay_minutes
FROM flights

UNION ALL

SELECT
    'Security Delay' AS delay_type,
    SUM(SECURITY_DELAY) AS total_delay_minutes
FROM flights

UNION ALL

SELECT
    'Airline Delay' AS delay_type,
    SUM(AIRLINE_DELAY) AS total_delay_minutes
FROM flights

UNION ALL

SELECT
    'Late Aircraft Delay' AS delay_type,
    SUM(LATE_AIRCRAFT_DELAY) AS total_delay_minutes
FROM flights

UNION ALL

SELECT
    'Weather Delay' AS delay_type,
    SUM(WEATHER_DELAY) AS total_delay_minutes
FROM flights

ORDER BY total_delay_minutes DESC;

SELECT
    ORIGIN_AIRPORT,
    DESTINATION_AIRPORT,
    COUNT(*) AS total_flights,

    ROUND(
        SUM(CASE WHEN CANCELLED = 0 AND DIVERTED = 0 AND ARRIVAL_DELAY <= 15 THEN 1 ELSE 0 END)
        / SUM(CASE WHEN CANCELLED = 0 AND DIVERTED = 0 THEN 1 ELSE 0 END) * 100,
        2
    ) AS on_time_rate_pct,

    ROUND(AVG(DEPARTURE_DELAY), 2) AS avg_departure_delay,
    ROUND(AVG(ARRIVAL_DELAY), 2) AS avg_arrival_delay,

    ROUND(SUM(CANCELLED) / COUNT(*) * 100, 2) AS cancellation_rate_pct

FROM flights
GROUP BY ORIGIN_AIRPORT, DESTINATION_AIRPORT
ORDER BY total_flights DESC
LIMIT 10;

SELECT
    ORIGIN_AIRPORT,
    DESTINATION_AIRPORT,
    COUNT(*) AS total_flights,

    ROUND(AVG(DEPARTURE_DELAY), 2) AS avg_departure_delay,
    ROUND(AVG(ARRIVAL_DELAY), 2) AS avg_arrival_delay,

    ROUND(
        SUM(CASE WHEN CANCELLED = 0 AND DIVERTED = 0 AND ARRIVAL_DELAY <= 15 THEN 1 ELSE 0 END)
        / SUM(CASE WHEN CANCELLED = 0 AND DIVERTED = 0 THEN 1 ELSE 0 END) * 100,
        2
    ) AS on_time_rate_pct

FROM flights
WHERE CANCELLED = 0
  AND DIVERTED = 0
GROUP BY ORIGIN_AIRPORT, DESTINATION_AIRPORT
HAVING COUNT(*) >= 500
ORDER BY avg_arrival_delay DESC
LIMIT 10;

USE airline_db;

CREATE OR REPLACE VIEW vw_overall_kpi AS
SELECT
    COUNT(*) AS total_flights,
    SUM(CASE WHEN CANCELLED = 0 AND DIVERTED = 0 THEN 1 ELSE 0 END) AS completed_flights,
    SUM(CANCELLED) AS cancelled_flights,
    SUM(DIVERTED) AS diverted_flights,

    ROUND(
        SUM(CASE WHEN CANCELLED = 0 AND DIVERTED = 0 AND ARRIVAL_DELAY <= 15 THEN 1 ELSE 0 END)
        / SUM(CASE WHEN CANCELLED = 0 AND DIVERTED = 0 THEN 1 ELSE 0 END) * 100,
        2
    ) AS on_time_rate_pct,

    ROUND(AVG(DEPARTURE_DELAY), 2) AS avg_departure_delay,
    ROUND(AVG(ARRIVAL_DELAY), 2) AS avg_arrival_delay,

    ROUND(SUM(CANCELLED) / COUNT(*) * 100, 2) AS cancellation_rate_pct,
    ROUND(SUM(DIVERTED) / COUNT(*) * 100, 2) AS diversion_rate_pct
FROM flights;

SELECT * FROM vw_overall_kpi;
CREATE OR REPLACE VIEW vw_airline_kpi AS
SELECT
    f.AIRLINE AS airline_code,
    a.AIRLINE AS airline_name,
    COUNT(*) AS total_flights,

    SUM(CASE WHEN f.CANCELLED = 0 AND f.DIVERTED = 0 THEN 1 ELSE 0 END) AS completed_flights,
    SUM(f.CANCELLED) AS cancelled_flights,
    SUM(f.DIVERTED) AS diverted_flights,

    ROUND(
        SUM(CASE WHEN f.CANCELLED = 0 AND f.DIVERTED = 0 AND f.ARRIVAL_DELAY <= 15 THEN 1 ELSE 0 END)
        / SUM(CASE WHEN f.CANCELLED = 0 AND f.DIVERTED = 0 THEN 1 ELSE 0 END) * 100,
        2
    ) AS on_time_rate_pct,

    ROUND(AVG(f.DEPARTURE_DELAY), 2) AS avg_departure_delay,
    ROUND(AVG(f.ARRIVAL_DELAY), 2) AS avg_arrival_delay,

    ROUND(SUM(f.CANCELLED) / COUNT(*) * 100, 2) AS cancellation_rate_pct

FROM flights f
LEFT JOIN airlines a
    ON f.AIRLINE = a.IATA_CODE
GROUP BY f.AIRLINE, a.AIRLINE;

SELECT *
FROM vw_airline_kpi
ORDER BY on_time_rate_pct DESC;

CREATE OR REPLACE VIEW vw_airport_kpi AS
SELECT
    f.ORIGIN_AIRPORT AS airport_code,
    ap.AIRPORT AS airport_name,
    ap.CITY AS city,
    ap.STATE AS state,
    COUNT(*) AS total_departures,
    ROUND(
        SUM(CASE WHEN f.CANCELLED = 0 AND f.DIVERTED = 0 AND f.ARRIVAL_DELAY <= 15 THEN 1 ELSE 0 END)
        / SUM(CASE WHEN f.CANCELLED = 0 AND f.DIVERTED = 0 THEN 1 ELSE 0 END) * 100,
        2
    ) AS on_time_rate_pct,
    ROUND(AVG(f.DEPARTURE_DELAY), 2) AS avg_departure_delay,
    ROUND(AVG(f.ARRIVAL_DELAY), 2) AS avg_arrival_delay,
    ROUND(SUM(f.CANCELLED) / COUNT(*) * 100, 2) AS cancellation_rate_pct
FROM flights f
LEFT JOIN airports ap
    ON f.ORIGIN_AIRPORT = ap.IATA_CODE
GROUP BY f.ORIGIN_AIRPORT, ap.AIRPORT, ap.CITY, ap.STATE;

CREATE OR REPLACE VIEW vw_monthly_kpi AS
SELECT
    MONTH,
    CASE MONTH
        WHEN 1 THEN 'Jan'
        WHEN 2 THEN 'Feb'
        WHEN 3 THEN 'Mar'
        WHEN 4 THEN 'Apr'
        WHEN 5 THEN 'May'
        WHEN 6 THEN 'Jun'
        WHEN 7 THEN 'Jul'
        WHEN 8 THEN 'Aug'
        WHEN 9 THEN 'Sep'
        WHEN 10 THEN 'Oct'
        WHEN 11 THEN 'Nov'
        WHEN 12 THEN 'Dec'
    END AS month_name,
    COUNT(*) AS total_flights,
    SUM(CANCELLED) AS cancelled_flights,
    ROUND(
        SUM(CASE WHEN CANCELLED = 0 AND DIVERTED = 0 AND ARRIVAL_DELAY <= 15 THEN 1 ELSE 0 END)
        / SUM(CASE WHEN CANCELLED = 0 AND DIVERTED = 0 THEN 1 ELSE 0 END) * 100,
        2
    ) AS on_time_rate_pct,
    ROUND(AVG(DEPARTURE_DELAY), 2) AS avg_departure_delay,
    ROUND(AVG(ARRIVAL_DELAY), 2) AS avg_arrival_delay,
    ROUND(SUM(CANCELLED) / COUNT(*) * 100, 2) AS cancellation_rate_pct
FROM flights
GROUP BY MONTH;

CREATE OR REPLACE VIEW vw_dayofweek_kpi AS
SELECT
    DAY_OF_WEEK,
    CASE DAY_OF_WEEK
        WHEN 1 THEN 'Monday'
        WHEN 2 THEN 'Tuesday'
        WHEN 3 THEN 'Wednesday'
        WHEN 4 THEN 'Thursday'
        WHEN 5 THEN 'Friday'
        WHEN 6 THEN 'Saturday'
        WHEN 7 THEN 'Sunday'
    END AS day_name,
    COUNT(*) AS total_flights,
    ROUND(
        SUM(CASE WHEN CANCELLED = 0 AND DIVERTED = 0 AND ARRIVAL_DELAY <= 15 THEN 1 ELSE 0 END)
        / SUM(CASE WHEN CANCELLED = 0 AND DIVERTED = 0 THEN 1 ELSE 0 END) * 100,
        2
    ) AS on_time_rate_pct,
    ROUND(AVG(DEPARTURE_DELAY), 2) AS avg_departure_delay,
    ROUND(AVG(ARRIVAL_DELAY), 2) AS avg_arrival_delay,
    ROUND(SUM(CANCELLED) / COUNT(*) * 100, 2) AS cancellation_rate_pct
FROM flights
GROUP BY DAY_OF_WEEK;
CREATE OR REPLACE VIEW vw_hourly_kpi AS
SELECT
    FLOOR(CAST(SCHEDULED_DEPARTURE AS UNSIGNED) / 100) AS scheduled_departure_hour,
    COUNT(*) AS total_flights,
    ROUND(
        SUM(CASE WHEN CANCELLED = 0 AND DIVERTED = 0 AND ARRIVAL_DELAY <= 15 THEN 1 ELSE 0 END)
        / SUM(CASE WHEN CANCELLED = 0 AND DIVERTED = 0 THEN 1 ELSE 0 END) * 100,
        2
    ) AS on_time_rate_pct,
    ROUND(AVG(DEPARTURE_DELAY), 2) AS avg_departure_delay,
    ROUND(AVG(ARRIVAL_DELAY), 2) AS avg_arrival_delay,
    ROUND(SUM(CANCELLED) / COUNT(*) * 100, 2) AS cancellation_rate_pct
FROM flights
GROUP BY scheduled_departure_hour;

CREATE OR REPLACE VIEW vw_cancellation_reason_kpi AS
SELECT
    CASE CANCELLATION_REASON
        WHEN 'A' THEN 'Airline/Carrier'
        WHEN 'B' THEN 'Weather'
        WHEN 'C' THEN 'National Air System'
        WHEN 'D' THEN 'Security'
        ELSE 'Not Cancelled'
    END AS cancellation_reason,
    COUNT(*) AS total_flights
FROM flights
GROUP BY cancellation_reason;
CREATE OR REPLACE VIEW vw_delay_type_kpi AS
SELECT 'Late Aircraft Delay' AS delay_type, SUM(LATE_AIRCRAFT_DELAY) AS total_delay_minutes FROM flights
UNION ALL
SELECT 'Airline Delay', SUM(AIRLINE_DELAY) FROM flights
UNION ALL
SELECT 'Air System Delay', SUM(AIR_SYSTEM_DELAY) FROM flights
UNION ALL
SELECT 'Weather Delay', SUM(WEATHER_DELAY) FROM flights
UNION ALL
SELECT 'Security Delay', SUM(SECURITY_DELAY) FROM flights;

CREATE OR REPLACE VIEW vw_route_kpi AS
SELECT
    ORIGIN_AIRPORT,
    DESTINATION_AIRPORT,
    COUNT(*) AS total_flights,
    ROUND(
        SUM(CASE WHEN CANCELLED = 0 AND DIVERTED = 0 AND ARRIVAL_DELAY <= 15 THEN 1 ELSE 0 END)
        / SUM(CASE WHEN CANCELLED = 0 AND DIVERTED = 0 THEN 1 ELSE 0 END) * 100,
        2
    ) AS on_time_rate_pct,
    ROUND(AVG(DEPARTURE_DELAY), 2) AS avg_departure_delay,
    ROUND(AVG(ARRIVAL_DELAY), 2) AS avg_arrival_delay,
    ROUND(SUM(CANCELLED) / COUNT(*) * 100, 2) AS cancellation_rate_pct
FROM flights
GROUP BY ORIGIN_AIRPORT, DESTINATION_AIRPORT;

-- ✅ FIX: Error 1052 - Ambiguous column in GROUP BY

CREATE OR REPLACE VIEW vw_cancellation_reason_kpi AS
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
GROUP BY
    CASE CANCELLATION_REASON
        WHEN 'A' THEN 'Airline/Carrier'
        WHEN 'B' THEN 'Weather'
        WHEN 'C' THEN 'National Air System'
        WHEN 'D' THEN 'Security'
        ELSE 'Not Cancelled'
    END;

-- ✅ Verify
SELECT * FROM vw_cancellation_reason_kpi
ORDER BY total_flights DESC;