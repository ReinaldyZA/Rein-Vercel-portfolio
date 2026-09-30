-- no1
SELECT
  c.categoryname,
  ROUND(SUM(s.quantity * p.price * (1 - s.discount)), 2) AS revenue_after_discount
FROM fsda-sql-01.grocery_dataset.sales s
JOIN fsda-sql-01.grocery_dataset.products p ON s.productid = p.productid
JOIN fsda-sql-01.grocery_dataset.categories c ON p.categoryid = c.categoryid
GROUP BY c.categoryname
ORDER BY revenue_after_discount DESC;

-- no2
SELECT
  c.categoryname,
  SUM(s.quantity) AS total_units_sold,
  ROUND(SUM(s.quantity * p.price * (1 - s.discount)), 2) AS revenue_after_discount
FROM fsda-sql-01.grocery_dataset.sales s
JOIN fsda-sql-01.grocery_dataset.products p ON s.productid = p.productid
JOIN fsda-sql-01.grocery_dataset.categories c ON p.categoryid = c.categoryid
GROUP BY c.categoryname
ORDER BY revenue_after_discount DESC;

-- no3
SELECT
  c.categoryname,
  COUNT(DISTINCT s.customerid) AS unique_customers,
  ROUND(SUM(s.quantity * p.price * (1 - s.discount)), 2) AS revenue_after_discount
FROM fsda-sql-01.grocery_dataset.sales s
JOIN fsda-sql-01.grocery_dataset.products p ON s.productid = p.productid
JOIN fsda-sql-01.grocery_dataset.categories c ON p.categoryid = c.categoryid
GROUP BY c.categoryname
ORDER BY revenue_after_discount DESC;

-- no4
SELECT
  c.categoryname,
  ROUND(AVG(p.price), 2) AS avg_price_per_unit
FROM fsda-sql-01.grocery_dataset.products p
JOIN fsda-sql-01.grocery_dataset.categories c ON p.categoryid = c.categoryid
GROUP BY c.categoryname
ORDER BY avg_price_per_unit DESC;

-- no5
WITH price_per_category AS (
  SELECT p.categoryid, c.categoryname,
    ROUND(AVG(p.price), 2) AS avg_price_per_unit
  FROM fsda-sql-01.grocery_dataset.products p
  JOIN fsda-sql-01.grocery_dataset.categories c ON p.categoryid = c.categoryid
  GROUP BY p.categoryid, c.categoryname
),
buyers_per_category AS (
  SELECT p.categoryid,
    COUNT(DISTINCT s.customerid) AS unique_buyers
  FROM fsda-sql-01.grocery_dataset.sales s
  JOIN fsda-sql-01.grocery_dataset.products p ON s.productid = p.productid
  GROUP BY p.categoryid
)
SELECT pc.categoryname, pc.avg_price_per_unit, bc.unique_buyers
FROM price_per_category pc
JOIN buyers_per_category bc ON pc.categoryid = bc.categoryid
ORDER BY pc.avg_price_per_unit DESC;

-- no6
WITH category_revenue AS (
  SELECT c.categoryname,
    SUM(s.quantity * p.price * (1 - s.discount)) AS revenue_after_discount
  FROM fsda-sql-01.grocery_dataset.sales s
  JOIN fsda-sql-01.grocery_dataset.products p ON s.productid = p.productid
  JOIN fsda-sql-01.grocery_dataset.categories c ON p.categoryid = c.categoryid
  GROUP BY c.categoryname
)
SELECT
  categoryname,
  ROUND(revenue_after_discount, 2) AS revenue_after_discount,
  ROUND(revenue_after_discount * 100.0 / SUM(revenue_after_discount) OVER (), 2) AS revenue_contribution_pct
FROM category_revenue
ORDER BY revenue_contribution_pct DESC;

-- no7
WITH customer_category_orders AS (
  SELECT c.categoryname, s.customerid,
    COUNT(DISTINCT s.transactionnumber) AS purchase_count
  FROM fsda-sql-01.grocery_dataset.sales s
  JOIN fsda-sql-01.grocery_dataset.products p ON s.productid = p.productid
  JOIN fsda-sql-01.grocery_dataset.categories c ON p.categoryid = c.categoryid
  GROUP BY c.categoryname, s.customerid
)
SELECT
  categoryname,
  COUNT(DISTINCT customerid) AS total_customers,
  COUNT(DISTINCT CASE WHEN purchase_count > 1 THEN customerid END) AS repeat_customers,
  ROUND(
    COUNT(DISTINCT CASE WHEN purchase_count > 1 THEN customerid END) * 100.0
    / COUNT(DISTINCT customerid), 2
  ) AS repeat_purchase_rate_pct
FROM customer_category_orders
GROUP BY categoryname
ORDER BY repeat_purchase_rate_pct DESC;

-- no8
WITH category_metrics AS (
  SELECT c.categoryname,
    SUM(s.quantity) AS total_units_sold,
    COUNT(DISTINCT s.customerid) AS unique_customers,
    SUM(s.quantity * p.price * (1 - s.discount)) AS revenue_after_discount
  FROM fsda-sql-01.grocery_dataset.sales s
  JOIN fsda-sql-01.grocery_dataset.products p ON s.productid = p.productid
  JOIN fsda-sql-01.grocery_dataset.categories c ON p.categoryid = c.categoryid
  GROUP BY c.categoryname
)
SELECT
  categoryname,
  total_units_sold,
  unique_customers,
  ROUND(revenue_after_discount, 2) AS revenue_after_discount,
  ROUND(revenue_after_discount * 100.0 / SUM(revenue_after_discount) OVER (), 2) AS revenue_contribution_pct
FROM category_metrics
ORDER BY revenue_after_discount DESC;

-- no9
WITH user_transactions AS (
  SELECT s.customerid, s.salesdate, s.transactionnumber,
    SUM(s.quantity * p.price * (1 - s.discount)) AS transaction_value
  FROM fsda-sql-01.grocery_dataset.sales s
  JOIN fsda-sql-01.grocery_dataset.products p ON s.productid = p.productid
  GROUP BY s.customerid, s.salesdate, s.transactionnumber
),
top_user AS (
  SELECT customerid
  FROM user_transactions
  GROUP BY customerid
  ORDER BY SUM(transaction_value) DESC
  LIMIT 1
)
SELECT
  ut.customerid,
  ut.salesdate,
  ut.transactionnumber,
  ROUND(ut.transaction_value, 2) AS transaction_value,
  ROUND(
    SUM(ut.transaction_value) OVER (
      PARTITION BY ut.customerid
      ORDER BY ut.salesdate, ut.transactionnumber
      ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ), 2
  ) AS cumulative_transaction
FROM user_transactions ut
JOIN top_user tu ON ut.customerid = tu.customerid
ORDER BY ut.salesdate, ut.transactionnumber;
