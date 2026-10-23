--Поезда с их полным маршрутом и временем прибытия
SELECT
    t.train_id,
    l.line_name,
    s.station_name,
    sc.arrival_time,
    LEAD(sc.arrival_time) OVER (PARTITION BY t.train_id ORDER BY sc.arrival_time) AS next_arrival,
    RANK() OVER (PARTITION BY t.line_id ORDER BY t.train_id) AS train_rank_on_line
FROM Trains t
JOIN Lines l ON t.line_id = l.line_id
JOIN Schedules sc ON t.train_id = sc.train_id
JOIN Stations s ON sc.station_id = s.station_id
ORDER BY t.train_id, sc.arrival_time;