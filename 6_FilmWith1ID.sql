WITH MovieDetails AS (
    SELECT
        m.id AS movie_id,
        m.title,
        m.release_date,
        m.duration,
        m.description
    FROM
        Movies m
    WHERE
        m.id = 1
),
DirectorDetails AS (
    SELECT
        p.id AS director_id,
        p.first_name AS director_first_name,
        p.last_name AS director_last_name,
        JSONB_BUILD_OBJECT(
            'id', f.id,
            'file_name', f.file_name,
            'mime_type', f.mime_type,
            's3_key', f.s3_key,
            'url', f.url
        ) AS primary_photo
    FROM
        Person p
    LEFT JOIN
        PersonPhotos pp ON p.id = pp.person_id AND pp.is_primary = TRUE
    LEFT JOIN
        Files f ON pp.file_id = f.id
    WHERE
        p.id = (SELECT director_id FROM Movies WHERE id = 1)
),
ActorDetails AS (
    SELECT
        mc.movie_id,
        p.id AS actor_id,
        p.first_name AS actor_first_name,
        p.last_name AS actor_last_name,
        JSONB_BUILD_OBJECT(
            'id', f.id,
            'file_name', f.file_name,
            'mime_type', f.mime_type,
            's3_key', f.s3_key,
            'url', f.url
        ) AS photo
    FROM
        MovieCharacters mc
    JOIN
        Person p ON mc.actor_id = p.id
    LEFT JOIN
        PersonPhotos pp ON p.id = pp.person_id AND pp.is_primary = TRUE
    LEFT JOIN
        Files f ON pp.file_id = f.id
    WHERE
        mc.movie_id = 1
),
GenreDetails AS (
    SELECT
        m.id AS movie_id,
        g.id AS genre_id,
        g.name AS genre_name
    FROM
        Movies m
    JOIN
        MovieGenres mg ON m.id = mg.movie_id
    JOIN
        Genres g ON mg.genre_id = g.id
    WHERE
        m.id = 1
),
PosterDetails AS (
    SELECT
        po.movie_id,
        f.id AS file_id,
        f.file_name,
        f.mime_type,
        f.s3_key,
        f.url
    FROM
        Posters po
    JOIN
        Files f ON po.file_id = f.id
    WHERE
        po.movie_id = 1
)
SELECT
    md.movie_id AS "ID",
    md.title AS "Title",
    md.release_date AS "Release date",
    md.duration AS "Duration",
    md.description AS "Description",
    JSON_AGG(DISTINCT
        JSONB_BUILD_OBJECT(
            'id', pd.file_id,
            'file_name', pd.file_name,
            'mime_type', pd.mime_type,
            's3_key', pd.s3_key,
            'url', pd.url
        )
    ) AS "Posters",
    JSONB_BUILD_OBJECT(
        'ID', dd.director_id,
        'First name', dd.director_first_name,
        'Last name', dd.director_last_name,
        'Photo', dd.primary_photo
    ) AS "Director",
    JSON_AGG(DISTINCT
        JSONB_BUILD_OBJECT(
            'ID', ad.actor_id,
            'First name', ad.actor_first_name,
            'Last name', ad.actor_last_name,
            'Photo', ad.photo
        )
    ) AS "Actors",
    JSON_AGG(DISTINCT
        JSONB_BUILD_OBJECT(
            'id', gd.genre_id,
            'name', gd.genre_name
        )
    ) AS "Genres"
FROM
    MovieDetails md
LEFT JOIN
    DirectorDetails dd ON (SELECT director_id FROM Movies WHERE id = md.movie_id) = dd.director_id
LEFT JOIN
    ActorDetails ad ON md.movie_id = ad.movie_id
LEFT JOIN
    PosterDetails pd ON md.movie_id = pd.movie_id
LEFT JOIN
    GenreDetails gd ON md.movie_id = gd.movie_id
GROUP BY
    md.movie_id, md.title, md.release_date, md.duration, md.description, dd.director_id, dd.director_first_name, dd.director_last_name, dd.primary_photo