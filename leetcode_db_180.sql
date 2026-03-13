-- please scroll to bottom for solution
-- question is presented "as is" from leetcode. 
-- Question difficulty on leetcode is marked as "medium"
-- Solution was developed indepently by myself
-- link to problem is : https://leetcode.com/problems/consecutive-numbers/

--Start of problem ;
/*
Table: Logs

+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| id          | int     |
| num         | varchar |
+-------------+---------+
In SQL, id is the primary key for this table.
id is an autoincrement column starting from 1.
 

Find all numbers that appear at least three times consecutively.

Return the result table in any order.

The result format is in the following example.

 

Example 1:

Input: 
Logs table:
+----+-----+
| id | num |
+----+-----+
| 1  | 1   |
| 2  | 1   |
| 3  | 1   |
| 4  | 2   |
| 5  | 1   |
| 6  | 2   |
| 7  | 2   |
+----+-----+
Output: 
+-----------------+
| ConsecutiveNums |
+-----------------+
| 1               |
+-----------------+
Explanation: 1 is the only number that appears consecutively for at least three times.
*/
--end of problem;
--
--
--Start of Solution
/* Write your PL/SQL query statement below */
SELECT DISTINCT
      num  consecutivenums
FROM (
        SELECT 
                id
                ,num
                ,lead(num,1,NULL) OVER (ORDER BY id ) as next_num
                ,lead(num,2,NULL) OVER (ORDER BY id ) as next_2_num
        FROM
           logs
      )
WHERE num    = next_num
AND   num    = next_2_num
AND next_num = next_2_num;
--End of Solution
