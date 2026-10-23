--Станции без переходов
SELECT s.station_name, l.line_name
FROM Stations s
JOIN Lines l ON s.line_id = l.line_id
LEFT JOIN Transitions t ON s.station_id = t.from_station_id OR s.station_id = t.to_station_id
WHERE t.transition_id IS NULL
ORDER BY l.line_name, s.order_on_line;