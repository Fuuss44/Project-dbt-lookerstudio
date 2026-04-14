{{
    config(
        materialized='table',
        description='Customer metrics aggregated from transactions and support tickets'
    )
}}

select
    c.customer_id,
    coalesce(sum(t.final_price), 0) as lifetime_value,
    coalesce(count(distinct t.transaction_id), 0) as order_count,
    round(avg(s.satisfaction_score), 2) as avg_satisfaction_score,
    coalesce(count(distinct s.ticket_id), 0) as total_support_tickets
from {{ ref('stg_customers') }} c
left join {{ ref('stg_transactions') }} t on c.customer_id = t.customer_id
left join {{ ref('stg_support_tickets') }} s on c.customer_id = s.customer_id
group by c.customer_id
