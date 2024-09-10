-- CREATE TABLE test
-- (
--     REPORT_DT
--         date
--         NULL,
--     VALUE
--         int4
--         NULL
-- );
--
-- INSERT INTO test (REPORT_DT, VALUE)
-- VALUES ('2013-02-26', 312),
--        ('2013-03-05', 833),
--        ('2013-03-12', 225),
--        ('2013-03-19', 453),
--        ('2013-03-26', 774),
--        ('2013-04-02', 719),
--        ('2013-04-09', 136),
--        ('2013-04-16', 133),
--        ('2013-04-23', 157),
--        ('2013-04-30', 850),
--        ('2013-05-07', 940),
--        ('2013-05-14', 933),
--        ('2013-05-21', 422),
--        ('2013-05-28', 952),
--        ('2013-06-04', 136),
--        ('2013-06-11', 701);

CREATE OR REPLACE VIEW test2 AS
(
WITH m AS (SELECT value::REAL / 7 AS v,
                  report_dt       AS d1,
                  report_dt - 1   AS d2,
                  report_dt - 2   AS d3,
                  report_dt - 3   AS d4,
                  report_dt - 4   AS d5,
                  report_dt - 5   AS d6,
                  report_dt - 6   AS d7
           FROM test),
     a AS (SELECT v, d1
           FROM m
           UNION
           SELECT v, d2
           FROM m
           UNION
           SELECT v, d3
           FROM m
           UNION
           SELECT v, d4
           FROM m
           UNION
           SELECT v, d5
           FROM m
           UNION
           SELECT v, d6
           FROM m
           UNION
           SELECT v, d7
           FROM m)
SELECT (DATE_TRUNC('month', d1)::DATE + INTERVAL '1 month' - INTERVAL '1 day')::DATE AS txn_month,
       ROUND(SUM(v)::NUMERIC, 2)
FROM a
GROUP BY txn_month
ORDER BY 1
    );

SELECT *
FROM test2;