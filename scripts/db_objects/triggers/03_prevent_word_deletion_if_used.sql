-- Триггер №3: для предотвращения удаления слов, задействованных в переводах
CREATE OR REPLACE FUNCTION prevent_word_deletion_if_used()
RETURNS TRIGGER AS $$
BEGIN
    IF EXISTS (
        SELECT 1 FROM translations
        WHERE source_word_id = OLD.word_id
           OR target_word_id = OLD.word_id
    ) THEN
        RAISE EXCEPTION 'Word "%" cannot be deleted: it is used in translations.', OLD.word;
    END IF;
    RETURN OLD;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_prevent_word_delete
BEFORE DELETE ON words
FOR EACH ROW
EXECUTE FUNCTION prevent_word_deletion_if_used();