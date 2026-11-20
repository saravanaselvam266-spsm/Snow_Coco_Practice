---
name: sp-dbt-int-marts
description: Build the dbt intermediate and marts layers (dimensions and facts) for the hospital analytics project, following our naming, safety and approval rules
---

# Build dbt intermediate and marts models (hospital project)

Use this skill when asked to create, review or extend intermediate (int) or marts
(dim / fct) models in the dbt project `coco_practice`.

## 1. Environment rules (never break these)
- Only use database COCO_PRACTICE_DB and schema PRACTICE.
- Never create databases, schemas or warehouses.
- Never modify or drop SOURCE_ tables, the existing staging models or views.
- Every new object and file uses the SP_ / sp_ prefix.
- Never set `+schema` or `schema=` in dbt_project.yml or in config().
  By default dbt appends it to the target schema and creates a NEW schema.
- The warehouse is shared and X-Small. Keep queries small. Never use SELECT *
  on large results; use LIMIT or COUNT for checks.
- Do not run `dbt run`, `dbt build` or `dbt test` without my approval.
  `dbt compile` is always allowed.
- Do not touch models/example/. Do not create packages.yml or install packages.

## 2. Always work in this order
1. INSPECT (read-only). List the files in models/staging/ and read sources.yml.
   Use the ACTUAL staging model names and column names you find. Do not guess them.
2. ASK what business question the model answers. If I have not given one,
   ask me before writing anything.
3. STATE THE GRAIN of the model in one sentence
   (example: "one row per appointment").
4. PROPOSE the model: file name, materialization, columns, joins.
   Explain it line by line. Wait for my approval.
5. WRITE one model per approval. Do not create all proposed models at once.
6. COMPILE and show the compiled SQL.
7. Only after approval: run ONLY that model with `--select <model_name>`.
8. VALIDATE (see section 6) and report the numbers.
9. Say clearly if any step would replace an existing object.

## 3. Layer rules

### Intermediate (models/intermediate/)
- Purpose: join and prepare staging data. No business KPIs, no reporting names.
- Name: sp_int_<what_it_prepares>.sql
- Materialization: view.
- Read only from staging models with `{{ ref('<staging model>') }}`.
  Never use `source()` here. Never read from marts.
- Join only on keys proven by the relationships below.

### Marts (models/marts/)
- Purpose: clean tables for BI and analytics.
- Dimensions: sp_dim_<entity>.sql. One row per entity, unique key, descriptive columns.
- Facts: sp_fct_<event>.sql. One row per event, foreign keys to dimensions,
  plus numeric measures.
- Materialization: table (data is small).
- Read from intermediate or staging models with `ref()`. Never use `source()`.
- A fact must never contain duplicated dimension attributes that belong in a dimension.

## 4. Known data relationships (already verified; do not re-profile)
- appointments.patient_id -> patients.patient_id
- appointments.doctor_id -> doctors.doctor_id
- treatments.appointment_id -> appointments.appointment_id
- billing.patient_id -> patients.patient_id
- billing.treatment_id -> treatments.treatment_id
- Today: 1 appointment = exactly 1 treatment = exactly 1 billing record.
  This may change, so after every join CHECK that the row count did not grow.
- Row counts: patients 50, doctors 10, appointments 200, treatments 200, billing 200.
- 48 of 50 patients have appointments. All 10 doctors have appointments.
  Use LEFT JOIN from a dimension when I need all patients, even those without visits.
- Categories: appointment status (Cancelled, Completed, No-show, Scheduled);
  payment status (Failed, Paid, Pending); payment method (Cash, Credit Card, Insurance).

## 5. SQL and style rules
- Lowercase SQL keywords. One column per line. Explicit column lists, no `select *`.
- Use CTEs (`with ... as`) named after what they hold.
- Use the primary keys from the data as keys. Do not generate surrogate keys with
  packages. Do not add a date dimension until I name a business need for it.
- Keep money columns as numbers. Do not round unless I ask.
- Add short comments only for non-obvious logic. Never put `{{ }}` inside comments.
- Do not add filters (for example removing cancelled visits) unless I
  state the business rule. Ask first.

