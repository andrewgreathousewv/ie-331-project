#Which seller performs best 
  #1 Compute Rev.
WITH revenue AS (
    SELECT 
        seller_id,
        SUM(price) AS total_revenue
    FROM order_items
    GROUP BY seller_id
),
