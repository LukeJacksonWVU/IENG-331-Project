#### IENG-331-Project
###Project for IENG331, will be updated and added to throughout the semester

###Milestone 1
The first part of this project is on SQL and utilizes DuckDB
The code will explore and query the olist.duckdb database provided. First it will determine the integrity and quality of the database through multiple queries, outlined below. Then several seperate .sql files will be created to conduct analytical queries of several particular business questions.

##data_quality.sql
Explores and organizes the olist database through six seperate queries. This code determines row count, NULL percentage for key columns, orphaned keys, date range, duplicates, missing data, and other quality concerns.
Identified key columns as the "ID" Columns that are refrenced in multiple tables. 

#ROW COUNT, Q1: Begins by counting rows of the following tables by selecting each column and using COUNT*. Tables analyzed include: categorytranslation, customers, geolocation, orderItems, orderPayments, orderReviews, orders, products, sellers.

#NULL RATE and KEY COLUMNS, Q2: Identified key columns and checked for null entries. Identified orderID, CustomerID, ProductID, and SellerID as key columns. Used ROUND function to calculate percentage of NULL data in a table. IF a key column does not exist in a table, Null percentage is set to 0.

#ORPHANED KEYS, Q3: Finds any orders that reference customers that do not exist, specifically ffrom the four key ID columns listed above. Uses LEFT JOIN function to compare tables while including null values. Assigns the count of null values to the orphan_count variable of each ID

#DATE RANGE, Q4: defines the range of dates in which purchases were made. Drawing data from the orders table, creates three variables: firstOrderDate, lastOrderDate, PurchaseDays. This is the earliest (MIN) date for which there is a purhcase timestamp, the latest (MAX) date for which there is a purchase tiem stamp, and a count of every distinct day on which a purchase was made, respectively. Used CAST to change data type to calendar days.

#DATE GAPS, Q5: finds beginning and end of purchase history, the MIN and MAX dates. These are the Date Bounds. Used a built in duckDB function, "generate_series", to list each calendar day one day at a time.
