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
