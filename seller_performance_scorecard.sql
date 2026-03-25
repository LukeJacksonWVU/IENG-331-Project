WITH seller_revenue AS (
    SELECT
        oi.seller_id,
        COUNT(DISTINCT oi.order_id)                AS total_orders,
        ROUND(SUM(oi.price + oi.freight_value), 2) AS total_revenue
    FROM olist.main.order_items oi
    JOIN olist.main.orders o ON oi.order_id = o.order_id
    WHERE o.order_status NOT IN ('canceled', 'unavailable')
    GROUP BY oi.seller_id
),
--seller ids in items; sum price and freight to get total cost and group by seller (cancellations ignored)
seller_delivery AS (
    SELECT
        oi.seller_id,
        ROUND(
            SUM(
                CASE
                    WHEN CAST(o.order_delivered_customer_date AS DATE)
                         <= CAST(o.order_estimated_delivery_date AS DATE)
                    THEN 1 ELSE 0
                END
                --if it was delivered on time (1) if it was not (0)
            ) * 100.0 / COUNT(DISTINCT o.order_id),
        2) AS on_time_rate_pct
        --converts to  rate of on time
    FROM olist.main.order_items oi
    JOIN olist.main.orders o ON oi.order_id = o.order_id
    WHERE o.order_status = 'delivered'
      AND o.order_delivered_customer_date IS NOT NULL
      AND o.order_estimated_delivery_date IS NOT NULL
    GROUP BY oi.seller_id
),
--gets rid of null
seller_reviews AS (
    SELECT
        oi_dedup.seller_id,
        ROUND(AVG(r.review_score), 2) AS avg_review_score
    FROM (
        SELECT DISTINCT seller_id, order_id
        FROM olist.main.order_items
    ) oi_dedup
    JOIN olist.main.order_reviews r ON oi_dedup.order_id = r.order_id
    GROUP BY oi_dedup.seller_id
),
--order can have multiple items from the same seller, gets rid of that, so seller is accounted for once
