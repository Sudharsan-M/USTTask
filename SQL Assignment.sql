use company;

CREATE TABLE departments (
    department_id SERIAL PRIMARY KEY,
    department_name VARCHAR(100) NOT NULL
);


CREATE TABLE employees (
    employee_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    salary DECIMAL(10, 2) NOT NULL,
    department_id INT REFERENCES departments(department_id),
    manager_id INT REFERENCES employees(employee_id)
);

CREATE TABLE sales (
    sale_id SERIAL PRIMARY KEY,
    product_name VARCHAR(100) NOT NULL,
    employee_id INT REFERENCES employees(employee_id),
    amount DECIMAL(10, 2) NOT NULL,
    sale_date DATE NOT NULL
);

INSERT INTO departments (department_name) VALUES
('Sales'),
('Engineering'),
('HR'),
('Marketing');

INSERT INTO employees (first_name, last_name, salary, department_id, manager_id) VALUES
('Alice', 'Smith', 75000, 1, NULL),   
('Bob', 'Johnson', 60000, 1, 1),
('Charlie', 'Brown', 50000, 2, NULL), 
('David', 'Wilson', 55000, 2, 3),
('Emma', 'Davis', 65000, 3, NULL),    
('Frank', 'Garcia', 48000, 4, NULL);  

INSERT INTO sales (product_name, employee_id, amount, sale_date) VALUES
('Product A', 2, 2000, '2024-01-15'),
('Product B', 2, 3000, '2024-01-16'),
('Product C', 4, 1500, '2024-01-17');

 SELECT * 
 FROM employees e
 WHERE (e.first_name LIKE "A%" OR e.first_name LIKE "E%" OR e.first_name LIKE "I%" OR e.first_name LIKE "O%" OR e.first_name LIKE "U%")
 AND (e.last_name NOT LIKE "%a" AND e.last_name NOT LIKE "%e" AND e.last_name NOT LIKE "i%" AND e.last_name NOT LIKE "o%" AND e.last_name NOT LIKE "u%"); 

SELECT department_id,
       SUM(salary) OVER (PARTITION BY department_id) AS total_salary,
       AVG(salary) OVER (PARTITION BY department_id) AS average_salary,
       MAX(salary) OVER (PARTITION BY department_id) AS highest_salary,
       employee_id,
       salary
FROM employees;

SELECT e.employee_id,
       e.first_name,
       e.last_name,
       d.department_name,
       m.first_name AS manager_first_name,
       m.last_name AS manager_last_name,
       e.salary
FROM employees e
JOIN departments d ON e.department_id = d.department_id
LEFT JOIN employees m ON e.manager_id = m.employee_id;

SELECT *
FROM employees
WHERE salary > 60000;  

CREATE TEMPORARY TABLE temp_sales_report AS
SELECT 
    product_name,
    SUM(amount) AS total_sales,
    AVG(amount) AS average_sales_per_customer,
    (SELECT employee_id 
     FROM sales s2 
     WHERE s2.product_name = s1.product_name 
     ORDER BY amount DESC 
     LIMIT 1) AS top_salesperson
FROM sales s1
GROUP BY product_name;