## 6. Tests and validation (required for every model)
- Add tests in a .yml file in the same folder as the model:
  `unique` and `not_null` on the primary key, `relationships` on foreign keys.
- Add a description for the model and each key column.
- After running a model, verify and report:
  - row count compared with the expected grain
  - no duplicate keys
  - for joins: row count before vs after
  - 3 sample rows, using LIMIT 3
- If any test or check fails, STOP and explain. Do not "fix" it by deleting rows
  or loosening the test.

## 7. How to explain (I am learning)
- Use simple English. Say what the model does, why it exists, what happens in
  Snowflake when it runs, and what result I should see.
- When I ask you to practise, give me a small task and let me try first.
- If I make a mistake, explain why it is a mistake before showing the fix.
- Never claim something succeeded without showing its result.

## 8. Example models (patterns to copy)

These are PATTERNS ONLY. Do not create them unless I ask for that model.
Replace the staging names with the real file names found in models/staging/
(the examples use sp_stg_*). Use the exact column names from those models.

### Example A: intermediate model, one row per appointment
File: models/intermediate/sp_int_appointment_details.sql
Grain: one row per appointment. Joins use LEFT JOIN so no appointment is lost.

```sql
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
```

Why: joins happen once here, so every mart reads the same prepared data.
Check after running: row count must equal the appointments count (200 today).
If it is higher, a join is duplicating rows. Stop and investigate.

### Example B: dimension, one row per patient
File: models/marts/sp_dim_patient.sql

```sql
{{ config(materialized='table') }}

select
    patient_id,
    first_name || ' ' || last_name as full_name,
    gender,
    date_of_birth,
    registration_date,
    insurance_provider
from {{ ref('sp_stg_patients') }}
```

Why: a dimension describes WHO or WHAT. Only descriptive columns, one row per key.
Check: row count 50, patient_id unique and not null.
Note: contact details (phone, email, address) are left out on purpose.
Add them only if I say a report needs them.

### Example C: dimension, one row per doctor
File: models/marts/sp_dim_doctor.sql

```sql
{{ config(materialized='table') }}

select
    doctor_id,
    first_name || ' ' || last_name as full_name,
    specialization,
    years_experience,
    hospital_branch
from {{ ref('sp_stg_doctors') }}
```

Check: row count 10, doctor_id unique and not null.

### Example D: fact, one row per appointment
File: models/marts/sp_fct_appointments.sql

```sql
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
```

Why: a fact describes WHAT HAPPENED. It holds keys (patient_id, doctor_id),
dates and numeric measures. Names and other descriptions stay in the dimensions.
Check: row count 200, appointment_id unique, every patient_id exists in
sp_dim_patient, every doctor_id exists in sp_dim_doctor.

### Example E: tests and descriptions for the marts
File: models/marts/sp_marts.yml

```yaml
version: 2

models:
  - name: sp_dim_patient
    description: One row per patient with descriptive attributes.
    columns:
      - name: patient_id
        description: Primary key of the patient.
        tests: [unique, not_null]

  - name: sp_dim_doctor
    description: One row per doctor with specialization and branch.
    columns:
      - name: doctor_id
        description: Primary key of the doctor.
        tests: [unique, not_null]

  - name: sp_fct_appointments
    description: One row per appointment, with treatment and billing measures.
    columns:
      - name: appointment_id
        description: Primary key of the appointment.
        tests: [unique, not_null]
      - name: patient_id
        tests:
          - relationships:
              to: ref('sp_dim_patient')
              field: patient_id
      - name: doctor_id
        tests:
          - relationships:
              to: ref('sp_dim_doctor')
              field: doctor_id
```

Rules for YAML: top-level keys start in column 1, indent with 2 spaces,
never use tabs. The `name` of a model must match its file name.

### Example F: how to validate after a run (small queries only)

```sql
select count(*) as n from SP_FCT_APPOINTMENTS;            -- expect 200
select count(*) - count(distinct appointment_id) as dups
from SP_FCT_APPOINTMENTS;                                  -- expect 0
select count(*) as orphans
from SP_FCT_APPOINTMENTS f
left join SP_DIM_PATIENT p on f.patient_id = p.patient_id
where p.patient_id is null;                                -- expect 0
```
