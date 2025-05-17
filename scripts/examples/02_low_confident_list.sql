-- 2) Список слов с низким уровнем качества перевода
SELECT t.translation_id, w1.word AS source_word, w2.word AS target_word, t.confidence
FROM translations t
INNER JOIN words w1 ON t.source_word_id = w1.word_id
INNER JOIN words w2 ON t.target_word_id = w2.word_id
WHERE t.confidence < 0.8 AND t.is_verified = FALSE;