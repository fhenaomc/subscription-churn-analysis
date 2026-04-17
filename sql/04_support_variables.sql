#GENERAL VIEW FOR SUPPORT CASES INFO

CREATE VIEW support_variables AS
SELECT case_id, cc.customer_id, date_time, channel, reason, age, 
gender, signup_date_time, cancel_date_time, name as subscription_type,
CASE WHEN cancel_date_time IS NOT NULL THEN 1 ELSE 0 END AS churn_flag
FROM customer_cases cc
LEFT JOIN customer_info ci ON ci.customer_id = cc.customer_id
LEFT JOIN customer_product cp ON cp.customer_id = ci.customer_id
LEFT JOIN product_info pi ON pi.product_id = cp.product;

# From past analysis:
-- Total customer cases: 330512
-- Distinct customers with cases: 258660 
-- Case distribution: 200985 support cases and 129527 sign up cases
-- Case date range: From 2017-01-01 10:32:03 to 2022-01-01 06:32:53
-- No duplicate case_id values were found

-- ------------------------------------------------------------------------------

SELECT *
FROM support_variables;

WITH CTE AS (
SELECT DISTINCT (cp.customer_id),
CASE WHEN case_id IS NOT NULL THEN 'with_cases' 
ELSE 'without_cases' END AS customer_cases,
CASE WHEN cancel_date_time IS NOT NULL THEN 1 ELSE 0 END AS churn_flag
FROM customer_product cp
LEFT JOIN customer_cases cc ON cp.customer_id=cc.customer_id)
SELECT customer_cases, COUNT(*) qty, 
ROUND(COUNT(*)*100/SUM(COUNT(*)) OVER (), 2) prcnt,
ROUND(SUM(churn_flag)*100/COUNT(*),2) churn_rate
FROM CTE
GROUP BY customer_cases;

-- Roughly half of the customers have at least one support case
-- Customers with support cases show a slightly higher churn rate (~23% vs ~21%)
-- The difference is small, suggesting that simply having support cases is not a strong driver of churn

-- ------------------------------------------------------------------------------

WITH CTE AS (
SELECT customer_id, COUNT(*) as total_cases_lifetime, 
CASE WHEN SUM(churn_flag) > 0 THEN 1 ELSE 0 END AS churn_flag
FROM support_variables
GROUP BY customer_id
)
SELECT total_cases_lifetime, COUNT(*) qty_cases, 
ROUND(COUNT(*)*100/SUM(COUNT(*)) OVER (), 2) participation_rate,
SUM(churn_flag) churned, 
ROUND(SUM(churn_flag)*100/COUNT(churn_flag), 2) churn_rate
FROM CTE
GROUP BY total_cases_lifetime
ORDER BY total_cases_lifetime;

-- Most customers have between 1 and 3 lifetime support cases
-- Customers with more than 3 cases represent a very small share of the population
-- Churn rate increases slightly with more cases, but the effect is weak
-- Due to low population at higher case counts, this pattern is not reliable
-- Overall, lifetime number of cases does not show a strong relationship with churn

-- ------------------------------------------------------------------------------

SELECT reason, COUNT(*) qty , ROUND(SUM(churn_flag)*100/COUNT(*), 2) as churn_rate
FROM support_variables
GROUP BY reason;

-- Churn rates are similar across different support reasons
-- No specific support reason stands out as a strong indicator of churn

-- ------------------------------------------------------------------------------

SELECT channel, COUNT(*) qty,
ROUND(COUNT(*)*100/SUM(COUNT(*)) OVER (), 2) qty_prcnt,
ROUND(SUM(churn_flag)*100/COUNT(*), 2) as churn_rate
FROM support_variables
GROUP BY channel;

-- Most support interactions occur through non-email channels
-- Churn rates are consistent across channels
-- Channel choice does not appear to influence churn behavior

-- ------------------------------------------------------------------------------

SELECT subscription_type, COUNT(*) qty,
ROUND(COUNT(*)*100/SUM(COUNT(*)) OVER (), 2) qty_prcnt,
ROUND(SUM(churn_flag)*100/COUNT(*), 2) as churn_rate
FROM support_variables
GROUP BY subscription_type;

-- Distribution of support cases varies by subscription type
-- However, churn rates remain similar across subscription types within support interactions
-- No strong relationship between subscription type and churn is observed at the support level

