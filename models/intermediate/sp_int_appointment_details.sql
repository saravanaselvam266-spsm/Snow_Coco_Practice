{{ config(materialized='view') }}

with appointments as (
    select * from {{ ref('sp_stg_appointments') }}
),

treatments as (
    select * from {{ ref('sp_stg_treatments') }}
),

billing as (
    select * from {{ ref('sp_stg_billing') }}
)

select
    appointments.appointment_id,
    appointments.patient_id,
    appointments.doctor_id,
    appointments.appointment_date,
    appointments.appointment_time,
    appointments.reason_for_visit,
    appointments.appointment_status,
    treatments.treatment_id,
    treatments.treatment_type,
    treatments.treatment_cost,
    billing.bill_id,
    billing.bill_date,
    billing.bill_amount,
    billing.payment_method,
    billing.payment_status
from appointments
left join treatments
    on appointments.appointment_id = treatments.appointment_id
left join billing
    on treatments.treatment_id = billing.treatment_id
