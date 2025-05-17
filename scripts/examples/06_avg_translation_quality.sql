-- 6) Среднее качество переводов по каждому языку
SELECT 
  l.language_name,
  ROUND(AVG(t.confidence)::numeric, 2) AS avg_confidence
FROM translations t
INNER JOIN words w ON t.source_word_id = w.word_id
INNER JOIN languages l ON w.language_id = l.language_id
GROUP BY l.language_name
HAVING AVG(t.confidence) IS NOT NULL;