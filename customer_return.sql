#Question: What percentage of customers return within 30, 60, and 90 days of their first purchase?

#1 Identify Purchase
WITH first_order AS (
    SELECT 
        customer_id,
        MIN(order_purchase_timestamp) AS first_purchase
    FROM orders
    GROUP BY customer_id
),
