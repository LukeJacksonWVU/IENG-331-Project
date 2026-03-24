##Quality Audit
#Counting rows in each Table by selecting each column and counting every row using count(*)
#Table Name undet tableName and Row Count under rowCount

SELECT 'categoryTranslation' AS tableName, COUNT(*) As rowCount FROM category_translation
    UNION ALL
SELECT 'customers', COUNT(*) FROM customers
    UNION ALL
SELECT 'geolocation', COUNT(*) FROM geolocation
    UNION ALL
SELECT 'orderItems', COUNT(*) FROM order_items
    UNION ALL
SELECT 'orderPayments', COUNT(*) FROM order_payments
    UNION ALL
SELECT 'orderReviews', COUNT(*) FROM order_reviews
    UNION ALL
SELECT 'orders', COUNT(*) FROM orders
    UNION ALL
SELECT 'products', COUNT(*) FROM products
    UNION ALL
SELECT 'sellers', COUNT(*) FROM sellers

#Checking for Nulls in a seperate query
#Identified orderID, CustomerID, ProductID, and SellerID as key columns
#Some tables dont have every one of these key columns ,set to 0 if not in table

    SELECT
       'orders' AS tableName,
       COUNT(*) AS totalRows,
       SUM(CASE WHEN order_id IS NULL THEN 1 ELSE 0 END) AS nullOrderId,
       SUM(CASE WHEN customer_id IS NULL THEN 1 ELSE 0 END) AS nullCustomerId,
       0 AS nullProductId,
       0 AS nullSellerId,
    FROM orders

    UNION ALL

    SELECT
        'orderItems',
        COUNT(*) AS totalRows,
        SUM(CASE WHEN order_id IS NULL THEN 1 ELSE 0 END),
        SUM(CASE WHEN product_id IS NULL THEN 1 ELSE 0 END),
        SUM(CASE WHEN seller_id IS NULL THEN 1 ELSE 0 END),
        0 AS nullCustomerId,
    FROM order_items

    UNION ALL

    SELECT
        'orderPayments',
        COUNT(*) AS total_rows,
        SUM(CASE WHEN order_id IS NULL THEN 1 ELSE 0 END),
        0 AS nullCustomerId,
        0 AS nullProductId,
        0 AS nullSellerId,
    FROM order_payments

    UNION ALL

    SELECT
        'orderReviews',
        COUNT(*) AS total_rows,
        SUM(CASE WHEN order_id IS NULL THEN 1 ELSE 0 END),
        0 AS nullCustomerId,
        0 AS nullProductId,
        0 AS nullSellerId,
    FROM order_reviews

    UNION ALL

    SELECT
        'customers',
        COUNT(*) AS total_rows,
        SUM(CASE WHEN customer_id IS NULL THEN 1 ELSE 0 END),
        0 AS nullOrderId,
        0 AS nullProductId,
        0 AS nullSellerId,
    FROM customers

    UNION ALL

    SELECT
        'products',
        COUNT(*) AS total_rows,
        SUM(CASE WHEN product_id IS NULL THEN 1 ELSE 0 END),
        0 AS nullOrderId,
        0 AS nullCustomerId,
        0 AS nullSellerId,
    FROM products

    UNION ALL

    SELECT
        'sellers',
        COUNT(*) AS total_rows,
        SUM(CASE WHEN seller_id IS NULL THEN 1 ELSE 0 END),
        0 AS nullOrderId,
        0 AS nullCustomerId,
        0 AS nullProductId,
    FROM sellers

#Orphaned Keys, Looking at 4 key columns identified above
#Seeing if orders refrence customers that dont exist by refrencing both tables' customer Ids and counting where null
SELECT 'orphanedCustomerId' As foreignKeys,
    COUNT(*) AS orphan_count
    FROM orders o
    LEFT JOIN customers c
    ON o.customer_id = c.customer_id
    WHERE c.customer_id IS NULL
