-- 8) Список полностью непереведённых на все другие языки слов
SELECT w.word, l.language_name
FROM words w
LEFT JOIN translations t ON w.word_id = t.source_word_id
INNER JOIN languages l ON w.language_id = l.language_id
WHERE t.translation_id IS NULL;