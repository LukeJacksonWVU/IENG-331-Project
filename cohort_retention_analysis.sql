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
