{{
    config(
        materialized='table',
        description='Fact table - transactions enriched with customer lifetime value and satisfaction'
    )
}}

select
    t.transaction_id,
    t.customer_id,
    t.product_name,
    t.product_category,
    t.quantity,
    t.price,
    t.discount_applied,
    t.final_price,
    t.payment_method,
    t.transaction_date,
    t.store_location,
    m.lifetime_value,
    m.order_count,
    m.avg_satisfaction_score,
    m.total_support_tickets
from {{ ref('stg_transactions') }} t
left join {{ ref('int_customer_metrics') }} m on t.customer_id = m.customer_id
