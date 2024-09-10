-- CREATE TABLE Problem_2_Test
-- (
--     ID  INT PRIMARY KEY,
--     FIO VARCHAR(255) NOT NULL
-- );
-- INSERT INTO Problem_2_Test
-- VALUES (1, 'Ivanov A. A.'),
--        (3, 'Ivanov A. B.'),
--        (5, 'Ivanov A. C.'),
--        (7, 'Ivanov A. D.'),
--        (8, 'Ivanov A. E.'),
--        (10, 'Ivanov A. F.');

SELECT *
FROM GENERATE_SERIES((SELECT MIN(id)
                      FROM Problem_2_Test), (SELECT MAX(id)
                                             FROM Problem_2_Test)) AS ID
EXCEPT
SELECT ID
FROM Problem_2_Test
ORDER BY ID
LIMIT 1;