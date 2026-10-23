--Линии и количество станций на них
SELECT l.line_name, COUNT(s.station_id) AS station_count
FROM Lines l
INNER JOIN Stations s ON l.line_id = s.line_id
GROUP BY l.line_id
ORDER BY station_count DESC;