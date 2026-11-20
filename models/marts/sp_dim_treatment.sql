{{ config(materialized='table') }}

select
    md5(treatment_id) as treatment_sk,
    treatment_id,
    appointment_id,
    treatment_type,
    treatment_description as description,
    treatment_cost as cost,
    treatment_date
from {{ ref('sp_stg_treatments') }}
