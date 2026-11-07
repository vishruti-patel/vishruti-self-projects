{{ config(
    materialized='view'
) }}

-- Staging model for patients.
-- Cleans up raw patient data and standardizes column names / types.

with source as (

    -- Raw seed table (from dbt seed)
    select *
    from main.raw_patients

),

renamed as (

    select
        patient_id,
        cast(date_of_birth as date)       as date_of_birth,
        upper(gender)                     as gender,
        city,
        state,
        cast(enrollment_date as date)     as enrollment_date
    from source

)

select * from renamed
