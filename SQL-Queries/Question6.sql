-- Die inneren Abfragen berechnen einmal die Anzahl der verspäteten Flüge und die Anzahl der pünktlichen Flüge 
-- die Abfragen werden über den Airlin Identifier gejoint und es werden in der äußeren Abfrage die jeweiligen Anteil an der
-- Gesamtzahl berechnet
SELECT 
    d.airline,
    d.count_delayed_arrival / (CAST(d.count_delayed_arrival AS FLOAT) + CAST(nd.count_non_delayed_arrival AS FLOAT)) * 100 AS portion_delayed,
    nd.count_non_delayed_arrival/ (CAST(d.count_delayed_arrival AS FLOAT) + CAST(nd.count_non_delayed_arrival AS FLOAT)) * 100 AS portion_non_delayed
FROM 
    (SELECT 
        airline,
        COUNT(*) AS count_delayed_arrival
    FROM flights 
    WHERE arrival_delay > 15
    GROUP BY airline) AS d
FULL JOIN
    (SELECT
        airline,
        COUNT(*) AS count_non_delayed_arrival
    FROM flights
    WHERE arrival_delay <= 15
    GROUP BY airline) AS nd
ON d.airline = nd.airline;

-- Airline mit den größten Anteil an sehr verspäteten Flügen
-- Es wird die Gesamtzahl der stark verspäteten Flügen berechnet und die Anzahl der stark verspäteten pro Airline. 
-- durch einen crossjoin wird die Gesamtzahl an alle Zeilen in einer zusätzlichen Spalte gefügt um den prozentualen Anteil zu berechen.
SELECT c.airline
FROM (
SELECT
    ca.airline,
    ca.count_much_to_late_per_airline,
    cc.count_much_to_late,
    (CAST(ca.count_much_to_late_per_airline AS FLOAT) / CAST(cc.count_much_to_late AS FLOAT)) * 100 AS airline_portion_on_all
FROM 
    (SELECT 
        COUNT(*) AS count_much_to_late
     FROM flights
     WHERE arrival_delay > 45) AS cc
CROSS JOIN 
    (SELECT 
        airline,
        COUNT(*) AS count_much_to_late_per_airline
     FROM flights 
     WHERE arrival_delay > 45
     GROUP BY airline) AS ca
) AS c
ORDER BY c.airline_portion_on_all DESC
LIMIT 1;