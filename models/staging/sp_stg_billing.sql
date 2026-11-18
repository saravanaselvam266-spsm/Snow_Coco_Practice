{{ config(materialized='view') }}

select
    trim(bill_id)          as bill_id,
    trim(patient_id)       as patient_id,
    trim(treatment_id)     as treatment_id,
    bill_date,
    amount                 as bill_amount,
    trim(payment_method)   as payment_method,
    trim(payment_status)   as payment_status
from {{ source('practice', 'SOURCE_BILLING') }}
