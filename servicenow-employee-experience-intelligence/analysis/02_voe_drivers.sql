-- VOE Driver Analysis
-- Purpose: Identify what impacts employee satisfaction
-- We want to calculate “How quickly do cases need to be resolved to maintain good employee experience?”

SELECT
    CASE
        WHEN resolution_time_hours <= 8 THEN '0–8 hrs'
        WHEN resolution_time_hours <= 24 THEN '8–24 hrs'
        WHEN resolution_time_hours <= 48 THEN '24–48 hrs'
        ELSE '48+ hrs'
    END AS resolution_bucket,
    COUNT(*) AS case_count,
    ROUND(AVG(voe_score), 2) AS avg_voe_score
FROM cases
WHERE voe_score IS NOT NULL
GROUP BY resolution_bucket
ORDER BY case_count DESC;
