-- 7) Информация о старых переводах слова "charge"
SELECT *
FROM translation_archive ta
WHERE EXISTS (
  SELECT 1
  FROM words w 
  WHERE w.word = 'charge' 
  AND ta.old_target_word = w.word
);