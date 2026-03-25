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

#ORPHANED KEYS, Q3: Finds any orders that reference customers that do not exist, specifically from the four key ID columns listed above. Uses LEFT JOIN function to compare tables while including null values. Assigns the count of null values to the orphan_count variable of each ID

#DATE RANGE, Q4: defines the range of dates in which purchases were made. Drawing data from the orders table, creates four columns: firstOrderDate, lastOrderDate, purchaseDays, and calendarDays. This is the earliest (MIN) date for which there is a purhcase timestamp, the latest (MAX) date for which there is a purchase time stamp, and a count of every distinct day on which a purchase was made, as well as a total calander day count that comes from max-min respectively. Used CAST to change data type to calendar days. From this table, it was clear that there were around eighty days in the range where there were no orders. To investigate this, a second Query was used.

#DATE GAPS, Q5: Once again using min and max functions to set the start and end dates under dateBounds. Used generate_series with an interval of 1 Day to generate a series of days starting at the min date and ending at the max date. This was under calander. Under dailyOrders, used a count to count days where orders were placed and a cast to store data as a date. Using this, did a left join on dailyOrders where the order date was equal to a calander date. This shows the days where orders were placed, leaving the days there were no orders. In order to actually count and see these gaps, an OVER function was used. This was used because we are not aggregating the table yet, and when there are no orders an integer was put in for the order date starting at 1,2,3... in order to fill in the blank cell. The order date is then subtracted from the calander date which leaves an arbitrary date which carrys no specific meaning. However, for dates there are gaps, the first row number in the gap is subtracted by 1, the next by 2, etc. which means all rows in the gap are left with the same aribitrary date. This is how the code knows how many days without orders are in a sequence. This was stored under gapGroups. Selecting the min and max of the gapGroups gives us the start and end of the gap and a count function can count the concecutive days within that gap. A case when is used to catagorize the severity level by the number of concecutive days with no orders. If there is a single day, the severity is low, a short gap is less than three days, a week gap is seven or less days, and if there are more than seven concecutive days, the severity is high since the missing orders could be caused by something other than no orders being placed. One of the gaps in the results of this query showed a 61 day gap in the data!

#DUPLICATE, Q6: Looked for duplicates in three main columns. The Product ID, Unique Customer ID, and Order ID. It is very important that these ID numbers are unique and have no duplicates. The duplicates are identified for each ID column first. Under duplicateOrders, the order ID is selected from the orders table if it has a count(*) greater than one (IE there are more than  one rows with the same ID). That is then counted and stored as cnt. The same method is used to store the duplicateCustomers and duplicateProducts. To set up a table with the duplicate IDs as well as the number of times they appear in total(number of rows), each is selected indivisually and unioned into one table using a Union All. The table name is first, followed by the count of rows stored under duplicate____. This is the number of IDs that have duplicates (duplicateKeys). The last column is the sum of the cnt, which is the total number of times a duplicate appears (totalDuplicateRows). A coalesce is used here as well to set null values to 0. This is then done for every ID listen above and Unioned together. This results in a table with a count of duplcate ID's and how many rows they afect. In the future, every ID number should be included, not just the three picked. The code is written in a way that makes it easy to add the other IDs to this duplicate table.

##Particular Business Applications Through SQL Queries
Four different business applications of the data queried from the database are presented in their own SQL files. A Cohort Retention Analysis, Seller Performance Scorecard, ABC Inventory Classification, and a Delivery Time Analysis.

#Cohort Retention Analysis: Cohorts of customers are created by their first purchase month, and then the percentage of each cohort that placed a second order within 30, 60, or 90 days is calculated. This provides a look into customer retention.

First, the CTE "customer_unique" is created by concatenating the city and the corresponding zip code from customer orders. This is important for elimanting duplicate IDs. Customers are then paired with their first order, and then sorted by purchase date. All orders are analyzed for thoroughness, but only the earliest is needed. Customers making their first order in the same month are in the same cohort.
Then, the data is queried to find repeat customers. The most recent orders by returning customers is gathered into a CTE called cohort_activity.
Using the cohort_month and unique customers groups, the time between orders for returning customers (one-time customers are excluded) is calculated.
A percentage rate is then calculated for each cohort, from cohort_activity, for 30, 60, and 90 day intervals.


#ABC Inventory Classification
Understanding what products are real, consistent, money makers is critical to running a marketplace. Conducting an analysis using SQL, revenues for products are ranked into three tiers: "A" tier comprises 80% of total revenue, "B" tier comprises 15% of total revenue, and "C" tier comprises the final 5% of total revenue.
Product revenue does not exist in the database naturally. It must be defined. In this analysis, it is defined as price + freight value, pulling data from orders that are not cancelled or unavailable. This is the total revenue for a product.
Grand totals, running totals, and percentages may be calculated next. This is the meat of the analysis, but also quite straightforward. When the grand total of all revenue, the percentage contribution to that total for each product, and the running total (sorted in descending order in the table for readability) are calculated, it is as simple as running a few WHEN statements that assign them a tier at certain thresholds.
Lastly, the products are joined into categories and sorted in order, with Tier A at the top of the lost.

>>>>>>> 04898da9fd4857913ca21b26c8d4dd87d4938c3f
