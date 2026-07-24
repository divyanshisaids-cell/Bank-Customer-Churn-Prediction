CREATE TABLE BC_Customers(
      customer_id INT PRIMARY KEY,
      credit_score INT,
      country NVARCHAR(50),
      gender NVARCHAR(10),
      age INT,
      tenure INT
);
CREATE TABLE BC_accounts(
      customer_id INT PRIMARY KEY,
      balance FLOAT,
      products_number INT,
      credit_card INT,
      active_member INT,
      estimated_salary FLOAT,
      churn INT,
      FOREIGN KEY(customer_id) REFERENCES BC_Customers(customer_id)
);

INSERT INTO BC_Customers(customer_id,credit_score,country,gender,age,tenure)
SELECT customer_id,credit_score,country,gender,age,tenure
FROM customers_raw

INSERT INTO BC_accounts(customer_id,balance,products_number,credit_card,active_member,estimated_salary,churn)
SELECT customer_id,balance,products_number,credit_card,active_member,estimated_salary,churn
FROM customers_raw