-- Функция/процедура №3: безопасное добавление нового перевода между двумя словами
CREATE OR REPLACE PROCEDURE add_translation_by_words(
    source_word TEXT,
    source_lang TEXT,
    target_word TEXT,
    target_lang TEXT,
    confidence_val NUMERIC,
    verified BOOLEAN,
    context_text TEXT DEFAULT NULL,
    usage_example TEXT DEFAULT NULL
)
LANGUAGE plpgsql
AS $$
DECLARE
    source_id INT;
    target_id INT;
    source_lang_id INT;
    target_lang_id INT;
    new_translation_id INT;
    new_context_id INT;
BEGIN
    -- Получаем id языков
    SELECT language_id INTO source_lang_id FROM languages WHERE language_name = source_lang;
    SELECT language_id INTO target_lang_id FROM languages WHERE language_name = target_lang;

    IF source_lang_id IS NULL OR target_lang_id IS NULL THEN
        RAISE NOTICE 'One of the languages not found.';
        RETURN;
    END IF;

    -- Получаем или вставляем source word
    SELECT word_id INTO source_id
    FROM words
    WHERE word = source_word AND language_id = source_lang_id;

    IF source_id IS NULL THEN
        INSERT INTO words (language_id, word, gender, pos, is_plural)
        VALUES (source_lang_id, source_word, 'unknown', 'noun', FALSE)
        RETURNING word_id INTO source_id;
    END IF;

    -- Получаем или вставляем target word
    SELECT word_id INTO target_id
    FROM words
    WHERE word = target_word AND language_id = target_lang_id;

    IF target_id IS NULL THEN
        INSERT INTO words (language_id, word, gender, pos, is_plural)
        VALUES (target_lang_id, target_word, 'unknown', 'noun', FALSE)
        RETURNING word_id INTO target_id;
    END IF;

    -- Получаем или создаём перевод
    SELECT translation_id INTO new_translation_id
    FROM translations
    WHERE source_word_id = source_id AND target_word_id = target_id;

    IF new_translation_id IS NULL THEN
        INSERT INTO translations (source_word_id, target_word_id, confidence, is_verified)
        VALUES (source_id, target_id, confidence_val, verified)
        RETURNING translation_id INTO new_translation_id;

        RAISE NOTICE 'Translation added.';
    ELSE
        RAISE NOTICE 'Translation already exists.';
    END IF;

    -- Добавляем контекст и пример (если они есть)
    IF context_text IS NOT NULL AND usage_example IS NOT NULL THEN
        -- Получаем или создаём context
        SELECT context_id INTO new_context_id FROM contexts WHERE context = context_text;


        IF new_context_id IS NULL THEN
            INSERT INTO contexts (context)
            VALUES (context_text)
            RETURNING context_id INTO new_context_id;
        END IF;

        -- Добавляем связь с usage_example
        IF NOT EXISTS (
            SELECT 1 FROM translation_contexts
            WHERE translation_id = new_translation_id AND context_id = new_context_id
        ) THEN
            INSERT INTO translation_contexts (translation_id, context_id, usage_example)
            VALUES (new_translation_id, new_context_id, usage_example);

            RAISE NOTICE 'Context and usage example added.';
        ELSE
            RAISE NOTICE 'Context already exists for this translation.';
        END IF;
    END IF;
END;
$$;