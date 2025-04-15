use balanced_tree;
  
  --  SCHEMA EXPLORATION QUERIES

--  List all tables in the schema
SELECT table_name
FROM information_schema.tables
WHERE table_schema = 'balanced_tree';

-- Describe the structure of the product_prices table
SELECT column_name, data_type
FROM information_schema.columns
WHERE table_name = 'product_prices';

--  Describe the structure of the product_details table
SELECT column_name, data_type
FROM information_schema.columns
WHERE table_name = 'product_details';

--  View sample data from product_hierarchy
SELECT *
FROM balanced_tree.product_hierarchy
LIMIT 10;

--  View sample data from product_prices
SELECT *
FROM balanced_tree.product_prices
LIMIT 10;

--  View sample data from product_details
SELECT *
FROM balanced_tree.product_details
LIMIT 10;
  -- WHAT WAS THE TOTAL QUANTITY SOLD FOR ALL PRODUCTS?
  SELECT COUNT(QTY) FROM BALANCED_TREE.SALES GROUP BY PROD_ID;
  
  -- HOW MANY UNIQUE TRANSACTIONS WERE THERE?
  SELECT DISTINCT(TXN_ID) FROM BALANCED_TREE.SALES;
  
  -- WHAT IS THE AVERAGE UNIQUE PRODUCTS PURCHASED IN EACH TRANSACTION?
  SELECT AVG(DISTINCT(PROD_ID)) FROM BALANCED_TREE.SALES GROUP BY TXN_ID ;
  
  -- HOW MANY MEMEBERS ARE THERE FOR PRODUCTS?
  SELECT COUNT(MEMBER) FROM BALANCED_TREE.SALES GROUP BY TXN_ID HAVING MEMBER= "T";
  
-- HOW MANY TRANSACTION ARE THERE BY NON-MEMBERS?
SELECT COUNT(TXN_ID) FROM BALANCED_TREE.SALES GROUP BY MEMBER HAVING MEMBER = "F";

-- WHAT ARE THE TOP 3 PRODUCTS BY PRICE?
SELECT PROD_ID , PRICE FROM BALANCED_TREE.SALES ORDER BY PRICE DESC LIMIT 3;

-- WHAT ARE THE TOP 3 PRODUCTS BY DISCOUNT?
SELECT PROD_ID , DISCOUNT FROM BALANCED_TREE.SALES ORDER BY DISCOUNT DESC LIMIT 3;

-- FIND TOTAL REVENUE GENERATED BEFORE DISCOUNT ?
SELECT SUM(PRICE*QTY) AS REVENUE FROM BALANCED_TREE.SALES;

-- FIND TOTAL AMOUNT OF DISCOUNT OFFERED FOR ALL PRODUCTS?
SELECT SUM((DISCOUNT/100)*QTY*PRICE) AS TOTAL_DISCOUNT FROM BALANCED_TREE.SALES;

-- FIND TOTAL REVENUE EARNED AFTER DISCOUNT?
SELECT  SUM(PRICE*QTY)- SUM((DISCOUNT/100)*QTY*PRICE) AS TOTAL_REVENUE FROM BALANCED_TREE.SALES;

-- FIND TOTAL REVENUE GENERATED FROM EACH CATEGORY?
SELECT TOTAL REVENUE FROM BALANCED_TREE.SALES GROUP BY CATEGORY_ID,SEGMENT_ID,STYLE_ID;

-- CREATE A VIEW SHOWING DISCOUNT AMOUNT OF EACH PRODUCT WITH PRODUCT_ID.
CREATE VIEW DISCOUNT_VALUES AS
SELECT PROD_ID, (DISCOUNT/100)*PRICE*QTY AS AMT_DISCOUNT FROM BALANCED_TREE.SALES;

-- find prod_id with maximum and minimum discount values.
select produ_id, amt_discount as max_disc from discount_values where amt_discount = (select max(amt_diacount) from discount_values);

select produ_id, amt_discount as min_disc from discount_values where amt_discount = (select min(amt_diacount) from discount_values);

-- CREATE A VIEW SHOWING DREVENUE EARNED FROM EACH PRODUCT WITH PRODUCT_ID.
CREATE VIEW REVENUE AS
SELECT PROD_ID,(PRICE*QTY) AS REV_ENUE FROM BALANCED_TREE.SALES;

  -- find prod_id with maximum and minimum revenue generated.
