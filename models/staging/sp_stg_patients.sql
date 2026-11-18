{{ config(materialized='view') }}

select
    trim(patient_id)          as patient_id,
    trim(first_name)          as first_name,
    trim(last_name)           as last_name,
    trim(gender)              as gender,
    date_of_birth,
    trim(contact_number)      as phone_number,
    trim(address)             as address,
    registration_date,
    trim(insurance_provider)  as insurance_provider,
    trim(insurance_number)    as insurance_number,
    trim(email)               as email
from {{ source('practice', 'SOURCE_PATIENTS') }}
