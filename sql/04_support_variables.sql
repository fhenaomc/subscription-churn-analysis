#GENERAL VIEW FOR SUPPORT CASES INFO

CREATE VIEW support_variables AS
SELECT case_id, cc.customer_id, date_time, channel, reason, age, 
gender, signup_date_time, cancel_date_time, name as subscription_type,
CASE WHEN cancel_date_time IS NOT NULL THEN 1 ELSE 0 END AS churn_flag
FROM customer_cases cc
LEFT JOIN customer_info ci ON ci.customer_id = cc.customer_id
LEFT JOIN customer_product cp ON cp.customer_id = ci.customer_id
LEFT JOIN product_info pi ON pi.product_id = cp.product;

-- ------------------------------------------------------------------------------

SELECT *
FROM support_variables;
## PENDIENTES:
-- Churn por cohortes de cuántos casos tiene un cliente
-- Churn por fecha
-- Churn por channel
-- Churn por reason
-- Churn por cohortes de age
-- Churn por cohortes de signup date time
-- Churn por subscription type

SELECT customer_id, COUNT(*) as cases_count, 
CASE WHEN SUM(churn_flag) > 0 THEN 1 ELSE 0 END AS churn_flag
FROM support_variables
GROUP BY customer_id
ORDER BY cases_count;
-- There are no clientes without support cases

WITH CTE AS (
SELECT customer_id, COUNT(*) as cases_count, 
CASE WHEN SUM(churn_flag) > 0 THEN 1 ELSE 0 END AS churn_flag
FROM support_variables
GROUP BY customer_id
)
SELECT cases_count, SUM(churn_flag) as churn_count, ROUND(SUM(churn_flag)*100/COUNT(churn_flag), 2) as churn_rate
FROM CTE
GROUP BY cases_count
ORDER BY cases_count
;
-- Most clients have between 1 and 3 cases. 4 cases are very rare and only 2 clients have 5 cases
-- Churn rate increase insignifically between 1 and 3 cases
-- There is no correlation found between number of cases and churn rate