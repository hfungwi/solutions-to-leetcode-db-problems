-- please scroll to bottom for solution
-- question is presented "as is" from leetcode. 
-- Question difficulty on leetcode is marked as "medium"
-- Solution was developed indepently by myself
-- link to problem is : https://leetcode.com/problems/customers-who-bought-all-products/description/

--Start of problem ;
/*
Table: Customer

+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| customer_id | int     |
| product_key | int     |
+-------------+---------+
This table may contain duplicates rows. 
customer_id is not NULL.
product_key is a foreign key (reference column) to Product table.
 

Table: Product

+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| product_key | int     |
+-------------+---------+
product_key is the primary key (column with unique values) for this table.
 

Write a solution to report the customer ids from the Customer table that bought all the products in the Product table.

Return the result table in any order.

The result format is in the following example.

 

Example 1:

Input: 
Customer table:
+-------------+-------------+
| customer_id | product_key |
+-------------+-------------+
| 1           | 5           |
| 2           | 6           |
| 3           | 5           |
| 3           | 6           |
| 1           | 6           |
+-------------+-------------+
Product table:
+-------------+
| product_key |
+-------------+
| 5           |
| 6           |
+-------------+
Output: 
+-------------+
| customer_id |
+-------------+
| 1           |
| 3           |
+-------------+
Explanation: 
The customers who bought all the products (5 and 6) are customers with IDs 1 and 3.
*/
-- end of problem;
--
--
--Start of Solution
/* Write your PL/SQL query statement below */
SELECT customer_id "customer_id"
FROM (
SELECT 
    customer_id, 
    listagg( product_key, ', ') within group (order by product_key) products_list
FROM   
    (select
        unique product_key,
        customer_id
        from customer
    )
GROUP BY 
    customer_id
)
WHERE products_list = (select listagg(product_key, ', ') within group (order by product_key)
                       from product)
-- End of Solution
