--Полный список станций Кольцевой линии
SELECT
    s.station_id,
    s.station_name,
    s.order_on_line AS station_order,
    l.line_name,
    l.color
FROM
    Stations s
JOIN
    Lines l ON s.line_id = l.line_id
WHERE
    s.line_id = 5
ORDER BY
    s.order_on_line;