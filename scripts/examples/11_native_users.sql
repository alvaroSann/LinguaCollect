-- 11) Список пользователей, знающих хотя бы один язык с уровнем "native"
SELECT username
FROM users
WHERE user_id = ANY (
    SELECT user_id 
    FROM user_languages 
    WHERE proficiency_level = 'native'
);