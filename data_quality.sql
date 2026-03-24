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

From orders
