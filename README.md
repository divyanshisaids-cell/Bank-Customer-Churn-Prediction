# Bank-Customer-Churn-Prediction

End-to-end analytics project predicting customer churn for a retail bank, combining Python (cleaning, EDA, modeling), SQL Server (business-facing segmentation and revenue-at-risk analysis), and Power BI (stakeholder dashboard).

Business Problem

Customer churn directly erodes recurring revenue. This project identifies which customers are likely to churn, what drives that churn, and how much revenue is at risk — giving the business a way to prioritize retention efforts.

Dataset

Bank Customer Churn Dataset — 10,000 customer records including credit score, geography, gender, age, tenure, balance, number of products, credit card status, activity status, estimated salary, and churn flag.

Project Structure
customer-churn-prediction/
├── data/
│   ├── raw/              # original dataset
│   └── cleaned/          # cleaned dataset, ready for SQL import
├── notebooks/
│   ├── 01_cleaning_eda.ipynb
│   └── 02_modeling.ipynb
├── sql/
│   ├── schema.sql        # table creation
│   ├── queries.sql       # segmentation, window functions, revenue-at-risk
│   └── views.sql         # views feeding into Power BI
├── powerbi/
│   └── churn_dashboard.pbix
├── outputs/
│   └── figures/          # saved plots, SHAP charts, etc.
├── README.md
└── requirements.txt

Tools

Python (pandas, scikit-learn, matplotlib/seaborn, SHAP) · SQL Server (SSMS) · Power BI
