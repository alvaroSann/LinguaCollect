-- 9) Список пользователей, владеющих славянскими языками
SELECT u.username, l.language_name
FROM users u
RIGHT JOIN user_languages ul ON u.user_id = ul.user_id
INNER JOIN languages l ON ul.language_id = l.language_id
WHERE l.language_id IN (SELECT language_id FROM languages WHERE family = 'Slavic');