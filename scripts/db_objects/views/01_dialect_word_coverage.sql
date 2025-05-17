-- Представление №1: для обеспечения быстрого доступа к диалектам
CREATE VIEW dialect_word_coverage_view AS
SELECT 
    parent.language_name AS base_language,
    child.language_name AS dialect_name,
    child.iso_code AS dialect_iso,
    COUNT(w.word_id) AS words_in_dialect
FROM languages child
JOIN languages parent ON child.parent_language_id = parent.language_id
LEFT JOIN words w ON w.language_id = child.language_id
GROUP BY parent.language_name, child.language_name, child.iso_code
ORDER BY words_in_dialect ASC;