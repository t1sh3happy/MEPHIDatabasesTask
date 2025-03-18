WITH CarResults AS (
    SELECT 
        c.name AS car_name, 
        c.class AS car_class, 
        AVG(r.position) AS average_position,
        COUNT(r.race) AS race_count, 
        cl.country AS car_country
    FROM 
        Results r
    JOIN 
        Cars c ON r.car = c.name
    JOIN 
        Classes cl ON cl.class = c.class
    GROUP BY 
        c.name, c.class, cl.country
    HAVING 
        AVG(r.position) > 3.0
),

ClassResults AS (
    SELECT 
        c.class AS class, 
        COUNT(DISTINCT c.name) AS carcount,
        COUNT(r.race) AS total_races
    FROM 
        Results r
    JOIN 
        Cars c ON r.car = c.name
    GROUP BY 
        c.class
)

SELECT 
    cr.car_name AS carname, 
    cr.car_class AS carclass, 
    cr.average_position AS averageposition,
    cr.race_count AS racecount, 
    cr.car_country AS carcountry, 
    cls.total_races AS totalraces,
    cls.carcount AS lowpositioncount
FROM 
    CarResults cr
JOIN 
    ClassResults cls ON cls.class = cr.car_class
ORDER BY 
    lowpositioncount DESC;
