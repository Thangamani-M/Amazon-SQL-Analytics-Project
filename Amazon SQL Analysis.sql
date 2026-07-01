create database amazon;
-- Task 1 --
-- Create an ER diagram for the Amazon Fresh database to understand the relationships between tables (e.g., Customers, Products, Orders).--

-- Task 2 --
-- Identify the primary keys and foreign keys for each table and describe their relationships.--

-- Task 3 --
-- 1) Retrieve all customers from a specific city.--
select Name, City from amazon.customers
where City = 'Patelberg';
-- 2) Fetch all products under the "Fruits" category.--
select ProductName, Category from amazon.products
where Category = 'Fruits' ;

-- Task 4 --
-- CustomerID as the primary key.--
-- Ensure Age cannot be null and must be greater than 18.--
-- Add a unique constraint for Name.--
select * from amazon.customers;
 ALTER TABLE Customers
MODIFY Age INT NOT NULL;
ALTER TABLE Customers
ADD CONSTRAINT chk_age CHECK (Age > 18);
ALTER TABLE Customers
MODIFY Name VARCHAR(100);
ALTER TABLE Customers
ADD CONSTRAINT uq_name UNIQUE (Name);

-- Task 5 --
-- Insert 3 new rows into the Products table using INSERT statements.--
select * from amazon.products;
insert into amazon.products(ProductID,ProductName,Category,SubCategory,PricePerUnit,StockQuantity,SupplierID) values
("0000003b-4abc-def5-6ghi-jklmno98765","World Fruit","Fruits","Sub-Fruits-4",304,295,"987654a-3abc-2efg-1asf-000000hijkl"),
("1111114c-5cde-efg6-7hij-klmnop98765","We Baker","Bakery","Sub-Bakery-3",436,147,"456789z-2def-1wer-6qwe-111111lkjhg"),
("2222225e-6asd-7jkl-8uytr-mnbvcx98765","Early Snack","Snacks","Sub-Snacks-",987,277,"5678234-4rty-5kjh-8uiop-2222222mnbv");

-- Task 6 --
-- Update the stock quantity of a product where ProductID matches a specific ID.--
set sql_safe_updates=0;
update amazon.products set StockQuantity = 200 where ProductID ="abcd";

-- Task 7 --
-- Delete a supplier from the Suppliers table where their city matches a specific value.--
set sql_safe_updates=0;
delete from amazon.suppliers where city like "Whitefurt";

-- Task 8 --
-- Add a CHECK constraint to ensure that ratings in the Reviews table are between 1 and 5.--
alter table amazon.reviews add constraint check_ranking check (rating between 1 and 5);
-- Add a DEFAULT constraint for the PrimeMember column in the Customers table (default value: "No").--
alter table amazon.customers 
alter column PrimeMember set default 'No';

-- Task 9 --
-- WHERE clause to find orders placed after 2024-01-01.--
select OrderID, OrderDate from amazon.orders where OrderDate > "2024-01-01";
-- HAVING clause to list products with average ratings greater than 4.--
select ProductID, avg (Rating) as avg_rating from amazon.reviews group by ProductID having avg_rating >4;
-- GROUP BY and ORDER BY clauses to rank products by total sales.--
select ProductID,sum(Quantity * UnitPrice - Discount) as Total_sales from amazon.order_details
group by ProductID order by Total_sales desc;

-- Task 10 --
-- 1. Calculate each customer's total spending.--
select CustomerId,sum(OrderAmount+DeliveryFee-DiscountApplied) as Total_spending from amazon.orders
group by CustomerID;
-- 2. Rank customers based on their spending.--
SELECT CustomerID, SUM(OrderAmount + DeliveryFee - DiscountApplied) AS Total_spending, RANK() 
OVER(ORDER BY SUM(OrderAmount + DeliveryFee - DiscountApplied) DESC) AS Spending_rank FROM orders
GROUP BY CustomerID;
-- 3. Identify customers who have spent more than ₹5,000.--
SELECT CustomerID, SUM(OrderAmount + DeliveryFee - DiscountApplied) AS Total_spending FROM orders
GROUP BY CustomerID
HAVING Total_spending > 5000;

