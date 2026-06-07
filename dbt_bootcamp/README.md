# dbt Bootcamp — Projet Superstore

## Description
Pipeline de transformation dbt sur les données Superstore Sales et Open Brewery DB.

## Structure
- **staging** : nettoyage et renommage des colonnes sources
- **intermediate** : agrégations intermédiaires
- **mart** : tables finales avec KPIs pour l'analyse

## Modèles principaux
| Modèle | Couche | Description |
|--------|--------|-------------|
| stg_superstore_sales | staging | Nettoyage des données Superstore |
| stg_breweries | staging | Nettoyage des données API |
| int_sales_by_region | intermediate | Ventes agrégées par région |
| mart_sales_performance | mart | KPIs finaux de performance |

## Commandes utiles
```bash
dbt run          # exécute tous les modèles
dbt test         # lance tous les tests
dbt build        # run + test
dbt docs serve   # lance la documentation
```

## Tests
19 tests automatisés couvrant :
- Contraintes not_null et unique
- Validation des valeurs acceptées
- Tests custom de qualité des données
