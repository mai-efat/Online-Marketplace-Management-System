CREATE TABLE users (
    id INT PRIMARY KEY,
    full_name VARCHAR(150),
    email VARCHAR(150) UNIQUE,
    password VARCHAR(255),
    phone VARCHAR(30),
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE roles (
    id INT PRIMARY KEY,
    role_name VARCHAR(50)
);
CREATE TABLE user_roles (
    user_id INT,
    role_id INT,
    PRIMARY KEY (user_id, role_id),
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (role_id) REFERENCES roles(id)
);
CREATE TABLE vendors (
    id INT PRIMARY KEY,
    user_id INT,
    shop_name VARCHAR(150),
    status VARCHAR(20),
    FOREIGN KEY (user_id) REFERENCES users(id)
);
CREATE TABLE customers (
    id INT PRIMARY KEY,
    user_id INT,
    FOREIGN KEY (user_id) REFERENCES users(id)
);
CREATE TABLE addresses (
    id INT PRIMARY KEY,
    user_id INT,
    city VARCHAR(100),
    street VARCHAR(150),
    postal_code VARCHAR(20),
    FOREIGN KEY (user_id) REFERENCES users(id)
);
CREATE TABLE categories (
    id INT PRIMARY KEY,
    category_name VARCHAR(100),
    parent_id INT,
    FOREIGN KEY (parent_id) REFERENCES categories(id)
);
CREATE TABLE products (
    id INT PRIMARY KEY,
    vendor_id INT,
    category_id INT,
    product_name VARCHAR(150),
    description TEXT,
    price DECIMAL(10,2),
    stock INT,
    FOREIGN KEY (vendor_id) REFERENCES vendors(id),
    FOREIGN KEY (category_id) REFERENCES categories(id)
);
CREATE TABLE product_images (
    id INT PRIMARY KEY,
    product_id INT,
    image_url VARCHAR(255),
    FOREIGN KEY (product_id) REFERENCES products(id)
);
CREATE TABLE carts (
    id INT PRIMARY KEY,
    user_id INT,
    created_at DATETIME,
    FOREIGN KEY (user_id) REFERENCES users(id)
);
CREATE TABLE cart_items (
    cart_id INT,
    product_id INT,
    quantity INT,
    PRIMARY KEY (cart_id, product_id),
    FOREIGN KEY (cart_id) REFERENCES carts(id),
    FOREIGN KEY (product_id) REFERENCES products(id)
);
CREATE TABLE orders (
    id INT PRIMARY KEY,
    user_id INT,
    order_date DATETIME,
    status VARCHAR(30),
    FOREIGN KEY (user_id) REFERENCES users(id)
);
CREATE TABLE order_items (
    order_id INT,
    product_id INT,
    price DECIMAL(10,2),
    quantity INT,
    PRIMARY KEY (order_id, product_id),
    FOREIGN KEY (order_id) REFERENCES orders(id),
    FOREIGN KEY (product_id) REFERENCES products(id)
);
CREATE TABLE payments (
    id INT PRIMARY KEY,
    order_id INT,
    payment_method VARCHAR(50),
    amount DECIMAL(10,2),
    payment_date DATETIME,
    FOREIGN KEY (order_id) REFERENCES orders(id)
);
CREATE TABLE shipments (
    id INT PRIMARY KEY,
    order_id INT,
    tracking_number VARCHAR(100),
    shipped_date DATETIME,
    delivered_date DATETIME,
    FOREIGN KEY (order_id) REFERENCES orders(id)
);
CREATE TABLE reviews (
    id INT PRIMARY KEY,
    user_id INT,
    product_id INT,
    rating INT,
    comment TEXT,
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (product_id) REFERENCES products(id)
);
CREATE TABLE coupons (
    id INT PRIMARY KEY,
    code VARCHAR(50),
    discount_percent INT,
    expiry_date DATE
);
INSERT INTO roles (id, role_name) VALUES 
(1, 'admin'), 
(2, 'vendor'), 
(3,'customer');
INSERT INTO users (id, full_name, email, password, phone) VALUES 
(1, 'Ahmed Ali', 'ahmed@mail.com', 'pass123', '0100000001'), 
(2, 'Sara Mohamed', 'sara@mail.com', 'pass123', '0100000002'), 
(3, 'hany Mohamed', 'hany@mail.com', 'pass123', '0100000003'),
(4, 'shaimaa gamal', 'shaimaa@mail.com', 'pass123', '016665555');

INSERT INTO user_roles (user_id, role_id) VALUES 
(1, 1), 
(2, 2), 
(3,3);
INSERT INTO vendors (id, user_id, shop_name, status) VALUES 
    
(1, 2, 'Sara Store', 'active'),
(2, 3, 'yousef Store', 'active'),
(3, 4, 'ibrahim Store', 'active'),
(4, 1, 'fathy Store', 'active');

INSERT INTO customers (id, user_id) VALUES 
(1,3);
INSERT INTO addresses (id, user_id, city, street, postal_code) VALUES 
(1, 3, 'Cairo', 'Nasr City', '12345'); 
INSERT INTO categories (id, category_name, parent_id) VALUES 
(1, 'Electronics', NULL), 
(2, 'Mobile Phones', 1); 
INSERT INTO products (id, vendor_id, category_id, product_name, description, price, stock) 
VALUES
(1, 1, 2, 'iPhone 14', 'Apple smartphone', 30000, 10), 
(2, 2, 2, 'Samsung S23', 'Samsung smartphone', 25000, 15),
(3, 3, 2, 'huawei', 'huawei smartphone', 10000, 30);

INSERT INTO product_images (id, product_id, image_url) VALUES 
(1, 1, 'iphone.jpg'), 
(2, 2, 'samsung.jpg'); 
INSERT INTO coupons (id, code, discount_percent, expiry_date) VALUES 
(1, 'SALE10', 10, '2026-12-31'),
(2,'SALE20',20,'2025-01-12');
INSERT INTO orders (id, user_id, order_date, status) VALUES 
(1, 3, NOW(), 'paid'),
(2, 3, NOW(), 'pending'); 

INSERT INTO order_items (order_id, product_id, price, quantity) VALUES 
(1, 1, 30000, 1), 
(1, 2, 25000, 2),
(2, 1, 75000, 3); 

INSERT INTO reviews (id, user_id, product_id, rating, comment) VALUES 
(1, 3, 1, 5, 'Excellent product'), 
(2, 3, 2, 4, 'Very good phone'), 
(3, 2, 1, 3, ' good phone'), 
(4, 3, 2, 2, 'Very good phone'); 
INSERT INTO payments (id, order_id, payment_method, amount, payment_date) VALUES 
(1, 1, 'card', 80000, NOW());
INSERT INTO shipments (id, order_id, tracking_number, shipped_date, delivered_date) 
VALUES
(1, 1, 'TRK123456', NOW(), NULL); 
INSERT INTO carts (id, user_id, created_at) VALUES 
(1, 3, NOW()), 
(2, 2, NOW()); 

INSERT INTO cart_items (cart_id, product_id, quantity) VALUES 
(1, 1, 1), 
(1, 2, 2),
(2, 2, 3); 


SELECT full_name, email, phone
FROM users;
SELECT u.full_name AS vendor_name, v.shop_name
FROM vendors v
JOIN users u ON v.user_id = u.id
WHERE v.status = 'active';

SELECT product_name, price, stock
FROM products;
SELECT code ,discount_percent from coupons where expiry_date >= now();
select u.full_name, r.role_name from user_roles ur join  users u on  u.id=ur.user_id
join roles r on r.id =ur.role_id;
select product_name from products where price  >25000;
select * from orders where status="paid";
select * from  reviews where rating >= 4;
SELECT u.full_name, p.product_name, r.rating, r.comment
FROM reviews r
JOIN users u ON r.user_id = u.id
JOIN products p ON r.product_id = p.id
WHERE r.rating >= 4;
select u.id,u.full_name,u.email from users u  join customers c  on u.id = c.user_id;
SELECT p.product_name, p.price, v.shop_name, c.category_name
FROM products p
JOIN vendors v ON p.vendor_id = v.id
JOIN categories c ON p.category_id = c.id
WHERE p.stock = 10;
select count(*) AS total_users from users;
select p.product_name,count(o.quantity) as total_quantity_sold  from products p join  order_items o on o.product_id =p.id 
group by product_name;
select category_name , count(p.id) from categories c left  join products p on p.category_id=c.id group by c.category_name; 

select o.id AS order_id,SUM(oi.price * oi.quantity) AS total_paid from orders o join order_items oi on o.id = oi.order_id group by order_id;
select  p.product_name ,avg(rating) as average_rating from  reviews r join products p on r.product_id=p.id group by product_name;
select * from users where id  in  (select user_id from orders);

select * from products where id not in ( select product_id from  reviews );
select * from users where id not in (select id from roles );
select * from vendors where id not in (Select vendor_id from products);
select * from orders where id not in (select  order_id from shipments );
select p.product_name  ,sum(oi.quantity) as total_quantity_sold  from products p join order_items oi on p.id = oi.product_id 
group by   p.product_name  order by total_quantity_sold desc limit 3;
select v.shop_name,sum(oi.price *oi.quantity) as total_quantity_sold from vendors v join products p 
    on v.id=p.vendor_id join order_items oi  on p.id =oi.product_id group by v.shop_name;

select u.full_name , sum(oi.price*oi.quantity) AS total_spent 
from users  u 
join orders o on u.id = o.user_id 
join  order_items oi  on o.id = oi.order_id
group by  u.full_name
ORDER BY total_spent desc limit 1;


select u.full_name,p.payment_method,payment_date from users u join orders o on u.id = o.user_id 
join order_items oi on o.id = oi.order_id
left join payments p on oi.order_id =p.order_id;

select p.product_name,count(ci.quantity) as times_in_carts
from products p

left join cart_items  ci on p.id = ci.product_id
    group by p.product_name
    order by times_in_carts desc;













