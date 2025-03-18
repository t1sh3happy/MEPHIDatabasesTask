WITH HotelCategories AS (
    SELECT 
        h.ID_hotel, 
        h.name AS hotel_name,
        CASE
            WHEN AVG(r.price) < 175 THEN 'Дешевый'
            WHEN AVG(r.price) BETWEEN 175 AND 300 THEN 'Средний'
            ELSE 'Дорогой'
        END AS category
    FROM 
        Hotel h
    JOIN 
        Room r ON h.id_hotel = r.id_hotel
    GROUP BY 
        h.ID_hotel
),
CustomerPreferences AS (
    SELECT
        c.ID_customer,
        c.name,
        COUNT(DISTINCT CASE WHEN hc.category = 'Дешевый' THEN hc.id_hotel END) AS cheapcount,
        COUNT(DISTINCT CASE WHEN hc.category = 'Средний' THEN hc.id_hotel END) AS mediumcount,
        COUNT(DISTINCT CASE WHEN hc.category = 'Дорогой' THEN hc.id_hotel END) AS expensivecount,
        STRING_AGG(DISTINCT hc.hotel_name, ', ') AS visited_hotels  
    FROM 
        Customer c
    JOIN 
        Booking b ON c.id_customer = b.id_customer
    JOIN 
        Room r ON b.id_room = r.id_room
    JOIN 
        HotelCategories hc ON r.id_hotel = hc.id_hotel
    GROUP BY 
        c.ID_customer, c.name
)
SELECT
    ID_customer, 
    name,
    CASE
        WHEN customerpreferences.expensivecount > 0 THEN 'Дорогой'
        WHEN customerpreferences.mediumcount > 0 THEN 'Средний'
        WHEN customerpreferences.cheapcount > 0 THEN 'Дешевый'
    END AS preferredhoteltype,
    visited_hotels
FROM
    CustomerPreferences
ORDER BY 
    CASE 
        WHEN customerpreferences.expensivecount > 0 THEN 3
        WHEN customerpreferences.mediumcount > 0 THEN 2
        ELSE 1 
    END, 
    ID_customer;
