-- CREATE TABLE ROUTES
-- (
--     ROUTE_ID         INT PRIMARY KEY GENERATED BY DEFAULT AS IDENTITY,
--     ROUTE_START_TIME TIMESTAMP NOT NULL,
--     ROUTE_END_TIME   TIMESTAMP NOT NULL
-- );
--
-- INSERT INTO ROUTES (ROUTE_ID, ROUTE_START_TIME, ROUTE_END_TIME)
--     (SELECT route_id,
--             to_timestamp(ROUTE_START_TIME, 'DD.MM.YYYY HH24:MI::SS'),
--             to_timestamp(ROUTE_END_TIME, 'DD.MM.YYYY HH24:MI::SS')
--      FROM dataset5);

SELECT MAX(
               (SELECT COUNT(*)
                FROM routes
                WHERE route_start_time <= r.route_start_time
                  AND route_end_time > r.route_start_time))
FROM ROUTES AS R;