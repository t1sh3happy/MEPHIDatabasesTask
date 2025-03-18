WITH BookingAnalysis AS (
    SELECT
        c.ID_customer,
        c.name,
        COUNT(b.id_booking) AS totalbookings,
        SUM(r.price * (b.check_out_date - b.check_in_date)) AS total_spent,
        COUNT(DISTINCT h.id_hotel) AS uniquehotels
    FROM Customer c
    JOIN Booking b ON c.id_customer = b.id_customer
    JOIN Room r ON b.id_room = r.id_room
    JOIN Hotel h ON r.id_hotel = h.id_hotel
    GROUP BY c.ID_customer
)

SELECT
    ID_customer,
    name,
    bookinganalysis.totalbookings,
    total_spent,
    bookinganalysis.uniquehotels
FROM 
    BookingAnalysis
WHERE
    uniquehotels > 1 AND totalbookings > 2 AND total_spent > 500
ORDER BY total_spent ASC;
