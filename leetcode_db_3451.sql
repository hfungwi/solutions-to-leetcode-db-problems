-- please scroll to bottom for solution
-- question is presented "as is" from leetcode. 
-- Question difficulty on leetcode is marked as "Hard"
-- Solution was developed indepently by myself
-- link to problem is : https://leetcode.com/problems/find-invalid-ip-addresses/description/

--Start of problem ;
/*
Table:  logs

+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| log_id      | int     |
| ip          | varchar |
| status_code | int     |
+-------------+---------+
log_id is the unique key for this table.
Each row contains server access log information including IP address and HTTP status code.
Write a solution to find invalid IP addresses. An IPv4 address is invalid if it meets any of these conditions:

Contains numbers greater than 255 in any octet
Has leading zeros in any octet (like 01.02.03.04)
Has less or more than 4 octets
Return the result table ordered by invalid_count, ip in descending order respectively. 

The result format is in the following example.

 

Example:

Input:

logs table:

+--------+---------------+-------------+
| log_id | ip            | status_code | 
+--------+---------------+-------------+
| 1      | 192.168.1.1   | 200         | 
| 2      | 256.1.2.3     | 404         | 
| 3      | 192.168.001.1 | 200         | 
| 4      | 192.168.1.1   | 200         | 
| 5      | 192.168.1     | 500         | 
| 6      | 256.1.2.3     | 404         | 
| 7      | 192.168.001.1 | 200         | 
+--------+---------------+-------------+
Output:

+---------------+--------------+
| ip            | invalid_count|
+---------------+--------------+
| 256.1.2.3     | 2            |
| 192.168.001.1 | 2            |
| 192.168.1     | 1            |
+---------------+--------------+
Explanation:

256.1.2.3 is invalid because 256 > 255
192.168.001.1 is invalid because of leading zeros
192.168.1 is invalid because it has only 3 octets
The output table is ordered by invalid_count, ip in descending order respectively.
*/
--end of problem;
--
--
--Start of Solution
/* Write your PL/SQL query statement below */
WITH log_dot_postions AS (
    SELECT
        log_id,
        instr(ip, '.', 1, 1)   first_dot_pos,
        instr(ip,
              '.',
              instr(ip, '.', 1, 1) + 1,
              1)               second_dot_position,
        TO_NUMBER(decode(instr(ip,
                               '.',
                               instr(ip,
                                     '.',
                                     instr(ip, '.', 1, 1) + 1,
                                     1) + 1,
                               1),
                         0,
                         NULL,
                         instr(ip,
                               '.',
                               instr(ip,
                                     '.',
                                     instr(ip, '.', 1, 1) + 1,
                                     1) + 1,
                               1)))              third_dot_position,
        TO_NUMBER(decode(instr(ip, '.', 1, 4),
                         0,
                         NULL,
                         instr(ip, '.', 1, 4))) fourth_dot_position,
        instr(ip, '.', - 1, 1) last_dot_position
    FROM
        logs
), log_octets AS (
    SELECT
        l.log_id,
        substr(l.ip, 1, ldp.first_dot_pos - 1)                                                           octet_1,
        substr(l.ip, ldp.first_dot_pos + 1,(ldp.second_dot_position - ldp.first_dot_pos) - 1)            octet_2,
        substr(l.ip, ldp.second_dot_position + 1,(ldp.third_dot_position - ldp.second_dot_position) - 1) octet_3,
        substr(l.ip, ldp.third_dot_position + 1,(ldp.fourth_dot_position - ldp.third_dot_position) - 1)  octet_4,
        substr(l.ip, ldp.last_dot_position + 1)                                                          last_octet
    FROM
             logs l
        INNER JOIN log_dot_postions ldp ON l.log_id = ldp.log_id
), log_octets_2 AS (
    SELECT
        log_id,
        octet_1,
        octet_2,
        octet_3,
        CASE
            WHEN octet_4 IS NULL THEN
                last_octet
            ELSE
                octet_4
        END AS octet_4,
        CASE
            WHEN octet_4 IS NULL THEN
                NULL
            ELSE
                last_octet
        END AS octet_5
    FROM
        log_octets
)
SELECT
    l.ip,
    COUNT(*) invalid_count
FROM
         logs l
    INNER JOIN log_octets_2 lo ON l.log_id = lo.log_id
WHERE
    ( TO_NUMBER(lo.octet_1) > 255
      OR TO_NUMBER(lo.octet_2) > 255
      OR TO_NUMBER(lo.octet_3) > 255
      OR TO_NUMBER(lo.octet_4) > 255 )
    OR ( substr(lo.octet_1, 1, 1) = '0'
         OR substr(lo.octet_2, 1, 1) = '0'
         OR substr(lo.octet_3, 1, 1) = '0'
         OR substr(lo.octet_4, 1, 1) = '0' )
    OR ( lo.octet_1 IS NULL
         OR lo.octet_2 IS NULL
         OR lo.octet_3 IS NULL
         OR lo.octet_4 IS NULL )
    OR ( lo.octet_5 IS NOT NULL )
GROUP BY
    l.ip
ORDER BY
    invalid_count DESC,
    l.ip DESC
--End of Solution
