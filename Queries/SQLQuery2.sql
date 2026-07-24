-- churn rate by country
SELECT country, 
       ROUND(AVG(CAST(churn AS FLOAT)),3) AS churn_rate, COUNT(*) total_customers
FROM BC_Customers c
JOIN BC_accounts a ON c.customer_id = a.customer_id
GROUP BY country
-- churn rate by active members
SELECT active_member,
       ROUND(AVG(CAST (churn AS FLOAT)),3) AS churn_rate,
       COUNT(*) total_customers
FROM BC_accounts
GROUP BY active_member
-- churn rate by age group 
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
ORDER BY age_group ASC 
-- churn rate by product number
SELECT products_number,
       ROUND(AVG(CAST(churn AS FLOAT)),3) AS churn_rate, COUNT(*) total_customers
FROM BC_accounts
GROUP BY products_number
ORDER BY products_number ASC
-- churn rate by gender
SELECT gender,
       ROUND(AVG(CAST(churn AS FLOAT)),3) AS churn_rate, COUNT(*) total_customers
FROM BC_Customers c JOIN BC_accounts a ON c.customer_id = a.customer_id
GROUP BY gender
-- rank customers by balance within each country
SELECT balance,country,
       RANK() OVER(PARTITION BY country ORDER BY balance) balance_rank
FROM BC_accounts a  JOIN BC_Customers c ON c.customer_id = a.customer_id 
-- running churn rate order by tenure or age
--if looked at all customers from youngest up to this age, what fraction of that whole accumulated group has churned so far?
SELECT age,
       SUM(CAST(churn AS FLOAT)) OVER(ORDER BY age
       ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)/
       COUNT(churn) OVER(ORDER BY age
       ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS running_churnrate
FROM BC_Customers c JOIN BC_accounts a ON c.customer_id = a.customer_id
-- Revenue at risk - identify customers who are most likely to churn, sum up how much money(revenue) tied to them.
-- from eda findings we know customers in germany, inactive members 
;WITH CTE_customer as(
     SELECT c.customer_id,
     country,active_member
     FROM BC_accounts a JOIN BC_Customers c ON a.customer_id = c.customer_id
     WHERE country = 'Germany' AND active_member = 0 
)
SELECT SUM(balance) revenue_at_risk, COUNT(*) risk_customers
FROM CTE_customer cc
JOIN BC_accounts a ON cc.customer_id = a.customer_id
