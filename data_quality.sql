#Data quality audit file
# Using Olist data set
# Row counts per table
# Use Count (*) command to count all rows in the result set
WITH row_counts AS (
  SELECT 'category_translation', COUNT(*) FROM category_translation
    UNION ALL
    SELECT 'customers', COUNT(*) FROM customers
    UNION ALL
    SELECT 'geolocation', COUNT(*) FROM geolocation
    UNION ALL
    SELECT 'order_items', COUNT(*) FROM order_items
    UNION ALL
    SELECT 'order_payments', COUNT(*) FROM order_payments
    UNION ALL
    SELECT 'order_reviews', COUNT(*) FROM order_reviews
    UNION ALL
    SELECT 'orders' AS table_name, COUNT(*) AS row_count FROM orders
    UNION ALL
    SELECT 'products', COUNT(*) FROM products
    UNION ALL
    SELECT 'sellers', COUNT(*) FROM sellers
    )
SELECT * FROM row_counts;
# NULL rates for key columnns

-- NULL rate analysis
null_rates AS (
    SELECT 
        COUNT(*) AS total_orders,
        COUNT(*) FILTER (WHERE customer_id IS NULL) * 1.0 / COUNT(*) AS pct_null_customer_id,
        COUNT(*) FILTER (WHERE order_purchase_timestamp IS NULL) * 1.0 / COUNT(*) AS pct_null_purchase_time,
        COUNT(*) FILTER (WHERE order_delivered_customer_date IS NULL) * 1.0 / COUNT(*) AS pct_null_delivery_date
    FROM orders
),

-- Orphaned foreign keys (orders to customers)
orphan_orders AS (
    SELECT COUNT(*) AS orphan_order_count
    FROM orders o
    LEFT JOIN customers c 
        ON o.customer_id = c.customer_id
    WHERE c.customer_id IS NULL
),
-- Orphaned order_items -> orders
orphan_order_items AS (
    SELECT COUNT(*) AS orphan_item_count
    FROM order_items oi
    LEFT JOIN orders o 
        ON oi.order_id = o.order_id
    WHERE o.order_id IS NULL
  -- Confirming orders are unique
duplicate_orders AS (
    SELECT order_id, COUNT(*) AS occurrences
    FROM orders
    GROUP BY order_id
    HAVING COUNT(*) > 1
),
-- Date coverage
date_coverage AS (
    SELECT 
        MIN(order_purchase_timestamp) AS min_purchase_date,
        MAX(order_purchase_timestamp) AS max_purchase_date,
        MIN(order_delivered_customer_date) AS min_delivery_date,
        MAX(order_delivered_customer_date) AS max_delivery_date
    FROM orders
)
--OUTPUT

SELECT * FROM row_counts;

SELECT * FROM null_rates;

SELECT * FROM orphan_orders;

SELECT * FROM orphan_order_items;

SELECT * FROM duplicate_orders;

SELECT * FROM date_coverage;
