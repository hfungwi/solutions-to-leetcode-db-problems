-- please scroll to bottom for solution
-- question is presented "as is" from leetcode. 
-- Question difficulty on leetcode is marked as "easy"
-- Solution was developed indepently by myself
-- link to problem is : https://leetcode.com/problems/rising-temperature/

--Start of problem ;
/*
Table: Weather

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| id            | int     |
| recordDate    | date    |
| temperature   | int     |
+---------------+---------+
id is the column with unique values for this table.
There are no different rows with the same recordDate.
This table contains information about the temperature on a certain day.
 

Write a solution to find all dates' id with higher temperatures compared to its previous dates (yesterday).

Return the result table in any order.

The result format is in the following example.

 

Example 1:

Input: 
Weather table:
+----+------------+-------------+
| id | recordDate | temperature |
+----+------------+-------------+
| 1  | 2015-01-01 | 10          |
| 2  | 2015-01-02 | 25          |
| 3  | 2015-01-03 | 20          |
| 4  | 2015-01-04 | 30          |
+----+------------+-------------+
Output: 
+----+
| id |
+----+
| 2  |
| 4  |
+----+
Explanation: 
In 2015-01-02, the temperature was higher than the previous day (10 -> 25).
In 2015-01-04, the temperature was higher than the previous day (20 -> 30).
*/
--end of problem;
--
--
--Start of Solution
/* Write your PL/SQL query statement below */
SELECT distinct ID
FROM 
(SELECT 
       ID
      ,W1.recorddate
      ,temperature
      ,(SELECT temperature
        FROM weather    
        WHERE recorddate = w1.recorddate -1) prev_day_temperature
FROM
     weather W1
)
WHERE temperature > prev_day_temperature
--End of Solution
