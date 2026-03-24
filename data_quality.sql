#Data quality audit file
# Using Olist data set
# Row counts per table
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