select produ_id, rev_enue as max_rev from discount_values GROUP BY PRODU_ID HAVING rev_enue = (select max(rev_enue) from revenue);

select produ_id, rev_enue as min_rev from discount_values GROUP BY PRODU_ID HAVING rev_enue = (select min(rev_enue) from revenue);

-- create a view showing month,day,hrs of each transaction .

create view TIME as
SELECT  MONTH(TXN_ID) AS MONTH ,HOUR(TXN_ID) AS HOUR, DAY(TXN_ID),PROD_ID,QTY,PRICE AS DAY FROM DETAILS;

-- find the month in which the revenue earned is maximum.
SELECT MONTH FROM TIME WHERE QTY = (SELECT MAX(QTY) FROM TIME) AND PRICE =(SELECT MAX(PRICE) FROM TIME) ;

-- find the DAY in which the revenue earned is maximum.
SELECT DAY FROM TIME WHERE QTY = (SELECT MAX(QTY) FROM TIME);

-- find the HOUR in which the revenue earned is maximum.
SELECT HOUR FROM TIME WHERE QTY = (SELECT MAX(QTY) FROM TIME);

-- FIND THE BEST SELLING PRODUCT.
SELECT PRODUCT_ID ,QTY, PRICE FROM BALANCED_TREE.SALES WHERE QTY = (SELECT MAX(QTY) FROM TIME) AND PRICE =(SELECT MAX(PRICE) FROM TIME) ;

-- Total transactions per year
SELECT
    calendar_year,
    SUM(transactions) AS total_transactions
FROM data_mart.clean_weekly_sales
GROUP BY calendar_year
ORDER BY calendar_year;

--  Total sales by region and month
SELECT
    region,
    month_number,
    SUM(sales) AS total_sales
FROM data_mart.clean_weekly_sales
GROUP BY region, month_number
ORDER BY region, month_number;

--  Total count of transactions per platform
SELECT
    platform,
    SUM(transactions) AS total_transactions
FROM data_mart.clean_weekly_sales
GROUP BY platform;

--  DATA INTEGRATION QUERIES

--  Join product_hierarchy and product_details to get detailed product information
SELECT
    ph.id,
    ph.level_text AS category_or_segment,
    pd.product_name,
    pd.price
FROM balanced_tree.product_hierarchy ph
JOIN balanced_tree.product_details pd ON ph.id = pd.category_id
LIMIT 10;

--  Join all tables to get complete product data with prices and hierarchy
SELECT
    ph.level_text AS category_or_segment,
    ph.level_name,
    pd.product_name,
    pp.price
FROM balanced_tree.product_hierarchy ph
JOIN balanced_tree.product_details pd ON ph.id = pd.category_id
JOIN balanced_tree.product_prices pp ON pd.product_id = pp.product_id;

--  Count the number of products in each category
SELECT
    ph.level_text AS category,
    COUNT(pd.product_id) AS product_count
FROM balanced_tree.product_hierarchy ph
JOIN balanced_tree.product_details pd ON ph.id = pd.category_id
GROUP BY ph.level_text;

--  Average price per category
SELECT
    ph.level_text AS category,
    ROUND(AVG(pd.price), 2) AS avg_price
FROM balanced_tree.product_hierarchy ph
JOIN balanced_tree.product_details pd ON ph.id = pd.category_id
GROUP BY ph.level_text;

--  Find the most expensive product in each category
SELECT
    ph.level_text AS category,
    pd.product_name,
    pd.price
FROM balanced_tree.product_hierarchy ph
JOIN balanced_tree.product_details pd ON ph.id = pd.category_id
WHERE pd.price = (
    SELECT MAX(price)
    FROM balanced_tree.product_details
    WHERE category_id = ph.id
);

--  Total number of products per segment
SELECT
    ph.level_text AS segment,
    COUNT(pd.product_id) AS product_count
FROM balanced_tree.product_hierarchy ph
JOIN balanced_tree.product_details pd ON ph.id = pd.segment_id
GROUP BY ph.level_text;

-- List all products and their corresponding categories and segments
SELECT
    pd.product_name,
    ph1.level_text AS category,
    ph2.level_text AS segment
FROM balanced_tree.product_details pd
JOIN balanced_tree.product_hierarchy ph1 ON pd.category_id = ph1.id
JOIN balanced_tree.product_hierarchy ph2 ON pd.segment_id = ph2.id;