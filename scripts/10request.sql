--Топ-3 самых длинных перехода между станциями
SELECT
    s1.station_name AS station_from,
    s2.station_name AS station_to,
    t.walk_time,
    'transition' AS type
FROM Transitions t
JOIN Stations s1 ON t.from_station_id = s1.station_id
JOIN Stations s2 ON t.to_station_id = s2.station_id
ORDER BY t.walk_time DESC
LIMIT 3;