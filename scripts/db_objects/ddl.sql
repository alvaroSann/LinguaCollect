-- Таблица: Users
CREATE TABLE users (
    user_id SERIAL PRIMARY KEY,
    username VARCHAR(20) UNIQUE NOT NULL,
    email VARCHAR(30) UNIQUE NOT NULL,
    role VARCHAR(20) NOT NULL
);

-- Таблица: Languages
CREATE TABLE languages (
    language_id SERIAL PRIMARY KEY,
    language_name VARCHAR(30) UNIQUE NOT NULL,
    family VARCHAR(30),
    iso_code CHAR(2) UNIQUE,
    parent_language_id INTEGER REFERENCES languages(language_id)
);

-- Таблица: User_Languages (N:M)
CREATE TABLE user_languages (
    user_id INTEGER,
    language_id INTEGER,
    proficiency_level VARCHAR(20),
    PRIMARY KEY (user_id, language_id),
    FOREIGN KEY (user_id) REFERENCES users(user_id),
    FOREIGN KEY (language_id) REFERENCES languages(language_id)
);

-- Таблица: Words
CREATE TABLE words (
    word_id SERIAL PRIMARY KEY,
    language_id INTEGER NOT NULL REFERENCES languages(language_id),
    word VARCHAR(50) NOT NULL,
    gender VARCHAR(20),
    pos VARCHAR(20),
    is_plural BOOLEAN NOT NULL
);

-- Таблица: Translations
CREATE TABLE translations (
    translation_id SERIAL PRIMARY KEY,
    source_word_id INTEGER NOT NULL REFERENCES words(word_id),
    target_word_id INTEGER NOT NULL REFERENCES words(word_id),
    confidence FLOAT,
    is_verified BOOLEAN
);

-- Таблица: Translation_Archive (SCD 4)
CREATE TABLE translation_archive (
    translation_id INTEGER PRIMARY KEY REFERENCES translations(translation_id),
    old_target_word VARCHAR(50),
    new_target_word VARCHAR(50),
    change_date TIMESTAMP NOT NULL
);

-- Таблица: Contexts
CREATE TABLE contexts (
    context_id SERIAL PRIMARY KEY,
    context VARCHAR(150)
);

-- Таблица: Translation_Contexts (N:M)
CREATE TABLE translation_contexts (
    translation_id INTEGER,
    context_id INTEGER,
    usage_example TEXT,
    PRIMARY KEY (translation_id, context_id),
    FOREIGN KEY (translation_id) REFERENCES translations(translation_id),
    FOREIGN KEY (context_id) REFERENCES contexts(context_id)
);