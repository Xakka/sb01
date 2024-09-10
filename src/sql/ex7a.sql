DROP FUNCTION
    IF EXISTS find_debt;
CREATE OR REPLACE FUNCTION find_debt(IN current date DEFAULT current_date)
    RETURNS TABLE
            (
                deal       int,
                debt       int,
                start_date date,
                days       float
            )
AS
$$
WITH m AS (SELECT deal, sum(sum_op) AS debt
           FROM pdcl as p
           WHERE dt <= current
           GROUP BY deal
           HAVING sum(sum_op) > 0)
SELECT deal,
       debt,
       dt,
       (current - dt) AS days
FROM pdcl
         INNER JOIN m USING (deal)
WHERE dt <= current;
$$ LANGUAGE SQL;

SELECT *
FROM find_debt('2009-12-13');


SELECT *
FROM find_debt();

-- ToDo 2. Дата начала текущей просрочки