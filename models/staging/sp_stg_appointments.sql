{{ config(materialized='view') }}

select
    trim(appointment_id)    as appointment_id,
    trim(patient_id)        as patient_id,
    trim(doctor_id)         as doctor_id,
    appointment_date,
    appointment_time,
    trim(reason_for_visit)  as reason_for_visit,
    trim(status)            as appointment_status
from {{ source('practice', 'SOURCE_APPOINTMENTS') }}
