-- Experiment -1
-- Create the Tables

-- Step 1: Suppliers
CREATE TABLE suppliers (
 supplier_id NUMBER(10) PRIMARY KEY,
 name VARCHAR2(100) NOT NULL,
 contact_person VARCHAR2(100),
 phone VARCHAR2(15),
 city VARCHAR2(50)
);

-- Step 2: Customers
CREATE TABLE customers (
 customer_id NUMBER(10) PRIMARY KEY,
 name VARCHAR2(100) NOT NULL,
 email VARCHAR2(100),
 phone VARCHAR2(15),
 city VARCHAR2(50),
 membership_type VARCHAR2(20)
);

-- Step 3: Employees
-- manager_id refers back to another employee, so this is a self-referencing foreign key.
CREATE TABLE employees (
 employee_id NUMBER(10) PRIMARY KEY,
 name VARCHAR2(100) NOT NULL,
 designation VARCHAR2(50),
 salary NUMBER(10,2),
 hire_date DATE,
 manager_id NUMBER(10),

 CONSTRAINT fk_employee_manager
 FOREIGN KEY (manager_id)
 REFERENCES employees(employee_id)
);

-- Step 4: Products
CREATE TABLE products (
 product_id NUMBER(10) PRIMARY KEY,
 name VARCHAR2(100) NOT NULL,
 category VARCHAR2(50),
 price NUMBER(10,2),
 stock_quantity NUMBER(10),
 supplier_id NUMBER(10),
 CONSTRAINT fk_product_supplier
 FOREIGN KEY (supplier_id)
 REFERENCES suppliers(supplier_id),
 CONSTRAINT chk_product_price
 CHECK (price > 0)
);

-- Step 5: Orders
CREATE TABLE orders (
 order_id NUMBER(10) PRIMARY KEY,
 customer_id NUMBER(10),
 employee_id NUMBER(10),
 order_date DATE,
 total_amount NUMBER(12,2),
 status VARCHAR2(20),
 CONSTRAINT fk_order_customer
 FOREIGN KEY (customer_id)
 REFERENCES customers(customer_id),
 CONSTRAINT fk_order_employee
 FOREIGN KEY (employee_id)
 REFERENCES employees(employee_id),
 CONSTRAINT chk_order_total
 CHECK (total_amount >= 0)
);

-- Step 6: Order Items
CREATE TABLE order_items (
 order_item_id NUMBER(10) PRIMARY KEY,
 order_id NUMBER(10),
 product_id NUMBER(10),
 quantity NUMBER(10),
 unit_price NUMBER(10,2),
 CONSTRAINT fk_orderitem_order
 FOREIGN KEY (order_id)
 REFERENCES orders(order_id),
 CONSTRAINT fk_orderitem_product
 FOREIGN KEY (product_id)
 REFERENCES products(product_id)
);

-- Step 7: Payments
CREATE TABLE payments (
 payment_id NUMBER(10) PRIMARY KEY,
 order_id NUMBER(10),
 payment_date DATE,
 amount NUMBER(12,2),
 method VARCHAR2(30),
 CONSTRAINT fk_payment_order
 FOREIGN KEY (order_id)
 REFERENCES orders(order_id)
);

-- Check Foreign Keys
SELECT
 constraint_name,
 table_name,
 constraint_type
FROM user_constraints
WHERE table_name IN (
 'CUSTOMERS',
 'SUPPLIERS',
 'PRODUCTS',
 'EMPLOYEES',
 'ORDERS',
 'ORDER_ITEMS',
 'PAYMENTS'
)
ORDER BY table_name, constraint_type;

-- Test the CHECK constraints
-- Run these after the sample data in Part B is loaded. Both statements should be rejected by Oracle and no row is stored.
-- Negative price: violates chk_product_price
INSERT INTO products VALUES (999, 'Test Item', 'Test', -50000, 10, 1);
-- Negative total: violates chk_order_total
INSERT INTO orders VALUES (999, 101, 201, SYSDATE, -500, 'Pending');

-- Execute and verify
-- (a) List the tables
SELECT table_name
FROM user_tables
ORDER BY table_name;

-- (b) Describe each table
DESC suppliers;
DESC customers;
DESC employees;
DESC products;
DESC orders;
DESC order_items;
DESC payments;

-- (c) Verify constraints
SELECT constraint_name, table_name, constraint_type
FROM user_constraints
WHERE table_name IN ('CUSTOMERS','SUPPLIERS','PRODUCTS','EMPLOYEES',
 'ORDERS','ORDER_ITEMS','PAYMENTS')
ORDER BY table_name, constraint_type;

-- Experiment -2
-- Task 1 – Insert sample records

