{{
    config(
        materialized='table',
        description='Transactions with validated amounts and discount logic applied'
    )
}}

select
    transaction_id,
    customer_id,
    product_name,
    product_category,
    store_location,
    quantity,
    price,
    quantity * price as total_price,
    coalesce(discount_applied, 0) as discount_applied,
    quantity * price * (1 - coalesce(discount_applied, 0) / 100) as final_price,
    payment_method,
    transaction_date,
    now() as dbt_loaded_at
from {{ ref('transactions') }}
where quantity > 0 and price >= 0
