### IENG-331-Project
##Project for IENG331, will be updated and added to throughout the semester

#Milestone 1
The first part of this project is on SQL and utilizes DuckDB
The code will explore and query the olist.duckdb database provided

#data_quality.sql
Explores and organizes the olist database. Looks into duplicates, missing data, and other quality concerns. 
Identified key columns as "ID" Columns that are refrenced in multiple tables. 

Begins by counting rows of the following tables by selecting each column and using COUNT*. Tables analyzed include: categorytranslation, customers, geolocation, orderItems, orderPayments, orderReviews, orders, products, sellers.

