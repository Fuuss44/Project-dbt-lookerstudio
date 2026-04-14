{{
    config(
        materialized='table',
        description='Customers with standardized demographics and preferences'
    )
}}

select
    customer_id,
    full_name,
    age,
    gender,
    email,
    phone,
    street_address,
    city,
    state,
    zip_code,
    registration_date,
    coalesce(preferred_channel, 'unknown') as preferred_channel,
    now() as dbt_loaded_at
from {{ ref('customers') }}
