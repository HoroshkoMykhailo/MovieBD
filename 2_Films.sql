SELECT
    m.id AS "ID",
    m.title AS "Title",
    COUNT(mc.actor_id) AS "Actors count"
FROM
    Movies m
LEFT JOIN
    MovieCharacters mc ON m.id = mc.movie_id
WHERE
    m.release_date >= (CURRENT_DATE - INTERVAL '5 years')
GROUP BY
    m.id, m.title
ORDER BY
    "Actors count" DESC;