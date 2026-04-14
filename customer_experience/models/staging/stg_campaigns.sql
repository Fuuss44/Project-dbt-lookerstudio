{{
    config(
        materialized='table',
        description='Marketing campaigns with budget and performance metrics'
    )
}}

select
    campaign_id,
    campaign_name,
    campaign_type,
    start_date,
    end_date,
    target_segment,
    budget,
    impressions,
    clicks,
    conversions,
    conversion_rate,
    roi,
    now() as dbt_loaded_at
from {{ ref('campaigns') }}
