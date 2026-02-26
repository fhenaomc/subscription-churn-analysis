# ANALYTICAL BASE


SELECT ci.customer_id, gender, age,  -- Customer demographic attributes
name AS product_name, price, billing_cycle, -- Product characteristics
signup_date_time, cancel_date_time, -- Subscription lifecycle timestamps

CASE -- Observed tenure calculation 
-- Cutoff date for active customers = MAX(cancel_date_time)
WHEN cancel_date_time IS NULL 
THEN DATEDIFF((SELECT MAX(cancel_date_time) FROM customer_product), signup_date_time)
-- Churned customers use actual cancellation date
ELSE DATEDIFF(cancel_date_time, signup_date_time)
END AS observed_tenure 

FROM customer_info ci
INNER JOIN customer_product cp
ON ci.customer_id = cp.customer_id
INNER JOIN product_info pi
ON cp.product = pi.product_id
;

