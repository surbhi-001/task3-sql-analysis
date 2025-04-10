
-- USERS
CREATE TABLE users (
    user_id INT PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(100),
    created_at DATE
);

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

INSERT INTO order_items VALUES
(1, 101, 1, 1, 55000.00),
(2, 102, 2, 1, 30000.00),
(3, 102, 5, 1, 500.00),
(4, 103, 3, 1, 2500.00),
(5, 103, 5, 1, 500.00),
(6, 104, 4, 1, 800.00);
