"""
triggers tests
"""

def test_trigger_auto_verify(conn):
    """
    check triggering after each insertion in the table "translations"
    """
    with conn.cursor() as cur:
        cur.execute("BEGIN;")

        cur.execute(
            "INSERT INTO translations (source_word_id, target_word_id, confidence, is_verified) VALUES (1, 2, 0.96, FALSE) RETURNING translation_id;"
        )
        translation_id = cur.fetchone()[0]

        cur.execute(
            "SELECT is_verified FROM translations WHERE translation_id = %s;",
            (translation_id,)
        )
        is_verified = cur.fetchone()[0]

        cur.execute("ROLLBACK;")

        assert is_verified is True


def test_trigger_prevent_delete_word(conn):
    """
    check that the word cannot be deleted if some translation has the reference on him
    """
    with conn.cursor() as cur:
        cur.execute("SELECT source_word_id FROM translations LIMIT 1;")
        word_id = cur.fetchone()[0]
        cur.execute("BEGIN;")
        try:
            with pytest.raises(psycopg2.errors.RaiseException):
                cur.execute(f"DELETE FROM words WHERE word_id = {word_id};")
        finally:
            cur.execute("ROLLBACK;")


def test_trigger_archive_translation(conn):
    """
    check that an item in archive appears after update the translation
    """
    with conn.cursor() as cur:
        cur.execute("""
            SELECT translation_id, target_word_id
            FROM translations ORDER BY translation_id LIMIT 1;
        """)
        tr_id, old_target = cur.fetchone()

        # find any other target_word_id to indeed have update 
        cur.execute("""
            SELECT word_id FROM words
            WHERE word_id <> %s
            LIMIT 1;
        """, (old_target,))
        new_target = cur.fetchone()[0]

        cur.execute("BEGIN;")
        cur.execute("""
            UPDATE translations
            SET target_word_id = %s
            WHERE translation_id = %s;
        """, (new_target, tr_id))

        cur.execute("""
            SELECT COUNT(*)
            FROM translation_archive
            WHERE translation_id = %s;
        """, (tr_id,))
        archive_rows = cur.fetchone()[0]
        cur.execute("ROLLBACK;")

        assert archive_rows > 0