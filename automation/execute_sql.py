from sqlalchemy import create_engine, text
from config import SERVER, DATABASE


engine = create_engine(
    f"mssql+pyodbc://@{SERVER}/{DATABASE}"
    "?driver=ODBC+Driver+17+for+SQL+Server"
    "&trusted_connection=yes"
)


def execute_sql(script_path):
    """
    Execute a SQL script file.
    """

    with open(script_path, "r", encoding="utf-8") as file:
        sql_script = file.read()

    with engine.begin() as conn:
        conn.execute(text(sql_script))

    print(f"{script_path} executed successfully.")