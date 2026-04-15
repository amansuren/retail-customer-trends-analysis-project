
# Data Analysis & ETL Pipeline

👉 [Open Notebook - customer_shopping_behaviour.ipynb](./customer_shopping_behaviour.ipynb)

## Overview
 
This notebook performs end-to-end data preparation and analysis on a **Customer Shopping Behaviour** dataset. 
It covers data loading, exploration, cleaning, feature engineering, and finally loading the processed data into a **PostgreSQL** database for further querying and reporting.

## 🔄 Workflow
 
### 1. 📥 Data Loading
- Loads the CSV dataset into a pandas DataFrame using `pd.read_csv()`.
### 2. 🔍 Exploratory Data Analysis (EDA)
- **`df.head(10)`** — Preview the first 10 rows.
- **`df.info()`** — Check column data types and non-null counts.
- **`df.describe(include='all')`** — Summary statistics for all columns (numeric & categorical).
### 3. 🧹 Data Cleaning
 
#### Missing Values
- Identified null values using `df.isnull().sum()`.
- Filled missing values in the **`Review Rating`** column with the **median rating per category** using a `groupby` + `transform` approach — ensuring context-aware imputation rather than a global fill.
#### Column Standardisation
- Converted all column names to **lowercase**.
- Replaced spaces with **underscores** for consistency.
- Renamed `purchase_amount_(usd)` → `purchase_amount` for cleaner access.

### 4. ⚙️ Feature Engineering (New columns)
 
#### `age_group` 
Segments customers into **4 age bands** using quantile-based binning (`pd.qcut`): Label and Description 
* `young Adult` - Bottom 25% by age 
* `Adult` - 25th–50th percentile 
* `Middle-aged` - 50th–75th percentile 
* `Senior` - Top 25% by age 
 
#### `purchase_frequency_days` 
Converts text-based purchase frequency into numeric days, enabling time-series and interval analysis: Original Value and Days 
*  `Weekly` - 7 
*  `Fortnightly / Bi-Weekly` - 14 
*  `Monthly` - 30 
*  `Quarterly / Every 3 Months` - 90 
*  `Annually` - 365 
 
#### Column Removal
- **Dropped `promo_code_used`** — deemed redundant since `discount_applied` already captures whether a discount was applied.

### 5. 🐘 PostgreSQL Integration
- Connects to a local PostgreSQL instance using **SQLAlchemy** (`psycopg2` driver).
- Loads the cleaned and engineered DataFrame into the `customer` table inside the `customer_behaviour` database.
- Uses `if_exists="replace"` to overwrite the table on each run .
