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
# Check for missing values in key columns
# Use NULL to find data that was not recorded or missing, count how many times it occured.
# The group went forward with using key columns: order_id,customer_id, product_id, and seller_id
# Columns headers are considered our key columns
WITH null_checks AS (
    select
        'orders' AS table_name,
        COUNT(*) AS total_rows,
        SUM(CASE WHEN order_id IS NULL THEN 1 ELSE 0 END) as  null_order_id,
        SUM(CASE WHEN customer_id IS NULL THEN 1 ELSE 0 END) as  null_customer_id,
        0 as null_product_id,
        0 as nul_seller_id
    from orders
  UNION ALL
    select
        'customers',
        COUNT(*),
        SUM(CASE WHEN customer_id IS NULL THEN 1 ELSE 0 END),
        0 as null_order_id,
        0 as null_product_id,
        0 as null_seller_id
    from customers
    UNION ALL
    select
        'products',
        COUNT(*),
        SUM(CASE WHEN product_id IS NULL THEN 1 ELSE 0 END),
        0 as null_order_id,
        0 as null_customer_id,
        0 as seller_id
    from products
    UNION ALL
    select
      'sellers',
      COUNT(*),
       SUM(CASE WHEN seller_id IS NULL THEN 1 ELSE 0 END),
       0 as nuller_order_id,
       0 as null_customer_id,
       0 as null_product_id
        from sellers
)
SELECT * FROM null_checks;
#test
