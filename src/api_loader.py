import requests
import pandas as pd
import logging
import time

logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s - %(levelname)s - %(message)s",
)
logger = logging.getLogger(__name__)


class ApiLoader:
    def __init__(self, base_url: str, headers: dict = None):
        self.base_url = base_url
        self.headers = headers or {}
        self.data = None

    def fetch_page(self, params: dict = None) -> list:
        try:
            response = requests.get(
                self.base_url,
                headers=self.headers,
                params=params,
                timeout=10
            )
            response.raise_for_status()
            return response.json()
        except requests.exceptions.Timeout:
            logger.error("Timeout : l'API ne répond pas.")
            raise
        except requests.exceptions.HTTPError as e:
            logger.error(f"Erreur HTTP : {e}")
            raise
        except Exception as e:
            logger.error(f"Erreur inattendue : {e}")
            raise

    def fetch_all(self, per_page: int = 50, max_pages: int = 10,
                  by_type: str = None) -> pd.DataFrame:
        """
        Récupère toutes les pages et retourne un DataFrame.
        
        Args:
            per_page  : nombre de résultats par page
            max_pages : nombre maximum de pages à récupérer
            by_type   : filtre optionnel sur le type (ex: "micro", "brewpub")
        """
        all_data = []
        page = 1

        while page <= max_pages:
            logger.info(f"Récupération page {page}...")

            # Construction dynamique des paramètres
            params = {"page": page, "per_page": per_page}
            if by_type:
                params["by_type"] = by_type

            results = self.fetch_page(params=params)

            if not results:
                logger.info("Plus de données, extraction terminée.")
                break

            all_data.extend(results)
            logger.info(f"{len(results)} enregistrements récupérés.")

            page += 1
            time.sleep(0.5)

        self.data = pd.DataFrame(all_data)
        logger.info(f"Total : {len(self.data)} lignes extraites.")
        return self.data

    def filter_by_country(self, country: str) -> pd.DataFrame:
        """Filtre les données par pays."""
        if self.data is None:
            logger.warning("Aucune donnée. Lance d'abord .fetch_all()")
            return pd.DataFrame()
        filtered = self.data[self.data["country"] == country]
        logger.info(f"{len(filtered)} brasseries trouvées pour : {country}")
        return filtered

    def to_csv(self, filepath: str) -> None:
        """Sauvegarde le DataFrame en CSV."""
        if self.data is None:
            logger.warning("Aucune donnée à sauvegarder.")
            return
        self.data.to_csv(filepath, index=False)
        logger.info(f"Données sauvegardées : {filepath}")
