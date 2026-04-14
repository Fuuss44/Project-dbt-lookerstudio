{{
    config(
        materialized='table',
        description='Customer dimension with value and satisfaction segmentation for Looker'
    )
}}

select
    c.customer_id,
    c.full_name,
    c.state,
    c.preferred_channel,
    m.lifetime_value,
    m.order_count,
    m.avg_satisfaction_score,
    m.total_support_tickets,
    case
        when m.lifetime_value >= 1000 then 'High Value'
        when m.lifetime_value >= 300 then 'Medium Value'
        else 'Low Value'
    end as customer_segment,
    case
        when m.avg_satisfaction_score >= 4 then 'Satisfied'
        when m.avg_satisfaction_score >= 2 then 'Neutral'
        else 'At Risk'
    end as satisfaction_level
from {{ ref('stg_customers') }} c
left join {{ ref('int_customer_metrics') }} m on c.customer_id = m.customer_id
