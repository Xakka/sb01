-- CREATE TABLE cur
-- (
--     CURR VARCHAR(3),
--     DT   DATE,
--     VAL  REAL
-- );
--
-- INSERT INTO cur
-- VALUES ('USD', TO_DATE('24.10.2019', 'DD.MM.YYYY'), 63.7997);
-- INSERT INTO cur
-- VALUES ('USD', TO_DATE('25.10.2019', 'DD.MM.YYYY'), 63.8600);
-- INSERT INTO cur
-- VALUES ('USD', TO_DATE('26.10.2019', 'DD.MM.YYYY'), 63.9966);
-- INSERT INTO cur
-- VALUES ('USD', TO_DATE('29.10.2019', 'DD.MM.YYYY'), 69.8700);
-- INSERT INTO cur
-- VALUES ('USD', TO_DATE('30.10.2019', 'DD.MM.YYYY'), 63.8320);
-- INSERT INTO cur
-- VALUES ('USD', TO_DATE('31.10.2019', 'DD.MM.YYYY'), 63.8734);
-- INSERT INTO cur
-- VALUES ('EUR', TO_DATE('24.10.2019', 'DD.MM.YYYY'), 70.9644);
-- INSERT INTO cur
-- VALUES ('EUR', TO_DATE('25.10.2019', 'DD.MM.YYYY'), 71.1400);
-- INSERT INTO cur
-- VALUES ('EUR', TO_DATE('26.10.2019', 'DD.MM.YYYY'), 71.1194);
-- INSERT INTO cur
-- VALUES ('EUR', TO_DATE('29.10.2019', 'DD.MM.YYYY'), 70.8382);
-- INSERT INTO cur
-- VALUES ('EUR', TO_DATE('30.10.2019', 'DD.MM.YYYY'), 70.7769);
-- INSERT INTO cur
-- VALUES ('EUR', TO_DATE('31.10.2019', 'DD.MM.YYYY'), 71.0081);


-- Дополнительный (без последнего дня)
WITH main AS (SELECT c.curr, c.dt as DT_FROM, min(a.dt) as VAL_FROM
              FROM cur AS c
                       LEFT JOIN cur AS a USING (curr)
              WHERE c.dt < a.dt
              GROUP BY c.curr, c.dt)
SELECT *
FROM main
         FULL JOIN cur USING (curr)
WHERE main.VAL_FROM = cur.dt
ORDER BY 1, 2;


-- Основной вариант
SELECT curr,
       dt                                                                                           AS dt_from,
       val                                                                                          AS val_from,
       (SELECT min(dt) FROM cur WHERE dt > m.dt)                                                    AS dt_to,
       (SELECT val FROM cur WHERE dt = (SELECT MIN(dt) FROM cur WHERE dt > m.dt) AND curr = m.curr) AS val
FROM cur AS m
ORDER BY 1, 2;