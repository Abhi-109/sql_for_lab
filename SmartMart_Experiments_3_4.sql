-- =====================================================================
-- SmartMart | Experiment 3 (Filtering & Sorting) and
--             Experiment 4 (Aggregate Functions & Grouping)
-- Written for MySQL Workbench.
-- Prerequisite: tables and sample data from Experiments 1 and 2 loaded.
-- Lines marked "ORACLE:" give the original lab-manual syntax.
-- =====================================================================

USE SmartMart;

-- =====================================================================
-- EXPERIMENT 3 : FILTERING AND SORTING DATA
-- =====================================================================

-- 3.1 Products with price between 200 and 1000, sorted by price (desc)
SELECT product_id, name, price, category
FROM products
WHERE price BETWEEN 200 AND 1000
ORDER BY price DESC;

-- 3.2 Customers from Bangalore and Mumbai only, sorted by name
SELECT customer_id, name, email, phone, city, membership_type
FROM customers
WHERE city IN ('Bangalore', 'Mumbai')
ORDER BY name ASC;

-- 3.3 Monthly sales records for October 2026
SELECT order_date, total_amount
FROM orders
WHERE order_date BETWEEN DATE '2026-10-01' AND DATE '2026-10-31'
ORDER BY order_date;

-- 3.4 Employees with salary > 40000 and designation containing 'Manager'
SELECT employee_id, name, designation, salary
FROM employees
WHERE salary > 40000
  AND designation LIKE '%Manager%'
ORDER BY salary DESC;

-- 3.5 Pending or Shipped orders with total_amount > 1000
SELECT order_id, customer_id, employee_id,
       order_date, total_amount, status
FROM orders
WHERE status IN ('Pending', 'Shipped')
  AND total_amount > 1000;


-- =====================================================================
-- EXPERIMENT 4 : AGGREGATE FUNCTIONS AND GROUPING
-- =====================================================================

-- 4.1 Total monthly sales for each month of 2026
SELECT
    DATE_FORMAT(order_date, '%Y-%m') AS sales_month,
    SUM(total_amount)                AS total_monthly_sales
FROM orders
WHERE order_date >= DATE '2026-01-01'
  AND order_date <  DATE '2027-01-01'
GROUP BY DATE_FORMAT(order_date, '%Y-%m')
ORDER BY sales_month;
-- ORACLE: replace DATE_FORMAT(order_date, '%Y-%m') with TO_CHAR(order_date, 'YYYY-MM')

-- 4.2 City-wise customer count
SELECT
    city,
    COUNT(*) AS customer_count
FROM customers
GROUP BY city
ORDER BY customer_count DESC, city ASC;

-- 4.3 Top 3 selling product categories (by total quantity sold)
SELECT
    p.category,
    SUM(oi.quantity) AS total_quantity_sold
FROM orders o
JOIN order_items oi ON o.order_id   = oi.order_id
JOIN products p     ON oi.product_id = p.product_id
GROUP BY p.category
ORDER BY total_quantity_sold DESC
LIMIT 3;
-- ORACLE: replace "LIMIT 3" with "FETCH FIRST 3 ROWS ONLY"

-- 4.4 Average salary by designation
SELECT
    designation,
    AVG(salary) AS average_salary
FROM employees
GROUP BY designation
ORDER BY average_salary DESC;

-- 4.5 Number of orders per customer (customers with zero orders excluded)
SELECT
    c.customer_id,
    c.name AS customer_name,
    COUNT(o.order_id) AS total_orders
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.name
ORDER BY total_orders DESC, c.name ASC;
