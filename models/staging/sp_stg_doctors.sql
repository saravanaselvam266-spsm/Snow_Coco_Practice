{{ config(materialized='view') }}

select
    trim(doctor_id)        as doctor_id,
    trim(first_name)       as first_name,
    trim(last_name)        as last_name,
    trim(specialization)   as specialization,
    trim(phone_number)     as phone_number,
    years_experience,
    trim(hospital_branch)  as hospital_branch,
    trim(email)            as email
from {{ source('practice', 'SOURCE_DOCTORS') }}
