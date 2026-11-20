{{ config(materialized='table') }}

select
    bill_id,
    patient_id,
    treatment_id,
    bill_date,
    bill_amount,
    payment_method,
    payment_status
from {{ ref('sp_stg_billing') }}
