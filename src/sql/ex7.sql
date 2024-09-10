-- CREATE TABLE pdcl
-- (
--     dt       date       NULL,
--     customer int4       NULL,
--     deal     int4       NULL,
--     currency varchar(4) NULL,
--     sum_op   int4       NULL
-- );
-- INSERT INTO pdcl (dt, customer, deal, currency, sum_op)
-- VALUES ('2009-12-12', 111110, 111111, 'RUR', 12000),
--        ('2009-12-25', 111110, 111111, 'RUR', 5000),
--        ('2009-12-12', 111110, 122222, 'RUR', 10000),
--        ('2010-01-12', 111110, 111111, 'RUR', -10100),
--        ('2009-11-20', 220000, 222221, 'RUR', 25000),
--        ('2009-12-20', 220000, 222221, 'RUR', -25000),
--        ('2009-12-21', 220000, 222221, 'RUR', 20000),
--        ('2009-12-29', 111110, 122222, 'RUR', -10000);

-- CREATE OR REPLACE function find_debt(IN current date DEFAULT current_date)
--     RETURNS TABLE
--             (
--                 deal int,
--                 debt int
--             )
-- AS
-- $$
-- SELECT DISTINCT deal, (SELECT sum(sum_op) FROM pdcl WHERE p.deal = deal and dt <= current GROUP BY deal)
-- FROM pdcl as p
-- where dt <= current;
-- $$
--     LANGUAGE SQL;
--
-- SELECT *
-- FROM find_debt();


CREATE OR REPLACE FUNCTION find_debt(IN current DATE DEFAULT current_date)
    RETURNS TABLE
            (
                deal   INT,
                dt     DATE,
                debt   INT,
                days_s REAL
            )
AS
$$
WITH m AS (SELECT deal,
                  dt,
                  (SELECT SUM(sum_op) AS debt FROM pdcl WHERE p.deal = deal AND p.dt <= dt),
                  SUM(sum_op) OVER (PARTITION BY deal) AS all_debt
           FROM pdcl AS p
           WHERE p.dt <= current),
     a AS (SELECT deal, max(dt) as dt, debt
           FROM m
           WHERE m.debt > 0
             AND debt = all_debt
           GROUP BY deal, m.debt)
SELECT *,
       (SELECT current - dt) as days
FROM a;
$$
    LANGUAGE SQL;

SELECT *
FROM find_debt();


-- SELECT *
-- FROM find_debt('2009-12-25');