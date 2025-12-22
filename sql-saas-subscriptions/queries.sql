-- 1) query for total payments per month
SELECT
  substr(paid_ts, 1, 7) AS month,
  COUNT(*) AS payments,
  ROUND(SUM(amount), 2) AS revenue
FROM payments
GROUP BY 1
ORDER BY 1;

-- 2) query for Active subscriptions by plan
SELECT
  plan,
  COUNT(*) AS active_subscriptions
FROM subscriptions
WHERE status = 'active'
GROUP BY 1
ORDER BY active_subscriptions DESC;

-- 3) calc average revenue per paying user(Avg Revenue Per Paying User)
SELECT
  ROUND(SUM(amount) * 1.0 / NULLIF(COUNT(DISTINCT user_id), 0), 2) AS arppu
FROM payments;

-- 4) Conversion: signup -> purchase (user-level)
WITH signups AS (
  SELECT DISTINCT user_id
  FROM events
  WHERE event_name = 'signup'
),
purchasers AS (
  SELECT DISTINCT user_id
  FROM events
  WHERE event_name = 'purchase'
)
SELECT
  ROUND(
    100.0 * (SELECT COUNT(*) FROM purchasers) / NULLIF((SELECT COUNT(*) FROM signups), 0),
    2
  ) AS signup_to_purchase_pct;
  

-- 5) Time to first purchase (days) per user
WITH first_purchase AS (
  SELECT user_id, MIN(paid_ts) AS first_paid_ts
  FROM payments
  GROUP BY 1
)
SELECT
  u.user_id,
  u.full_name,
  u.created_at,
  fp.first_paid_ts,
  ROUND((julianday(fp.first_paid_ts) - julianday(u.created_at)), 2) AS days_to_first_purchase
FROM users u
JOIN first_purchase fp ON fp.user_id = u.user_id
ORDER BY days_to_first_purchase;

-- 6) DAU (daily active users) using login/feature_use events
SELECT
  substr(event_ts, 1, 10) AS day,
  COUNT(DISTINCT user_id) AS dau
FROM events
WHERE event_name IN ('login','feature_use')
GROUP BY 1
ORDER BY 1;

-- 7) Retention proxy: users who used feature 7+ days after signup
WITH signup_ts AS (
  SELECT user_id, MIN(event_ts) AS signup_ts
  FROM events
  WHERE event_name='signup'
  GROUP BY 1
),
later_usage AS (
  SELECT e.user_id
  FROM events e
  JOIN signup_ts s ON s.user_id=e.user_id
  WHERE e.event_name='feature_use'
    AND (julianday(e.event_ts) - julianday(s.signup_ts)) >= 7
  GROUP BY e.user_id
)
SELECT
  ROUND(100.0 * (SELECT COUNT(*) FROM later_usage) / NULLIF((SELECT COUNT(*) FROM signup_ts), 0), 2)
  AS retained_7d_pct;

-- 8) Power users: top users by feature_use count (RANK window)
WITH usage AS (
  SELECT user_id, COUNT(*) AS feature_uses
  FROM events
  WHERE event_name='feature_use'
  GROUP BY 1
)
SELECT
  user_id,
  feature_uses,
  RANK() OVER (ORDER BY feature_uses DESC) AS rnk
FROM usage
ORDER BY rnk, user_id;

-- 9) Revenue running total over time (window)
SELECT
  paid_ts,
  amount,
  ROUND(SUM(amount) OVER (ORDER BY paid_ts), 2) AS running_revenue
FROM payments
ORDER BY paid_ts;

-- 10) Revenue day-over-day delta (LAG)
WITH daily AS (
  SELECT substr(paid_ts, 1, 10) AS day, SUM(amount) AS revenue
  FROM payments
  GROUP BY 1
)
SELECT
  day,
  revenue,
  revenue - LAG(revenue) OVER (ORDER BY day) AS delta_vs_prev_day
FROM daily
ORDER BY day;
