#Question: Which customer regions experience the largest delays compared to estimated delivery times?

# 1 Join orders with customers
# Filtering to only delivered orders
WITH delivery_times AS (
    SELECT 
        o.order_id,
        c.customer_state,
        DATE_DIFF('day', o.order_purchase_timestamp::DATE, o.order_delivered_customer_date::DATE) AS actual_days,
        DATE_DIFF('day', o.order_purchase_timestamp::DATE, o.order_estimated_delivery_date::DATE)  AS estimated_days
    FROM orders o
    JOIN customers c ON o.customer_id = c.customer_id
    WHERE o.order_delivered_customer_date IS NOT NULL
      AND o.order_status = 'delivered'
),

