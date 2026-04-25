# FINAL INSIGHTS

---

## Executive Summary

This analysis evaluated churn behavior across a dataset of over **500k customers**, integrating structural variables (tenure, product, demographics) and behavioral signals (support interactions).

The results show a clear and consistent pattern:

> **Churn is primarily driven by lifecycle dynamics, not by product, demographic, or support-related variables.**

The **early customer lifecycle (first 180 days)** represents the highest-risk period, while most other variables provide limited explanatory power at scale.

---

## Key Findings

### 1. Churn is a Lifecycle Problem

Tenure is the strongest and most consistent factor associated with churn.

- **0–30 days:** ~42% churn rate  
- **31–180 days:** ~32% churn rate  
- **181+ days:** progressively decreasing churn  

This indicates that:

> **The highest churn risk occurs during the early stages of the customer lifecycle.**

Customers who remain active beyond the first months show significantly higher retention.

---

### 2. Most Churn Happens Where Most Customers Are

Although a large portion of churn events occurs in mid-tenure segments (181–1080 days), this is driven by customer concentration rather than increased risk.

> **Volume does not equal risk.**

This distinction is critical for correct business interpretation.

---

### 3. Product and Billing Have Minimal Impact

- Monthly and annual subscriptions show **similar churn rates**
- Billing cycle distribution changes with tenure, but:
  
> **There is no strong evidence that product structure drives churn**

---

### 4. Demographics Do Not Explain Churn

- Gender: no meaningful differences  
- Age: consistent churn rates across segments  

> **Churn behavior is not significantly influenced by demographic variables**

---

### 5. Support Activity Has Limited Explanatory Power

Support-related variables were analyzed in depth:

- Presence of cases → minimal difference in churn
- Number of cases → weak and unstable relationship
- Case reason / channel → no clear impact

However, one important nuance:

- Customers with **recent support activity (last 30 days)** show higher churn rates

But:

- This group represents **<3% of the population**

> **Support activity provides localized signals, but does not explain churn at scale**

---

## Business Interpretation

The findings point to a clear conclusion:

> **Churn is primarily an onboarding and early experience problem**

This has direct implications:

### Strategic Focus

- Improve **early customer experience**
- Strengthen **onboarding processes**
- Ensure **early value realization**

### Tactical Opportunities

- Monitor customers with **recent support activity** as a high-risk segment
- Apply **targeted interventions**, not broad strategies, for support-related churn

---

## What Does NOT Drive Churn

The analysis explicitly rules out several common assumptions:

- Product type is not a major driver  
- Billing cycle is not a major driver  
- Demographics are not meaningful predictors  
- Support volume does not explain churn behavior  

This prevents misallocation of effort toward low-impact areas.

---

## Limitations

- The analysis is based on **descriptive patterns**, not causal inference
- Support interactions may not fully capture **customer dissatisfaction**
- External factors (pricing changes, competition, market conditions) are not included

---

## Final Conclusion

Churn in this dataset is driven by **when customers are in their lifecycle**, not by **who they are** or **which product they use**.

> **If a customer survives the early lifecycle, retention becomes significantly more stable.**

This makes early-stage experience the most critical lever for improving overall retention.