# ER DIAGRAM
```mermaid
    erDiagram
    USERS {
        int id PK
        string username
        string first_name
        string last_name
        string email
        string password
        int avatar_file_id FK
    }

    FILES {
        int id PK
        string file_name
        string mime_type
        string s3_key
        string url
    }

    MOVIES {
        int id PK
        string title
        text description
        numeric budget
        date release_date
        int duration
        int director_id FK
        int country_id FK
    }

    POSTERS{
        int movie_id PK, FK
        int file_id PK, FK
    }

    GENRES {
        int id PK
        string name
    }

    MOVIE_GENRES {
        int movie_id PK, FK
        int genre_id PK, FK
    }

    CHARACTERS {
        int id PK
        string name
        text description
        string role
    }

    MOVIE_CHARACTERS {
        int id PK
        int movie_id FK
        int character_id FK
        int actor_id FK
    }

    PERSON {
        int id PK
        string first_name
        string last_name
        text biography
        date date_of_birth
        string gender
        int country_id FK
    }

    COUNTRY{
        int id PK
        string country
    }

    PERSON_PHOTOS {
        int id PK
        int person_id FK
        int file_id FK
        boolean is_primary
    }

    FAVORITE_MOVIES {
        int user_id PK, FK
        int movie_id PK, FK
    }

    FILES ||--o{ USERS : "Has Avatar"
    MOVIES ||--|| PERSON : "Director makes film"
    MOVIES ||--o{ POSTERS : "Has posters"
    FILES ||--o{ POSTERS : "Stored at"
    MOVIES ||--|{ MOVIE_GENRES : "Has genres"
    GENRES ||--|{ MOVIE_GENRES : "Genre"
    MOVIES ||--|{ MOVIE_CHARACTERS : "Has characters"
    CHARACTERS |o--|{ MOVIE_CHARACTERS : "Represents"
    PERSON |o--|| MOVIE_CHARACTERS : "Actor plays"
    COUNTRY ||--o{ MOVIES: "Filmed in"
    COUNTRY ||--o{ PERSON: "From"
    PERSON ||--|{ PERSON_PHOTOS : "Has photos"
    FILES ||--|{ PERSON_PHOTOS : "Stored at"
    USERS ||--|{ FAVORITE_MOVIES : "Has"
    MOVIES ||--|{ FAVORITE_MOVIES : "Which movie"
```