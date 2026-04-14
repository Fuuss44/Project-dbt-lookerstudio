{{
    config(
        materialized='table',
        description='Product reviews cleaned and standardized'
    )
}}

select
    review_id,
    customer_id,
    product_name,
    product_category,
    full_name,
    transaction_date,
    review_date,
    rating,
    review_title,
    review_text,
    now() as dbt_loaded_at
from {{ ref('customer_reviews_complete') }}
