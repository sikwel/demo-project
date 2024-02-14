-- durchschnittliche Verspätung am Ziel- bzw. Startflughafen
SELECT 
    airline,
    ROUND(AVG(departure_delay), 2) AS avg_depature_delay,
    ROUND(AVG(arrival_delay), 2) AS avg_arrival_delay
FROM flights 
GROUP BY airline