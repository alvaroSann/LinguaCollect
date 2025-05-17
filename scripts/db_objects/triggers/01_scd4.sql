-- Триггер №1: для реализации SCD 4
CREATE OR REPLACE FUNCTION archive_translation_version()
RETURNS TRIGGER AS $$
DECLARE
    old_word_text VARCHAR(50);
    new_word_text VARCHAR(50);
BEGIN
    IF NEW.target_word_id IS DISTINCT FROM OLD.target_word_id THEN
        -- Получаем текст старого и нового слов
        SELECT word INTO old_word_text FROM words WHERE word_id = OLD.target_word_id;
        SELECT word INTO new_word_text FROM words WHERE word_id = NEW.target_word_id;

        -- Сохраняем в архив
        INSERT INTO translation_archive (
            translation_id,
            old_target_word,
            new_target_word,
            change_date
        )
        VALUES (
            OLD.translation_id,
            old_word_text,
            new_word_text,
            NOW()
        );
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_archive_translation
AFTER UPDATE ON translations
FOR EACH ROW
EXECUTE FUNCTION archive_translation_version();