
-- In dieser Variante wird die Richtung der Flüge berücksichtigt. Zuerst werden alle Flüge für eine Richtung berechnet,
-- diese werden pro Airline aufgeschlüsselt. Im nächsten Schritt wird der Anteil dieser Flüge an den Flügen für eine Richtung berechnet.
-- In einem weiteren Schritt wird der prozentuale Anteil der einzelnen Airlines an den Flügen berechnet und pro Strecke ein
-- Rang erstellt, damit am Ende pro Strecke die Airline mit dem größten Anteil an den Flügen ausgegeben werden kann.
WITH flight_count AS(
SELECT
    origin_airport,
    destination_airport,
    airline,
    COUNT(*) AS flights_per_airline,
    SUM(COUNT(*)) OVER (PARTITION BY origin_airport, destination_airport) AS total_flights_on_route
FROM flights
GROUP BY 
    origin_airport, 
    destination_airport, 
    airline
ORDER BY total_flights_on_route DESC
), calc_proportion AS (
    SELECT
        origin_airport,
        destination_airport,
        airline,
        ROUND((flights_per_airline/total_flights_on_route) * 100, 2) AS proportion,
        total_flights_on_route,
        flights_per_airline
    FROM flight_count
), ranked AS (
    SELECT
        *,
        RANK() OVER (PARTITION BY origin_airport, destination_airport ORDER BY proportion DESC) AS rank
    FROM calc_proportion
)
SELECT 
    origin_airport,
    destination_airport,
    airline,
    total_flights_on_route,
    flights_per_airline,
    proportion
FROM ranked
WHERE rank = 1
ORDER BY total_flights_on_route DESC;


-- Die zweite Abfrage ist vom Aufbau wie die erste Form hier wird bloß eine Strecke unabhängig von ihrer Richtung betrachtet.
-- Die beiden Airports werden hinsichtlich ihrer Bezeichnungen vergleich sodass jeweils die "kleinere" Bezeichnung dem ersten
-- Airport zugerechnet wird und die "größere" Bezeichnung dem zweiten Airport
WITH flight_count AS (
    SELECT
        CASE 
            WHEN origin_airport < destination_airport THEN origin_airport 
            ELSE destination_airport 
        END AS airport1,
        CASE 
            WHEN origin_airport < destination_airport THEN destination_airport 
            ELSE origin_airport 
        END AS airport2,
        airline,
        COUNT(*) AS flights_per_airline,
        SUM(COUNT(*)) OVER (PARTITION BY 
            CASE 
                WHEN origin_airport < destination_airport THEN origin_airport 
                ELSE destination_airport 
            END, 
            CASE 
                WHEN origin_airport < destination_airport THEN destination_airport 
                ELSE origin_airport 
            END) AS total_flights_on_route
    FROM flights 
    GROUP BY 
        airport1,
        airport2, 
        airline
), calc_proportion AS (
    SELECT
        airport1,
        airport2,
        airline,
        ROUND((flights_per_airline / total_flights_on_route) * 100, 2) AS proportion,
        total_flights_on_route,
        flights_per_airline
    FROM flight_count
),ranked AS (
    SELECT
        airport1,
        airport2,
        airline,
        proportion,
        total_flights_on_route,
        flights_per_airline,
        RANK() OVER (PARTITION BY airport1, airport2 ORDER BY proportion DESC) AS rank
    FROM calc_proportion
)
SELECT 
    airport1,
    airport2,
    airline AS airline_with_biggest_proportion,
    total_flights_on_route,
    flights_per_airline,
    proportion
FROM ranked
WHERE rank = 1
ORDER BY total_flights_on_route DESC;