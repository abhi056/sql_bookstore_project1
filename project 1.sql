
CREATE DATABASE onlineBookStore;


--
DROP TABLE IF EXISTS books;

--for first table
CREATE TABLE books (
	Book_ID SERIAL PRIMARY KEY,	
	Title VARCHAR(100),	
	Author VARCHAR(100),
	Genre VARCHAR (50),
	Published_Year INT,	
	Price NUMERIC (10,2),
	Stock INT
);


--for second table
DROP TABLE IF EXISTS customers;

CREATE TABLE customers(
	Customer_ID INT PRIMARY KEY,	
	Name VARCHAR(100),
	Email VARCHAR(100),
	Phone INT,	
	City VARCHAR(100),
	Country VARCHAR(100)
);



--for  third table
DROP TABLE IF EXISTS orders;

CREATE TABLE orders(
	Order_ID INT PRIMARY KEY,	
	Customer_ID	INT REFERENCES customers(Customer_ID),
	Book_ID	INT REFERENCES books(book_id),
	order_Date DATE,
	Quantity INT,	
	Total_Amount NUMERIC(10,2)

 );

 
SELECT * FROM books;
SELECT* FROM customers;
SELECT * FROM orders;



--IMPORT BOOK CSV
COPY books(Book_ID,	Title,	Author,	Genre,	Published_Year,	Price,	Stock)
FROM 'C:\Books.csv'
DELIMITER ','
CSV HEADER;

--IMPORT CUSTOMERS CSV
COPY customers(Customer_ID,	Name, Email, Phone,	City, Country)
FROM 'C:\Customers.csv'
DELIMITER ','
CSV HEADER;

--IMPORT ORDER CSV
COPY orders(Order_ID, Customer_ID, Book_ID, order_Date, Quantity, Total_Amount)
FROM 'C:\Orders.csv'
DELIMITER ','
CSV HEADER;




-- 1) Retrieve all books in the "Fiction" genre

SELECT * FROM books
	where Genre='Fiction'; 


--  2) Find books published after the year 1950

SELECT * FROM books
	where published_year>1950;


	
--  3) List all customers from the Canada

select * FROM customers
	where Country='Canada';



--  4) Show orders placed in November 2023

SELECT * FROM orders
	where Order_Date between '2023-10-31' and '2023-12-01';



--  5) Retrieve the total stock of books available

SELECT  sum (stock) as total_stock
FROM books;
	

--  6) Find the details of the most expensive book
SELECT
	*
FROM
	BOOKS
ORDER BY
	PRICE DESC
LIMIT
	1; 	




 
--  7) Show all customers who ordered more than 1 quantity of a book

SELECT * FROM ORDERS
	WHERE QUANTITY>1;


--  8) Retrieve all orders where the total amount exceeds $20

SELECT *FROM ORDERS 
	WHERE TOTAL_AMOUNT > 20;


--  9) List all genres available in the Books table
SELECT DISTINCT genre FROM BOOKS;

--  10) Find the book with the lowest stock

SELECT * FROM BOOKS ORDER BY STOCK ASC LIMIT 1;


--  11) Calculate the total revenue generated from all orders

select sum(total_amount) as total_revenue
from orders;




 -- Advance Questions : 

-- 1) Retrieve the total number of books sold for each genre:
SELECT * FROM ORDERS

SELECT b.genre, sum(o.quantity) as totalbook_sold
from orders o
join books b on o.book_id = b.book_id
group by b.genre;

-- 2) Find the average price of books in the "Fantasy" genre:
	
select avg(price) as average_price
from books
	where genre = 'Fantasy';
	
-- 3) List customers who have placed at least 2 orders:

select o.customer_id, c.name, count(o.order_id) as order_count
from orders o
join customers c on o.customer_id =c.customer_id
group by o.customer_id, c.name
having count (order_id) >=2;



-- 4) Find the most frequently ordered book:

SELECT o.book_id, b.title, count(o.order_id) AS order_count
FROM ORDERS o
join books b on o.book_id=b.book_id
group by o.book_id, b.title
order by order_count desc limit 1;


-- 5) Show the top 3 most expensive books of 'Fantasy' Genre :

select*from books
where genre='Fantasy'
order by price desc limit 3;


-- 6) Retrieve the total quantity of books sold by each author:

select b.author, sum(o.quantity)  as total_booksold
from orders o
join books b on o.book_id=b.book_id
group by b.author;

-- 7) List the cities where customers who spent over $30 are located:

select distinct c.city, total_amount
from orders o
join customers c on o.customer_id=c.customer_id
where o.total_amount >30;

-- 8) Find the customer who spent the most on orders:

select c.customer_id, c.name, sum(o.total_amount) as total_spent
from orders o
join customers c on o.customer_id=c.customer_id
group by c.customer_id, c.name
order by total_spent desc limit 5;

--9) Calculate the stock remaining after fulfilling all orders:

select b.book_id, b.title, b.stock, coalesce(sum(o.quantity),0) as order_quantity,
		b.stock - coalesce(sum(o.quantity),0) as remainig_stock
from books b
left join orders o on b.book_id=o.book_id 
group by b.book_id order by b.book_id asc;





