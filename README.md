# Customer Experience Analytics with dbt and Looker Studio

A comprehensive data analytics project designed to analyze customer experience and business performance using dbt for data transformation and Looker Studio for visualization.
Looker link : [https://lookerstudio.google.com/s/hHMoW5CWElA](https://datastudio.google.com/reporting/518d01c2-ac4f-4e5f-b68b-7849474e0bd9)

## Project Objective

Transform raw retail data into a clean, analyzable star schema using dbt, enabling strategic insights on:
- Customer lifetime value and segmentation
- Product performance and category analysis
- Customer support quality and satisfaction metrics
- Marketing campaign ROI effectiveness
- Customer behavior and engagement patterns

## Dataset Overview

Source data from Kaggle: [Retail Customer and Transaction Dataset](https://www.kaggle.com/datasets/raghavendragandhi/retail-customer-and-transaction-dataset)

### Data Summary

| Table | Rows | Key Columns | Coverage |
|-------|------|------------|----------|
| **customers** | 5,000 | customer_id, age, gender, registration_date, preferred_channel | Baseline dimension |
| **transactions** | 32,295 | transaction_id, customer_id, product_name, price, quantity, discount, payment_method | Core fact table |
| **support_tickets** | 3,000 | ticket_id, customer_id, issue_category, satisfaction_score, resolution_time | CX metrics |
| **interactions** | 100,000 | interaction_id, customer_id, channel, interaction_type, session_id, duration | Behavioral data |
| **campaigns** | 200 | campaign_id, campaign_type, budget, impressions, conversions, roi | Marketing performance |
| **customer_reviews** | 1,000 | review_id, customer_id, product_id, rating, review_text | Sentiment analysis |

### Data Quality Assessment

- Average NULL values: 2-3% (manageable)
- Unique customers with transactions: 100% coverage
- Date range: 2020 to 2024 (4 years of historical data)
- Data consistency: Strong referential integrity between customer_id across tables
- Critical data completeness: 97%+ for transaction amounts and dates

### Key Findings

- 32,295 transactions generating total revenue to be calculated in marts
- 100,000 interaction events (highly dimensional data, requires aggregation)
- Average customer satisfaction score: To be computed from resolved tickets
- Product diversity: 20+ categories tracked
- Marketing ROI varies from -61% to +558% (profitable and unprofitable campaigns)

## dbt Pipeline Architecture (3-Layer)

###  Staging Layer (6 models)
Raw data cleaning and standardization from CSV sources:
- **stg_customers**: COALESCE missing demographics, standardize preferred_channel → 'unknown'
- **stg_transactions**: Calculate final_price with discount logic, validate quantity > 0
- **stg_support_tickets**: Create is_resolved flag, track resolution_time_hours 
- **stg_interactions**: Preserve all events (100k rows), include session_id grouping
- **stg_campaigns**: Pass-through campaigns with ROI pre-calculated
- **stg_reviews**: Preserve all reviews with ratings (1-5 scale)

###  Intermediate Layer (2 models)
Business logic aggregations for reuse across marts:
- **int_customer_metrics**: Aggregate by customer_id → lifetime_value, order_count, avg_satisfaction_score
- **int_product_performance**: Aggregate by product_category → total_revenue, order_volume, avg_rating

###  Marts Layer (2 models) 
Analytics-ready denormalized tables for Looker Studio:
- **fct_customer_orders**: Fact table (32k+ rows) enriched transactions with customer metrics
- **dim_customer_experience**: Customer dimension with value segments (High/Medium/Low) + satisfaction levels (Satisfied/Neutral/At Risk)

## KPI Production

Primary metrics to be calculated:

- Total Revenue (SUM of final transaction amounts)
- Average Order Value (customer ordering patterns)
- Customer Segmentation (VIP, High Value, Active, Inactive)
- Customer Satisfaction Rate (average satisfaction score)
- Average Resolution Time (support efficiency)
- Churn Risk Score (days since last purchase + satisfaction correlation)
- Product Performance (units sold, category trends)
- Campaign ROI Effectiveness (marketing channel analysis)

## Data Quality Tests (dbt)

All models include automated tests:
- Unique and NOT NULL checks on primary keys
- Expression validation (prices > 0, satisfaction scores 1-5)
- Referential integrity between dimensional keys
- NULL percentage monitoring
- Date consistency validation

## Project Status

### Completed 
- EDA analysis of 6 CSV sources with findings documented in EDA-all.ipynb
- dbt project initialized with DuckDB adapter
- CSV seeds loaded into DuckDB via `dbt seed`
- All 10 models (6 staging + 2 intermediate + 2 marts) built and tested
- Data quality tests passing (unique, not_null constraints on PKs)
- Marts tables ready for Looker Studio export

### Next Steps
- Export marts to CSV for Looker Studio import
- Create interactive dashboards in Looker Studio (KPI, Customer Segments, Product Performance)

## Quick Start Commands

```bash
# Activate Python environment
source .venv/Scripts/activate  # (or .venv\Scripts\activate on Windows)
cd customer_experience

# Build entire pipeline
dbt run

# Build specific layers
dbt run --select path:models/staging
dbt run --select path:models/intermediate
dbt run --select path:models/marts

# Run data quality tests
dbt test

# Full pipeline with fresh rebuild
dbt clean && dbt run && dbt test
```

## Export to Looker Studio

Export marts from DuckDB to CSV:

```bash
# Using DuckDB CLI
duckdb dev.duckdb "SELECT * FROM fct_customer_orders" > fct_customer_orders.csv
duckdb dev.duckdb "SELECT * FROM dim_customer_experience" > dim_customer_experience.csv

# Then import CSVs into Looker Studio via Google Drive or direct upload
```

```
Project-dbt-lookerstudio/
├── README.md (this file)
├── Data/ (raw CSV sources)
│   ├── customers.csv
│   ├── transactions.csv
│   ├── support_tickets.csv
│   ├── interactions.csv
│   ├── campaigns.csv
│   └── customer_reviews_complete.csv
├── EDA-all.ipynb (exploratory analysis)
├── dbt_project.yml (dbt configuration)
├── profiles.yml (database connection)
└── models/
    ├── staging/ (source cleaning)
    ├── intermediate/ (business logic)
    └── marts/ (analytics tables)
```

## Setup Instructions

### Prerequisites

- Python 3.8+
- dbt-core
- PostgreSQL or compatible data warehouse
- Virtual environment configured

### Installation

```bash
# Activate virtual environment
source .venv/Scripts/activate  # Windows
source .venv/bin/activate     # macOS/Linux

# Install dbt
pip install dbt-postgres

# Initialize dbt project structure
dbt init

# Configure database connection in profiles.yml
```

### Running the Pipeline

```bash
# Test database connection
dbt debug

# Execute all models
dbt run

# Run only staging layer
dbt run --select stg_* & path:models/{staging}{intermediate}{mart}

# Execute tests
dbt test

# Generate documentation
dbt docs generate
dbt docs serve
```

## Next Steps

1. Initialize dbt project structure
2. Configure database connection (PostgreSQL or Redshift)
3. Set up source definitions (schema.yml)
4. Develop staging models (stg_*.sql)
5. Add data quality tests
6. Build intermediate models
7. Create analytics-ready mart tables
8. Connect Looker Studio for visualization
9. Document lineage and create data dictionary

## Key Insights for Interview Preparation

- Demonstrates understanding of ETL/ELT patterns
- Shows data quality discipline through automated testing
- Illustrates dimensional modeling (star schema)
- Highlights customer experience metrics calculation
- Connects business questions to technical implementation
- Emphasizes reproducibility and version control
