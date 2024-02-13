-- Berechnung der Wetterverspätungen pro Flug (Berücksichtigung der Richtung)
SELECT 
    origin_airport,
    destination_airport,
    weather_delay
FROM flights
WHERE weather_delay != 0
AND weather_delay IS NOT NULL
ORDER BY weather_delay DESC;


-- Hier wird wieder die Strecke unabhängig von der Richtung betrachtet.
-- Es werden für alle Strecken, die Anzahl der Verpätungen, deren Grund das Wetter war, berechnet.
SELECT 
    CASE 
        WHEN origin_airport < destination_airport THEN origin_airport 
        ELSE destination_airport 
    END AS airport1,
    CASE 
        WHEN origin_airport < destination_airport THEN destination_airport 
        ELSE origin_airport 
    END AS airport2,
    COUNT(weather_delay) AS count_weather_delay_per_route
FROM flights 
WHERE weather_delay != 0
AND weather_delay IS NOT NULL
GROUP BY 
    airport1,
    airport2
ORDER BY count_weather_delay_per_route DESC;