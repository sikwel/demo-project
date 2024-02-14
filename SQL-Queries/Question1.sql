-- alle Routen die von DCA ausgehen und die nicht gestrichen wurden
SELECT 
    date, 
    origin_airport, 
    destination_airport, 
    cancellation_reason
FROM flights
WHERE origin_airport = 'DCA'
AND cancellation_reason IS NOT NULL