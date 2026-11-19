{{ config(materialized='view') }}

select
    trim(treatment_id)    as treatment_id,
    trim(appointment_id)  as appointment_id,
    trim(treatment_type)  as treatment_type,
    trim(description)     as treatment_description,
    cost                  as treatment_cost,
    treatment_date
from {{ source('hospital_raw', 'SOURCE_TREATMENTS') }}
