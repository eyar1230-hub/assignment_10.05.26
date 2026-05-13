--1. Relationship view: orders 1:N sales and products 1:N sales.
	-- Create orders: id PK AUTOINCREMENT, order_no TEXT UNIQUE, address TEXT NOT NULL, phone TEXT NOT NULL, ordered_at TEXT DEFAULT (date('now'))
CREATE TABLE orders(
	id 			INTEGER PRIMARY KEY NOT	NULL, 
	order_no 	TEXT UNIQUE,
	address 	TEXT NOT NULL,
	phone 		TEXT NOT NULL,
	ordered_at 	TEXT DEFAULT (date('now'))
	);

	-- Create products: id PK AUTOINCREMENT, name TEXT NOT NULL, unit_price REAL NOT NULL CHECK (unit_price >= 0)	
CREATE TABLE products(
	id 			INTEGER PRIMARY KEY NOT	NULL, 
	name 		TEXT NOT NULL,
	unit_price	REAL NOT NULL CHECK(unit_price >= 0)
	);

	-- Create sales (junction): order_id FK, product_id FK, qty INTEGER NOT NULL DEFAULT 1 CHECK (qty > 0), with composite PK (order_id, product_id) (Each row means one product sold in one order)
CREATE TABLE sales( 
	order_id 	INTEGER NOT NULL,
	product_id 	INTEGER NOT NULL,
	qty 		INTEGER NOT NULL DEFAULT 1 CHECK (qty > 0),
	PRIMARY key (order_id,product_id),
	FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE
	FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE
	 );

--4. Insert sample data:
INSERT INTO orders (id, order_no, address, phone, ordered_at)
VALUES
	(1, 'ORD-1001', '12 Lake St, Boston',  '+1-555-0101', '2026-01-05'),
	(2, 'ORD-1002', '12 Lake St, Boston',  '+1-555-0101', '2026-01-07'),
	(3, 'ORD-1003', '88 Pine Ave, Seattle', '+1-555-0202', '2026-01-09'),
	(4, 'ORD-1004', '44 Nile Rd, Cairo',    '+1-555-0303', '2026-01-10'),
	(5, 'ORD-1005', '77 Hill Rd, Austin',   '+1-555-0404', '2026-01-11')
	;

INSERT INTO products (id, name, unit_price)
VALUES
	(1, 'Laptop', 1200),
	(2, 'Mouse', 25),
	(3, 'Keyboard', 80),
	(4, 'Webcam', 95),
	(5, 'Monitor', 280),
	(6, 'Desk Lamp', 35),
	(7, 'USB Hub', 40)
	;

INSERT INTO sales (order_id, product_id, qty)
VALUES
  (1, 1, 1),
  (1, 2, 2),
  (1, 3, 1),
  (2, 4, 1),
  (2, 7, 2),
  (3, 5, 1),
  (3, 6, 3),
  (4, 2, 1),
  (4, 7, 1);
	
--5. Write a query to show each sold product with order_no, address, phone, product_name, qty, unit_price, and line total (qty * unit_price)
SELECT 
	o.order_no,
	o.address,
	o.phone,
	p.name as product_name,
	p.unit_price,
	(s.qty * p.unit_price) as total_price
	
FROM sales s
	INNER JOIN orders o on s.order_id = o.id
	INNER JOIN products p on s.product_id = p.id
ORDER by order_no
;

--6. Write a query to list each order with total item count (SUM(qty)) and total price (SUM(qty * unit_price))
SELECT 
	o.order_no,
	o.address,
	o.phone,
	p.name,
	p.unit_price,
	sum(s.qty * p.unit_price) as total_sold_price,
	sum(s.qty) as total_it_perchesed
FROM  sales s
	INNER JOIN orders o on s.order_id = o.id
	INNER JOIN products p on s.product_id = p.id
GROUP by o.order_no
;
--7. Write a query to list each order with all product names. Make sure to print all products of the same order before going to the next order
SELECT 
	o.order_no,
	p.name as product_name
FROM products p
CROSS JOIN orders o
order by o.order_no

--8. Write a query to calculate each phone (or address) and the sum of all orders
SELECT
	o.address as address,
	coalesce(sum(s.qty), 0) as amount_sold,
	coalesce(sum(s.qty * p.unit_price), 0) as total_spent
FROM sales s
FULL OUTER JOIN orders o on s.order_id = o.id
FULL OUTER JOIN products p on s.product_id = p.id

GROUP BY address
ORDER by amount_sold DESC
;
	
	
--9. Write a query to show orders that have no products in sales
SELECT
	o.order_no as order_no,
	coalesce(sum(s.qty), 0) as amount_sold
FROM sales s
FULL OUTER JOIN orders o on s.order_id = o.id
GROUP BY order_no
having amount_sold = 0
;
	
	
	
