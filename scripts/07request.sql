--Сегменты с временем движения больше среднего
SELECT
    s1.station_name AS from_station,
    s2.station_name AS to_station,
    seg.train_travel_time,
    (SELECT AVG(train_travel_time) FROM Segments) AS avg_travel_time
FROM Segments seg
JOIN Stations s1 ON seg.from_station_id = s1.station_id
JOIN Stations s2 ON seg.to_station_id = s2.station_id
WHERE seg.train_travel_time > (SELECT AVG(train_travel_time) FROM Segments)
ORDER BY seg.train_travel_time DESC;