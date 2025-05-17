"""
procedure tests
"""

def test_procedure_verify_confident_translations(conn):
    """
    check procedure execution with parameter 0.9
    the execution performs in transaction with rollback to not update base
    """
    with conn.cursor() as cur:
        cur.execute("BEGIN;")
        cur.execute("CALL verify_confident_translations(0.9);")
        cur.execute("ROLLBACK;")
        assert True


def test_add_translation_basic(conn):
    """
    check that the translation does not exist before adding,
    then call procedure to add it,
    and verify translation appears after insertion
    """

    test_script = """
                SELECT COUNT(*) FROM translations t
                JOIN words sw ON t.source_word_id = sw.word_id
                JOIN words tw ON t.target_word_id = tw.word_id
                JOIN languages sl ON sw.language_id = sl.language_id
                JOIN languages tl ON tw.language_id = tl.language_id
                WHERE sw.word = 'звезда' AND sl.language_name = 'Russian'
                  AND tw.word = 'gwiazda' AND tl.language_name = 'Polish';
    """

    with conn.cursor() as cur:
        cur.execute(test_script)
        count_before = cur.fetchone()[0]
        assert count_before == 0, "Translation already exists before test"

        cur.execute("BEGIN;")
        cur.execute("""
            CALL add_translation_by_words(
                'звезда', 'Russian',
                'gwiazda', 'Polish',
                0.91, TRUE
            );
        """)

        cur.execute(test_script)
        count_after = cur.fetchone()[0]
        cur.execute("ROLLBACK;")

        assert count_after > 0


def test_procedure_verify_confident(conn):
    """
    call procedure verify_confident_translations(0.9)
    and check that before call there are translations with confidence > 0.9,
    and after call no such translations remain
    """
    with conn.cursor() as cur:
        cur.execute("SELECT COUNT(*) FROM translations WHERE confidence > 0.9 AND is_verified = FALSE;")
        count_before = cur.fetchone()[0]
        assert count_before > 0

        cur.execute("BEGIN;")
        cur.execute("CALL verify_confident_translations(0.9);")

        cur.execute("SELECT COUNT(*) FROM translations WHERE confidence > 0.9 AND is_verified = FALSE;")
        count_after = cur.fetchone()[0]
        cur.execute("ROLLBACK;")

        assert count_after == 0


def test_translation_insert_conflict(conn):
    """
    check that procedure does not raise error on duplicate insert,
    but raises notice 'Translation already exists.'
    """
    conn.notices.clear()

    with conn.cursor() as cur:
        cur.execute("BEGIN;")
        cur.execute("""
            CALL add_translation_by_words(
                'вода', 'Russian',
                'woda', 'Polish',
                0.95, FALSE
            );
        """)
        cur.execute("ROLLBACK;")

    assert any("Translation already exists." in notice for notice in conn.notices), \
        "Expected NOTICE 'Translation already exists.' was not found in notices"
