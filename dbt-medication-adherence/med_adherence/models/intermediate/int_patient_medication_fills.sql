{{ config (
    materialized = 'table'
) }}

-- Intermediate model: one row per fill event, enriched with patient
-- and medication attributes. This is the base fact table for adherence.

with prescriptions as(
    select *
    from {{ ref('stg_prescriptions') }}
),

patients as (
    select *
    from {{ ref('stg_patients') }}
),

medications as (
    select *
    from {{ ref('stg_medications') }}
),

joined as (
    select p.prescription_id,
        p.patient_id,
        pt.date_of_birth,
        pt.gender,
        pt.city,
        pt.state,
        pt.enrollment_date,

        p.medication_id,
        m.medication_name,
        m.therapeutic_class,
        m.form,
        m.strength_mg,

        p.prescribed_date,
        p.fill_date,
        p.days_supply,
        p.refill_number,
        p.pharmacy_id,
        p.status
    from prescriptions p
    left join patients pt
        on p.patient_id = pt.patient_id
    left join medications m
        on p.medication_id = m.medication_id
)

select * from joined