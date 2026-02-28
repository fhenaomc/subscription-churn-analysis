SELECT *
FROM analytical_base;

SELECT churn_flag, observed_tenure
FROM analytical_base
WHERE churn_flag = 1 and observed_tenure = 0;
-- No hay clientes que hayan hecho churn el mismo día de haber activado

WITH TB AS (
SELECT *, 
CASE 
WHEN observed_tenure BETWEEN 0 AND 30 THEN 'a: 0-30'
WHEN observed_tenure BETWEEN 31 AND 90 THEN 'b: 31-90'
WHEN observed_tenure BETWEEN 91 AND 180 THEN 'c: 91-180'
WHEN observed_tenure BETWEEN 181 AND 360 THEN 'd: 181-360'
WHEN observed_tenure BETWEEN 361 AND 720 THEN 'e: 361-720'
WHEN observed_tenure BETWEEN 721 AND 1080 THEN 'f: 721-1080'
WHEN observed_tenure > 1080 THEN 'g: 1080+'
END AS tenure_bucket
FROM analytical_base)
SELECT tenure_bucket, 
ROUND((COUNT(customer_id) * 100 / (SELECT COUNT(customer_id) FROM analytical_base)), 2) as tenure_bucket_percent
FROM TB
GROUP BY tenure_bucket
ORDER BY tenure_bucket
;
-- Tenure bucket

WITH TB AS (
SELECT *, 
CASE 
WHEN observed_tenure BETWEEN 0 AND 30 THEN 'a: 0-30'
WHEN observed_tenure BETWEEN 31 AND 90 THEN 'b: 31-90'
WHEN observed_tenure BETWEEN 91 AND 180 THEN 'c: 91-180'
WHEN observed_tenure BETWEEN 181 AND 360 THEN 'd: 181-360'
WHEN observed_tenure BETWEEN 361 AND 720 THEN 'e: 361-720'
WHEN observed_tenure BETWEEN 721 AND 1080 THEN 'f: 721-1080'
WHEN observed_tenure > 1080 THEN 'g: 1080+'
END AS tenure_bucket
FROM analytical_base)

SELECT tenure_bucket, 
COUNT(*) AS subtotal,
SUM(churn_flag) AS churned,
ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 2) AS subtotal_over_total,
ROUND(SUM(churn_flag) * 100.0 / SUM(SUM(churn_flag)) OVER (), 2) AS churned_over_total_churned,
ROUND(SUM(churn_flag) * 100 /  COUNT(*), 2) AS churned_over_subtotal,
ROUND(SUM(churn_flag) * 100.0 / SUM(COUNT(*)) OVER (), 2) AS churned_over_total
FROM TB
GROUP BY tenure_bucket
ORDER BY tenure_bucket

