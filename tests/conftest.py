import pytest
import psycopg2


@pytest.fixture(scope="module")
def conn():
    """
    create connection to database
    uses for establishing connection once for test module and closes after all executions
    """
    connection = psycopg2.connect(
        dbname="postgres",
        user="postgres",
        password="<ваш пароль тут>",
        host="localhost",
        port="5432"
    )
    yield connection
    connection.close()
