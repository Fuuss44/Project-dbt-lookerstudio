{{
    config(
        materialized='table',
        description='Support tickets with resolution tracking and satisfaction handling'
    )
}}

select
    ticket_id,
    customer_id,
    issue_category,
    priority,
    submission_date,
    resolution_status,
    resolution_time_hours,
    case 
        when resolution_status = 'Resolved' then 1
        else 0 
    end as is_resolved,
    customer_satisfaction_score as satisfaction_score,
    case 
        when customer_satisfaction_score is null then 1
        else 0 
    end as has_null_satisfaction,
    notes,
    now() as dbt_loaded_at
from {{ ref('support_tickets') }}
