--Полный список всех переходов между станциями московского метро
SELECT
    t.transition_id,
    s1.station_name AS from_station,
    l1.line_name AS from_line,
    s2.station_name AS to_station,
    l2.line_name AS to_line,
    t.walk_time AS time_minutes
FROM
    Transitions t
JOIN
    Stations s1 ON t.from_station_id = s1.station_id
JOIN
    Lines l1 ON s1.line_id = l1.line_id
JOIN
    Stations s2 ON t.to_station_id = s2.station_id
JOIN
    Lines l2 ON s2.line_id = l2.line_id
ORDER BY
    from_station, to_station;