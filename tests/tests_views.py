"""
views tests
"""

def test_view_dialect_coverage_exists(conn):
    """
    check if there's at least an item in dialect_word_coverage_view
    """
    with conn.cursor() as cur:
        cur.execute("SELECT * FROM dialect_word_coverage_view LIMIT 1;")
        assert cur.fetchone() is not None


def test_view_verified_translations(conn):
    """
    check if verified_translations_contexts_view operates correctly (all item confidence, indeed, less than 0.8)
    """
    with conn.cursor() as cur:
        cur.execute("SELECT * FROM verified_translations_contexts_view WHERE confidence < 0.8;")
        rows = cur.fetchall()
        assert all(row[7] < 0.8 for row in rows)
