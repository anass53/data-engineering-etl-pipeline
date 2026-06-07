import pandas as pd
import logging
import yaml

# Configuration du logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(levelname)s - %(message)s'
)
logger = logging.getLogger(__name__)

class DataLoader:
    def __init__(self, filepath: str, separator: str = ",", encoding: str = "latin-1"):
        """
        Initialise le DataLoader avec le chemin du fichier, séparateur et encodage.
        """
        self.filepath = filepath
        self.separator = separator
        self.encoding = encoding
        self.data = None  # Attribut pour stocker le DataFrame

    def load(self) -> pd.DataFrame:
        """
        Charge le fichier CSV dans un DataFrame.
        """
        try:
            logger.info(f"Chargement : {self.filepath}")
            self.data = pd.read_csv(self.filepath, sep=self.separator, encoding=self.encoding)
            logger.info(f"{len(self.data)} lignes chargées.")
            return self.data
        except FileNotFoundError:
            logger.error(f"Fichier introuvable : {self.filepath}")
            raise
        except Exception as e:
            logger.error(f"Erreur lors du chargement : {e}")
            raise

    def describe(self) -> None:
        """
        Affiche les informations et statistiques descriptives du DataFrame.
        """
        if self.data is None:
            logger.warning("Aucune donnée. Lance d'abord .load()")
            return
        self.data.info()
        print(self.data.describe())

    def drop_duplicates(self) -> pd.DataFrame:
        """
        Supprime les doublons dans le DataFrame.
        """
        if self.data is None:
            logger.warning("Aucune donnée. Lance d'abord .load()")
            return self.data
        avant = len(self.data)
        self.data = self.data.drop_duplicates()
        logger.info(f"{avant - len(self.data)} doublon(s) supprimé(s).")
        return self.data

    def rename_columns(self, mapping: dict) -> pd.DataFrame:
        """
        Renomme les colonnes du DataFrame selon le dictionnaire {ancien_nom: nouveau_nom}.
        """
        if self.data is None:
            logger.warning("Aucune donnée. Lance d'abord .load()")
            return self.data
        self.data = self.data.rename(columns=mapping)
        logger.info(f"Colonnes renommées : {list(mapping.keys())}")
        return self.data

    def get_summary(self, group_by: str, agg_col: str, aggfunc: str) -> pd.DataFrame:
        """
        Agrège le DataFrame en groupant par `group_by` et en appliquant `aggfunc` sur `agg_col`.
        """
        if self.data is None:
            logger.warning("Aucune donnée. Lance d'abord .load()")
            return pd.DataFrame()
        if group_by not in self.data.columns or agg_col not in self.data.columns:
            logger.error(f"Colonnes inexistantes : {group_by} ou {agg_col}")
            return pd.DataFrame()
        summary = self.data.groupby(group_by)[agg_col].agg(aggfunc).reset_index()
        logger.info(f"Agrégation réalisée : {aggfunc} de {agg_col} par {group_by}")
        return summary

    def filter_nulls(self, columns: list) -> pd.DataFrame:
        """
        Supprime les lignes contenant des valeurs nulles dans les colonnes spécifiées.
        """
        if self.data is None:
            logger.warning("Aucune donnée. Lance d'abord .load()")
            return self.data
        try:
            colonnes_absentes = [c for c in columns if c not in self.data.columns]
            if colonnes_absentes:
                raise ValueError(f"Colonnes inexistantes : {colonnes_absentes}")
            avant = len(self.data)
            self.data = self.data.dropna(subset=columns)
            logger.info(f"{avant - len(self.data)} ligne(s) supprimée(s) contenant des valeurs nulles.")
            return self.data
        except Exception as e:
            logger.error(f"Erreur lors du filtrage : {e}")
            raise

    def load_config(self, config_path: str) -> dict:
        try:
            with open(config_path, 'r', encoding='utf-8-sig') as f:
                config = yaml.safe_load(f)
            logger.info("Configuration chargée.")
            return config
        except FileNotFoundError:
            logger.error(f"Config introuvable : {config_path}")
            raise