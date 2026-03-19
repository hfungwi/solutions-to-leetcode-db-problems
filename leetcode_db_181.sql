-- please scroll to bottom for solution
-- question is presented "as is" from leetcode. 
-- Question difficulty on leetcode is marked as "easy"
-- Solution was developed indepently by myself
-- link to problem is : https://leetcode.com/problems/employees-earning-more-than-their-managers/

--Start of problem ;
/*
Table: Employee

+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| id          | int     |
| name        | varchar |
| salary      | int     |
| managerId   | int     |
+-------------+---------+
id is the primary key (column with unique values) for this table.
Each row of this table indicates the ID of an employee, their name, salary, and the ID of their manager.
 

Write a solution to find the employees who earn more than their managers.

Return the result table in any order.

The result format is in the following example.

 

Example 1:

Input: 
Employee table:
+----+-------+--------+-----------+
| id | name  | salary | managerId |
+----+-------+--------+-----------+
| 1  | Joe   | 70000  | 3         |
| 2  | Henry | 80000  | 4         |
| 3  | Sam   | 60000  | Null      |
| 4  | Max   | 90000  | Null      |
+----+-------+--------+-----------+
Output: 
+----------+
| Employee |
+----------+
| Joe      |
+----------+
Explanation: Joe is the only employee who earns more than his manager.
*/
--end of problem;
--
--
--Start of Solution
/* Write your PL/SQL query statement below */
SELECT 
           e.name  employee
FROM
           employee e 
INNER JOIN employee m
       ON  e.managerid = m.id
WHERE 
           e.salary > m.salary  
--End of Solution
