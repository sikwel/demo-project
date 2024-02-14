--Die Top 10 Airlines, die die meisten Flughäfen (DISTINCT) ansteuern
SELECT 
    airline,
    COUNT(DISTINCT(destination_airport)) AS count_destination
FROM flights
GROUP BY airline
ORDER BY count_destination DESC
LIMIT 10;