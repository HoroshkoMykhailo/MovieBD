WITH movie_genres AS (
    SELECT
        m.id AS movie_id,
        m.title,
        m.release_date,
        m.duration,
        m.description,
        p.id AS director_id,
        p.first_name,
        p.last_name,
        g.name AS genre
    FROM
        Movies m
    JOIN
        MovieGenres mg ON m.id = mg.movie_id
    JOIN
        Genres g ON mg.genre_id = g.id
    JOIN
        Person p ON m.director_id = p.id
    WHERE
        m.country_id = 1
        AND m.release_date >= '2022-01-01'
        AND m.duration > 135
        AND g.name IN ('Action', 'Drama')
)
SELECT
    mg.movie_id AS "ID",
    mg.title AS "Title",
    mg.release_date AS "Release date",
    mg.duration AS "Duration",
    mg.description AS "Description",
    JSON_AGG(DISTINCT
        JSONB_BUILD_OBJECT(
            'id', f.id,
            'file_name', f.file_name,
            'mime_type', f.mime_type,
            's3_key', f.s3_key,
            'url', f.url
        )
    ) AS "Posters",
    JSONB_BUILD_OBJECT(
        'id', mg.director_id,
        'first_name', mg.first_name,
        'last_name', mg.last_name
    ) AS "Director"
FROM
    movie_genres mg
LEFT JOIN
    Posters po ON mg.movie_id = po.movie_id
LEFT JOIN
    Files f ON po.file_id = f.id
GROUP BY
    mg.movie_id, mg.title, mg.release_date, mg.duration, mg.description, mg.director_id, mg.first_name, mg.last_name
ORDER BY
    mg.release_date DESC;