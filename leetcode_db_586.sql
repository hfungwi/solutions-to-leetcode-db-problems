-- please scroll to bottom for solution
-- question is presented "as is" from leetcode. 
-- Question difficulty on leetcode is marked as "easy"
-- Solution was developed indepently by myself
-- link to problem is : https://leetcode.com/problems/customer-placing-the-largest-number-of-orders/

--Start of problem ;
/*
Table: Orders

+-----------------+----------+
| Column Name     | Type     |
+-----------------+----------+
| order_number    | int      |
| customer_number | int      |
+-----------------+----------+
order_number is the primary key (column with unique values) for this table.
This table contains information about the order ID and the customer ID.
 

Write a solution to find the customer_number for the customer who has placed the largest number of orders.

The test cases are generated so that exactly one customer will have placed more orders than any other customer.

The result format is in the following example.

 

Example 1:

Input: 
Orders table:
+--------------+-----------------+
| order_number | customer_number |
+--------------+-----------------+
| 1            | 1               |
| 2            | 2               |
| 3            | 3               |
| 4            | 3               |
+--------------+-----------------+
Output: 
+-----------------+
| customer_number |
+-----------------+
| 3               |
+-----------------+
Explanation: 
The customer with number 3 has two orders, which is greater than either customer 1 or 2 because each of them only has one order. 
So the result is customer_number 3.
 

Follow up: What if more than one customer has the largest number of orders, can you find all the customer_number in this case?
*/
--end of problem;
--
--
--Start of Solution
select customer_number
from
(
select 
       customer_number
       ,dense_rank()  over ( order by count(order_number) desc ) ranking
from orders
group by customer_number
)
where ranking = 1 ;
--End of Solution
-- my solution also answers the follow up question : What if more than one customer has the largest number of orders, can you find all the customer_number in this case?
