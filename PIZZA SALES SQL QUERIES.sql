-- 🍕 Pizza Sales Analysis Queries --

-- 1) Total Revenue Generated
SELECT ROUND(SUM(od.quantity * p.price), 2) AS total_revenue
FROM order_details od
JOIN pizzas p ON od.pizza_id = p.pizza_id;

-- 2) Total Pizzas Sold
SELECT SUM(quantity) AS total_pizzas_sold
FROM order_details;

-- 3) Average Pizzas per Order
SELECT ROUND(SUM(od.quantity) / COUNT(DISTINCT o.order_id), 2) AS avg_pizzas_per_order
FROM order_details od
JOIN orders o ON od.order_id = o.order_id;

-- 4) Average Revenue per Pizza
SELECT ROUND(SUM(od.quantity * p.price) / SUM(od.quantity), 2) AS avg_revenue_per_pizza
FROM order_details od
JOIN pizzas p ON od.pizza_id = p.pizza_id;

-- 5) Top 5 Best-Selling Pizzas (By Quantity)
SELECT pt.name, SUM(od.quantity) AS total_quantity_sold
FROM order_details od
JOIN pizzas p ON od.pizza_id = p.pizza_id
JOIN pizza_types pt ON p.pizza_type_id = pt.pizza_type_id
GROUP BY pt.name
ORDER BY total_quantity_sold DESC
LIMIT 5;

-- 6) Top 5 Pizzas by Revenue
SELECT pt.name, ROUND(SUM(od.quantity * p.price), 2) AS revenue
FROM order_details od
JOIN pizzas p ON od.pizza_id = p.pizza_id
JOIN pizza_types pt ON p.pizza_type_id = pt.pizza_type_id
GROUP BY pt.name
ORDER BY revenue DESC
LIMIT 5;

-- 7) Revenue by Pizza Category
SELECT pt.category, ROUND(SUM(od.quantity * p.price), 2) AS category_revenue
FROM order_details od
JOIN pizzas p ON od.pizza_id = p.pizza_id
JOIN pizza_types pt ON p.pizza_type_id = pt.pizza_type_id
GROUP BY pt.category
ORDER BY category_revenue DESC;

-- 8) Monthly Revenue Trend
SELECT DATE_FORMAT(o.date, '%Y-%m') AS month, ROUND(SUM(od.quantity * p.price), 2) AS revenue
FROM orders o
JOIN order_details od ON o.order_id = od.order_id
JOIN pizzas p ON od.pizza_id = p.pizza_id
GROUP BY month
ORDER BY month;


-- B. Daily Trend for Total Orders
SELECT order_day, COUNT(*) AS total_orders
FROM (
    SELECT DAYNAME(date) AS order_day
    FROM orders
) AS daily_orders
GROUP BY order_day
ORDER BY FIELD(order_day, 'Monday','Tuesday','Wednesday','Thursday','Friday','Saturday','Sunday');

-- C. Hourly Trend for Orders
SELECT order_hour, COUNT(*) AS total_orders
FROM (
    SELECT HOUR(time) AS order_hour
    FROM orders
) AS hourly_orders
GROUP BY order_hour
ORDER BY order_hour;

-- D. % of Sales by Pizza Category
SELECT pt.category,
       ROUND(SUM(od.quantity * p.price), 2) AS category_revenue,
       ROUND(SUM(od.quantity * p.price) * 100 / (
           SELECT SUM(od2.quantity * p2.price)
           FROM order_details od2
           JOIN pizzas p2 ON od2.pizza_id = p2.pizza_id
       ), 2) AS percentage_of_total_sales
FROM order_details od
JOIN pizzas p ON od.pizza_id = p.pizza_id
JOIN pizza_types pt ON p.pizza_type_id = pt.pizza_type_id
GROUP BY pt.category
ORDER BY percentage_of_total_sales DESC;

-- E. % of Sales by Pizza Size
SELECT p.size,
       ROUND(SUM(od.quantity * p.price), 2) AS size_revenue,
       ROUND(SUM(od.quantity * p.price) * 100 / (
           SELECT SUM(od2.quantity * p2.price)
           FROM order_details od2
           JOIN pizzas p2 ON od2.pizza_id = p2.pizza_id
       ), 2) AS percentage_of_total_sales
FROM order_details od
JOIN pizzas p ON od.pizza_id = p.pizza_id
GROUP BY p.size
ORDER BY percentage_of_total_sales DESC;

-- F. Total Pizzas Sold by Pizza Category
SELECT pt.category,
       SUM(od.quantity) AS total_pizzas_sold
FROM order_details od
JOIN pizzas p ON od.pizza_id = p.pizza_id
JOIN pizza_types pt ON p.pizza_type_id = pt.pizza_type_id
GROUP BY pt.category
ORDER BY total_pizzas_sold DESC;

-- G. Top 5 Best Sellers by Total Pizzas Sold
SELECT pt.name AS pizza_name,
       SUM(od.quantity) AS total_pizzas_sold
FROM order_details od
JOIN pizzas p ON od.pizza_id = p.pizza_id
JOIN pizza_types pt ON p.pizza_type_id = pt.pizza_type_id
GROUP BY pt.name
ORDER BY total_pizzas_sold DESC
LIMIT 5;

-- H. Bottom 5 Best Sellers by Total Pizzas Sold
SELECT pt.name AS pizza_name,
       SUM(od.quantity) AS total_pizzas_sold
FROM order_details od
JOIN pizzas p ON od.pizza_id = p.pizza_id
JOIN pizza_types pt ON p.pizza_type_id = pt.pizza_type_id
GROUP BY pt.name
ORDER BY total_pizzas_sold ASC
LIMIT 5;
