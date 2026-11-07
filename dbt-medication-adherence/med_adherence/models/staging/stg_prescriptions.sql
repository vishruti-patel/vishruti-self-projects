{{ config (
    materialized = 'view'
) }}

-- Staging model for prescriptions / fills.
-- Cleans dates, standardizes status, and prepares for adherence logic.

with source as (

    select *
    from main.raw_prescriptions
),

cleaned as (
    select prescription_id,
        patient_id,
        medication_id,
        cast(prescribed_date as date)   as prescribed_date,
        cast(days_supply as integer)    as days_supply,
        cast(refill_number as integer)  as refill_number,
        cast(fill_date as date)         as fill_date,
        pharmacy_id, 
        lower(status)                   as status
    from source
),


filtered as (
    select * 
    from cleaned
    where status in ('filled', 'canceled')
)


select * from filtered