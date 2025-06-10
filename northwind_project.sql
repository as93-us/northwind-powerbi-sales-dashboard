--Lista wszytskich tabel w schemacie public 
SELECT table_name
FROM information_schema.tables
WHERE table_schema = 'public';

SELECT * FROM products LIMIT 5;

--Lista dostępnych produktów 
SELECT product_name, unit_price
FROM products
WHERE discontinued = 0
ORDER BY unit_price DESC;

--Produkty, których jest mało na stanie
SELECT product_name, units_in_stock
FROM products
WHERE units_in_stock < 10
ORDER BY 2 DESC; 

--Najdroższe produkty
SELECT product_name, unit_price
FROM products
ORDER BY 2 DESC
LIMIT 5;

SELECT *
FROM order_details od
JOIN products p 
ON od.product_id = p.product_id
JOIN orders o 
ON od.order_id = o.order_id
LIMIT 10;

--Top 10 produktów
SELECT p.product_name, SUM(od.quantity) AS total_quantity
FROM order_details od
INNER JOIN products p
ON od.product_id = p.product_id
GROUP BY p.product_name
ORDER BY total_quantity DESC
LIMIT 10;

--Produkty, które wygenerowały najwyższy przychód 
SELECT 
    p.product_name,
    ROUND(CAST(SUM(od.quantity * od.unit_price) AS numeric), 2) AS total_revenue
FROM order_details od
JOIN products p ON od.product_id = p.product_id
GROUP BY p.product_name
ORDER BY total_revenue DESC
LIMIT 10;

--Sprzedaż miesięczna (ilość sztuk)
SELECT 
    DATE_TRUNC('month', o.order_date) AS sale_month,
    SUM(od.quantity) AS total_units_sold
FROM order_details od
JOIN orders o ON od.order_id = o.order_id
GROUP BY sale_month
ORDER BY sale_month;

--Total Revenue 
SELECT 
    DATE_TRUNC('month', o.order_date) AS sale_month,
    SUM(od.quantity * od.unit_price) AS monthly_revenue
FROM order_details od
JOIN orders o ON od.order_id = o.order_id
GROUP BY sale_month
ORDER BY sale_month;

--Sprzedaż według krajów klientów 
SELECT 
    c.country,
    SUM(od.quantity * od.unit_price) AS total_revenue
FROM order_details od
JOIN orders o ON od.order_id = o.order_id
JOIN customers c ON o.customer_id = c.customer_id
GROUP BY c.country
ORDER BY total_revenue DESC;

--KPI summary
SELECT 
    SUM(od.quantity * od.unit_price) AS total_revenue,
    SUM(od.quantity) AS total_units_sold,
    COUNT(DISTINCT o.customer_id) AS unique_customers,
    COUNT(DISTINCT o.ship_country) AS countries_shipped
FROM order_details od
JOIN orders o ON od.order_id = o.order_id;

--Najlepsze miesiące sprzedażowe
SELECT 
    TO_CHAR(o.order_date, 'FMMonth YYYY') AS sale_month,  -- np. "April 1998"
    DATE_TRUNC('month', o.order_date) AS sale_month_key,  -- do sortowania
    SUM(od.quantity * od.unit_price) AS total_revenue
FROM order_details od
JOIN orders o ON od.order_id = o.order_id
GROUP BY sale_month, sale_month_key
ORDER BY sale_month_key;

--Top 5 kategorii
SELECT 
    c.category_name,
    SUM(od.quantity * od.unit_price) AS revenue
FROM order_details od
JOIN products p ON od.product_id = p.product_id
JOIN categories c ON p.category_id = c.category_id
GROUP BY c.category_name
ORDER BY revenue DESC
LIMIT 5;

SELECT p.product_name, SUM(od.quantity) AS total_quantity
FROM order_details od
INNER JOIN products p
ON od.product_id = p.product_id
GROUP BY p.product_name
ORDER BY total_quantity DESC
LIMIT 10;