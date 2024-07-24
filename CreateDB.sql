-- Country Table
CREATE TABLE Country (
    id SERIAL PRIMARY KEY,
    country VARCHAR(100) NOT NULL,
    createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Files Table
CREATE TABLE Files (
    id SERIAL PRIMARY KEY,
    file_name VARCHAR(255) NOT NULL,
    mime_type VARCHAR(100) NOT NULL,
    s3_key VARCHAR(255) NOT NULL,
    url VARCHAR(500) NOT NULL,
    createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP
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
    FOREIGN KEY (avatar_file_id) REFERENCES Files(id),
    createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP
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
    FOREIGN KEY (country_id) REFERENCES Country(id),
    createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP
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
    FOREIGN KEY (country_id) REFERENCES Country(id),
    createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Posters Table
CREATE TABLE Posters (
    movie_id INTEGER,
    file_id INTEGER,
    PRIMARY KEY (movie_id, file_id),
    FOREIGN KEY (movie_id) REFERENCES Movies(id),
    FOREIGN KEY (file_id) REFERENCES Files(id),
    createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Genres Table
CREATE TABLE Genres (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Movie Genres Table
CREATE TABLE MovieGenres (
    movie_id INTEGER NOT NULL,
    genre_id INTEGER NOT NULL,
    PRIMARY KEY (movie_id, genre_id),
    FOREIGN KEY (movie_id) REFERENCES Movies(id),
    FOREIGN KEY (genre_id) REFERENCES Genres(id),
    createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Characters Table
CREATE TABLE Characters (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    role VARCHAR(20) CHECK (role IN ('leading', 'supporting', 'background')),
    createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Movie Characters Table
CREATE TABLE MovieCharacters (
    id SERIAL PRIMARY KEY,
    movie_id INTEGER NOT NULL,
    character_id INTEGER NOT NULL,
    actor_id INTEGER,
    FOREIGN KEY (movie_id) REFERENCES Movies(id),
    FOREIGN KEY (character_id) REFERENCES Characters(id),
    FOREIGN KEY (actor_id) REFERENCES Person(id),
    createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Person Photos Table
CREATE TABLE PersonPhotos (
    id SERIAL PRIMARY KEY,
    person_id INTEGER NOT NULL,
    file_id INTEGER NOT NULL,
    is_primary BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (person_id) REFERENCES Person(id),
    FOREIGN KEY (file_id) REFERENCES Files(id),
    createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Favorite Movies Table
CREATE TABLE FavoriteMovies (
    user_id INTEGER NOT NULL,
    movie_id INTEGER NOT NULL,
    PRIMARY KEY (user_id, movie_id),
    FOREIGN KEY (user_id) REFERENCES Users(id),
    FOREIGN KEY (movie_id) REFERENCES Movies(id),
    createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE OR REPLACE FUNCTION update_modified_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updatedAt = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger for Country Table
CREATE TRIGGER update_country_updated_at
BEFORE UPDATE ON Country
FOR EACH ROW
EXECUTE FUNCTION update_modified_column();

-- Trigger for Files Table
CREATE TRIGGER update_files_updated_at
BEFORE UPDATE ON Files
FOR EACH ROW
EXECUTE FUNCTION update_modified_column();

-- Trigger for Users Table
CREATE TRIGGER update_users_updated_at
BEFORE UPDATE ON Users
FOR EACH ROW
EXECUTE FUNCTION update_modified_column();

-- Trigger for Person Table
CREATE TRIGGER update_person_updated_at
BEFORE UPDATE ON Person
FOR EACH ROW
EXECUTE FUNCTION update_modified_column();

-- Trigger for Movies Table
CREATE TRIGGER update_movies_updated_at
BEFORE UPDATE ON Movies
FOR EACH ROW
EXECUTE FUNCTION update_modified_column();

-- Trigger for Posters Table
CREATE TRIGGER update_posters_updated_at
BEFORE UPDATE ON Posters
FOR EACH ROW
EXECUTE FUNCTION update_modified_column();

-- Trigger for Genres Table
CREATE TRIGGER update_genres_updated_at
BEFORE UPDATE ON Genres
FOR EACH ROW
EXECUTE FUNCTION update_modified_column();

-- Trigger for MovieGenres Table
CREATE TRIGGER update_movie_genres_updated_at
BEFORE UPDATE ON MovieGenres
FOR EACH ROW
EXECUTE FUNCTION update_modified_column();

-- Trigger for Characters Table
CREATE TRIGGER update_characters_updated_at
BEFORE UPDATE ON Characters
FOR EACH ROW
EXECUTE FUNCTION update_modified_column();

-- Trigger for MovieCharacters Table
CREATE TRIGGER update_movie_characters_updated_at
BEFORE UPDATE ON MovieCharacters
FOR EACH ROW
EXECUTE FUNCTION update_modified_column();

-- Trigger for PersonPhotos Table
CREATE TRIGGER update_person_photos_updated_at
BEFORE UPDATE ON PersonPhotos
FOR EACH ROW
EXECUTE FUNCTION update_modified_column();

-- Trigger for FavoriteMovies Table
CREATE TRIGGER update_favorite_movies_updated_at
BEFORE UPDATE ON FavoriteMovies
FOR EACH ROW
EXECUTE FUNCTION update_modified_column();