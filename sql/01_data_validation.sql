# DATA VALIDATION 

-- ------------------------------------------------------------------------------
# product_info TABLE

SELECT *
FROM churn_project.product_info;
-- Two (2) products in total, each product represents a different billing cycle

-- ------------------------------------------------------------------------------

# customer_cases TABLE

SELECT COUNT(case_id) as total_customer_cases
FROM churn_project.customer_cases;
-- Total customer cases: 330512

SELECT COUNT(DISTINCT(customer_id)) as total_distinct_customer_with_Cases
FROM churn_project.customer_cases;
-- Distinct customer with cases: 258660 

SELECT reason, COUNT(reason) as qty 
FROM churn_project.customer_cases
GROUP BY reason;
-- Case distribution: 200985 support cases and 129527 sign up cases

SELECT MIN(date_time) as older_support_case, 
MAX(date_time) as newer_support_case
FROM churn_project.customer_cases;
-- Case date range: From 2017-01-01 10:32:03 to 2022-01-01 06:32:53

SELECT case_id, COUNT(case_id) as duplicates
FROM churn_project.customer_cases
GROUP BY case_id
HAVING COUNT(case_id) > 1;
-- No duplicate case_id values were found

-- ------------------------------------------------------------------------------

# customer_info Table

SELECT COUNT(customer_id) as total_customers
FROM churn_project.customer_info;
-- Total customers: 508932

SELECT gender, COUNT(gender)
FROM churn_project.customer_info
GROUP BY gender;
-- Gender distribution: 309930 male customers, 199002 female customers

SELECT MIN(age) as younger_age, MAX(age) as older_age
FROM churn_project.customer_info;
-- Ages range: 21 to 78 years

-- ------------------------------------------------------------------------------

# customer_product TABLE

SELECT COUNT(id) as total_id
FROM churn_project.customer_product;
-- Total customers: 508932

SELECT customer_id, COUNT(customer_id) as duplicates
FROM churn_project.customer_product
GROUP BY customer_id
HAVING duplicates>1;
-- No duplicate customer_id values were found

SELECT COUNT(distinct(customer_id)) as total_customer_id
FROM churn_project.customer_product;
-- The total number of customers matches the customer_info table
-- Each customer is associated with exactly one product

SELECT COUNT(cancel_date_time - signup_date_time) AS difference
FROM churn_project.customer_product
WHERE cancel_date_time - signup_date_time < 0;
-- No records were found where cancel_date_time precedes signup_date_time

SELECT 
CASE
WHEN cancel_date_time IS NOT NULL THEN 'churned_customer'
ELSE 'active_customer'
END AS customer_status,
COUNT(customer_id) as qty
FROM churn_project.customer_product
GROUP BY customer_status;
-- Customer status: 396447 active customers, 112485 churned customers

SELECT 
CASE
WHEN cancel_date_time IS NULL THEN 'A'
ELSE 'b'
END AS customer_status,
COUNT(customer_id) as qty
FROM churn_project.customer_product
GROUP BY customer_status;
-- Customer status: 396447 active customers, 112485 churned customers


