-- Operational Friction Analysis
-- Purpose: Identify inefficiencies in case handling
-- we want to calculate “Which teams experience the most friction and need process or staffing improvements?”

SELECT
    assignment_group,
    COUNT(*) AS total_cases,
    ROUND(AVG(resolution_time_hours), 1) AS avg_resolution_hours,
    SUM(CASE WHEN reopen_count > 0 THEN 1 ELSE 0 END) AS reopened_cases,
    ROUND(100.0 * SUM(CASE WHEN reopen_count > 0 THEN 1 ELSE 0 END) / COUNT(*), 1) AS reopen_rate_pct
FROM cases
GROUP BY assignment_group
ORDER BY avg_resolution_hours DESC;
