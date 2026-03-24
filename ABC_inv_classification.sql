#Question: Which products fall into A, B, and C categories based on revenue contribution?

#1 Compute Revenue
WITH product_revenue AS (
    SELECT 
        oi.product_id,
        p.product_category_name,
        SUM(oi.price)                   AS revenue,
        COUNT(*)                         AS units_sold
    FROM order_items oi
    LEFT JOIN products p ON oi.product_id = p.product_id
    GROUP BY oi.product_id, p.product_category_name
),
