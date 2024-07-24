-- Country Table
CREATE TABLE Country (
    id SERIAL PRIMARY KEY,
    country VARCHAR(100) NOT NULL
);

-- Files Table
CREATE TABLE Files (
    id SERIAL PRIMARY KEY,
    file_name VARCHAR(255) NOT NULL,
    mime_type VARCHAR(100) NOT NULL,
    s3_key VARCHAR(255) NOT NULL,
    url VARCHAR(500) NOT NULL
);

-- Users Table
CREATE TABLE Users (
    id SERIAL PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    avatar_file_id INTEGER,
    FOREIGN KEY (avatar_file_id) REFERENCES Files(id)
);

-- Person Table
CREATE TABLE Person (
    id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    biography TEXT,
    date_of_birth DATE,
    gender VARCHAR(10),
    country_id INTEGER,
    FOREIGN KEY (country_id) REFERENCES Country(id)
);

-- Movies Table
CREATE TABLE Movies (
    id SERIAL PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    budget NUMERIC,
    release_date DATE,
    duration INTEGER,
    director_id INTEGER,
    country_id INTEGER,
    FOREIGN KEY (director_id) REFERENCES Person(id),
    FOREIGN KEY (country_id) REFERENCES Country(id)
);

-- Posters Table
CREATE TABLE Posters (
    movie_id INTEGER,
    file_id INTEGER,
    PRIMARY KEY (movie_id, file_id),
    FOREIGN KEY (movie_id) REFERENCES Movies(id),
    FOREIGN KEY (file_id) REFERENCES Files(id)
);

-- Genres Table
CREATE TABLE Genres (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL
);

-- Movie Genres Table
CREATE TABLE MovieGenres (
    movie_id INTEGER NOT NULL,
    genre_id INTEGER NOT NULL,
    PRIMARY KEY (movie_id, genre_id),
    FOREIGN KEY (movie_id) REFERENCES Movies(id),
    FOREIGN KEY (genre_id) REFERENCES Genres(id)
);

-- Characters Table
CREATE TABLE Characters (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    role VARCHAR(20) CHECK (role IN ('leading', 'supporting', 'background'))
);

-- Movie Characters Table
CREATE TABLE MovieCharacters (
    movie_id INTEGER NOT NULL,
    character_id INTEGER NOT NULL,
    actor_id INTEGER,
    PRIMARY KEY (movie_id, character_id, actor_id),
    FOREIGN KEY (movie_id) REFERENCES Movies(id),
    FOREIGN KEY (character_id) REFERENCES Characters(id),
    FOREIGN KEY (actor_id) REFERENCES Person(id)
);

-- Person Photos Table
CREATE TABLE PersonPhotos (
    id SERIAL PRIMARY KEY,
    person_id INTEGER NOT NULL,
    file_id INTEGER NOT NULL,
    is_primary BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (person_id) REFERENCES Person(id),
    FOREIGN KEY (file_id) REFERENCES Files(id)
);

-- Favorite Movies Table
CREATE TABLE FavoriteMovies (
    user_id INTEGER NOT NULL,
    movie_id INTEGER NOT NULL,
    PRIMARY KEY (user_id, movie_id),
    FOREIGN KEY (user_id) REFERENCES Users(id),
    FOREIGN KEY (movie_id) REFERENCES Movies(id)
);