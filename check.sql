-- Индексы
EXPLAIN ANALYZE
SELECT * FROM Stations
WHERE station_name LIKE 'Киев%';

 EXPLAIN ANALYZE
SELECT train_id, arrival_time
FROM Schedules
WHERE station_id = 123
AND arrival_time >= '2023-01-01 10:00:00'
ORDER BY arrival_time;

--Триггеры
INSERT INTO Stations (line_id, station_name, order_on_line)
VALUES (1, 'Тестовая станция', 1);

-- Ожидаемый результат: Ошибка "Order value 1 is already used..."

INSERT INTO Schedules (train_id, station_id, arrival_time)
VALUES (1, 1, '2023-01-01 06:00:00'),
       (1, 2, '2023-01-01 05:00:00');

-- Ожидаемый результат: Ошибка "Arrival time must be after previous station arrival time"


-- Проверка процедуры update_station_name
SELECT station_name FROM Stations WHERE station_id = 15;

-- 2. Выполняем процедуру
CALL update_station_name(15, 'Новое имя станции', '2023-01-01 00:00:00');

-- 3. Проверяем изменение имени
SELECT station_name FROM Stations WHERE station_id = 15;

-- Проверка функций
SELECT calculate_travel_time('Белорусская', 'Маяковская', 'Замоскворецкая') AS travel_time_minutes;

SELECT * FROM find_next_train('Белорусская', 'Замоскворецкая', '2023-01-01 12:00:00');

-- Проверка представления "Расписание станций с пересадками"
SELECT * FROM station_schedule_with_transfers
WHERE station_name = 'Белорусская'
ORDER BY arrival_time
LIMIT 5;

-- Проверка представления "Статистика по линиям метро"
SELECT * FROM line_statistics
WHERE line_name = 'Кольцевая';

-- Проверка анализа
python3 analysis/metro_analysis.py

        -- Вывод всех линий метро
SELECT * FROM Lines;

-- Вывод всех станций метро
SELECT * FROM Stations;

-- Вывод всей истории изменений названий станций
SELECT * FROM Station_history;

-- Вывод всех поездов
SELECT * FROM Trains;

-- Вывод всего расписания
SELECT * FROM Schedules;

-- Вывод всех перегонов между станциями
SELECT * FROM Segments;

-- Вывод всех переходов между линиями
SELECT * FROM Transitions;