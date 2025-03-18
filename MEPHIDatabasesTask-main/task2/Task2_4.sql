WITH ClassAverages AS (
    SELECT 
        c.class, 
        AVG(r.position) AS avgclassposition,
        COUNT(DISTINCT c.name) AS car_count
    FROM 
        Results r
    INNER JOIN 
        Cars c ON r.car = c.name
    GROUP BY 
        c.class
    HAVING 
        COUNT(DISTINCT c.name) >= 2
),

CarResults AS (
    SELECT 
        c.name AS car_name, 
        c.class AS car_class, 
        AVG(r.position) AS averageposition,
        COUNT(r.race) AS race_count, 
        cl.country AS car_country
    FROM 
        Results r
    INNER JOIN 
        Cars c ON r.car = c.name
    INNER JOIN 
        Classes cl ON c.class = cl.class
    GROUP BY 
        c.name, c.class, cl.country
)

SELECT 
    cr.car_name, 
    cr.car_class, 
    cr.averageposition, 
    cr.race_count, 
    cr.car_country
FROM 
    CarResults cr
INNER JOIN 
    ClassAverages ca ON ca.class = cr.car_class
WHERE 
    cr.averageposition < ca.avgclassposition
ORDER BY 
    cr.car_class, cr.averageposition;
