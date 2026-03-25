#### IENG-331-Project
###Project for IENG331, will be updated and added to throughout the semester

###Milestone 1
The first part of this project is on SQL and utilizes DuckDB
The code will explore and query the olist.duckdb database provided. First it will determine the integrity and quality of the database through multiple queries, outlined below. Then several seperate .sql files will be created to conduct analytical queries of several particular business questions.

##data_quality.sql
Explores and organizes the olist database through ten seperate queries. This code determines row count, NULL percentage for key columns, orphaned keys, date range, duplicates, missing data, and other quality concerns.
Identified key columns as the "ID" Columns that are refrenced in multiple tables. 

#ROW COUNT, Q1: Begins by counting rows of the following tables by selecting each column and using COUNT*. Tables analyzed include: categorytranslation, customers, geolocation, orderItems, orderPayments, orderReviews, orders, products, sellers.

#NULL RATE and KEY COLUMNS, Q2: Identified key columns and checked for null entries. Identified orderID, CustomerID, ProductID, and SellerID as key columns. Used ROUND function to calculate percentage of NULL data in a table. IF a key column does not exist in a table, Null percentage is set to 0.

#ORPHANED KEYS, Q3: 
