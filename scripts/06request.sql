--История переименований станций
SELECT
    s.station_name AS current_name,
    sh.old_station_name AS previous_name,
    sh.valid_from,
    sh.valid_to
FROM Stations s
JOIN Station_history sh ON s.station_id = sh.station_id
WHERE sh.valid_to < CURRENT_TIMESTAMP
ORDER BY s.station_name, sh.valid_from DESC;