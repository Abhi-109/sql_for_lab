-- =====================================================================
-- CSA4307 Database System | Mid-Term Lab Exam 2026 | Sets A to E
-- MySQL 8.0.16+ (CHECK constraints are enforced from this version)
-- =====================================================================
-- PART 0: Create tables and insert data (the 20-mark part)
-- The paper only gives row counts, so this sample data is made up to
-- match them. Real exam data will differ, but the queries still work.
-- =====================================================================

CREATE DATABASE IF NOT EXISTS smartmart;
USE smartmart;

CREATE TABLE suppliers (
    supplier_id    INT PRIMARY KEY,
    name           VARCHAR(100) NOT NULL,
    contact_person VARCHAR(100),
    phone          VARCHAR(15),
    city           VARCHAR(50)
);

CREATE TABLE customers (
    customer_id     INT PRIMARY KEY,
    name            VARCHAR(100) NOT NULL,
    email           VARCHAR(100) UNIQUE,
    phone           VARCHAR(15),
    city            VARCHAR(50),
    membership_type VARCHAR(20)
);

CREATE TABLE employees (
    employee_id INT PRIMARY KEY,
    name        VARCHAR(100) NOT NULL,
    designation VARCHAR(50),
    salary      DECIMAL(10,2),
    hire_date   DATE,
    manager_id  INT,
    FOREIGN KEY (manager_id) REFERENCES employees(employee_id)
);

CREATE TABLE products (
    product_id     INT PRIMARY KEY,
    name           VARCHAR(100) NOT NULL,
    category       VARCHAR(50),
    price          DECIMAL(10,2) CHECK (price > 0),
    stock_quantity INT,
    supplier_id    INT,
    FOREIGN KEY (supplier_id) REFERENCES suppliers(supplier_id)
);

CREATE TABLE orders (
    order_id     INT PRIMARY KEY,
    customer_id  INT,
    employee_id  INT,
    order_date   DATE,
    total_amount DECIMAL(10,2) CHECK (total_amount >= 0),
    status       VARCHAR(20),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (employee_id) REFERENCES employees(employee_id)
);

