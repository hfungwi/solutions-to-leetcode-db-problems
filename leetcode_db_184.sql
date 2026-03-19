-- please scroll to bottom for solution
-- question is presented "as is" from leetcode. 
-- Question difficulty on leetcode is marked as "medium"
-- Solution was developed indepently by myself
-- link to problem is : https://leetcode.com/problems/department-highest-salary/description/

--Start of problem ;
/*
Table: Employee

+--------------+---------+
| Column Name  | Type    |
+--------------+---------+
| id           | int     |
| name         | varchar |
| salary       | int     |
| departmentId | int     |
+--------------+---------+
id is the primary key (column with unique values) for this table.
departmentId is a foreign key (reference columns) of the ID from the Department table.
Each row of this table indicates the ID, name, and salary of an employee. It also contains the ID of their department.
 

Table: Department

+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| id          | int     |
| name        | varchar |
+-------------+---------+
id is the primary key (column with unique values) for this table. It is guaranteed that department name is not NULL.
Each row of this table indicates the ID of a department and its name.
 

Write a solution to find employees who have the highest salary in each of the departments.

Return the result table in any order.

The result format is in the following example.

 

Example 1:

Input: 
Employee table:
+----+-------+--------+--------------+
| id | name  | salary | departmentId |
+----+-------+--------+--------------+
| 1  | Joe   | 70000  | 1            |
| 2  | Jim   | 90000  | 1            |
| 3  | Henry | 80000  | 2            |
| 4  | Sam   | 60000  | 2            |
| 5  | Max   | 90000  | 1            |
+----+-------+--------+--------------+
Department table:
+----+-------+
| id | name  |
+----+-------+
| 1  | IT    |
| 2  | Sales |
+----+-------+
Output: 
+------------+----------+--------+
| Department | Employee | Salary |
+------------+----------+--------+
| IT         | Jim      | 90000  |
| Sales      | Henry    | 80000  |
| IT         | Max      | 90000  |
+------------+----------+--------+
Explanation: Max and Jim both have the highest salary in the IT department and Henry has the highest salary in the Sales department.
*/
--end of problem;
--
--
--Start of Solution 1
/* Write your PL/SQL query statement below */
SELECT 
        dept.name department
       ,emp.name  employee
       ,emp.salary
FROM
   (
    SELECT
        e.id        employee_id 
       ,d.id        department_id
       ,dense_rank() over (partition by d.name ORDER BY e.salary DESC) rn
    FROM
        department d, 
        employee e
    WHERE
         e.departmentid = d.id(+)
   ) a
INNER JOIN employee   emp  ON emp.id  = a.employee_id
INNER JOIN department dept ON dept.id = a.department_id
WHERE a.rn = 1
/
--End of Solution 1
--
--
--Start of Solution 2
/* Write your PL/SQL query statement below */
WITH max_dept_sal AS
(SELECT 
      departmentid
      ,max(salary) salary
FROM employee 
GROUP BY departmentid
)
SELECT
        d.name department
       ,e.name employee
       ,e.salary
FROM 
     department d, employee e, max_dept_sal mds
WHERE 
       e.departmentid  = d.id
   AND d.id            = mds.departmentid
   AND e.salary        = mds.salary
ORDER BY 3 DESC
/
--End of Solution 2
