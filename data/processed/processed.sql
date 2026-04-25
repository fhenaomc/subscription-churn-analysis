CREATE TEMPORARY TABLE cutoff AS
SELECT MAX(cancel_date_time) AS max_date
FROM customer_product;

CREATE TABLE tmp_total_cases AS
SELECT customer_id, COUNT(*) AS total_cases
FROM customer_cases
GROUP BY customer_id;

CREATE TABLE tmp_recent_cases AS
SELECT 
    cp.customer_id,
    COUNT(cc.case_id) AS cases_last_30_days
FROM customer_product cp
CROSS JOIN cutoff c
LEFT JOIN customer_cases cc 
    ON cp.customer_id = cc.customer_id
    AND DATEDIFF(
        COALESCE(cp.cancel_date_time, c.max_date),
        cc.date_time
    ) BETWEEN 0 AND 30
GROUP BY cp.customer_id;

CREATE TABLE final_dataset AS
SELECT
    ab.customer_id,
    ab.gender,
    ab.age,
    ab.product_name,
    ab.billing_cycle,
    ab.signup_date_time,
    ab.cancel_date_time,
    ab.churn_flag,
    ab.observed_tenure,

    COALESCE(tc.total_cases, 0) AS total_cases_lifetime,
    CASE WHEN tc.total_cases > 0 THEN 1 ELSE 0 END AS has_cases,
    COALESCE(rc.cases_last_30_days, 0) AS cases_last_30_days

FROM analytical_base ab
LEFT JOIN tmp_total_cases tc 
    ON ab.customer_id = tc.customer_id
LEFT JOIN tmp_recent_cases rc 
    ON ab.customer_id = rc.customer_id;
