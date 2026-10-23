--Станции, которые являются пересадочными
SELECT s.station_name, l.line_name
FROM Stations s
JOIN Lines l ON s.line_id = l.line_id
WHERE EXISTS (
    SELECT 1 FROM Transitions t
    WHERE t.from_station_id = s.station_id OR t.to_station_id = s.station_id
)
ORDER BY l.line_name, s.order_on_line;