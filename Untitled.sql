

select table_schema, table_name
from COCO_PRACTICE_DB.INFORMATION_SCHEMA.VIEWS
where table_name = 'SP_INT_APPOINTMENT_DETAILS';


select
    count(*)                       as total_rows,
    count(distinct appointment_id) as unique_appointments,
    count_if(treatment_id is null) as missing_treatment,
    count_if(bill_id is null)      as missing_bill
from COCO_PRACTICE_DB.PRACTICE.SP_INT_APPOINTMENT_DETAILS





select table_schema, table_name, table_type
from COCO_PRACTICE_DB.INFORMATION_SCHEMA.TABLES
where table_name = 'SP_DIM_PATIENT';



select
    count(*)                   as total_rows,
    count(distinct patient_id) as unique_patients,
    count_if(full_name is null) as null_names
from COCO_PRACTICE_DB.PRACTICE.SP_DIM_PATIENT;


select table_schema, table_name, table_type
from COCO_PRACTICE_DB.INFORMATION_SCHEMA.TABLES
where table_name = 'SP_DIM_DOCTOR';



select
    count(*)                    as total_rows,
    count(distinct doctor_id)   as unique_doctors,
    count_if(full_name is null) as null_names
from COCO_PRACTICE_DB.PRACTICE.SP_DIM_DOCTOR;


select table_schema, table_name, table_type
from COCO_PRACTICE_DB.INFORMATION_SCHEMA.TABLES
where table_name = 'SP_FCT_APPOINTMENTS';


select
    count(*)                       as total_rows,
    count(distinct appointment_id) as unique_appointments
from COCO_PRACTICE_DB.PRACTICE.SP_FCT_APPOINTMENTS;


select
    count_if(p.patient_id is null) as orphan_patients,
    count_if(d.doctor_id  is null) as orphan_doctors
from COCO_PRACTICE_DB.PRACTICE.SP_FCT_APPOINTMENTS f
left join COCO_PRACTICE_DB.PRACTICE.SP_DIM_PATIENT p on f.patient_id = p.patient_id
left join COCO_PRACTICE_DB.PRACTICE.SP_DIM_DOCTOR  d on f.doctor_id  = d.doctor_id;