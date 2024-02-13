--Staaten mit den meisten Annulierungen, dazu left join auf die airports-Tabelle, diese enthält Informationen über die Staaten
SELECT 
    a.state, 
    COUNT(f.cancelled) AS count_cancelled
FROM flights f
LEFT JOIN airports a ON f.origin_airport = a.iata_code
WHERE f.cancelled = True
AND a.state IS NOT NULL
GROUP BY a.state
ORDER BY count_cancelled DESC;

-- Monat mit den meisten Annulierungen und Monat mit den wenigsten Annulierungen,
-- für jeden monat wird die Anzahl der Annulierungen berechnet und ein Rank erstellt um den 1 und 12 Platz herauszufilten
WITH ranked_cancellation AS(
    SELECT 
        EXTRACT(MONTH from Date) AS month,
        COUNT(cancelled) AS count_cancelled_per_month,
        RANK() OVER (ORDER BY COUNT(cancelled) DESC) AS cancellation_rank
    FROM flights 
    WHERE cancelled = True
    GROUP BY 
        month
)
SELECT 
    month,
    count_cancelled_per_month
FROM ranked_cancellation
WHERE cancellation_rank = 1
OR cancellation_rank = 12
