--Среднее время движения между станциями по линиям
SELECT
    l.line_name,
    AVG(seg.train_travel_time) AS avg_travel_time,
    MIN(seg.train_travel_time) AS min_travel_time,
    MAX(seg.train_travel_time) AS max_travel_time
FROM Lines l
JOIN Segments seg ON l.line_id = (
    SELECT line_id FROM Stations WHERE station_id = seg.from_station_id
)
GROUP BY l.line_id
HAVING AVG(seg.train_travel_time) > 2
ORDER BY avg_travel_time DESC;