-- Task 11 --
-- Join the Orders and OrderDetails tables to calculate total revenue per order.--
SELECT o.OrderID, SUM(od.Quantity * od.UnitPrice) AS Total_revenue FROM orders AS o
JOIN order_details AS od
ON o.OrderID = od.OrderID
GROUP BY o.OrderID
ORDER BY Total_revenue desc ;
-- Identify customers who placed the most orders in a specific time period.--
SELECT c.Name,c.City,COUNT(o.OrderID) AS OrderCount, SUM(o.OrderAmount) AS TotalSpent
FROM Customers AS c
JOIN Orders AS o ON c.CustomerID = o.CustomerID
WHERE EXTRACT(YEAR FROM o.OrderDate) = 2025
GROUP BY c.CustomerID, c.Name, c.City
ORDER BY OrderCount DESC
LIMIT 10;
-- Find the supplier with the most products in stock.--
SELECT SupplierID,SUM(StockQuantity) AS TotalStock FROM amazon.products
GROUP BY SupplierID
ORDER BY TotalStock DESC LIMIT 5;

-- Task 12 --
-- Separate product categories and subcategories into a new table.--
create table amazon.categories(ProductID varchar(50),Category text,PricePerUnit int,StockQuantity int,Supplier_Id Varchar(50));
INSERT INTO amazon.categories(ProductID,Category,PricePerUnit,StockQuantity,Supplier_Id )VALUES 
("2aa28375-c563-41b5-aa33-8e2c2e0f4db9","Fruits","207","290","0658c953-98c4-4d00-bf29-4fbfe4aca4cd"),
("e9282403-e234-4e35-a711-50acb03bbecc"	,"Snacks","905","259","cb890936-8142-4fa3-ac60-2ecba78f8aa8"),
("d79d1b95-ecdf-4810-aea0-45e9bd10627d","Fruits","111","26","455b7097-b656-49b8-9cf2-a98d71d3ba88"),
("05765892-c750-44cc-96e2-31fa53d42cb2","Vegetables","887","296","a2ed0ef5-a6c8-4b51-ac6f-6209edf45a02"),
("3bfb746e-f1e6-4946-a314-7d9119fd950d","Bakery","961","127","16c44a77-d01f-4154-a7b7-1f5b5dee4255"),
("11dc08ec-ef6f-43d0-abaa-414a9c336956","Vegetables","50","19","92bedb68-2b59-4cb3-9520-fec1256dfa04"),
("e5bdb329-60d3-4673-8782-1ab101f98187","Dairy","604","126","20e7f27c-8f08-46b3-950f-2c0bbf56722d"),
("9747fd32-5076-46c3-90b4-5f404b86b219","Fruits","6","306","eafcc3e7-83b3-4392-b278-1cc6efc9a2a2"),
("9d82e469-12e6-4fd6-9a41-837ac63c1d2b","Dairy","131","322","1d344858-3396-49cf-be1a-6fe391841b4b"),
("e4c3f640-fa46-4510-8f45-32df79fcaec4","Meat","169","451","1acc6cf8-0309-4b0c-88d2-8d58807168eb"),
("b8a16df8-38c0-462d-888d-9c5e42704267","Vegetables","766","265","36f49379-ba01-499f-be3c-ddfd8a6eda41"),
("37cc1e52-274c-4fd2-bc0e-d0506c57973b","Meat","302","326","561d6fbf-83fd-40b1-8310-4e546ae02e94");

-- Task 13 --
-- Identify the top 3 products based on sales revenue.--
SELECT p.ProductID,p.ProductName,o.total_revenue AS Total_Revenue FROM amazon.products p
JOIN(SELECT ProductID,SUM(Quantity * UnitPrice - Discount) AS total_revenue FROM amazon.order_details GROUP BY ProductID) AS o
ON p.ProductID = o.ProductID
ORDER BY o.total_revenue DESC
LIMIT 3;
-- Find customers who haven’t placed any orders yet.--
select customerID,Name,City,State,country from amazon.customers
where CustomerID not in (select customerid from amazon.orders);

-- Task 14 --
-- Which cities have the highest concentration of Prime members?--
select Name,City,PrimeMember from amazon.customers
where PrimeMember like "yes";
-- What are the top 3 most frequently ordered categories?--
select P.Category,sum(o.quantity) as Orders_placed from amazon.products p 
join amazon.order_details o 
on o.ProductID=p.ProductID
group by p.Category
order by Orders_placed desc limit 3;
