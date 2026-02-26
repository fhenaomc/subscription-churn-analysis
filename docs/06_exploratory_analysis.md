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


This script consolidates customer-level information into a single, structured dataset that will serve as the foundation for all subsequent churn analysis.

### Objective

Build a customer-level analytical table integrating demographics, subscription lifecycle data, and product attributes, without computing aggregated metrics at this stage.

### Dataset Design Principles

- Granularity: One row per customer.
- Scope: Customer attributes + subscription lifecycle + plan information.
- No aggregated KPIs are calculated in this layer.
- All business logic definitions are made explicit and reproducible.

### Observed Tenure

Observed tenure is calculated as the number of days between signup_date_time and:

- cancel_date_time for churned customers
- The maximum cancel_date_time observed in the dataset for active customers

Using the dataset-level maximum cancellation date as a cutoff ensures that tenure for active customers is measured within a consistent observation window. This prevents systematic underestimation of tenure for customers who have not churned.

### Plan and Pricing Information

The analytical base incorporates:

- product_name
- price
- billing_cycle

This allows segmentation of churn behavior by plan characteristics without requiring additional joins in later stages.

### Validation Considerations

- No duplicate customer_id values are present.
- Each customer is associated with exactly one product.
- No cases were detected where cancel_date_time precedes signup_date_time.

These validations ensure internal consistency and make the analytical base suitable for churn modeling, survival analysis, and retention metrics.

This table represents the final modeling-ready dataset. If the definitions and logic implemented here are robust, subsequent churn metrics and analytical outputs become straightforward transformations of this base.

