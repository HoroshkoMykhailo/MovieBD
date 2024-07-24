SELECT
    p.id AS "ID",
    p.first_name AS "First name",
    p.last_name AS "Last name",
    COALESCE(SUM(m.budget), 0) AS "Total movies budget"
FROM
    Person p
LEFT JOIN
    MovieCharacters mc ON p.id = mc.actor_id
LEFT JOIN
    Movies m ON mc.movie_id = m.id
GROUP BY
    p.id, p.first_name, p.last_name
ORDER BY
	"Total movies budget" DESC;