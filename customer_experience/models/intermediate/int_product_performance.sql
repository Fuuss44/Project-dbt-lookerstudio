{{
    config(
        materialized='table',
        description='Product category performance aggregated from transactions and reviews'
    )
}}

select
    t.product_category,
    coalesce(sum(t.final_price), 0) as total_revenue,
    coalesce(count(distinct t.transaction_id), 0) as order_volume,
    round(avg(r.rating), 2) as avg_rating,
    coalesce(count(distinct r.review_id), 0) as review_count
from {{ ref('stg_transactions') }} t
left join {{ ref('stg_reviews') }} r on t.product_category = r.product_category
where t.product_category is not null
group by t.product_category
