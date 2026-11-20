{{ config(materialized='table') }}

select
    doctor_id,
    first_name || ' ' || last_name as full_name,
    specialization,
    years_experience,
    hospital_branch
from {{ ref('sp_stg_doctors') }}