CREATE TABLE order_items (
    order_item_id INT PRIMARY KEY,
    order_id      INT,
    product_id    INT,
    quantity      INT CHECK (quantity > 0),
    unit_price    DECIMAL(10,2),
    FOREIGN KEY (order_id)   REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

CREATE TABLE payments (
    payment_id   INT PRIMARY KEY,
    order_id     INT,
    payment_date DATE,
    amount       DECIMAL(10,2),
    method       VARCHAR(20),
    FOREIGN KEY (order_id) REFERENCES orders(order_id)
);

INSERT INTO suppliers VALUES
(1, 'FreshFarm Traders', 'Ramesh Rao',  '9810000001', 'Mumbai'),
(2, 'TechSource India',  'Anita Das',   '9810000002', 'Bangalore'),
(3, 'HomeNeeds Co',      'Suresh Iyer', '9810000003', 'Chennai'),
(4, 'GadgetHub',         'Priya Nair',  '9810000004', 'Delhi'),
(5, 'DailyMart Supplies','Karan Shah',  '9810000005', 'Mumbai');

INSERT INTO customers VALUES
(101, 'Arjun Mehta',  'arjun@mail.com',  '9900000101', 'Bangalore', 'Gold'),
(102, 'Sneha Reddy',  'sneha@mail.com',  '9900000102', 'Mumbai',    'Silver'),
(103, 'Vikram Singh', 'vikram@mail.com', '9900000103', 'Chennai',   'Platinum'),
(104, 'Divya Nair',   'divya@mail.com',  '9900000104', 'Bangalore', 'Gold'),
(105, 'Rohit Sharma', 'rohit@mail.com',  '9900000105', 'Delhi',     'Silver'),
(106, 'Meena Iyer',   'meena@mail.com',  '9900000106', 'Mumbai',    'Platinum'),
(107, 'Karthik Rao',  'karthik@mail.com','9900000107', 'Chennai',   'Silver');

-- 201 first because other rows reference it as manager
INSERT INTO employees VALUES
(201, 'Anil Kumar',     'General Manager', 80000, '2018-03-15', NULL),
(202, 'Bhavna Shetty',  'Sales Manager',   55000, '2019-07-01', 201),
(203, 'Chetan Gowda',   'Sales Executive', 28000, '2021-06-10', 202),
(204, 'Deepa Menon',    'Sales Executive', 30000, '2022-02-20', 202),
(205, 'Esha Patil',     'Cashier',         22000, '2023-01-05', 202),
(206, 'Farhan Ali',     'Store Manager',   45000, '2020-11-12', 201);

INSERT INTO products VALUES
(301, 'Wireless Mouse',      'Electronics', 599,  120, 2),
(302, 'Bluetooth Speaker',   'Electronics', 1499, 60,  4),
(303, 'Basmati Rice 5kg',    'Groceries',   450,  200, 1),
(304, 'Olive Oil 1L',        'Groceries',   650,  90,  5),
(305, 'Steel Water Bottle',  'Home',        350,  150, 3),
(306, 'Laptop Stand',        'Electronics', 1200, 40,  2),
(307, 'Notebook Pack',       'Stationery',  180,  300, 5),
(308, 'Cooking Pan',         'Home',        899,  70,  3),
(309, 'Headphones',          'Electronics', 2499, 25,  4);

INSERT INTO orders VALUES
(401, 101, 203, '2025-09-05', 1848, 'Delivered'),
(402, 102, 204, '2025-09-18', 450,  'Delivered'),
(403, 103, 203, '2025-10-02', 3599, 'Shipped'),
(404, 101, 204, '2025-10-15', 650,  'Pending'),
(405, 104, 203, '2025-10-28', 2750, 'Delivered'),
(406, 105, 205, '2025-11-03', 900,  'Pending'),
(407, 103, 203, '2025-11-10', 1499, 'Shipped'),
(408, 106, 204, '2025-11-20', 2499, 'Delivered');

INSERT INTO order_items VALUES
(501, 401, 301, 2, 599),
(502, 401, 304, 1, 650),
(503, 402, 303, 1, 450),
(504, 403, 302, 1, 1499),
(505, 403, 306, 1, 1200),
(506, 403, 307, 5, 180),
(507, 404, 304, 1, 650),
(508, 405, 305, 1, 350),
(509, 405, 306, 2, 1200),
(510, 406, 307, 5, 180),
(511, 407, 303, 2, 450),
(512, 407, 301, 1, 599),
(513, 408, 309, 1, 2499);

INSERT INTO payments VALUES
(601, 401, '2025-09-05', 1848, 'UPI'),
(602, 402, '2025-09-18', 450,  'Cash'),
(603, 403, '2025-10-03', 3599, 'Card'),
(604, 405, '2025-10-28', 2750, 'UPI'),
(605, 408, '2025-11-20', 2499, 'Card'),
(606, 407, '2025-11-11', 1499, 'UPI'),
(607, 404, '2025-10-16', 650,  'Cash'),
(608, 406, '2025-11-04', 900,  'Card');


-- =====================================================================
-- SET A
-- =====================================================================

-- Q1(a) Customers whose city is Bangalore
SELECT * FROM customers
WHERE city = 'Bangalore';

-- Q1(b) Products priced between 400 and 1000, highest price first
SELECT * FROM products
WHERE price BETWEEN 400 AND 1000
ORDER BY price DESC;

-- Q2(a) Total monthly sales for each month of 2025
SELECT MONTH(order_date)     AS month_no,
       MONTHNAME(order_date) AS month_name,
       SUM(total_amount)     AS total_sales
FROM orders
WHERE YEAR(order_date) = 2025
GROUP BY MONTH(order_date), MONTHNAME(order_date)
ORDER BY month_no;

-- Q2(b) Customer order summary using INNER JOIN
SELECT c.name AS customer_name,
       o.order_id,
       o.order_date,
       p.name AS product_name,
       oi.quantity,
       oi.unit_price
FROM customers c
INNER JOIN orders o       ON c.customer_id = o.customer_id
INNER JOIN order_items oi ON o.order_id    = oi.order_id
INNER JOIN products p     ON oi.product_id = p.product_id
ORDER BY o.order_id;

-- Q3(a) Employee(s) who handled the highest number of orders
SELECT e.name, COUNT(o.order_id) AS order_count
FROM employees e
INNER JOIN orders o ON e.employee_id = o.employee_id
GROUP BY e.employee_id, e.name
HAVING COUNT(o.order_id) = (
    SELECT MAX(cnt)
    FROM (SELECT COUNT(*) AS cnt
          FROM orders
          GROUP BY employee_id) AS t
);

-- Q3(b) Products never purchased, using NOT EXISTS
SELECT p.*
FROM products p
WHERE NOT EXISTS (
    SELECT 1
    FROM order_items oi
    WHERE oi.product_id = p.product_id
);

-- Q4(a) Create feedback table
CREATE TABLE feedback (
    feedback_id   INT PRIMARY KEY,
    customer_id   INT,
    product_id    INT,
    rating        INT CHECK (rating BETWEEN 1 AND 5),
    comments      VARCHAR(200),
    feedback_date DATE,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (product_id)  REFERENCES products(product_id)
);

-- Q4(b) Insert two records, then update the first record's rating to 5
INSERT INTO feedback (feedback_id, customer_id, product_id, rating, comments, feedback_date)
VALUES
(1, 101, 301, 4, 'Works well', '2025-11-21'),
(2, 103, 306, 3, 'Decent stand', '2025-11-22');

UPDATE feedback
SET rating = 5
WHERE feedback_id = 1;


-- =====================================================================
-- SET B
-- =====================================================================

-- Q1(a) Name, price, category for products with stock_quantity > 80
SELECT name, price, category
FROM products
WHERE stock_quantity > 80;

-- Q1(b) Customers from Mumbai and Chennai only, sorted by name
SELECT * FROM customers
WHERE city IN ('Mumbai', 'Chennai')
ORDER BY name ASC;

-- Q2(a) City-wise customer count
SELECT city, COUNT(*) AS number_of_customers
FROM customers
GROUP BY city;

-- Q2(b) Salary > 40000 and designation contains 'Manager'
SELECT *
FROM employees
WHERE salary > 40000
  AND designation LIKE '%Manager%'
ORDER BY salary DESC;

-- Q3(a) Suppliers whose products have never been ordered (subquery)
SELECT *
FROM suppliers
WHERE supplier_id IN (
    SELECT supplier_id
    FROM products
    WHERE product_id NOT IN (SELECT product_id FROM order_items)
);

-- Q3(b) Customers whose total orders exceed 2500 (subquery + GROUP BY + HAVING)
SELECT *
FROM customers
WHERE customer_id IN (
    SELECT customer_id
    FROM orders
    GROUP BY customer_id
    HAVING SUM(total_amount) > 2500
);

-- Q4(a) Create discounts table
CREATE TABLE discounts (
    discount_id      INT PRIMARY KEY,
    category         VARCHAR(50) NOT NULL,
    discount_percent DECIMAL(5,2) CHECK (discount_percent BETWEEN 0 AND 100),
    valid_from       DATE,
    valid_to         DATE
);

-- Q4(b) Insert records, then raise the Electronics discount by 5 points
INSERT INTO discounts (discount_id, category, discount_percent, valid_from, valid_to)
VALUES
(1, 'Electronics', 10.00, '2025-11-01', '2025-11-30'),
(2, 'Groceries',    5.00, '2025-11-01', '2025-11-30');

UPDATE discounts
SET discount_percent = discount_percent + 5
WHERE category = 'Electronics';


-- =====================================================================
-- SET C
-- =====================================================================

-- Q1(a) Employees hired after 2021-01-01
SELECT name, designation
FROM employees
WHERE hire_date > '2021-01-01';

-- Q1(b) Pending or Shipped orders with total_amount > 800
SELECT *
FROM orders
WHERE status IN ('Pending', 'Shipped')
  AND total_amount > 800;

-- Q2(a) Top 3 selling product categories by quantity sold
SELECT p.category, SUM(oi.quantity) AS total_quantity_sold
FROM order_items oi
INNER JOIN products p ON oi.product_id = p.product_id
GROUP BY p.category
ORDER BY total_quantity_sold DESC
LIMIT 3;

-- Q2(b) Average salary for each designation
SELECT designation, AVG(salary) AS avg_salary
FROM employees
GROUP BY designation;

-- Q3(a) Number of orders per customer (customers with zero orders excluded)
SELECT c.name AS customer_name, COUNT(o.order_id) AS order_count
FROM customers c
INNER JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.name;

-- Q3(b) Purchase history of customer 101
SELECT o.order_id,
       o.order_date,
       p.name AS product_name,
       oi.quantity,
       oi.unit_price
FROM orders o
INNER JOIN order_items oi ON o.order_id    = oi.order_id
INNER JOIN products p     ON oi.product_id = p.product_id
WHERE o.customer_id = 101;

-- Q4(a) Add loyalty_points column with default 0
ALTER TABLE customers
ADD COLUMN loyalty_points INT DEFAULT 0;

-- Q4(b) Gold = 500, Platinum = 1000
-- If MySQL Workbench blocks it (safe update mode), run first: SET SQL_SAFE_UPDATES = 0;
UPDATE customers
SET loyalty_points = CASE membership_type
                         WHEN 'Gold'     THEN 500
                         WHEN 'Platinum' THEN 1000
                     END
WHERE membership_type IN ('Gold', 'Platinum');

-- Same thing as two simple statements, if you prefer:
-- UPDATE customers SET loyalty_points = 500  WHERE membership_type = 'Gold';
-- UPDATE customers SET loyalty_points = 1000 WHERE membership_type = 'Platinum';


-- =====================================================================
-- SET D
-- =====================================================================

-- Q1(a) Orders placed after 2025-10-01, sorted by order_date
SELECT *
FROM orders
WHERE order_date > '2025-10-01'
ORDER BY order_date;

-- Q1(b) Products with price less than 500
SELECT *
FROM products
WHERE price < 500;

-- Q2(a) Sales records for October 2025 using BETWEEN
SELECT order_date, total_amount
FROM orders
WHERE order_date BETWEEN '2025-10-01' AND '2025-10-31';

-- Q2(b) Orders with customer name, employee name and status (INNER JOIN)
SELECT o.order_id,
       c.name AS customer_name,
       e.name AS employee_name,
       o.status
FROM orders o
INNER JOIN customers c ON o.customer_id = c.customer_id
INNER JOIN employees e ON o.employee_id = e.employee_id;

-- Q3(a) Total payment amount for each payment method
SELECT method, SUM(amount) AS total_amount_received
FROM payments
GROUP BY method;

-- Q3(b) Products supplied by suppliers from Mumbai (subquery)
SELECT *
FROM products
WHERE supplier_id IN (
    SELECT supplier_id
    FROM suppliers
    WHERE city = 'Mumbai'
);

-- Q4(a) Create product_returns table
CREATE TABLE product_returns (
    return_id     INT PRIMARY KEY,
    order_item_id INT,
    return_date   DATE,
    reason        VARCHAR(100),
    refund_amount DECIMAL(10,2) CHECK (refund_amount >= 0),
    FOREIGN KEY (order_item_id) REFERENCES order_items(order_item_id)
);

-- Q4(b) Insert return for order item 509 (refund 1800), then add 1 to stock of product 306
INSERT INTO product_returns (return_id, order_item_id, return_date, reason, refund_amount)
VALUES (1, 509, '2025-11-25', 'Defective item', 1800.00);

UPDATE products
SET stock_quantity = stock_quantity + 1
WHERE product_id = 306;


-- =====================================================================
-- SET E
-- =====================================================================

-- Q1(a) Products priced between 200 and 1000, highest price first
SELECT *
FROM products
WHERE price BETWEEN 200 AND 1000
ORDER BY price DESC;

-- Q1(b) Gold or Platinum customers
SELECT *
FROM customers
WHERE membership_type IN ('Gold', 'Platinum');

-- Q2(a) Total sales amount for each order status
SELECT status, SUM(total_amount) AS total_sales
FROM orders
GROUP BY status;

-- Q2(b) Product name, category and supplier name (INNER JOIN)
SELECT p.name AS product_name,
       p.category,
       s.name AS supplier_name
FROM products p
INNER JOIN suppliers s ON p.supplier_id = s.supplier_id;

-- Q3(a) Customer(s) with the maximum number of orders
SELECT c.customer_id, c.name, COUNT(o.order_id) AS order_count
FROM customers c
INNER JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.name
HAVING COUNT(o.order_id) = (
    SELECT MAX(cnt)
    FROM (SELECT COUNT(*) AS cnt
          FROM orders
          GROUP BY customer_id) AS t
);

-- Q3(b) Employees who have not handled any orders (LEFT JOIN ... IS NULL)
SELECT e.*
FROM employees e
LEFT JOIN orders o ON e.employee_id = o.employee_id
WHERE o.order_id IS NULL;

-- Q4(a) Create employee_shifts (one shift per employee per date)
CREATE TABLE employee_shifts (
    shift_id    INT PRIMARY KEY,
    employee_id INT,
    shift_date  DATE NOT NULL,
    start_time  TIME,
    end_time    TIME,
    FOREIGN KEY (employee_id) REFERENCES employees(employee_id),
    UNIQUE (employee_id, shift_date)
);

-- Q4(b) Insert shifts for 203, 204, 206 on 2025-11-15, then change 204's end_time
INSERT INTO employee_shifts (shift_id, employee_id, shift_date, start_time, end_time)
VALUES
(1, 203, '2025-11-15', '09:00:00', '17:00:00'),
(2, 204, '2025-11-15', '10:00:00', '18:00:00'),
(3, 206, '2025-11-15', '09:00:00', '17:00:00');

UPDATE employee_shifts
SET end_time = '19:00:00'
WHERE employee_id = 204
  AND shift_date = '2025-11-15';
