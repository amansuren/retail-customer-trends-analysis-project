# 🛍️ Customer Shopping Behaviour Analysis
 
**End-to-end retail data pipeline** - Python ETL -> PostgreSQL -> Power BI

## 📊 Full Business Analysis & Insights -> [View on Notion]()
 
> The GitHub repository contains all technical code and pipeline documentation.
> The **[Notion page](https://your-notion-page-link-here)** contains the full business analysis — problem statement, SQL insights, KPIs, recommendations, and key takeaways.


## Pipeline Overview
 
```
Raw CSV  -->  Python ETL -->  PostgreSQL  -->  SQL Analysis  -->  Power BI
```
 
**ETL steps:**
1. Load CSV (3,900 rows, 18 columns)
2. Impute 37 missing `review_rating` values using category-level median
3. Standardise column names to `snake_case`
4. Feature engineer `age_group` (quantile-based) and `purchase_frequency_days` (numeric mapping)
5. Drop redundant `promo_code_used` column
6. Load to PostgreSQL via SQLAlchemy
 


## Tech Stack
 
* Python 3.10, Pandas 
* PostgreSQL 14
* SQLAlchemy, psycopg2 
* PostgreSQL (CTEs, window functions) 
* Power BI


## Setup
 
```bash
# Install dependencies
pip install pandas psycopg2-binary sqlalchemy
 
# Configure PostgreSQL connection in notebook
username = "your_username"
password = "your_password"
host     = "localhost"
port     = "5432"
database = "customer_behaviour"
```
 
Run all cells in `notebooks/customer_shopping_behaviour.ipynb` top-to-bottom.
 
---
 
📊 **Business insights, recommendations, and findings** → [Notion Page](https://your-notion-page-link-here)
