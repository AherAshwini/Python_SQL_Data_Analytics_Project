#1. Find top 10 highest revenue generating products
SELECT product_id, SUM(sale_price) AS revenue
FROM df_orders 
GROUP BY product_id
ORDER BY revenue desc
LIMIT 10

#2. Find top 5 highest selling products in each region.
WITH region_cte AS (
SELECT region, product_id, SUM(sale_price) AS total_sale,
ROW_NUMBER() OVER (PARTITION BY region ORDER BY SUM(sale_price) DESC) AS product_row_number
FROM df_orders
GROUP BY region, product_id)

SELECT region, product_id, total_sale, product_row_number
FROM region_cte
WHERE product_row_number <= 5

#3. Find month over month growth comparison for 2022 and 2023 sales eg: Jan 2022 and Jan 2023.
WITH cte_2022 AS(
SELECT EXTRACT(year from order_date) as year_22, EXTRACT(MONTH FROM order_date) as month_22, SUM(sale_price) AS total_sale_22
FROM df_orders
WHERE EXTRACT(YEAR from order_date) = 2022
GROUP BY EXTRACT(YEAR FROM order_date), EXTRACT(MONTH FROM order_date)
),
cte_2023 AS(
SELECT EXTRACT(year from order_date) as year_23, EXTRACT(MONTH FROM order_date) as month_23, SUM(sale_price) AS total_sale_23
FROM df_orders
WHERE EXTRACT(YEAR from order_date) = 2023
GROUP BY EXTRACT(YEAR FROM order_date), EXTRACT(MONTH FROM order_date)
)
SELECT c23.month_23 AS order_month, c22.total_sale_22, c23.total_sale_23
FROM cte_2022 AS c22
JOIN cte_2023 AS c23
ON c22.month_22 = c23.month_23

#4. For each category which month had highest sales.
WITH category_cte AS(
SELECT EXTRACT(MONTH FROM order_date) AS order_month, EXTRACT(YEAR from order_date) as order_year, category, SUM(sale_price) as total_sale,
ROW_NUMBER() OVER (PARTITION BY category ORDER BY SUM(sale_price) DESC) as category_rn
FROM df_orders
GROUP BY category, EXTRACT(MONTH FROM order_date), EXTRACT(YEAR from order_date))

SELECT category, order_month, order_year, total_sale
FROM category_cte
WHERE category_rn = 1





















