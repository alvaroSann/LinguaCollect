-- 4) Ранжирование контекстов употребления по заполненности примерами
SELECT 
  c.context,
  COUNT(tc.translation_id) AS example_count,
  RANK() OVER (ORDER BY COUNT(tc.translation_id) DESC) AS rank
FROM contexts c
LEFT JOIN translation_contexts tc ON c.context_id = tc.context_id
GROUP BY c.context;