# ie-331-project
Class Project IE 331
# Question 1
**Row Counts per table**
**Business Question:**
How much data does each table contain, and where do most of the records come from in the business?
**Approach/alternatives**
By doing a simple query and count the number of rows per table, I was able to understand where data is stored and what tables are more relevant. This was a good approach to start the project on and showed which tables are important. Alternatives could have considered more information than we really needed at this point in the project.
**Results**
The results show that the most rows and data is consisted in the geolocation, order_items, and order_payments tables. Revealing that a lot of the data is based on transaction and the zip codes. Looking back at my queries in question 1, I should have coded more for geolocation and the order tables as they are more important. My original thoughts were to include the tables of customers, orders, products, and sellers.
**Limitations**
Row counts per table just provided the quantity of the data. Quality or accurate data, and relationships between tables or columns is not found using row counts.



















# Question 2 

**Query 1: Customer Retention**
**Business question**
What percentage of customers return within 30, 60, and 90 days of their first purchase?
This query investigated whether customers return to the shop again after their first purchase. The hard part of this query was that Olist gives every order a new customer_id, so if you join that you'll never find a repeating customer. To fix this I had to use the help of claude to join through the customers table to get customer_unique_id, which tracks the customer through new orders. Once that was solved, we flagged whether each customer placed more orders withing 30,60, and 90 days of their first purchase. The results were 0.68, 1.03, and 1.24 percent, which seems low but makes sense in 