-- Suppliers (5 records)
INSERT INTO suppliers VALUES (1, 'TechWorld Supplies', 'Ramesh Kumar', '9876543210', 'Bangalore');
INSERT INTO suppliers VALUES (2, 'FreshMart Distributors', 'Anil Sharma', '9876543211', 'Chennai');
INSERT INTO suppliers VALUES (3, 'HomeNeeds Suppliers', 'Priya Singh', '9876543212', 'Hyderabad');
INSERT INTO suppliers VALUES (4, 'ElectroHub India', 'Vikram Rao', '9876543213', 'Mumbai');
INSERT INTO suppliers VALUES (5, 'DailyNeeds Wholesale', 'Neha Verma', '9876543214', 'Delhi');

-- Customers (5 records)
INSERT INTO customers VALUES (101, 'Amit Kumar', 'amit@gmail.com', '9000000001', 'Bangalore', 'Gold');
INSERT INTO customers VALUES (102, 'Priya Sharma', 'priya@gmail.com', '9000000002', 'Chennai', 'Silver');
INSERT INTO customers VALUES (103, 'Rahul Singh', 'rahul@gmail.com', '9000000003', 'Hyderabad', 'Gold');
INSERT INTO customers VALUES (104, 'Sneha Rao', 'sneha@gmail.com', '9000000004', 'Mumbai', 'Bronze');
INSERT INTO customers VALUES (105, 'Arjun Verma', 'arjun@gmail.com', '9000000005', 'Delhi', 'Silver');

-- Employees (5 records) – the manager (201) has NULL manager_id; others report to 201
INSERT INTO employees VALUES (201, 'Rajesh Kumar', 'Store Manager', 65000, DATE '2022-01-10', NULL);
INSERT INTO employees VALUES (202, 'Anita Sharma', 'Sales Executive', 35000, DATE '2023-03-15', 201);
INSERT INTO employees VALUES (203, 'Vivek Singh', 'Sales Executive', 36000, DATE '2023-06-20', 201);
INSERT INTO employees VALUES (204, 'Kavya Rao', 'Cashier', 30000, DATE '2024-01-05', 201);
INSERT INTO employees VALUES (205, 'Rohit Verma', 'Sales Executive', 34000, DATE '2024-07-12', 201);

-- Products (5 records) – supplier_id values 1–5 already exist
INSERT INTO products VALUES (301, 'Laptop', 'Electronics', 55000, 20, 1);
INSERT INTO products VALUES (302, 'Wireless Mouse', 'Electronics', 450, 100, 4);
INSERT INTO products VALUES (303, 'Keyboard', 'Electronics', 850, 75, 4);
INSERT INTO products VALUES (304, 'Rice 5kg', 'Grocery', 450, 200, 2);
INSERT INTO products VALUES (305, 'Electric Kettle', 'Home Appliances', 1200, 40, 3);

-- Orders (5 records) – customer and employee IDs must already exist
INSERT INTO orders VALUES (401, 101, 202, DATE '2026-09-25', 55450, 'Completed');
INSERT INTO orders VALUES (402, 102, 203, DATE '2026-09-28', 450, 'Completed');
INSERT INTO orders VALUES (403, 103, 202, DATE '2026-10-02', 2050, 'Completed');
INSERT INTO orders VALUES (404, 104, 204, DATE '2026-10-05', 55000, 'Pending');
INSERT INTO orders VALUES (405, 105, 205, DATE '2026-10-10', 900, 'Completed');

-- Order items (7 records) – one or more items for every order
INSERT INTO order_items VALUES (501, 401, 301, 1, 55000);
INSERT INTO order_items VALUES (502, 401, 302, 1, 450);
INSERT INTO order_items VALUES (503, 402, 304, 1, 450);
INSERT INTO order_items VALUES (504, 403, 305, 1, 1200);
INSERT INTO order_items VALUES (505, 403, 303, 1, 850);
INSERT INTO order_items VALUES (506, 404, 301, 1, 55000);
INSERT INTO order_items VALUES (507, 405, 302, 2, 450);

-- Payments (5 records)
INSERT INTO payments VALUES (601, 401, DATE '2026-09-25', 55450, 'Credit Card');
INSERT INTO payments VALUES (602, 402, DATE '2026-09-28', 450, 'UPI');
INSERT INTO payments VALUES (603, 403, DATE '2026-10-02', 2050, 'Debit Card');
INSERT INTO payments VALUES (604, 404, DATE '2026-10-05', 55000, 'Credit Card');
INSERT INTO payments VALUES (605, 405, DATE '2026-10-10', 900, 'UPI');
COMMIT;

-- Task 2(a) – Display all customer details
SELECT * FROM customers;

-- Task 2(b) – Product name, price and category
SELECT name, price, category
FROM products;

-- Task 2(c) – Employee names and designations
SELECT name, designation
FROM employees;

-- Task 3 – Purchase history for a specific customer
-- Data is spread over three tables, so two JOINs are needed: CUSTOMERS → ORDERS → ORDER_ITEMS → PRODUCTS. Here we use customer_id = 101.
SELECT o.order_id,
 o.order_date,
 p.name AS product_name,
 oi.quantity,
 oi.unit_price
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id
WHERE o.customer_id = 101
ORDER BY o.order_date;
