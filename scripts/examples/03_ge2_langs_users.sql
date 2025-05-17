-- 3) Список пользователей, владеющие больше чем 2 языками
SELECT u.username, COUNT(ul.language_id) AS languages_known
FROM users u
INNER JOIN user_languages ul ON u.user_id = ul.user_id
GROUP BY u.username
HAVING COUNT(ul.language_id) > 2;