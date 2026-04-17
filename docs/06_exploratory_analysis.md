# EXPLORATORY ANALYSIS

---

## 01 DATA VALIDATION

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

## 02 ANALYTICAL BASE

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


---

## 03 STRUCTURAL CHURN METRICS

Using the analytical base, the next stage of the analysis explores structural churn patterns across the customer population.

The goal of this step is to evaluate whether churn behavior varies across fundamental customer characteristics such as tenure, product type, billing cycle, demographic attributes, and signup cohorts.

This stage focuses on **descriptive structural analysis** rather than predictive modeling.

### Global Churn Rate

The dataset contains **508932 customers**, of which **112485 have churned**, resulting in a **global churn rate of approximately 22.10%**.

No churned customers were observed with zero days of tenure, indicating that churn events occur only after at least one day of subscription activity.

This confirms that churn and tenure calculations behave consistently.

### Tenure Distribution

Customer tenure is concentrated within mid-range lifecycle stages.

Most customers fall between **181 and 1080 days of tenure**, with the largest group located between **361 and 720 days**.

Churned customers are also primarily distributed within these same tenure ranges, reflecting the overall distribution of customers rather than an elevated churn risk.

When churn rate is evaluated within each tenure segment, a clear pattern emerges:

- **0–30 days:** highest churn rate
- **31–90 days:** second highest churn rate
- **91–180 days:** moderate churn
- **Beyond 180 days:** churn decreases progressively as tenure increases

This suggests that the **early lifecycle stage represents the highest churn-risk period**.

### Lifecycle Segmentation

Based on the tenure distribution and churn behavior, tenure was regrouped into four lifecycle segments:

| Segment | Tenure Range | Interpretation |
|------|------|------|
| A | 0–30 days | Early churn risk |
| B | 31–180 days | Early lifecycle |
| C | 181–1080 days | Core lifecycle |
| D | 1081+ days | Long-term customers |

The **core lifecycle segment (181–1080 days)** represents the majority of customers.

Although many churn events occur in this group, this primarily reflects the concentration of customers within that tenure range rather than a higher churn probability.

### Product-Level Churn

Two subscription products exist in the dataset, representing **monthly and annual billing plans**.

Churn rates across these products appear very similar. The monthly plan shows a slightly higher churn rate, but the difference is small and does not indicate a strong product-level effect.

### Billing Cycle

Billing cycle distribution varies across lifecycle stages.

In early tenure segments, customers are relatively evenly distributed between monthly and annual subscriptions.

As tenure increases, annual subscriptions become more common among long-term customers.

Despite this shift in distribution, churn rates remain relatively similar across billing cycles within tenure segments, suggesting that billing cycle alone is not a strong driver of churn behavior.

### Demographic Factors

Churn behavior was also evaluated across demographic attributes.

**Gender**

Churn rates across genders are nearly identical within tenure segments, indicating no meaningful association between gender and churn.

**Age**

Customers were grouped into three age segments:

- 20–40 years
- 41–60 years
- 61+ years

Churn rates across these groups appear very similar, suggesting that age does not significantly influence churn behavior in this dataset.

### Signup Cohorts

Customers were grouped by signup year to evaluate cohort-level churn patterns.

Churn proportions decrease for more recent cohorts, which is expected because newer cohorts have had less time to accumulate churn events within the observation window.

No specific cohort exhibits an abnormal churn pattern.

### Structural Findings

Key observations from the structural analysis include:

- The **global churn rate is approximately 22%**
- **Tenure is the strongest structural factor associated with churn**
- **Most churn occurs during the first 180 days after signup**
- **Product type, gender, and age show minimal relationship with churn**
- **Annual subscriptions become more common among long-tenure customers**
- **Signup cohorts display stable churn patterns over time**

Overall, churn dynamics in this dataset appear to be driven primarily by **subscription lifecycle behavior rather than demographic or product characteristics**.



---

## 04 SUPPORT VARIABLES

This stage extends the analysis by incorporating customer support interactions to evaluate whether support-related behavior is associated with churn.

The objective is to determine whether variables such as:
- Presence of support cases
- Number of cases
- Case timing
- Case characteristics (reason, channel)

provide meaningful signals to explain or anticipate churn behavior.

### Support Coverage

Approximately half of the customers have at least one support case.

Customers with support cases show a slightly higher churn rate compared to those without cases.

However, the difference is small, suggesting that the mere existence of support interactions is not a strong driver of churn.

### Volume of Support Cases

Most customers with support activity have between **1 and 3 cases**.

Customers with a higher number of cases represent a very small portion of the population.

A slight increase in churn rate is observed as the number of cases increases, but this effect is weak and unstable due to low sample size in higher case counts.

Overall, **lifetime number of support cases does not strongly explain churn behavior**.

### Case Characteristics

Support cases were analyzed by **reason** and **channel**.

- Churn rates remain consistent across different support reasons
- Churn rates also remain stable across communication channels

No specific support category emerges as a strong indicator of churn.

### Post-Churn Activity and Data Leakage

A portion of churned customers continue to generate support cases after cancellation.

This confirms that churn is **not dependent on support activity**, and that customers may continue interacting with the service after cancellation (e.g., remaining subscription time).

This behavior highlights the importance of avoiding **data leakage** when building churn-related variables, particularly when using support events.

### Timing of Support Cases

The time between the last support case and churn was analyzed.

Only a small percentage of customers had support interactions close to their churn date.

The distribution of time intervals between last case and churn is relatively flat, suggesting no clear pattern where recent support activity systematically precedes churn.

### Support Activity Near Churn (Last 30 Days)

A more targeted analysis was conducted focusing on **support activity within the last 30 days** before the reference date (churn date for churned customers, cutoff date for active customers).

Key findings:

- Approximately **97% of customers have no support cases in the last 30 days**
- A very small segment (**<3%**) shows recent support activity

Within this small segment:

- Churn rate increases as the number of recent cases increases
- This indicates a **localized signal of higher churn risk**

However:

- The segment is too small to explain overall churn patterns
- Most churn events occur among customers without recent support activity

### Interpretation

Support-related variables provide **limited explanatory power at the population level**.

However, an important nuance emerges:

- Support activity is **not a dominant driver of churn**
- But when recent support activity exists, it is associated with **higher churn probability**

This means:

- Support variables have **low coverage but meaningful signal**
- They are useful for identifying **high-risk subsets of customers**, rather than explaining global churn behavior

### Final Support Insights

- Support activity alone does not explain churn for the majority of customers
- No strong relationship is observed between churn and:
  - Number of cases (lifetime)
  - Case reason
  - Case channel
- Recent support activity (last 30 days) is associated with higher churn risk
- However, this applies to a very small portion of the customer base

### Overall Conclusion

Combining structural and behavioral analysis:

- Churn is primarily driven by **lifecycle dynamics (tenure)**
- Support-related variables do not explain most churn events
- A minority of churn cases may be associated with **recent support friction**

This suggests that:

- Broad churn reduction strategies should focus on **early lifecycle experience**
- Targeted interventions can be applied to customers with **recent support activity**, as a high-risk segment

