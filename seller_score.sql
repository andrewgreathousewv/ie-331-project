#Which seller performs best 
  #1 Compute Rev.
  #Total amount of money each seller brought in
WITH revenue AS (
    SELECT 
        seller_id,
        SUM(price)  AS total_revenue,
        COUNT(*)    AS total_items_sold
    FROM order_items
    GROUP BY seller_id
),
  
#2 Measure Delivery
# What percentage of the sellers orders arrive on time
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
      AND o.order_status = 'delivered'
    GROUP BY oi.seller_id
),

#3 Review Scores (Aggregate)
#  What is the sellers average satisfaction rate from customers
reviews AS (
    SELECT 
        oi.seller_id,
        AVG(r.review_score) AS avg_review
    FROM order_reviews r
    JOIN order_items oi ON r.order_id = oi.order_id
    GROUP BY oi.seller_id
),

#4 Cancellation Rate
# What percentage of the sellers orders get cancelled
cancellations AS (
    SELECT 
        oi.seller_id,
        AVG(CASE WHEN o.order_status = 'canceled' THEN 1 ELSE 0 END) AS cancel_rate
    FROM orders o
    JOIN order_items oi ON o.order_id = oi.order_id
    GROUP BY oi.seller_id
),
  
#5 Combine
# Put all seller performance stats into one table
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

#6 Rank
# Who is the best seller
ranked AS (
    SELECT *,
        RANK() OVER (ORDER BY total_revenue DESC)  AS revenue_rank,
        RANK() OVER (ORDER BY on_time_rate DESC)   AS delivery_rank,
        RANK() OVER (ORDER BY avg_review DESC)     AS review_rank,
        RANK() OVER (ORDER BY cancel_rate ASC)     AS cancel_rank,
        # Composite score: lower is better (average of all four ranks)
        ROUND(
            (
                RANK() OVER (ORDER BY total_revenue DESC) +
                RANK() OVER (ORDER BY on_time_rate DESC) +
                RANK() OVER (ORDER BY avg_review DESC) +
                RANK() OVER (ORDER BY cancel_rate ASC)
            ) / 4.0, 1
        ) AS composite_score
    FROM combined
)

SELECT *
FROM ranked
ORDER BY composite_score ASC;
