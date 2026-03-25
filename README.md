# ie-331-project
Class Project IE 331
# Question 1
**Row Counts per Table**
**Business Question**
How much data does each table contain, and where do most of the records come from in the business?
**Approach/Alternatives**
By doing a simple query and count the number of rows per table, I was able to understand where data is stored and what tables are more relevant. This was a good approach to start the project on and showed which tables are important. Alternatives could have considered more information than we really needed at this point in the project.
**Results**
The results show that the most rows and data is consisted in the geolocation, order_items, and order_payments tables. Revealing that a lot of the data is based on transaction and the zip codes. Looking back at my queries in question 1, I should have coded more for geolocation and the order tables as they are more important. My original thoughts were to include the tables of customers, orders, products, and sellers.
**Limitations**
Row counts per table just provided the quantity of the data. Quality or accurate data, and relationships between tables or columns is not found using row counts.

**NULL Rates for Key Columns**
**Business Question**
Are there missing values in key columns that could affect analysis?
**Approach/Alternatives**
We used a query to check for null values for the following key columns: order_id,customer_id, product_id, and seller_id.
A CTE was used to count total rows per table and the number of nulls for each of the key columns. An alternative, as I previously mentioned in the first part of question one (row counts per table) could have been to consider key columns in other tables such as the geolocation or order_items tables.
**Results**
Results in the output show that all key ID columns have no null values. The order, customer, product, and seller tables are connected well.
**Limitations**
This query checks for any missing values, but we do not know if there is incorrect data.

**Orphaned Foreign Keys**
**Business Question**
Are there any ophaned foreign keys that could affect analysis?
**Approach/Alternatives**
Using the same columns in the second part of question one, which are order_id,customer_id, product_id, and seller_id, a query was made to find orphaned foreign keys. A CTE was used performing LEFT JOIN's between related tables and identified rows where the joined table returned NULL. An alternative could have been to use different columns under the other tables in the dataset.
**Results**
Results show that there are no orphaned foreign keys within the key relationships. The relationship between the order, customer, product, and seller tables are reliable.
**Limitations**
The query only has 4 key columns. Many other columns in the dataset could possibly have orphaned foreign keys but were not included in this part.



















# Question 2 

**Query 1: Customer Retention**
**What percentage of customers return within 30, 60, and 90 days of their first purchase?**

This query investigated whether customers return to the shop again after their first purchase. The hard part of this query was that Olist gives every order a new customer_id, so if you join that you'll never find a repeating customer. To fix this I had to use the help of claude to join through the customers table to get customer_unique_id, which tracks the customer through new orders. Once that was solved, we flagged whether each customer placed more orders withing 30,60, and 90 days of their first purchase. The results were 0.68, 1.03, and 1.24 percent, which seems low but makes sense in

**Query 2: Seller Scorecard**

**Query 3: A,B,C inventory classification**
**Which products fall into A, B, and C categories based on revenue contribution?**

We classified by revenue instead of units sold because businees value matters more than volume, a cheap high volume product can be more meanigful sometimes than an expensive low volume one. The query uses a cumulaive window funtion to build a running revenue total sorted highest to lowest, then stamps an A on eveyrhtng higher than 80%, B on the next 15%, and C for the rest. Results showed a pareto pattern, a few hundred products drive 80% of revenue while thusands generated only 5% combined. The main limitation is that this is a static. The tiers shift with seasonality so they don't account for product margin

**Query 4: Delivery Time**
**Which products fall into A, B, and C categories based on revenue contribution?**

WE compared the actual vs. estimated delivery time rather than the absolute delivery time alone, cause we realized what matters is whether customers are getting what they were promised. A key filter was making sure to only include the delivered orders. Without it canclled orders with partial timestamps would corruprt the averages. Results showed us a clear north and south divide, remote norther states like Amazonas and Roraima consistently miss estimates, while southern states like Sao Pauli would arrive early. The main limitation was thay delays could originate from both sides, the seller or carrier and this query couldn't seperate between the two.


