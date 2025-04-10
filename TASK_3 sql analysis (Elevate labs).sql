create database ecommerce;
use ecommerce;
-- USERS
CREATE TABLE users (
    user_id INT PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(100),
    created_at DATE
);
select * from users;
INSERT INTO users VALUES
(1, 'Amit Kumar', 'amit@example.com', '2024-01-10'),
(2, 'Surbhi Singh', 'surbhi@example.com', '2024-02-15'),
(3, 'Ravi Verma', 'ravi@example.com', '2024-03-05');

-- PRODUCTS
CREATE TABLE products (
    product_id INT PRIMARY KEY,
    name VARCHAR(100),
    category VARCHAR(50),
    price DECIMAL(10, 2)
);
select* from products;
INSERT INTO products VALUES
(1, 'Laptop', 'Electronics', 55000.00),
(2, 'Phone', 'Electronics', 30000.00),
(3, 'Shoes', 'Fashion', 2500.00),
(4, 'T-shirt', 'Fashion', 800.00),
(5, 'Book', 'Books', 500.00);

-- ORDERS
CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    user_id INT,
    order_date DATE,
    total_amount DECIMAL(10, 2),
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);
select * from orders;
INSERT INTO orders VALUES
(101, 1, '2024-03-10', 55000.00),
(102, 2, '2024-03-12', 30500.00),
(103, 3, '2024-04-01', 3300.00),
(104, 1, '2024-04-03', 800.00);

-- ORDER_ITEMS
CREATE TABLE order_items (
    order_item_id INT PRIMARY KEY,
    order_id INT,
    product_id INT,
    quantity INT,
    price DECIMAL(10, 2),
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);
select * from order_items;
INSERT INTO order_items VALUES
(1, 101, 1, 1, 55000.00),
(2, 102, 2, 1, 30000.00),
(3, 102, 5, 1, 500.00),
(4, 103, 3, 1, 2500.00),
(5, 103, 5, 1, 500.00),
(6, 104, 4, 1, 800.00);


-- 1. show user who regester after 1 feb 2024.

select * from users
where created_at> '2024-02-01';

-- 2. show products sorted by pricre (high to low)

select * from products
order by price desc;

-- 3. show total number of orders per user.

select u.name, count(o.order_id) as
total_orders
from users u 
join orders o ON u.user_id =
o. user_id
group by u.user_id, u.name;

-- 4. Revenue per product category

select p. category, sum(oi. quantity * oi. price) as category_revenue 
from order_items oi
join products p on oi.product_id =
p.product_id
group by p. category;

-- 5. Show user names with their order ids and dates.
 select u.name, o.order_id,
 o.order_date
 from users u
 inner join orders o on u. user_id=
 o.user_id;

-- 6. show all users even if they haven't placed any order.

select u. name, o.order_id
from users u
left join orders o on u.user_id = 
o.user_id;

-- 7. show all orders even if user info is missing.

select o.order_id, u.name
from orders o 
Right join users u on u.user_id = 
o.user_id;

-- 8. Products priced above the average price.
SELECT *
FROM products
WHERE price > (
    SELECT AVG(price)
    FROM products
);
-- 9. Orders with total amount greater than average.
SELECT *
FROM orders
WHERE total_amount > (
    SELECT AVG(total_amount)
    FROM orders
);

 -- 10. Users who bought more than one product in a single order

SELECT *
FROM users
WHERE user_id IN (
    SELECT o.user_id
    FROM orders o
    JOIN order_items oi ON o.order_id = oi.order_id
    GROUP BY o.order_id
    HAVING COUNT(oi.product_id) > 1
);

-- 1. View: user_order_summary
-- Shows each user's total spend and number of orders.


CREATE VIEW user_order_summary AS
SELECT 
    u.user_id,
    u.name,
    COUNT(o.order_id) AS total_orders,
    SUM(o.total_amount) AS total_spent
FROM users u
LEFT JOIN orders o ON u.user_id = o.user_id
GROUP BY u.user_id, u.name;


-- 2. View: product_sales_summary
-- Shows total quantity and revenue per product.


CREATE VIEW product_sales_summary AS
SELECT 
    p.product_id,
    p.name AS product_name,
    p.category,
    SUM(oi.quantity) AS total_sold,
    SUM(oi.price * oi.quantity) AS revenue_generated
FROM products p
LEFT JOIN order_items oi ON p.product_id = oi.product_id
GROUP BY p.product_id, p.name, p.category;


-- 3. View: order_details_view
-- Shows complete order breakdown with user, date, and item details.


CREATE VIEW order_details_view AS
SELECT 
    o.order_id,
    o.order_date,
    u.name AS user_name,
    p.name AS product_name,
    oi.quantity,
    oi.price,
    (oi.quantity * oi.price) AS item_total
FROM orders o
JOIN users u ON o.user_id = u.user_id
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id;

-- 1. Index on orders.user_id

CREATE INDEX idx_orders_user_id ON orders(user_id);

--  2. Index on order_items.order_id and order_items.product_id

CREATE INDEX idx_order_items_order_id ON order_items(order_id);


--  3. Index on products.category

CREATE INDEX idx_products_category ON products(category);

-- 5. How to check index Exist.
show indexes from orders;


