-- 10) Список слов и следующих за ними слов в каждом языке
SELECT 
  w.word,
  l.language_name,
  LEAD(w.word) OVER (
    PARTITION BY w.language_id 
    ORDER BY w.word_id
  ) AS next_word_in_language
FROM words w
FULL JOIN languages l ON w.language_id = l.language_id
WHERE l.language_id IS NOT NULL;