-- please scroll to bottom for solution
-- question is presented "as is" from leetcode. 
-- Question difficulty on leetcode is marked as "medium"
-- Solution was developed indepently by myself
-- link to problem is : https://leetcode.com/problems/find-consistently-improving-employees/

--Start of problem ;
/*
Table: employees

+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| employee_id | int     |
| name        | varchar |
+-------------+---------+
employee_id is the unique identifier for this table.
Each row contains information about an employee.
Table: performance_reviews

+-------------+------+
| Column Name | Type |
+-------------+------+
| review_id   | int  |
| employee_id | int  |
| review_date | date |
| rating      | int  |
+-------------+------+
review_id is the unique identifier for this table.
Each row represents a performance review for an employee. The rating is on a scale of 1-5 where 5 is excellent and 1 is poor.
Write a solution to find employees who have consistently improved their performance over their last three reviews.

An employee must have at least 3 review to be considered
The employee's last 3 reviews must show strictly increasing ratings (each review better than the previous)
Use the most recent 3 reviews based on review_date for each employee
Calculate the improvement score as the difference between the latest rating and the earliest rating among the last 3 reviews
Return the result table ordered by improvement score in descending order, then by name in ascending order.

The result format is in the following example.
Example:

Input:

employees table:

+-------------+----------------+
| employee_id | name           |
+-------------+----------------+
| 1           | Alice Johnson  |
| 2           | Bob Smith      |
| 3           | Carol Davis    |
| 4           | David Wilson   |
| 5           | Emma Brown     |
+-------------+----------------+
performance_reviews table:

+-----------+-------------+-------------+--------+
| review_id | employee_id | review_date | rating |
+-----------+-------------+-------------+--------+
| 1         | 1           | 2023-01-15  | 2      |
| 2         | 1           | 2023-04-15  | 3      |
| 3         | 1           | 2023-07-15  | 4      |
| 4         | 1           | 2023-10-15  | 5      |
| 5         | 2           | 2023-02-01  | 3      |
| 6         | 2           | 2023-05-01  | 2      |
| 7         | 2           | 2023-08-01  | 4      |
| 8         | 2           | 2023-11-01  | 5      |
| 9         | 3           | 2023-03-10  | 1      |
| 10        | 3           | 2023-06-10  | 2      |
| 11        | 3           | 2023-09-10  | 3      |
| 12        | 3           | 2023-12-10  | 4      |
| 13        | 4           | 2023-01-20  | 4      |
| 14        | 4           | 2023-04-20  | 4      |
| 15        | 4           | 2023-07-20  | 4      |
| 16        | 5           | 2023-02-15  | 3      |
| 17        | 5           | 2023-05-15  | 2      |
+-----------+-------------+-------------+--------+
Output:

+-------------+----------------+-------------------+
| employee_id | name           | improvement_score |
+-------------+----------------+-------------------+
| 2           | Bob Smith      | 3                 |
| 1           | Alice Johnson  | 2                 |
| 3           | Carol Davis    | 2                 |
+-------------+----------------+-------------------+
Explanation:

Alice Johnson (employee_id = 1):
Has 4 reviews with ratings: 2, 3, 4, 5
Last 3 reviews (by date): 2023-04-15 (3), 2023-07-15 (4), 2023-10-15 (5)
Ratings are strictly increasing: 3 → 4 → 5
Improvement score: 5 - 3 = 2
Carol Davis (employee_id = 3):
Has 4 reviews with ratings: 1, 2, 3, 4
Last 3 reviews (by date): 2023-06-10 (2), 2023-09-10 (3), 2023-12-10 (4)
Ratings are strictly increasing: 2 → 3 → 4
Improvement score: 4 - 2 = 2
Bob Smith (employee_id = 2):
Has 4 reviews with ratings: 3, 2, 4, 5
Last 3 reviews (by date): 2023-05-01 (2), 2023-08-01 (4), 2023-11-01 (5)
Ratings are strictly increasing: 2 → 4 → 5
Improvement score: 5 - 2 = 3
Employees not included:
David Wilson (employee_id = 4): Last 3 reviews are all 4 (no improvement)
Emma Brown (employee_id = 5): Only has 2 reviews (needs at least 3)
The output table is ordered by improvement_score in descending order, then by name in ascending order.
*/
--end of problem;
--
--
--Start of Solution
WITH valid_employees AS
(
SELECT 
       employee_id, 
       count(review_id) number_of_reviews
FROM   
       performance_reviews 
GROUP BY 
       employee_id
), emp_review_details AS
(
SELECT 
        employee_id
       ,name
       ,review_id
       ,review_date
       ,lag(review_id,1,NULL) OVER (PARTITION BY employee_id ORDER BY review_date) prev_review_id
       ,lag(review_id,2,NULL) OVER (PARTITION BY employee_id ORDER BY review_date) prev_2_review_id
       ,rating
       ,lag(rating,1,NULL) OVER (partition by employee_id ORDER BY review_date) prev_rating 
       ,lag(rating,2,NULL) OVER (partition by employee_id ORDER BY review_date) prev_2_rating
FROM 
       performance_reviews
JOIN   employees         USING (employee_id) 
WHERE employee_id IN (SELECT distinct 
                             employee_id
                      FROM   
                            valid_employees 
                     )
)
SELECT 
       c.employee_id
      ,c.name
      ,c.rating - c.prev_2_rating improvement_score
FROM   
       emp_review_details c
WHERE  (
        c.rating > c.prev_rating 
    AND c.prev_rating > c.prev_2_rating
       )
    AND c.review_id - c.prev_2_review_id = 2
    AND c.review_date = (SELECT 
                               max(review_date)
                        FROM   
                               performance_reviews
                        WHERE  
                               employee_id = c.employee_id
                         )
ORDER BY 
         improvement_score DESC, 
         c.name ASC
--End of Solution
