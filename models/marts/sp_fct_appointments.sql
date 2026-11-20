{{ config(materialized='table') }}

select
    appointment_id,
    patient_id,
    doctor_id,
    appointment_date,
    appointment_status,
    reason_for_visit,
    treatment_type,
    treatment_cost,
    bill_amount,
    payment_method,
    payment_status
from {{ ref('sp_int_appointment_details') }}