-- ------------------------------------------------------------------------------

SELECT COUNT(DATEDIFF(cancel_date_time, date_time)) qty,
CASE WHEN DATEDIFF(cancel_date_time, date_time) >= 0 THEN 'NO CASES AFTER CHURN' 
ELSE 'HAVE CASES AFTER CHURN' END AS cases_after_churn,
ROUND(100*COUNT(DATEDIFF(cancel_date_time, date_time))/SUM(COUNT(DATEDIFF(cancel_date_time, date_time))) OVER (), 2) prcnt
FROM support_variables
WHERE churn_flag='1'
GROUP BY cases_after_churn;

-- Around 14% of churned customers continue opening cases after cancellation
-- This confirms that churn is independent from support activity
-- Post-churn behavior must be considered carefully to avoid leakage in analysis

-- ------------------------------------------------------------------------------

WITH CTE_1 AS (
SELECT customer_id, MAX(date_time) last_case
FROM customer_cases cc
GROUP BY customer_id
ORDER BY customer_id)
SELECT CASE WHEN DATEDIFF(cancel_date_time, last_case) < 31 THEN 'A: 0-30 days' 
WHEN DATEDIFF(cancel_date_time, last_case) BETWEEN 31 AND 60 THEN 'B: 31-60 days'
WHEN DATEDIFF(cancel_date_time, last_case) BETWEEN 61 AND 90 THEN 'C: 61-90 days'
WHEN DATEDIFF(cancel_date_time, last_case) BETWEEN 91 AND 180 THEN 'D: 91-180 days'
WHEN DATEDIFF(cancel_date_time, last_case) BETWEEN 181 AND 360 THEN 'E: 181-360 days'
ELSE 'F: 361+ days' 
END AS 'days_from_last_case_to_cancel',
COUNT(DATEDIFF(cancel_date_time, last_case)) qty,
ROUND(100*COUNT(DATEDIFF(cancel_date_time, last_case))/SUM(COUNT(DATEDIFF(cancel_date_time, last_case))) OVER (), 2) prcnt
FROM CTE_1
LEFT JOIN customer_product cp ON cp.customer_id = CTE_1.customer_id
WHERE cancel_date_time IS NOT NULL AND DATEDIFF(cancel_date_time, last_case) > 0
GROUP BY days_from_last_case_to_cancel
ORDER BY days_from_last_case_to_cancel;

-- Only a small share of customers had a support case close to churn (e.g., within 30 days)
-- Distribution across time buckets is relatively flat
-- No strong pattern suggests that timing of last case alone explains churn

-- ------------------------------------------------------------------------------

WITH cutoff AS (
SELECT MAX(cancel_date_time) AS max_date
FROM customer_product),

base AS (
SELECT customer_id, cancel_date_time, 
CASE WHEN cancel_date_time IS NOT NULL THEN 1 ELSE 0 END AS churn_flag,
CASE WHEN cancel_date_time IS NOT NULL THEN cancel_date_time ELSE co.max_date END AS reference_date
FROM customer_product cp
CROSS JOIN cutoff co),

last_cases AS (
SELECT ba.customer_id, churn_flag, COUNT(case_id) cases_last_30_days
FROM base ba
LEFT JOIN customer_cases cc ON ba.customer_id=cc.customer_id
	AND DATEDIFF(reference_date, date_time) BETWEEN 0 AND 30
GROUP BY ba.customer_id, churn_flag, reference_date)

SELECT cases_last_30_days, COUNT(*) customers, 
ROUND(COUNT(*)*100/(SUM(COUNT(*)) OVER ()), 2) prcnt,
ROUND(SUM(churn_flag)*100/COUNT(*), 2) churn_rate
FROM last_cases
GROUP BY cases_last_30_days;

-- The majority of customers (~97%) have zero cases in the last 30 days
-- A very small segment (<3%) has recent support activity

-- Churn rate increases as the number of recent cases increases
-- This indicates a localized signal: recent support activity is associated with higher churn risk

-- However, due to the small size of this segment, it does not explain overall churn behavior

-- Conclusion:
-- Recent support cases are not a dominant driver of churn at the population level
-- But they represent a meaningful risk signal for a small subset of customers