SELECT
    p.id AS "Director ID",
    CONCAT(p.first_name, ' ', p.last_name) AS "Director name",
    AVG(m.budget) AS "Average budget"
FROM
    Person p
JOIN
    Movies m ON p.id = m.director_id
GROUP BY
    p.id, p.first_name, p.last_name
ORDER BY
    "Average budget" DESC;