{{ config(materialized='table') }}

with date_bounds as (
    select
        date_from_parts(year(min_date), 1, 1) as start_date,
        date_from_parts(year(max_date), 12, 31) as end_date
    from (
        select
            least(
                (select min(appointment_date) from {{ ref('sp_stg_appointments') }}),
                (select min(treatment_date) from {{ ref('sp_stg_treatments') }}),
                (select min(bill_date) from {{ ref('sp_stg_billing') }}),
                (select min(registration_date) from {{ ref('sp_stg_patients') }})
            ) as min_date,
            greatest(
                (select max(appointment_date) from {{ ref('sp_stg_appointments') }}),
                (select max(treatment_date) from {{ ref('sp_stg_treatments') }}),
                (select max(bill_date) from {{ ref('sp_stg_billing') }}),
                (select max(registration_date) from {{ ref('sp_stg_patients') }})
            ) as max_date
    )
),

date_spine as (
    select
        dateadd(day, seq4(), (select start_date from date_bounds)) as date_day
    from table(generator(rowcount => 5000))
)

select
    ds.date_day,
    year(ds.date_day) as year_number,
    quarter(ds.date_day) as quarter_number,
    month(ds.date_day) as month_number,
    monthname(ds.date_day) as month_name,
    to_char(ds.date_day, 'YYYY-MM') as year_month,
    day(ds.date_day) as day_of_month,
    dayname(ds.date_day) as day_name,
    dayofweekiso(ds.date_day) as iso_day_of_week,
    case when dayofweekiso(ds.date_day) in (6, 7) then true else false end as is_weekend,
    dateadd(day, -(dayofweekiso(ds.date_day) - 1), ds.date_day) as week_start_date
from date_spine ds
where ds.date_day <= (select end_date from date_bounds)
order by ds.date_day
