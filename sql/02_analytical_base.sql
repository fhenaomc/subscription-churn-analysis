# ANALYTICAL BASE

CREATE VIEW analytical_base AS

WITH cutoff AS (SELECT GREATEST(MAX(cancel_date_time), MAX(signup_date_time))
AS max_date
FROM customer_product)
-- Selection of the most recent date in the dataset to define the cutoff date 
-- for customers who have not churned (cancel_date_time IS NULL)
-- Churned customers use actual cancellation date

SELECT ci.customer_id, gender, age, -- Customer demographic attributes
name AS product_name, price, billing_cycle, -- Product characteristics
signup_date_time, cancel_date_time, -- Subscription lifecycle timestamps 

CASE -- Churn flag calculation
WHEN cancel_date_time IS NOT NULL THEN 1 ELSE 0
END AS churn_flag,

CASE -- Observed tenure calculation 
WHEN cancel_date_time IS NULL 
THEN DATEDIFF(c.max_date, signup_date_time)
ELSE DATEDIFF(cancel_date_time, signup_date_time)
END AS observed_tenure 

FROM customer_info ci
INNER JOIN customer_product cp
ON ci.customer_id = cp.customer_id
INNER JOIN product_info pi
ON cp.product = pi.product_id
CROSS JOIN cutoff c
;

