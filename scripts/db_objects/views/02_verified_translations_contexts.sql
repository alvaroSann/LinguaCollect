-- Представление №2: информация о переводе конкретных пар слов в одном месте
-- (например, для вывода всех близких переводов слова, запрошенного юзером)
CREATE OR REPLACE VIEW verified_translations_contexts_view AS
SELECT 
    t.translation_id,
    sw.word AS source_word,
    sl.language_name AS source_language,
    tw.word AS target_word,
    tl.language_name AS target_language,
    c.context,
    tc.usage_example,
    t.confidence,
    t.is_verified
FROM translations t
JOIN words sw ON t.source_word_id = sw.word_id
JOIN languages sl ON sw.language_id = sl.language_id
JOIN words tw ON t.target_word_id = tw.word_id
JOIN languages tl ON tw.language_id = tl.language_id
JOIN translation_contexts tc ON t.translation_id = tc.translation_id
JOIN contexts c ON tc.context_id = c.context_id;