-- 1) Топ 5 языков по количеству слов
SELECT l.language_name, COUNT(w.word_id) AS word_count
FROM languages l
LEFT JOIN words w ON l.language_id = w.language_id
GROUP BY l.language_name
ORDER BY word_count DESC
LIMIT 5;