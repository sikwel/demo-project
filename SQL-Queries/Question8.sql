-- In dem Statement in der FROM-Klausel werden alle Anzahlen berechnet, die für das äußere Statement benötigt werden, es wird zum einen
-- der gesamte Anteil an Verspätungen berechnet, danach in einer Fallunterscheidungen der häufigste Grund für eine Verspätung
-- gesucht. Nicht jedes depature_delay oder arrival_delay lässt sich auf einen der Gründe zurückführen.
-- Hier werden die Flüge aus beiden Richtungen betrachtet, dies kann durch ähnliche Anpassung, wie in den vorherigen Aufgaben angepasst
-- werden.
SELECT 
    origin_airport,
    destination_airport,
    (CAST(summe AS FLOAT)/ CAST(total_flights AS FLOAT) ) * 100 AS percentage_delays_on_total_flights,
    CASE
        WHEN air_system_delay >= GREATEST (security_delay, airline_delay, late_aircraft_delay, weather_delay) THEN 'air_system_delay'
        WHEN security_delay >= GREATEST (air_system_delay, airline_delay, late_aircraft_delay, weather_delay) THEN 'security_delay'
        WHEN airline_delay >= GREATEST (security_delay, air_system_delay, late_aircraft_delay, weather_delay) THEN 'air_line_delay'
        WHEN late_aircraft_delay >= GREATEST (security_delay, airline_delay, air_system_delay, weather_delay) THEN 'late_aircraft_delay'
        WHEN weather_delay >= GREATEST (security_delay, airline_delay, late_aircraft_delay, weather_delay) THEN 'weather_delay'
        END
    AS most_common_delay_reason
FROM(
    SELECT 
        origin_airport,
        destination_airport,
        COUNT(*) AS total_flights,
        SUM(CASE WHEN departure_delay > 0 THEN 1 ELSE 0 END) AS departure_delays,
        SUM(CASE WHEN arrival_delay > 0 THEN 1 ELSE 0 END) AS arrival_delays,
        SUM(CASE WHEN departure_delay > 0 THEN 1 ELSE 0 END) + SUM(CASE WHEN arrival_delay > 0 THEN 1 ELSE 0 END) AS summe,
        SUM(CASE WHEN air_system_delay > 0 THEN 1 ELSE 0 END) AS air_system_delay,
        SUM(CASE WHEN security_delay > 0 THEN 1 ELSE 0 END) AS security_delay,
        SUM(CASE WHEN airline_delay > 0 THEN 1 ELSE 0 END) AS airline_delay,
        SUM(CASE WHEN late_aircraft_delay > 0 THEN 1 ELSE 0 END) AS late_aircraft_delay,
        SUM(CASE WHEN weather_delay > 0 THEN 1 ELSE 0 END) AS weather_delay
    FROM flights
    GROUP BY 
        origin_airport, 
        destination_airport
    ORDER BY summe DESC)