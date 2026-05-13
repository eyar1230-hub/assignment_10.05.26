--1. Create a categories table: id PK AUTOINCREMENT, title TEXT UNIQUE NOT NULL.
CREATE TABLE IF NOT EXISTS categories(
	id 		INTEGER PRIMARY KEY  AUTOINCREMENT,
	title 	TEXT UNIQUE NOT NULL
);
	
--2. Create a posts table: id PK AUTOINCREMENT, category_id FK (NOT NULL), title TEXT, views INTEGER DEFAULT 0. Use ON DELETE RESTRICT.
CREATE TABLE posts (
	id 			INTEGER PRIMARY KEY AUTOINCREMENT,
	category_id INTEGER NOT NULL,
	title 		TEXT,
	views 		INTEGER DEFAULT 0,
	FOREIGN KEY (category_id) REFERENCES categories(id)
		ON DELETE RESTRICT
);
--3. Insert 3 categories and at least 5 posts spread across the categories.
INSERT INTO categories (title)
	VALUES ('Technology'),('Lifestyle'),('Travel');

INSERT INTO posts (category_id,title,views)
	VALUES 
	(1, 'Top 10 Tech Trends in 2026', 1500),
	(1, 'How to Build a Smarter Home', 850),
	(2, 'Morning Routines for Productivity', 2400),
	(3, 'Hidden Gems in Southern Italy', 3200),
	(3, 'Packing Essentials for Solo Travelers', 1100);

--4. Query: list all posts with their category title using INNER JOIN.
SELECT c.title,p.title,p.views as posts_title FROM posts p
INNER JOIN categories c on p.category_id = c.id
;

--5. Query: count posts per category, show categories with 0 posts too (use LEFT JOIN + GROUP BY).
SELECT
	c.title,
	p.title		AS posts_title,
	p.views,
	COUNT(c.id) AS posts_per_category
FROM  posts p
left JOIN categories c on p.category_id = c.id
GROUP by c.title
;
--6. Query: find the category with the highest total views using GROUP BY + ORDER BY + LIMIT 1.
SELECT
	c.title,
	p.title		AS posts_title,
	SUM(p.views)
FROM  posts p
LEFT JOIN categories c on p.category_id = c.id
GROUP by c.title
ORDER by c.title DESC
LIMIT 1
;




