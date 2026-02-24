# Exploratory Analysis 

---

##Data Validation

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
- **Customer status: **
	- 396447 active customers
	- 112485 churned customers
- **signup_date_time range:** From 2017-01-01 07:55:42 to 2021-12-31 19:38:21
- **cancel_date_time range:** From 2017-01-08 15:14:53 to 2021-12-31 21:44:10


---



