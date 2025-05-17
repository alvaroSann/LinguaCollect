-- Индекс №1: для ускорения анализа качества переводов
CREATE INDEX idx_translations_verified_confidence
ON translations (is_verified, confidence);

-- Индекс №2: для фильтрации и join по языкам
CREATE INDEX idx_words_language
ON words (language_id);