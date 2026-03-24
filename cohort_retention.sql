#Question: What percentage of customers return within 30, 60, and 90 days of their first purchase?

#1 Identify Purchase
# When did each customer buy their first item
WITH first_order AS (
    SELECT 
        customer_id,
        MIN(order_purchase_timestamp) AS first_purchase
    FROM orders
    GROUP BY customer_id
),

#2 Combine future orders with customers
# For every order, we will now know when customer started
all_orders AS (
    SELECT 
        o.customer_id,
        o.order_purchase_timestamp,
        f.first_purchase
    FROM orders o
    JOIN first_order f 
        ON o.customer_id = f.customer_id
),

#3 Calculate time differences
# How long was it until the customer returned
time_diffs AS (
    SELECT 
        customer_id,
        DATE_DIFF('day', first_purchase, order_purchase_timestamp) AS days_since_first
    FROM all_orders
),

#4 Retention Rates (Aggregate)
# Did they comeback within 30, 60, or 90 days
retention_flags AS (
    SELECT 
        customer_id,
        MAX(CASE WHEN days_since_first > 0 AND days_since_first <= 30 THEN 1 ELSE 0 END) AS retained_30,
        MAX(CASE WHEN days_since_first <= 60 THEN 1 ELSE 0 END) AS retained_60,
        MAX(CASE WHEN days_since_first <= 90 THEN 1 ELSE 0 END) AS retained_90
    FROM time_diffs
    GROUP BY customer_id
)

