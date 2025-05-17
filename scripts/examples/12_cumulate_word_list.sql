-- 12) Список слов на каждом языке с накоплением общего числа слов в базе
SELECT 
  language_name,
  word_count,
  SUM(word_count) OVER (ORDER BY word_count DESC) AS cumulative_total
FROM (
  SELECT l.language_name, COUNT(w.word_id) AS word_count
  FROM languages l
  LEFT JOIN words w ON l.language_id = w.language_id
  GROUP BY l.language_name
) AS subquery;