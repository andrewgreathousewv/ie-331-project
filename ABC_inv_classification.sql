#Question: Which products fall into A, B, and C categories based on revenue contribution?

#1 Compute Revenue
# adds all order_items and adds them up, groupig by product
# It also join to product table to grab the category name
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

#2 Calculate cummulative revenue (using windows function)
# Takes revenue list and adds two new columsn with winows function 
ranked_products AS (
    SELECT *,
        SUM(revenue) OVER ()                                                        AS total_revenue,
        SUM(revenue) OVER (ORDER BY revenue DESC ROWS BETWEEN UNBOUNDED PRECEDING 
                                                          AND CURRENT ROW)          AS cumulative_revenue
    FROM product_revenue
),

#3 Assign A,B, and C tiers based on % contribution
# Divides each product by grand total to get a % then applies tier logic
classified AS (
    SELECT
        product_id,
        product_category_name,
        revenue,
        units_sold,
        ROUND(revenue / total_revenue * 100, 4)             AS pct_of_revenue,
        ROUND(cumulative_revenue / total_revenue * 100, 4)  AS cumulative_pct,
        CASE 
            WHEN cumulative_revenue / total_revenue <= 0.80 THEN 'A'
            WHEN cumulative_revenue / total_revenue <= 0.95 THEN 'B'
            ELSE 'C'
        END AS abc_class
    FROM ranked_products
)
