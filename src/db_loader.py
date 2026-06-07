import pandas as pd
import logging
from sqlalchemy import create_engine, text
from sqlalchemy.exc import SQLAlchemyError

logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s - %(levelname)s - %(message)s"
)
logger = logging.getLogger(__name__)


class DbLoader:
    def __init__(self, host: str, port: int, user: str, password: str, dbname: str):
        self.host = host
        self.port = port
        self.user = user
        self.password = password
        self.dbname = dbname
        self.engine = None

    def connect(self) -> None:
        try:
            url = f"postgresql://{self.user}:{self.password}@{self.host}:{self.port}/{self.dbname}"
            self.engine = create_engine(url)
            with self.engine.connect() as conn:
                conn.execute(text("SELECT 1"))
            logger.info("Connexion PostgreSQL établie.")
        except SQLAlchemyError as e:
            logger.error(f"Echec de connexion : {e}")
            raise

    def insert(self, df: pd.DataFrame, table_name: str,
               if_exists: str = "replace", chunksize: int = 500) -> None:
        if self.engine is None:
            raise RuntimeError("Lance d'abord .connect()")
        try:
            df.to_sql(
                name=table_name,
                con=self.engine,
                if_exists=if_exists,
                index=False,
                chunksize=chunksize
            )
            logger.info(f"{len(df)} lignes insérées dans '{table_name}'.")
        except SQLAlchemyError as e:
            logger.error(f"Erreur lors de l'insertion : {e}")
            raise

    def read(self, query: str) -> pd.DataFrame:
        if self.engine is None:
            raise RuntimeError("Lance d'abord .connect()")
        try:
            df = pd.read_sql(query, self.engine)
            logger.info(f"{len(df)} lignes lues.")
            return df
        except SQLAlchemyError as e:
            logger.error(f"Erreur lors de la lecture : {e}")
            raise

    def execute(self, sql: str) -> None:
        if self.engine is None:
            raise RuntimeError("Lance d'abord .connect()")
        try:
            with self.engine.connect() as conn:
                conn.execute(text(sql))
                conn.commit()
            logger.info("Requête exécutée avec succès.")
        except SQLAlchemyError as e:
            logger.error(f"Erreur SQL : {e}")
            raise

    def close(self) -> None:
        if self.engine:
            self.engine.dispose()
            logger.info("Connexion fermée.")