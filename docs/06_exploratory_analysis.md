# Exploratory Analysis 

---

## 01 Data Validation

Dataset appears structurally consistent in all four tables:

### product_info Table

- **Total products :** 2
- **Billing cycles :** Annual or monthly subscription


### customer_cases Table

- **Total customer cases :** 330512
- **Distinct customer with cases :** 258660 
- **Case distribution :**
	- 200985 support cases
	- 129527 sign up cases
- **Case date range:** From 2017-01-01 10:32:03 to 2022-01-01 06:32:53
- No duplicate case_id values were found


### customer_info Table

- **Total customers:** 508932
	- 309930 male customers
	- 199002 female customers
- **Ages range :** 21 to 78 years


### customer_product Table

- **Total customers :** 508932
- No duplicate customer_id values were found
- The total number of customers matches the customer_info table
- Each customer is associated with exactly one product
- No records were found where cancel_date_time precedes signup_date_time
- **Customer status :**
	- 396447 active customers
	- 112485 churned customers
- **signup_date_time range:** From 2017-01-01 07:55:42 to 2021-12-31 19:38:21
- **cancel_date_time range:** From 2017-01-08 15:14:53 to 2021-12-31 21:44:10


---


## Analytical Base

The analytical base consolidates customer-level information into a single structured dataset that serves as the foundation for all subsequent churn and retention analysis.

### Objective

- Construct a customer-level table integrating:
- Demographic attributes
- Subscription lifecycle information
- Product characteristics
- Explicit churn definition
- Observed tenure within a consistent observation window

No aggregated KPIs are computed at this stage. This layer focuses strictly on structural integrity and business logic clarity.

### Granularity and Scope

- Granularity: One row per customer
- Scope: Customer attributes + subscription lifecycle + product information
- Primary purpose: Provide a clean and reproducible modeling-ready structure

Each customer is associated with exactly one subscription product.

### Churn Definition

Churn is defined exclusively based on the presence of a cancel_date_time.

- churn_flag = 1 → cancel_date_time IS NOT NULL
- churn_flag = 0 → cancel_date_time IS NULL

This definition is independent of customer activity (e.g., support cases).
Subscription cancellation determines churn status, regardless of post-cancellation usage or support interactions.

### Observation Window and Cutoff Logic

To ensure consistent tenure measurement, a global observation cutoff is defined as:

- The maximum date observed in the subscription dataset(i.e., the latest lifecycle event recorded)

This cutoff is applied only to customers who have not churned.

### Observed Tenure

Observed tenure is calculated as the number of days between signup_date_time and:

- cancel_date_time for churned customers
- The global dataset cutoff for active customers

This approach ensures:

- Active customers are right-censored at a consistent observation point
- Tenure comparisons between churned and active customers are structurally valid
- The analytical base remains suitable for retention metrics and survival-style reasoning

No negative tenure values were detected during validation.
Churned customers may exhibit very short tenure values (e.g., 1 day), which are consistent with the business definition of cancellation.

### Structural Validation

The following validations were performed:

- No duplicate customer_id values
- One product per customer
- No instances where cancel_date_time precedes signup_date_time
- No negative tenure values

These checks confirm structural consistency across the integrated dataset.

### Role Within the Project

This analytical base represents the structural backbone of the project.

All subsequent churn metrics, segmentation analyses, and behavioral variables will be derived from this dataset to ensure:

- Logical consistency
- Reproducibility
- Alignment between business definitions and analytical outputs