"""
function tests
"""

def test_function_get_translations_for_word_exception(conn):
    """
    check if function returns translations when it exists
    and check if exception arises
    """
    with conn.cursor() as cur:
        cur.execute("SELECT * FROM get_translations_for_word('солнце', 'Russian');")
        results = cur.fetchall()
        assert len(results) > 0


def test_function_get_translations_for_word_valid(conn):
    """
    check if get_translations_for_word return translations correctly
    for existing word "солнце" in Russian and that returning fields not empty
    """
    with conn.cursor() as cur:
        cur.execute("SELECT * FROM get_translations_for_word('солнце', 'Russian');")
        results = cur.fetchall()
        assert len(results) > 0
        for row in results:
            assert row[0], "target_word is empty"
            assert row[1], "target_language is empty"
            assert isinstance(row[2], float), "confidence is not a float"
            assert isinstance(row[3], bool), "is_verified is not a boolean"
