--Расписание станций с пересадками - показывает расписание прибытия поездов с информацией о возможных пересадках:
CREATE OR REPLACE VIEW station_schedule_with_transfers AS
SELECT
    s.station_id,
    s.station_name,
    l.line_name,
    l.color AS line_color,
    sch.arrival_time,
    t.train_id,
    t.direction,
    STRING_AGG(tr.to_station_id::TEXT || '|' ||
               (SELECT station_name FROM Stations WHERE station_id = tr.to_station_id) || '|' ||
               tr.walk_time::TEXT, ',') AS transfer_info
FROM Schedules sch
JOIN Stations s ON sch.station_id = s.station_id
JOIN Lines l ON s.line_id = l.line_id
JOIN Trains t ON sch.train_id = t.train_id
LEFT JOIN Transitions tr ON s.station_id = tr.from_station_id
GROUP BY s.station_id, s.station_name, l.line_name, l.color, sch.arrival_time, t.train_id, t.direction;





--Статистика по линиям метро - агрегированная информация о линия
CREATE OR REPLACE VIEW line_statistics AS
SELECT
    l.line_id,
    l.line_name,
    l.color,
    COUNT(DISTINCT s.station_id) AS station_count,
    COUNT(DISTINCT t.train_id) AS train_count,
    (SELECT SUM(train_travel_time)
     FROM (
       SELECT DISTINCT LEAST(from_station_id, to_station_id), GREATEST(from_station_id, to_station_id), train_travel_time
       FROM Segments
       WHERE from_station_id IN (SELECT station_id FROM Stations WHERE line_id = l.line_id)
          OR to_station_id IN (SELECT station_id FROM Stations WHERE line_id = l.line_id)
     ) AS unique_segments
    ) AS total_travel_time_minutes,
    COUNT(DISTINCT tr.transition_id) AS transfer_count
FROM Lines l
LEFT JOIN Stations s ON l.line_id = s.line_id
LEFT JOIN Trains t ON l.line_id = t.line_id
LEFT JOIN Transitions tr ON tr.from_station_id IN (SELECT station_id FROM Stations WHERE line_id = l.line_id)
GROUP BY l.line_id, l.line_name, l.color;