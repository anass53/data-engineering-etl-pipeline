from airflow import DAG
from airflow.operators.python import PythonOperator
from airflow.operators.bash import BashOperator
from datetime import datetime, timedelta
import sys

sys.path.insert(0, "/opt/airflow/src")
sys.path.insert(0, "/opt/airflow")

from src.data_loader import DataLoader
from src.api_loader import ApiLoader
from src.db_loader import DbLoader

default_args = {
    "owner": "anass",
    "retries": 1,
    "retry_delay": timedelta(minutes=5),
    "email_on_failure": False,
}

# ── Fonctions Python ──────────────────────────────────────

def extract_csv(**context):
    loader = DataLoader(
        filepath="/opt/airflow/data/superstore.csv",
        separator=","
    )
    loader.load()
    loader.drop_duplicates()
    loader.filter_nulls(columns=["Sales", "Profit", "Region"])
    nb = len(loader.data)
    print(f"✅ CSV : {nb} lignes")
    context["ti"].xcom_push(key="csv_rows", value=nb)

def extract_api(**context):
    loader = ApiLoader(base_url="https://api.openbrewerydb.org/v1/breweries")
    df = loader.fetch_all(per_page=50, max_pages=3)
    nb = len(df)
    print(f"✅ API : {nb} lignes")
    context["ti"].xcom_push(key="api_rows", value=nb)

def load_to_db(**context):
    # CSV
    csv_loader = DataLoader(
        filepath="/opt/airflow/data/superstore.csv",
        separator=","
    )
    csv_loader.load()
    csv_loader.drop_duplicates()
    csv_loader.filter_nulls(columns=["Sales", "Profit", "Region"])

    # API
    api_loader = ApiLoader(base_url="https://api.openbrewerydb.org/v1/breweries")
    df_breweries = api_loader.fetch_all(per_page=50, max_pages=3)

    # DB
    db = DbLoader(
        host="postgres_bootcamp",
        port=5432,
        user="admin",
        password="admin",
        dbname="bootcamp"
    )
    db.connect()
    db.insert(csv_loader.data, table_name="superstore_sales", if_exists="replace")
    db.insert(df_breweries, table_name="breweries", if_exists="replace")
    db.close()
    print("✅ Données chargées dans PostgreSQL")

def verify_load(**context):
    db = DbLoader(
        host="postgres_bootcamp",
        port=5432,
        user="admin",
        password="admin",
        dbname="bootcamp"
    )
    db.connect()
    df = db.read("SELECT COUNT(*) AS nb FROM superstore_sales")
    nb = df["nb"].values[0]
    print(f"✅ {nb} lignes dans superstore_sales")
    assert nb > 0, "❌ Table vide !"
    db.close()

def check_data_volume(**context):
    """
    Vérifie la qualité des données dans superstore_sales.
    """

    db = DbLoader(
        host="postgres_bootcamp",
        port=5432,
        user="admin",
        password="admin",
        dbname="bootcamp"
    )
    db.connect()

    # 1 — Volume minimum
    df_count = db.read("SELECT COUNT(*) AS nb FROM superstore_sales")
    nb_rows = df_count["nb"].values[0]

    assert nb_rows >= 5000, f"❌ Volume insuffisant : {nb_rows} lignes"
    print(f"✅ Volume OK : {nb_rows}")

    # 2 — Nulls Sales
    df_nulls = db.read("""
        SELECT COUNT(*) AS nb
        FROM superstore_sales
        WHERE "Sales" IS NULL
    """)
    nb_nulls = df_nulls["nb"].values[0]

    assert nb_nulls == 0, f"❌ {nb_nulls} valeurs nulles dans Sales"
    print("✅ Pas de valeurs nulles")

    # 3 — Sales négatives
    df_neg = db.read("""
        SELECT COUNT(*) AS nb
        FROM superstore_sales
        WHERE "Sales" < 0
    """)
    nb_neg = df_neg["nb"].values[0]

    assert nb_neg == 0, f"❌ {nb_neg} ventes négatives"
    print("✅ Ventes positives uniquement")

    # 4 — Régions valides
    df_regions = db.read("""
        SELECT COUNT(*) AS nb
        FROM superstore_sales
        WHERE "Region" NOT IN ('East', 'West', 'Central', 'South')
    """)
    nb_invalid = df_regions["nb"].values[0]

    assert nb_invalid == 0, f"❌ {nb_invalid} régions invalides"
    print("✅ Régions valides")

    db.close()
    print("✅ Tous les contrôles qualité OK")

# ── DAG ───────────────────────────────────────────────────
with DAG(
    dag_id="etl_dbt_pipeline",
    description="Pipeline complet ETL + dbt orchestré par Airflow",
    default_args=default_args,
    start_date=datetime(2024, 1, 1),
    schedule="@daily",
    catchup=False,
    tags=["etl", "dbt", "bootcamp", "semaine3"],
) as dag:

    # ── Extract ───────────────────────────────────────────
    task_extract_csv = PythonOperator(
        task_id="extract_csv",
        python_callable=extract_csv,
    )

    task_extract_api = PythonOperator(
        task_id="extract_api",
        python_callable=extract_api,
    )

    # ── Load ──────────────────────────────────────────────
    task_load_db = PythonOperator(
        task_id="load_to_db",
        python_callable=load_to_db,
    )

    # ── Verify ────────────────────────────────────────────
    task_verify = PythonOperator(
        task_id="verify_load",
        python_callable=verify_load,
    )

    task_quality_check = PythonOperator(
    task_id="check_data_quality",
    python_callable=check_data_volume,
    )

    # ── dbt run ───────────────────────────────────────────
    task_dbt_run = BashOperator(
        task_id="dbt_run",
        bash_command="cd /opt/airflow/dbt_bootcamp && dbt run --profiles-dir /opt/airflow/dbt_bootcamp",
    )

    # ── dbt test ──────────────────────────────────────────
    task_dbt_test = BashOperator(
        task_id="dbt_test",
        bash_command="cd /opt/airflow/dbt_bootcamp && dbt test --profiles-dir /opt/airflow/dbt_bootcamp",
    )

    # ── Notify ────────────────────────────────────────────
    task_notify = BashOperator(
        task_id="notify",
        bash_command='echo "✅ Pipeline ETL + dbt terminé le $(date) — models: $(cd /opt/airflow/dbt_bootcamp && dbt ls --profiles-dir /opt/airflow/dbt_bootcamp 2>/dev/null | wc -l) modèles"',
    )

    # ── Dépendances ───────────────────────────────────────
[task_extract_csv, task_extract_api] >> task_load_db >> task_verify >> task_quality_check >> task_dbt_run >> task_dbt_test >> task_notify