SELECT *
FROM analytical_base;

SELECT churn_flag, observed_tenure
FROM analytical_base
WHERE churn_flag = 1 and observed_tenure = 0;
-- No churned clients have observed_tenure = 0

SELECT
COUNT(*) AS total_clients,
SUM(churn_flag) AS churned_clients,
ROUND(SUM(churn_flag) / COUNT(*) * 100,2) AS churn_rate
FROM analytical_base;
-- Global churn rate: 22.10%

SELECT 
CASE 
WHEN observed_tenure BETWEEN 0 AND 30 THEN 'a: 0-30'
WHEN observed_tenure BETWEEN 31 AND 90 THEN 'b: 31-90'
WHEN observed_tenure BETWEEN 91 AND 180 THEN 'c: 91-180'
WHEN observed_tenure BETWEEN 181 AND 360 THEN 'd: 181-360'
WHEN observed_tenure BETWEEN 361 AND 720 THEN 'e: 361-720'
WHEN observed_tenure BETWEEN 721 AND 1080 THEN 'f: 721-1080'
WHEN observed_tenure > 1080 THEN 'g: 1081+'
END AS tenure_bucket,
COUNT(*) AS subtotal,
SUM(churn_flag) AS churned,
ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 2) AS subtotal_over_total,
ROUND(SUM(churn_flag) * 100.0 / SUM(SUM(churn_flag)) OVER (), 2) AS churned_over_total_churned,
ROUND(SUM(churn_flag) * 100.0 / SUM(COUNT(*)) OVER (), 2) AS churned_over_total,
ROUND(SUM(churn_flag) * 100 /  COUNT(*), 2) AS churned_over_subtotal
FROM analytical_base
GROUP BY tenure_bucket
ORDER BY tenure_bucket;
-- Most customers concentrate between 181 and 1080 days of tenure.
-- The largest segment is 361–720 days (~29% of all customers).

-- Churned customers are also mostly distributed across these same tenure ranges.

-- However, when analyzing churn rate within each tenure bucket,
-- early tenure segments show the highest churn rates:
-- 0–30 days (~42%)
-- 31–90 days (~38%)
-- 91–180 days (~29%)

-- Churn rate decreases steadily as tenure increases.

-- Based on the previous distribution, tenure is regrouped into broader lifecycle segments:
-- A: 0-30 days: Early churn risk  
-- B: 31-180 days: Early lifecycle
-- C: 181-1080 days: Core lifecycle
-- D: 1081+ days: Long-term customers


SELECT 
CASE 
WHEN observed_tenure BETWEEN 0 AND 30 THEN 'A: 0-30'
WHEN observed_tenure BETWEEN 31 AND 180 THEN 'B: 31-180'
WHEN observed_tenure BETWEEN 181 AND 1080 THEN 'C: 181-1080'
WHEN observed_tenure > 1080 THEN 'D: 1081+'
END AS tenure_bucket,
ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 2) AS subtotal_over_total,
ROUND(SUM(churn_flag) * 100.0 / SUM(SUM(churn_flag)) OVER (), 2) AS churned_over_total_churned,
ROUND(SUM(churn_flag) * 100.0 / SUM(COUNT(*)) OVER (), 2) AS churned_over_total,
ROUND(SUM(churn_flag) * 100 /  COUNT(*), 2) AS churned_over_subtotal
FROM analytical_base
GROUP BY tenure_bucket
ORDER BY tenure_bucket;
-- Most customers fall into the Core Lifecycle segment (181–1080 days), representing ~69% of the dataset.

-- Early churn risk (0–30 days) represents a very small share of the dataset (~2%),
-- but shows the highest churn rate.

-- Most churn events occur in the Core Lifecycle segment simply because most customers
-- are located in this tenure range.

-- However, churn rate itself is highest in the Early Lifecycle segments (0–180 days).


