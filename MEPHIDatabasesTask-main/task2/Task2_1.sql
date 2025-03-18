WITH CarResults AS (
    SELECT c.class, r.car, AVG(r.position) AS avg_pos, COUNT(r.race) AS race_count
    FROM Results r
    JOIN Cars c ON r.car = c.name
    GROUP BY c.class, r.car
),

MinAvgPosition AS (
    SELECT class, car, avg_pos, race_count, RANK() OVER (PARTITION BY class ORDER BY avg_pos) AS rank
    FROM CarResults
)

SELECT car AS car_name, class AS car_class, avg_pos AS average_position, race_count
FROM MinAvgPosition
WHERE rank = 1
ORDER BY avg_pos;
