-- Функция/процедура №2: массовая верификация переводов с высоким доверием
CREATE PROCEDURE verify_confident_translations(
    min_confidence NUMERIC
)
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE translations
    SET is_verified = TRUE
    WHERE confidence >= min_confidence
      AND is_verified = FALSE;
END;
$$;