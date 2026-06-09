-- Zepto_SQL_project

-- DATA EXPLORING
-- select all data from zepto_v2 table
SELECT *
FROM zepto_v2;

-- count rows
SELECT COUNT(*)
FROM zepto_v2;

-- sample data
SELECT * 
FROM zepto_v2
LIMIT 10;

-- null values
SELECT *
FROM zepto_v2
WHERE category IS NULL
OR name IS NULL
OR mrp IS NULL
OR discountPercent IS NULL
OR availableQuantity IS NULL
OR discountedSellingPrice IS NULL
OR weightInGms IS NULL
OR outOfStock IS NULL
OR quantity IS NULL;

-- different product categories and count them
SELECT DISTINCT category, COUNT(category)
FROM zepto_v2
GROUP BY category
ORDER BY category;

-- products in stock vs out of stock
SELECT outOfStock, COUNT(*)
FROM zepto_v2
GROUP BY outOfStock;

-- product names present multiple times
SELECT name, COUNT(name)
FROM zepto_v2
GROUP BY name
HAVING COUNT(name) > 1
ORDER BY COUNT(name);


-- DATA CLEANING
-- products with price = 0
SELECT *
FROM zepto_v2
WHERE mrp = 0 OR discountedSellingPrice = 0;

DELETE FROM zepto_v2
WHERE mrp = 0;

--  convert paise to rupees
UPDATE zepto_v2
SET mrp = mrp/100,
discountedSellingPrice = discountedSellingPrice/100;

SELECT * 
FROM zepto_v2;


-- BUSINESS INSIGHT QUERIES
-- Q1. Find the top best-value products based on the discount percentage.
SELECT DISTINCT name, discountPercent
FROM zepto_v2
ORDER BY discountPercent DESC
LIMIT 10;

-- Q2. What are the products with high mrp but Out of stock
SELECT name, mrp
FROM zepto_v2
WHERE outOfStock = TRUE 
ORDER BY mrp DESC;

-- Q3. Calculate estimated revenue for each category
SELECT Category, SUM(discountedSellingPrice * availableQuantity) AS total_revenue
FROM zepto_v2
GROUP BY Category;

-- Q4. Find all products where mrp is greater than 500 and discount is less than 10%
SELECT DISTINCT name, mrp, discountPercent
FROM zepto_v2
WHERE mrp > 500 AND discountPercent < 10;

-- Q5. Identify the top 5 categories offering the highest average discount percentage
SELECT DISTINCT category, AVG(discountPercent) as avg_discount
FROM zepto_v2
GROUP BY category
ORDER BY avg(discountPercent) DESC
LIMIT 5;

-- Q6. Find the price per gram for products above 100g and sort by best value
SELECT DISTINCT name, weightInGms, discountedSellingPrice, discountedSellingPrice/weightInGms AS price_per_gm
FROM zepto_v2
WHERE weightInGms > 100
ORDER BY price_per_gm;

-- Q7. Group the products into categories like low, Medium, Bulk
SELECT DISTINCT name, weightInGms,
CASE WHEN weightInGms < 1000 THEN 'LOW'
	WHEN weightInGms <5000 THEN 'MEDIUM'
    ELSE 'BULK'
END AS weight_category
FROM zepto_v2;

-- Q8. What is the total Inventory weight per category
SELECT category, SUM(weightInGms * availableQuantity) AS total_weight
FROM zepto_v2
GROUP BY category;