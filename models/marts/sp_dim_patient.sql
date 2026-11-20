{{ config(materialized='table') }}

select
    patient_id,
    first_name || ' ' || last_name as full_name,
    gender,
    date_of_birth,
    registration_date,
    insurance_provider
from {{ ref('sp_stg_patients') }}
