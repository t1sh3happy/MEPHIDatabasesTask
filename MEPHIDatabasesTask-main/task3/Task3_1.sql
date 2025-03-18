SELECT
    c.name AS customer_name,
    c.email AS customer_email,
    c.phone AS customer_phone,
    COUNT(b.id_booking) AS totalbookings,
    STRING_AGG(DISTINCT h.name, ', ') AS hotels,
   AVG((b.check_out_date - b.check_in_date)) AS averagestayduration  
FROM 
    Customer c
JOIN 
    Booking b ON c.id_customer = b.id_customer
JOIN 
    Room r ON b.id_room = r.id_room
JOIN 
    Hotel h ON r.id_hotel = h.id_hotel
GROUP BY 
    c.id_customer
HAVING 
    COUNT(DISTINCT h.id_hotel) > 1 AND COUNT(b.id_booking) > 2
ORDER BY 
    totalbookings DESC;
