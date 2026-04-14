{{
    config(
        materialized='table',
        description='Customer interactions standardized with channel and type tracking'
    )
}}

select
    interaction_id,
    customer_id,
    channel,
    interaction_type,
    interaction_date,
    duration,
    page_or_product,
    session_id,
    now() as dbt_loaded_at
from {{ ref('interactions') }}
