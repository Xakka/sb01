-- CREATE TABLE table1
-- (
--     company_id INTEGER     NULL,
--     acc_numb   VARCHAR(16) NULL,
--     tran_dttm  DATE        NULL,
--     tran_sum   INTEGER     NULL,
--     tran_nazn  VARCHAR(32) NULL
-- );
-- INSERT INTO table1 (company_id, acc_numb, tran_dttm, tran_sum, tran_nazn)
-- VALUES (1, '4******01', '2021-05-10', 18234, 'НДС не облагается'),
--        (1, '4******02', '2021-05-10', 1003000, 'Перевод на свою карту'),
--        (2, '4******40', '2021-05-18', 2000, 'ЗП'),
--        (3, '4******39', '2021-04-18', 50031, 'платеж по зарплате'),
--        (2, '4******40', '2021-04-19', 12335, 'перевод зарплаты'),
--        (4, '4******88', '2021-03-20', 1327, 'ЗАРПЛАТА ЗА ПЕРИОД ***'),
--        (5, '4******33', '2021-04-21', 23452, 'оплата по договору'),
--        (1, '4******01', '2021-03-01', 42367, 'налог'),
--        (1, '4******02', '2021-05-23', 23467, 'перевод на карту');

-- 1
SELECT company_id, DATE_TRUNC('month', tran_dttm) AS month, SUM(tran_sum)
FROM table1
GROUP BY company_id, month
ORDER BY company_id, month;

-- 2
SELECT company_id,
       SUM(tran_sum) AS salary
FROM (SELECT *
      FROM table1
      WHERE tran_dttm >= (SELECT MAX(tran_dttm) FROM table1) - INTERVAL
          '3 month'
        AND LOWER(tran_nazn) SIMILAR TO '%(зарплат|зп)%') AS m
GROUP BY company_id
HAVING SUM(tran_sum) >= 200000;

-- 3
SELECT *
FROM (SELECT acc_numb, MAX(tran_dttm)
      FROM (SELECT *
            FROM table1
            WHERE table1.tran_dttm >= DATE '2021-05-01'
              AND table1.tran_dttm < DATE '2021-06-01' + INTERVAL '1 MONTH')
      GROUP BY acc_numb) AS m
         LEFT JOIN table1 AS t
                   ON t.tran_dttm = m.max AND t.acc_numb = m.acc_numb;


-- 4
SELECT DATE_TRUNC('month', tran_dttm) AS month, SUM(tran_sum)
FROM table1
GROUP BY DATE_TRUNC('month', tran_dttm)
ORDER BY month DESC
LIMIT 3;