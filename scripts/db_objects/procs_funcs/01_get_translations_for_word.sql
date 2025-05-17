-- Функция/процедура №1: получение переводов по слову
CREATE OR REPLACE FUNCTION get_translations_for_word(
    word_text TEXT,
    word_lang TEXT
)
RETURNS TABLE (
    target_word VARCHAR(50),
    target_language VARCHAR(30),
    confidence FLOAT8,
    is_verified BOOLEAN
)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    SELECT 
        tw.word,
        tl.language_name,
        t.confidence,
        t.is_verified
    FROM words sw
    JOIN languages sl ON sw.language_id = sl.language_id
    JOIN translations t ON t.source_word_id = sw.word_id
    JOIN words tw ON t.target_word_id = tw.word_id
    JOIN languages tl ON tw.language_id = tl.language_id
    WHERE sw.word = word_text
      AND sl.language_name = word_lang;
END;
$$;