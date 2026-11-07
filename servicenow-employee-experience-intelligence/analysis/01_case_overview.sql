-- Case Overview Metrics
-- Purpose: High-level view for leadership
-- we want to calculate - “Which support areas generate the most cases, take the longest to resolve, and hurt employee satisfaction.”

SELECT
    category,
    COUNT(*) AS total_cases,
    ROUND(AVG(resolution_time_hours), 1) AS avg_resolution_hours,
    ROUND(100.0 * SUM(CASE WHEN sla_breached = 'Y' THEN 1 ELSE 0 END) / COUNT(*), 1) AS sla_breach_rate_pct,
    ROUND(AVG(voe_score), 2) AS avg_voe_score
FROM cases
GROUP BY category
ORDER BY total_cases DESC;
