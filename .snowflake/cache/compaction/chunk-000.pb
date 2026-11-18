
û
	README.mdÁWelcome to your new dbt project!

### Using the starter project

Try running the following commands:
- dbt run
- dbt test


### Resources:
- Learn more about dbt [in the docs](https://docs.getdbt.com/docs/introduction)
- Check out [Discourse](https://discourse.getdbt.com/) for commonly asked questions and answers
- Join the [dbt community](https://getdbt.com/community) to learn from other analytics engineers
- Find [dbt events](https://events.getdbt.com) near you
- Check out [the blog](https://blog.getdbt.com/) for the latest news on dbt's development and best practices
*
Ú·ð× 429dce6f0ad5ecbca2c362903f4bf1ef
¾
!models/staging/sp_stg_billing.sqlì{{ config(materialized='view') }}

select
    trim(bill_id)          as bill_id,
    trim(patient_id)       as patient_id,
    trim(treatment_id)     as treatment_id,
    bill_date,
    amount                 as bill_amount,
    trim(payment_method)   as payment_method,
    trim(payment_status)   as payment_status
from {{ source('practice', 'SOURCE_BILLING') }}
*
ü†õ× 7379c2ec70114bed02250f896fe21ce6
«
$models/staging/sp_stg_treatments.sqlÖ{{ config(materialized='view') }}

select
    trim(treatment_id)    as treatment_id,
    trim(appointment_id)  as appointment_id,
    trim(treatment_type)  as treatment_type,
    trim(description)     as treatment_description,
    cost                  as treatment_cost,
    treatment_date
from {{ source('practice', 'SOURCE_TREATMENTS') }}
*
û†õ× c453432d7ed3a96052592a9076fb3db9
É
&models/staging/sp_stg_appointments.sqlò{{ config(materialized='view') }}

select
    trim(appointment_id)    as appointment_id,
    trim(patient_id)        as patient_id,
    trim(doctor_id)         as doctor_id,
    appointment_date,
    appointment_time,
    trim(reason_for_visit)  as reason_for_visit,
    trim(status)            as appointment_status
from {{ source('practice', 'SOURCE_APPOINTMENTS') }}
*
ú†õ× af7295c0c494362f327514f90b8ca966
ë
!models/staging/sp_stg_doctors.sql™{{ config(materialized='view') }}

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
*
ù†õ× 80d54a74c3b24106497c70ef468685f8
ï
"models/staging/sp_stg_patients.sqlœ{{ config(materialized='view') }}

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
*
ø†õ× 32cf8257e1c11457b2f28f1daef0a461
±
%models/example/my_first_dbt_model.sqlÛ
/*
    Welcome to your first dbt model!
    Did you know that you can also configure models directly within SQL files?
    This will override configurations stated in dbt_project.yml

    Try changing "table" to "view" below
*/

{{ config(materialized='table') }}

with source_data as (

    select 1 as id
    union all
    select null as id

)

select *
from source_data

/*
    Uncomment the line below to remove records with null `id` values
*/

-- where id is not null
*
Ú·ð× 1e97e6684bf41b2203c5cb165b355d8c
É
&models/example/my_second_dbt_model.sqls
-- Use the `ref` function to select from other models

select *
from {{ ref('my_first_dbt_model') }}
where id = 1
*
Ú·ð× a517f5165049b0dfe0d8d338c6141af4
Ã
models/staging/sources.ymløversion: 2

sources:
  - name: hospital_raw
    database: COCO_PRACTICE_DB
    schema: PRACTICE
    description: Raw hospital source tables
    tables:
      - name: SOURCE_APPOINTMENTS
        description: Raw appointments data
      - name: SOURCE_BILLING
        description: Raw billing data
      - name: SOURCE_DOCTORS
        description: Raw doctors data
      - name: SOURCE_PATIENTS
        description: Raw patients data
      - name: SOURCE_TREATMENTS
        description: Raw treatments data*
Åîô× 720c583677969bf457cbc57a90cb47ae
ã
dbt_project.yml£name: 'coco_practice'
version: '1.0.0'
config-version: 2

profile: 'default'

model-paths: ["models"]
analysis-paths: ["analyses"]
test-paths: ["tests"]
seed-paths: ["seeds"]
macro-paths: ["macros"]
snapshot-paths: ["snapshots"]

clean-targets:
  - "target"
  - "dbt_packages"*
Ú·ð× 62c3f00fe6cc6dbc0786e9ccb6153560
»
models/example/schema.ymlñ
version: 2

models:
    - name: my_first_dbt_model
      description: "A starter dbt model"
      columns:
          - name: id
            description: "The primary key for this table"
            tests:
                - unique
                - not_null

    - name: my_second_dbt_model
      description: "A starter dbt model"
      columns:
          - name: id
            description: "The primary key for this table"
            tests:
                - unique
                - not_null
*
Ú·ð× f426088a706515fa590259e81a0e542c