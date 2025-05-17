-- 5) Самосоединение таблицы для вывода всех диалектов
SELECT 
  d.language_name AS dialect,
  p.language_name AS parent_language
FROM languages d
INNER JOIN languages p ON d.parent_language_id = p.language_id;