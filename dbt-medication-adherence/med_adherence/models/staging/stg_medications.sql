{{ config (
    materialized = 'view'
) }}

-- Staging model for medications.
-- Normalizes field names and data types for medication attributes.

with source as (

    select *
    from main.raw_medications
),

renamed as (
    select medication_id,
        medication_name,
        therapeutic_class,
        form,
        cast(strength_mg as integer) as strength_mg
    from source
)

select * from renamed