-- creating views
CREATE VIEW v_churnby_country AS
SELECT country, 
       ROUND(AVG(CAST(churn AS FLOAT)),3) AS churn_rate, COUNT(*) total_customers
FROM BC_Customers c
JOIN BC_accounts a ON c.customer_id = a.customer_id
GROUP BY country;

CREATE VIEW v_revenue_at_risk AS
WITH CTE_customer as(
     SELECT c.customer_id,
     country,active_member
     FROM BC_accounts a JOIN BC_Customers c ON a.customer_id = c.customer_id
     WHERE country = 'Germany' AND active_member = 0 
)
SELECT SUM(balance) revenue_at_risk, COUNT(*) risk_customers
FROM CTE_customer cc
JOIN BC_accounts a ON cc.customer_id = a.customer_id

CREATE VIEW v_age_group AS
SELECT CASE WHEN age between 18 AND 30 then '18-30'
            WHEN age between 31 AND 40 then '31-40'
            WHEN age between 41 AND 60 then '41-50'
            WHEN age between 51 AND 60 then '51-60'
            WHEN age between 61 AND 70 then '61-70'
            ELSE '71+'
        END AS age_group,
        ROUND(AVG(CAST(churn AS FLOAT)),3) AS churn_rate, COUNT(*) total_customers
FROM BC_accounts a
JOIN BC_Customers c ON c.customer_id = a.customer_id
GROUP BY CASE WHEN age between 18 AND 30 then '18-30'
            WHEN age between 31 AND 40 then '31-40'
            WHEN age between 41 AND 60 then '41-50'
            WHEN age between 51 AND 60 then '51-60'
            WHEN age between 61 AND 70 then '61-70'
            ELSE '71+'
        END

CREATE VIEW v_products_number AS
SELECT products_number,
       ROUND(AVG(CAST(churn AS FLOAT)),3) AS churn_rate, COUNT(*) total_customers
FROM BC_accounts
GROUP BY products_number

CREATE VIEW v_activemember AS
SELECT active_member,
       ROUND(AVG(CAST (churn AS FLOAT)),3) AS churn_rate,
       COUNT(*) total_customers
FROM BC_accounts
GROUP BY active_member

ALTER VIEW v_age_group AS 
SELECT CASE WHEN age between 18 AND 30 then '18-30'
            WHEN age between 31 AND 40 then '31-40'
            WHEN age between 41 AND 50 then '41-50'
            WHEN age between 51 AND 60 then '51-60'
            WHEN age between 61 AND 70 then '61-70'
            ELSE '71+'
        END AS age_group,
        ROUND(AVG(CAST(churn AS FLOAT)),3) AS churn_rate, COUNT(*) total_customers
FROM BC_accounts a
JOIN BC_Customers c ON c.customer_id = a.customer_id
GROUP BY CASE WHEN age between 18 AND 30 then '18-30'
            WHEN age between 31 AND 40 then '31-40'
            WHEN age between 41 AND 50 then '41-50'
            WHEN age between 51 AND 60 then '51-60'
            WHEN age between 61 AND 70 then '61-70'
            ELSE '71+'
        END

SELECT TABLE_NAME 
FROM INFORMATION_SCHEMA.VIEWS 
WHERE TABLE_SCHEMA = 'dbo';

CREATE VIEW v_overall_churn AS
SELECT ROUND(AVG(CAST(churn AS FLOAT)), 3) AS overall_churn_rate,
       COUNT(*) AS total_customers
FROM BC_accounts;




