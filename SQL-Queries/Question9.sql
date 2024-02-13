-- Erst die Berechnung aller delays pro Wochentag, hier wurde so gerechnet das ein Flug zwei delays haben kann, wie man nur ein delay 
-- einbeziehen würde, ist im Statement erklärt. Im zweiten Schritt werden alle Flüge pro Wochentag berechnet. Im dritten Schritt
-- wird auf Grundlage der Wochentage gejoint und nach den prozentualen delays und totalen delay ausgegeben
WITH total_delays_table AS (
    SELECT 
        day_of_week,
        SUM(CASE WHEN departure_delay > 0 THEN 1 ELSE 0 END) + SUM(CASE WHEN arrival_delay > 0 THEN 1 ELSE 0 END) AS total_delays
    FROM flights
    --WHERE departure_delay > 0 OR arrival_delay > 0 wenn diese Zeile bleibt und total_delay durch COUNT(*) berechnet wird, wird nur eine Verpätung pro Flug gezählt
    GROUP BY day_of_week
), total_flights_table AS (
    SELECT 
        day_of_week,
        COUNT(*) AS total_flights
    FROM flights
    GROUP BY day_of_week
), delay_percentage AS (
    SELECT 
        t.day_of_week,
        t.total_delays,
        f.total_flights,
        (CAST(t.total_delays AS FLOAT) / CAST(f.total_flights AS FLOAT)) * 100 AS percentage_delays
    FROM total_delays_table t
    JOIN total_flights_table f ON t.day_of_week = f.day_of_week
)
SELECT 
    day_of_week,
    total_delays,
    total_flights,
    percentage_delays AS percentage_delays
FROM delay_percentage
ORDER BY total_delays DESC, percentage_delays DESC;