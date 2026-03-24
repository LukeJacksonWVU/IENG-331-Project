##Quality Audit
#Counting rows in each Table by selecting each table and counting every row using count(*)

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
