#Which seller performs best 
  #1 Compute Rev.
WITH revenue AS (
    SELECT 
        seller_id,
        SUM(price) AS total_revenue
    FROM order_items
    GROUP BY seller_id
),
  
#Measure Delivery
delivery AS (
    SELECT 
        oi.seller_id,
        AVG(
            CASE 
                WHEN o.order_delivered_customer_date <= o.order_estimated_delivery_date THEN 1
                ELSE 0
            END
        ) AS on_time_rate
    FROM orders o
    JOIN order_items oi ON o.order_id = oi.order_id
    WHERE o.order_delivered_customer_date IS NOT NULL
    GROUP BY oi.seller_id
),

#Review Scores (Aggregate)
reviews AS (
    SELECT 
        oi.seller_id,
        AVG(r.review_score) AS avg_review
    FROM order_reviews r
    JOIN order_items oi ON r.order_id = oi.order_id
    GROUP BY oi.seller_id
),

#Cancellation Rate
cancellations AS (
    SELECT 
        oi.seller_id,
        AVG(CASE WHEN o.order_status = 'canceled' THEN 1 ELSE 0 END) AS cancel_rate
    FROM orders o
    JOIN order_items oi ON o.order_id = oi.order_id
    GROUP BY oi.seller_id
),
#Combine
combined AS (
    SELECT 
        r.seller_id,
        r.total_revenue,
        d.on_time_rate,
        rv.avg_review,
        c.cancel_rate
    FROM revenue r
    LEFT JOIN delivery d ON r.seller_id = d.seller_id
    LEFT JOIN reviews rv ON r.seller_id = rv.seller_id
    LEFT JOIN cancellations c ON r.seller_id = c.seller_id
),

#Rank
ranked AS (
    SELECT *,
        RANK() OVER (ORDER BY total_revenue DESC) AS revenue_rank,
        RANK() OVER (ORDER BY avg_review DESC) AS review_rank
    FROM combined
)
  
SELECT *
FROM ranked
ORDER BY revenue_rank;
