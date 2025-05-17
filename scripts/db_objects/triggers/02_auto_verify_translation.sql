-- Триггер №2: для автоверификации слов с высокой точностью перевода при каждом обновлении таблицы
CREATE OR REPLACE FUNCTION auto_verify_translation()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.confidence > 0.95 THEN
        NEW.is_verified := TRUE;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_auto_verify
BEFORE INSERT ON translations
FOR EACH ROW
EXECUTE FUNCTION auto_verify_translation();