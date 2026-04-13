# Customer Experience Analytics with dbt and Looker Studio

A comprehensive data analytics project designed to analyze customer experience and business performance using dbt for data transformation and Looker Studio for visualization.

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

## Data Cleaning Strategy (dbt)

### Staging Layer
1. stg_customers: Handle missing demographics (age, email ~2%), standardize channels
2. stg_transactions: Validate prices > 0, manage discount logic, flag invalid records
3. stg_support_tickets: Create resolution flags, handle missing satisfaction scores (11%)
4. stg_interactions: Preserve all events, flag missing channel/type fields
5. stg_campaigns: Minimal transformations, standardize date formats
6. stg_reviews: Minimal nulls (<3%), flag incomplete reviews

### Intermediate Layer
1. int_customer_metrics: Aggregate revenue, order count, tenure by customer
2. int_product_performance: Category performance, popularity metrics
3. int_support_quality: Ticket volume, resolution time, satisfaction by issue type
4. int_interaction_summary: Session aggregation, engagement scoring
5. int_customer_satisfaction_risk: Segment at-risk customers

### Marts Layer (Analytics-Ready)
1. fact_customer_orders: Granular transaction table with customer context
2. fact_support_interactions: Enriched ticket data with customer lifetime value
3. dim_customer_experience: Customer dimension with segmentation and churn risk
4. dim_product_performance: Product dimension with category metrics
5. dim_marketing_campaigns: Campaign performance analysis

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

## Technology Stack

- Language: SQL (dbt)
- Data Source: CSV files (local)
- Transformation Engine: dbt (data build tool)
- Visualization: Looker Studio
- Development Environment: Python, Jupyter Notebook for EDA
- Database Target: PostgreSQL / Redshift compatible SQL

## Project Structure

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
dbt run --select stg_*

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
