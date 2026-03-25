WITH resolved_customers AS (
    SELECT
        o.order_id,
        o.order_purchase_timestamp,
        c.customer_zip_code_prefix || '_' || c.customer_city    AS customer_unique
    FROM olist.main.orders o
    JOIN olist.main.customers c
        ON o.customer_id = c.customer_id
    WHERE o.order_status = 'delivered'
),
--join order and customers with location attached, eliminates duplicate id's by using location (customer_unique)
first_orders AS (
    SELECT
        customer_unique,
        order_id                                                AS first_order_id,
        order_purchase_timestamp                                AS first_order_ts,
        CAST(DATE_TRUNC('month', order_purchase_timestamp) AS DATE) AS cohort_month
    FROM (
        SELECT
            customer_unique,
            order_id,
            order_purchase_timestamp,
            ROW_NUMBER() OVER (
                PARTITION BY customer_unique
                ORDER BY order_purchase_timestamp ASC, order_id ASC
            ) AS rn
        FROM resolved_customers
    ) ranked
    WHERE rn = 1
),
--find each customer's first order; sort by purchase date and keep the first (rn=1);
