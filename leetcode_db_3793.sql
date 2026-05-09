-- please scroll to bottom for solution
-- question is presented "as is" from leetcode. 
-- Question difficulty on leetcode is marked as "medium"
-- Solution was developed indepently by myself
-- link to problem is : https://leetcode.com/problems/find-users-with-high-token-usage/

--Start of problem ;
/*
Table: prompts

+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| user_id     | int     |
| prompt      | varchar |
| tokens      | int     |
+-------------+---------+
(user_id, prompt) is the primary key (unique value) for this table.
Each row represents a prompt submitted by a user to an AI system along with the number of tokens consumed.
Write a solution to analyze AI prompt usage patterns based on the following requirements:

For each user, calculate the total number of prompts they have submitted.
For each user, calculate the average tokens used per prompt (Rounded to 2 decimal places).
Only include users who have submitted at least 3 prompts.
Only include users who have submitted at least one prompt with tokens greater than their own average token usage.
Return the result table ordered by average tokens in descending order, and then by user_id in ascending order.

The result format is in the following example.

 

Example:

Input:

prompts table:

+---------+--------------------------+--------+
| user_id | prompt                   | tokens |
+---------+--------------------------+--------+
| 1       | Write a blog outline     | 120    |
| 1       | Generate SQL query       | 80     |
| 1       | Summarize an article     | 200    |
| 2       | Create resume bullet     | 60     |
| 2       | Improve LinkedIn bio     | 70     |
| 3       | Explain neural networks  | 300    |
| 3       | Generate interview Q&A   | 250    |
| 3       | Write cover letter       | 180    |
| 3       | Optimize Python code     | 220    |
+---------+--------------------------+--------+
Output:

+---------+---------------+------------+
| user_id | prompt_count  | avg_tokens |
+---------+---------------+------------+
| 3       | 4             | 237.5      |
| 1       | 3             | 133.33     |
+---------+---------------+------------+
Explanation:

User 1:
Total prompts = 3
Average tokens = (120 + 80 + 200) / 3 = 133.33
Has a prompt with 200 tokens, which is greater than the average
Included in the result
User 2:
Total prompts = 2 (less than the required minimum)
Excluded from the result
User 3:
Total prompts = 4
Average tokens = (300 + 250 + 180 + 220) / 4 = 237.5
Has prompts with 300 and 250 tokens, both greater than the average
Included in the result
The Results table is ordered by avg_tokens in descending order, then by user_id in ascending order
*/
--end of problem;
--
--
--Start of Solution
/* Write your PL/SQL query statement below */
SELECT
         user_id
        ,count(prompt)        prompt_count
        ,round(avg(tokens),2) avg_tokens
FROM prompts
WHERE user_id IN (SELECT user_id 
                  FROM prompts p
                  WHERE tokens > (select avg(tokens)
                                  from prompts t
                                  where p.user_id = t.user_id
                                 )
                 )
GROUP BY 
         user_id
HAVING count(*) >= 3 
ORDER BY 3 DESC, 1 ASC;
--End of Solution