SELECT 
CASE 
WHEN observed_tenure BETWEEN 0 AND 30 THEN 'A: 0-30'
WHEN observed_tenure BETWEEN 31 AND 180 THEN 'B: 31-180'
WHEN observed_tenure BETWEEN 181 AND 1080 THEN 'C: 181-1080'
WHEN observed_tenure > 1080 THEN 'D: 1081+'
END AS tenure_bucket,
gender,
COUNT(*) AS subtotal,
ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 2) AS subtotal_over_total,
ROUND(SUM(churn_flag) * 100.0 / SUM(SUM(churn_flag)) OVER (), 2) AS churned_over_total_churned,
ROUND(SUM(churn_flag) * 100.0 / SUM(COUNT(*)) OVER (), 2) AS churned_over_total,
ROUND(SUM(churn_flag) * 100.0 /  COUNT(*), 2) AS churned_over_subtotal
FROM analytical_base
GROUP BY tenure_bucket, gender
ORDER BY tenure_bucket;
-- Churn rates (churned_over_subtotal) are nearly identical across genders
-- within each tenure segment.

-- This suggests no meaningful relationship between gender and churn behavior.


SELECT 
CASE 
WHEN observed_tenure BETWEEN 0 AND 30 THEN 'A: 0-30'
WHEN observed_tenure BETWEEN 31 AND 180 THEN 'B: 31-180'
WHEN observed_tenure BETWEEN 181 AND 1080 THEN 'C: 181-1080'
WHEN observed_tenure > 1080 THEN 'D: 1081+'
END AS tenure_bucket,
CASE 
WHEN age BETWEEN 20 AND 40 THEN 'I: 20-40'
WHEN age BETWEEN 41 AND 60 THEN 'II: 40-60'
WHEN age > 60 THEN 'III: 61+'
END AS age_bucket,
COUNT(*) AS subtotal,
ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 2) AS subtotal_over_total,
ROUND(SUM(churn_flag) * 100.0 / SUM(SUM(churn_flag)) OVER (), 2) AS churned_over_total_churned,
ROUND(SUM(churn_flag) * 100.0 / SUM(COUNT(*)) OVER (), 2) AS churned_over_total,
ROUND(SUM(churn_flag) * 100.0 /  COUNT(*), 2) AS churned_over_subtotal
FROM analytical_base
GROUP BY tenure_bucket, age_bucket
ORDER BY tenure_bucket;
-- Churn rates appear similar across all age groups,
-- suggesting no clear relationship between age and churn.


SELECT 
CASE 
WHEN observed_tenure BETWEEN 0 AND 30 THEN 'A: 0-30'
WHEN observed_tenure BETWEEN 31 AND 180 THEN 'B: 31-180'
WHEN observed_tenure BETWEEN 181 AND 1080 THEN 'C: 181-1080'
WHEN observed_tenure > 1080 THEN 'D: 1081+'
END AS tenure_bucket,
billing_cycle,
COUNT(*) AS subtotal,
ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 2) AS subtotal_over_total,
ROUND(SUM(churn_flag) * 100.0 / SUM(SUM(churn_flag)) OVER (), 2) AS churned_over_total_churned,
ROUND(SUM(churn_flag) * 100.0 / SUM(COUNT(*)) OVER (), 2) AS churned_over_total,
ROUND(SUM(churn_flag) * 100.0 /  COUNT(*), 2) AS churned_over_subtotal
FROM analytical_base
GROUP BY tenure_bucket, billing_cycle
ORDER BY tenure_bucket;
-- Short-tenure segments (A and B) show a similar distribution between monthly and annual billing.

-- In longer tenure segments (C and D), annual billing becomes more dominant,
-- suggesting that long-term customers are more likely to choose annual plans.

-- Churn rates decrease consistently with tenure.

-- Within each tenure segment, churn rates between monthly and annual billing
-- are generally similar, suggesting no strong relationship between billing cycle
-- and churn behavior.

-- A small difference appears in the longest tenure segment, where monthly plans
-- show slightly higher churn rates.
