#Question: What percentage of customers return within 30, 60, and 90 days of their first purchase?

#1 Identify Purchase
# When did each customer buy their first item
WITH first_order AS (
    SELECT 
        c.customer_unique_id,
        MIN(o.order_purchase_timestamp) AS first_purchase
    FROM orders o
    JOIN customers c ON o.customer_id = c.customer_id
    GROUP BY c.customer_unique_id
),

#2 Combine future orders with known customers
# For every order, we will now know when customer started
all_orders AS (
    SELECT 
        c.customer_unique_id,
        o.order_purchase_timestamp,
        f.first_purchase
    FROM orders o
    JOIN customers c ON o.customer_id = c.customer_id
    JOIN first_order f ON c.customer_unique_id = f.customer_unique_id
),

#3 Calculate time differences
# How long was it until the customer returned
time_diffs AS (
    SELECT 
        customer_unique_id,
        DATE_DIFF(
            'day',
            CAST(first_purchase AS DATE),
            CAST(order_purchase_timestamp AS DATE)
        ) AS days_since_first
    FROM all_orders
),

#4 Retention Rates (Aggregate)
# Did they comeback within 30, 60, or 90 days
retention_flags AS (
    SELECT 
        customer_unique_id,
        MAX(CASE WHEN days_since_first > 0 AND days_since_first <= 30 THEN 1 ELSE 0 END) AS retained_30,
        MAX(CASE WHEN days_since_first > 0 AND days_since_first <= 60 THEN 1 ELSE 0 END) AS retained_60,
        MAX(CASE WHEN days_since_first > 0 AND days_since_first <= 90 THEN 1 ELSE 0 END) AS retained_90
    FROM time_diffs
    GROUP BY customer_unique_id
)
SELECT 
    COUNT(*) AS total_customers,
    ROUND(AVG(retained_30) * 100, 2) AS retention_30_pct,
    ROUND(AVG(retained_60) * 100, 2) AS retention_60_pct,
    ROUND(AVG(retained_90) * 100, 2) AS retention_90_pct
FROM retention_flags;
