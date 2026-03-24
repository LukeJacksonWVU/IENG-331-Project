##Quality Audit
#Counting rows in each Table by selecting each column and counting every row using count(*)
#Table Name under tableName and Row Count under rowCount

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
#Used Round to divide Null by Total and mukltiply by 100

SELECT
    'orders' AS tableName,
    COUNT(*) AS totalRows,
    ROUND(100.0 * SUM(CASE WHEN customer_id IS NULL THEN 1 ELSE 0 END) / COUNT(*), 2) AS nullCustomerIdPercent,
    ROUND(100.0 * SUM(CASE WHEN order_id IS NULL THEN 1 ELSE 0 END) / COUNT(*), 2) AS nullOrderIdPercent,
    0 AS nullProductIdPercent,
    0 AS nullSellerIdPercent,
From orders

    UNION ALL

SELECT
    'orderItems',
    COUNT(*) AS totalRows,
    ROUND(100.0 * SUM(CASE WHEN order_id IS NULL THEN 1 ELSE 0 END) / COUNT(*), 2),
    ROUND(100.0 * SUM(CASE WHEN product_id IS NULL THEN 1 ELSE 0 END) / COUNT(*), 2),
    ROUND(100.0 * SUM(CASE WHEN seller_id IS NULL THEN 1 ELSE 0 END) / COUNT(*), 2),
    0 AS nullCustomerIdPercent,
FROM order_items

    UNION ALL

SELECT
    'orderPayments',
    COUNT(*) AS total_rows,
    ROUND(100.0 * SUM(CASE WHEN order_id IS NULL THEN 1 ELSE 0 END) / COUNT(*), 2),
    0 AS nullCustomerIdPercent,
    0 AS nullProductIdPercent,
    0 AS nullSellerIdPercent,
FROM order_payments

    UNION ALL

SELECT
    'orderReviews',
    COUNT(*) AS total_rows,
    ROUND(100.0 * SUM(CASE WHEN order_id IS NULL THEN 1 ELSE 0 END) / COUNT(*), 2),
    0 AS nullCustomerIdPercent,
    0 AS nullProductIdPercent,
    0 AS nullSellerIdPercent,
FROM order_reviews

    UNION ALL

SELECT
    'customers',
    COUNT(*) AS total_rows,
    ROUND(100.0 * SUM(CASE WHEN customer_id IS NULL THEN 1 ELSE 0 END) / COUNT(*), 2),
    0 AS nullOrderIdPercent,
    0 AS nullProductIdPercent,
    0 AS nullSellerIdPercent,
FROM customers

    UNION ALL

SELECT
    'products',
    COUNT(*) AS total_rows,
    ROUND(100.0 * SUM(CASE WHEN product_id IS NULL THEN 1 ELSE 0 END) / COUNT(*), 2),
    0 AS nullOrderIdPercent,
    0 AS nullCustomerIdPercent,
    0 AS nullSellerIdPercent,
FROM products

    UNION ALL

SELECT
    'sellers',
    COUNT(*) AS total_rows,
    ROUND(100.0 * SUM(CASE WHEN seller_id IS NULL THEN 1 ELSE 0 END) / COUNT(*), 2),
    0 AS nullOrderIdPercent,
    0 AS nullCustomerIdPercent,
    0 AS nullProductIdPercent,
FROM sellers

#Orphaned Keys, Looking at 4 key columns identified above
#Seeing if orders refrence customers that dont exist by refrencing both tables customer Ids and counting where null

SELECT 'orphanedCustomerId' As foreignKeys,
    COUNT(*) AS orphan_count
    FROM orders AS o
    LEFT JOIN customers AS c
        ON o.customer_id = c.customer_id
    WHERE c.customer_id IS NULL

UNION ALL

SELECT 'orphanedOrderId',
    COUNT(*) AS orphan_count
    FROM order_items AS oi
    LEFT JOIN orders AS o
        ON oi.order_id = o.order_id
    WHERE o.order_id IS NULL

UNION ALL

SELECT 'orphanedProductId',
    COUNT(*) AS orphan_count
    FROM order_items AS oi
    LEFT JOIN products AS p
        ON oi.product_id = p.product_id
    WHERE p.product_id IS NULL

UNION ALL

SELECT 'orphanedSellerId',
    COUNT(*) AS orphan_count
    FROM order_items AS oi
    LEFT JOIN sellers AS s
        ON oi.seller_id = s.seller_id
    WHERE s.seller_id IS NULL

    #Investigating Date Ranges
    #Looking at Order range to find number of days an order was placed and the total number of days
    #Cast converts data type
    SELECT
        MIN(order_purchase_timestamp) AS firstOrderDate,
        MAX(order_purchase_timestamp) AS lastOrderDate,
        COUNT(DISTINCT DATE(order_purchase_timestamp)) AS PurchaseDays,
        CAST(MAX(order_purchase_timestamp) AS DATE) - CAST(MIN(order_purchase_timestamp) AS DATE) AS calendarDays
    FROM orders

    #Looking into days missing, this gets the start and end date
    #Setting the date bounds by using the max and min order date from the orders table
    WITH dateBounds AS (
            SELECT
            CAST(MIN(order_purchase_timestamp) AS DATE) AS startDate,
            CAST(MAX(order_purchase_timestamp) AS DATE) AS endDate
            FROM orders),
    #Generate_series function built into duckDB with an interval of 1 day with start and end from previous section
    #List every calander day (Youtube video showed me how to do this)
        calendar AS (
            SELECT CAST(generate_series AS DATE) AS calanderDate
            FROM generate_series(
            (SELECT startDate FROM dateBounds),
            (SELECT endDate   FROM dateBounds),
            INTERVAL '1 day')),
    #Counts where orders were placed and stores it as DailyOrders
        dailyOrders AS (
            SELECT
            CAST(order_purchase_timestamp AS DATE) AS orderDate,
            COUNT(*) AS orders
            FROM orders
            GROUP BY CAST(order_purchase_timestamp AS DATE)),
    #Assigns number to gap days in order where there is no value. This is a way to group the gaps
    #Subtracts the date by the number, you end up with an arbitrary date but it is the same date
    #This creates a group
    #This is where AI helped the most and something I couldnt figure out on my own
        gapGroups AS (
            SELECT
            c.calanderDate,
            c.calanderDate - CAST(ROW_NUMBER() OVER (ORDER BY c.calanderDate) AS INTEGER) AS gapGroup
            FROM calendar AS c
            LEFT JOIN dailyOrders AS d ON c.calanderDate = d.orderDate
            WHERE d.orderDate IS NULL)

    #Getting the beginning and end of the gap from the GAPGROUP, counting everything as the missing days
    #Using a case when to catagorise the gaps
    #Ordering by the gap start date
        SELECT
            MIN(calanderDate) AS gapStart,
            MAX(calanderDate) AS gapEnd,
            COUNT(*) AS missingDays,
            CASE
                WHEN COUNT(*) = 1  THEN 'single day'
                WHEN COUNT(*) <= 3 THEN 'short gap (≤ 3 days)'
                WHEN COUNT(*) <= 7 THEN 'week-level gap'
                ELSE '!!!Extended gap!!! (> 7 days)'
            END AS Severity
        FROM gapGroups
        GROUP BY gapGroup
        ORDER BY gapStart;
