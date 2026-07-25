# Bank Customer Churn Prediction

![Python](https://img.shields.io/badge/Python-3.11-blue?logo=python)
![SQL Server](https://img.shields.io/badge/SQL_Server-CC2927?logo=microsoftsqlserver&logoColor=white)
![Power BI](https://img.shields.io/badge/Power_BI-F2C811?logo=powerbi&logoColor=black)
![Scikit-learn](https://img.shields.io/badge/scikit--learn-F7931E?logo=scikitlearn&logoColor=white)
![XGBoost](https://img.shields.io/badge/XGBoost-ML-green)

An end-to-end analytics project predicting customer churn for a retail bank using Python, SQL Server, Machine Learning, and Power BI.
## Project Overview

An end-to-end analytics project predicting customer churn for a retail bank, combining Python (cleaning, EDA, modeling), SQL Server (relational schema, segmentation, window functions, CTEs, views), and Power BI (dashboard).

## Objective

To build an end-to-end customer churn prediction system for a retail bank, identifying which customers are likely to churn, understanding the key factors driving that churn, and translating those insights into a measurable, business-actionable output (revenue at risk). The project was designed to demonstrate practical, job-relevant analytics skills across the full pipeline: data cleaning and exploratory analysis in Python, relational data modeling and business-facing queries in SQL, predictive modeling with proper evaluation for imbalanced classification, and an interactive dashboard for stakeholder-facing decision-making in Power BI.


## Business Problem

Customer churn directly erodes recurring revenue. This project identifies which customers are likely to churn, what factors actually drive that churn, and how much revenue is at risk giving the business a way to prioritize retention efforts.

## Dataset

Bank Customer Churn Dataset — 10,000 customer records including customer id, geography, gender, age, tenure, balance, number of products, credit card status, activity status, estimated salary, and churn flag.


## Tech Stack

- Python (Pandas, NumPy, Scikit-learn, Matplotlib, XGBoost)
- SQL Server (SSMS)
- Power BI
- Jupyter Notebook

## Work Flow

Dataset
     ↓
Data Cleaning
     ↓
EDA
     ↓
Feature Engineering
     ↓
Machine Learning
     ↓
SQL Analysis
     ↓
Power BI Dashboard
     ↓
Business Recommendations


## Dashboard Preview

![Dashboard]("C:\Users\Divyanshi\OneDrive\Pictures\Screenshots\Screenshot 2026-07-25 231454.png")



## Data Cleaning
The dataset required minimal cleaning, but every column was explicitly verified rather than assumed clean:

- Duplicates: **0 duplicate rows found.**
- Missing values: **0 nulls** across all 12 columns.
- Age range: 18–92, **no implausible values.**
- Balance range: 0–250,898. 3,617 customers (36%) hold a $0 balance, investigated further (see EDA).
- Credit score range: 350–850, within the standard real world range.
- Estimated salary: **59 customers (0.6%) had salaries under 1,000.** Investigation showed these rows were unremarkable across every other feature, had a churn rate (22.0%) close to the population average (20.4%), and salary values were smoothly distributed rather than clustered at a placeholder value — retained without modification as genuine low-tail values.


## Exploratory Data Analysis — Key Findings

Overall churn rate: 20.4% (moderately imbalanced target).

**Age is the strongest driver, with a non-linear, life-stage pattern.**  Churn rises from 7.5% (18–30) to a sharp peak of 56.2% at 51–60, then falls back to 8.3% for 71+. This inverted-U shape suggests middle-aged customers are most likely to actively reassess their banking relationship, while younger and older customers are comparatively stable. Strongest linear correlation with churn (0.285).

**Products held shows a striking non-linear reversal.** Churn drops from 27.7% (1 product) to 7.6% (2 products) — consistent with cross-held products increasing switching costs but spikes sharply to 82.7% (3 products, n=266) and 100% (4 products, n=60). This suggests customers pushed into 3+ products may represent a distinct, higher-risk segment (potentially oversold or already dissatisfied) rather than more loyal ones. This pattern is nearly invisible in the linear correlation (-0.048), demonstrating that correlation alone can understate a feature's true predictive value when the relationship is non-linear — a key reason tree-based models were included alongside logistic regression.

**Active membership status is a strong, intuitive driver.** Inactive members churn at 26.9% vs. 14.3% for active members — nearly double. Second-strongest correlation (-0.156).

**Germany shows elevated churn relative to other markets.** Germany's churn rate (32.4%) is roughly double France (16.2%) and Spain (16.7%), across large, comparable sample sizes.

**Gender shows a consistent difference.** Female customers churn at 25.1% vs. 16.5% for male customers, across large sample sizes in both groups. Cause is not determinable from this data.

**Zero-balance customers churn less, not more.** Customers with a $0 balance churn at 13.8% vs. 24.1% for those with a positive balance. Follow-up showed zero-balance customers hold more products on average (1.78 vs. 1.39), suggesting the effect is driven by product "stickiness" rather than balance itself.

**Estimated salary, credit card ownership, and tenure** showed minimal/no relationship with churn (correlations of 0.012, -0.007, and -0.014, respectively) and were not treated as meaningful drivers.

**Summary — churn drivers ranked by strength of evidence:**
1. Age (life-stage curve)
2. Products held (non-linear — strongest in tree-based models)
3. Active membership status
4. Country (Germany elevated)
5. Gender
**Weak/non-drivers:** credit card ownership, tenure, estimated salary

## Feature Engineering & Preprocessing

- Dropped 'customer_id' (identifier only, near-zero correlation with churn).
One-hot encoded **'country'**; binary-encoded **'gender'**.
- **Train/test split: 80/20**, stratified on churn to preserve the ~20% churn ratio in both sets.
- **Standardized features (fit on train, applied to test)** for logistic regression only — tree-based models do not require scaling.

## Modeling and Evaluation

Five model variants were built and compared, using precision/recall/F1/ROC-AUC rather than accuracy alone, since the target is imbalanced (~80/20).

Model	               Precision (churn)  	Recall (churn)   	F1 (churn)	    Accuracy	      AUC
Logistic Regression 	    0.58	              0.22	           0.32	          0.81	       0.774
(default)
Logistic Regression 	    0.38	              0.71	           0.50	          0.71         0.774
(class-balanced)
Random Forest            	0.78               	0.51	           0.61	          0.87         0.864
(default)
Random Forest             0.78              	0.48	           0.60	          0.87	         —
(class-balanced)	
XGBoost                 	0.72	              0.53	           0.61          	0.86	       0.856


**Best model:** Random Forest — highest AUC (0.864), tied-best F1 (0.61), and the best precision-recall balance. XGBoost is a very close second. Logistic regression, while far more interpretable, is the weakest performer — consistent with its inability to capture the non-linear churn drivers (particularly products held) that the tree-based models pick up.

**A key methodological finding:** class_weight='balanced' had a large effect on logistic regression (recall 0.22 → 0.71) but almost no effect on Random Forest (0.51 → 0.48). This is because logistic regression's decision boundary is a single formula that reweighting directly shifts, while Random Forest's bagged, averaged structure dilutes the effect of reweighting across many trees — a reminder that imbalance-handling techniques are not universally effective across model types.

**Business framing on the precision/recall trade-off:** missing a real churner (false negative) is a direct revenue loss, while wrongly flagging a loyal customer (false positive) costs little more than an unnecessary retention offer. This asymmetry generally justifies favoring recall over precision for churn prediction.

## SQL Analysis

- Normalized the flat dataset into two related tables (BC_Customers, BC_accounts) with a foreign key relationship on customer_id.
- Segmentation queries recreating EDA findings using GROUP BY and CASE WHEN (churn by country, age group, active member status, products held).
- Window functions: RANK() OVER (PARTITION BY country ORDER BY balance) to rank customers by balance within each country; a cumulative running churn rate using SUM() OVER (ORDER BY age ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW).
- A CTE-based revenue-at-risk calculation identifying customers in Germany who are inactive members — a compounding high-risk segment identified through EDA — totaling 1,261 customers and ₹150,799,350.97 in combined balance.
- Multiple views (vw_churn_by_country, vw_churn_by_age_group, vw_churn_by_products_number, vw_revenue_at_risk, etc.) built to feed Power BI directly from SQL Server.


## Power BI Dashboard

An interactive, single-page dashboard built in Power BI Desktop, connected live to SQL Server.
![Dashboard]("C:\Users\Divyanshi\OneDrive\Pictures\Screenshots\Screenshot 2026-07-25 231454.png")

**KPI cards:** Overall Churn Rate, Total Customers, Revenue at Risk (Inactive Members) — built as DAX measures on the raw customer/account tables, so they dynamically update when the country slicer changes.

**Visuals:**

- Churn rate by country (bar chart + filled map)
- Churn rate by age group (line chart, showing the life-stage curve)
- Churn rate by products held (column chart, showing the non-linear spike)
- Churn rate by active membership status (donut chart)


## Business Recommendations

- Prioritize retention campaigns for inactive customers in Germany.
- Customers holding 3+ products should receive proactive relationship reviews rather than additional cross-selling.
- Develop targeted retention strategies for customers aged 45–60, the highest-risk age segment.
- Promote customer engagement programs to increase active membership.
- Monitor high-balance customers because they represent greater revenue at risk.

## Key Takeaways

- Random Forest is the best-performing model (AUC 0.864), correctly capturing the non-linear churn drivers that logistic regression misses.
- Products held and age are the strongest, most actionable churn signals — a customer holding 3+ products should be flagged as high-risk, not treated as more loyal.
- A targeted retention segment (Germany + inactive members) represents ₹150.8M in at-risk balance, identified through EDA and quantified in SQL.
## Project Structure

```text
customer-churn-prediction/
│
├── data/
│   ├── raw/
│   │   └── Churn_Modelling.csv
│   └── cleaned/
│       └── cleaned_churn.csv
│
├── notebooks/
│   ├── 01_cleaning_eda.ipynb
│   └── 02_modeling.ipynb
│
├── sql/
│   ├── schema.sql
│   ├── queries.sql
│   └── views.sql
│
├── powerbi/
│   └── churn_dashboard.pbix
│
├── images/
│   ├── dashboard.png
│   ├── correlation_heatmap.png
│   └── roc_curve.png
│
├── README.md
└── requirements.txt
```

## Concepts Used

### Python
- Data cleaning and preprocessing
- Exploratory Data Analysis (EDA)
- Feature engineering
- Data visualization using Matplotlib
- Machine Learning using Scikit-learn and XGBoost
- Model evaluation (Precision, Recall, F1-score, ROC-AUC)

### SQL
- Database normalization
- Primary and Foreign Keys
- SQL Views
- Common Table Expressions (CTEs)
- Window Functions
- Aggregate Functions
- GROUP BY and CASE WHEN
- Ranking and Running Totals

### Power BI
- Data Modeling
- DAX Measures
- KPI Cards
- Interactive Dashboard Design
- Slicers and Cross-filtering
- Data Visualization

### Machine Learning
- Logistic Regression
- Random Forest
- XGBoost
- Train-Test Split
- Feature Scaling
- Class Imbalance Handling
- Model Comparison
  
## About Me

Economics Student at Hansraj College, Delhi University.


**Email:** [divyanhisai.ds@gmail.com ](mailto:divyanhisai.ds@gmail.com )

**LinkedIn:** [Connect with me on LinkedIn](https://www.linkedin.com/in/divyanshisaini23/)
