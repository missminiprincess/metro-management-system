

-- Создание временной таблицы с параметрами линий
CREATE TEMPORARY TABLE LineParams AS
SELECT 
    line_id,
    CASE
        WHEN line_id = 5 THEN 57  -- Кольцевая линия
        WHEN line_id = 13 THEN 63 -- МЦК
        ELSE 62                   -- Остальные линии
    END AS full_circle_time,
    CASE
        WHEN line_id = 5 THEN 12  -- Кольцевая
        WHEN line_id = 13 THEN 15 -- МЦК
        ELSE 15                   -- Остальные
    END AS station_count,
    15 AS train_interval
FROM (SELECT DISTINCT line_id FROM Stations) AS lines;

-- Функция генерации расписания
CREATE OR REPLACE FUNCTION generate_metro_schedule()
RETURNS VOID AS $$
DECLARE
    line_record RECORD;
    direction_list TEXT[] := ARRAY['forward', 'backward'];
    direction_text TEXT;
    station_order INT[];
    current_station INT;
    next_station INT;
    travel_time INT;
    arrival_time TIMESTAMP;
    start_time TIMESTAMP := '2023-01-01 06:00:00';
    train_num INT;
    train_offset INTERVAL;
    line_interval INT;
    is_loop BOOLEAN;
    forward_time INT;
    backward_time INT;
    total_cycle_time INT;
    cycle_num INT;
    idx INT;
    train_id_val INT;
BEGIN
    -- Для каждой линии
    FOR line_record IN SELECT line_id FROM LineParams ORDER BY line_id LOOP
        -- Получаем параметры линии
        SELECT train_interval, full_circle_time INTO line_interval, forward_time
        FROM LineParams WHERE line_id = line_record.line_id;

        is_loop := (line_record.line_id = 5 OR line_record.line_id = 13);

        -- Рассчитываем время обратного пути для некольцевых линий
        IF NOT is_loop THEN
            backward_time := 0;
            -- Получаем обратный порядок станций
            SELECT ARRAY(
                SELECT station_id FROM Stations
                WHERE line_id = line_record.line_id
                ORDER BY order_on_line DESC
            ) INTO station_order;

            FOR idx IN 1..(array_length(station_order, 1) - 1) LOOP
                SELECT train_travel_time INTO travel_time
                FROM Segments
                WHERE (from_station_id = station_order[idx] AND to_station_id = station_order[idx+1])
                   OR (to_station_id = station_order[idx] AND from_station_id = station_order[idx+1]);

                backward_time := backward_time + COALESCE(travel_time, 0);
            END LOOP;

            total_cycle_time := forward_time + 2 + backward_time + 2;
        ELSE
            total_cycle_time := forward_time;
        END IF;

        -- Для каждого направления (прямое и обратное)
        FOREACH direction_text IN ARRAY direction_list LOOP
            -- Получаем порядок станций для направления
            IF direction_text = 'forward' THEN
                SELECT ARRAY(
                    SELECT station_id FROM Stations
                    WHERE line_id = line_record.line_id
                    ORDER BY order_on_line
                ) INTO station_order;
            ELSE
                SELECT ARRAY(
                    SELECT station_id FROM Stations
                    WHERE line_id = line_record.line_id
                    ORDER BY order_on_line DESC
                ) INTO station_order;
            END IF;

            -- Генерируем расписание для поездов в каждом направлении
            FOR train_num IN 0..9 LOOP
                -- Смещение для текущего поезда (интервал 15 минут)
                train_offset := (train_num * line_interval * INTERVAL '1 minute');

                -- Получаем ID поезда для данного направления
                SELECT t.train_id INTO train_id_val
                FROM Trains t
                WHERE t.line_id = line_record.line_id
                  AND t.direction::text = direction_text
                LIMIT 1 OFFSET train_num;

                -- Пропускаем если нет поезда
                CONTINUE WHEN train_id_val IS NULL;

                -- Генерация расписания для каждого цикла
                cycle_num := 0;
                WHILE start_time + train_offset + (cycle_num * total_cycle_time * INTERVAL '1 minute') < '2023-01-01 23:59:00' LOOP
                    arrival_time := start_time + train_offset + (cycle_num * total_cycle_time * INTERVAL '1 minute');

                    -- Проходим по всем станциям маршрута
                    FOR idx IN 1..array_length(station_order, 1) LOOP
                        current_station := station_order[idx];

                        -- Записываем прибытие на станцию
                        INSERT INTO Schedules (train_id, station_id, arrival_time)
                        VALUES (train_id_val, current_station, arrival_time);
                        
                        -- Если не последняя станция, добавляем время стоянки и движения
                        IF idx < array_length(station_order, 1) THEN
                            next_station := station_order[idx + 1];
                            
                            -- 2 минуты стоянки
                            arrival_time := arrival_time + INTERVAL '2 minutes';
                            
                            -- Время движения до следующей станции
                            SELECT train_travel_time INTO travel_time
                            FROM Segments
                            WHERE (from_station_id = current_station AND to_station_id = next_station)
                               OR (to_station_id = current_station AND from_station_id = next_station);
                            
                            arrival_time := arrival_time + COALESCE(travel_time, 0) * INTERVAL '1 minute';
                        END IF;
                    END LOOP;
                    
                    -- Для некольцевых линий добавляем время возврата
                    IF NOT is_loop THEN
                        -- 2 минуты стоянки на конечной
                        arrival_time := arrival_time + INTERVAL '2 minutes';
                        
                        -- Движение обратно без остановок
                        arrival_time := arrival_time + backward_time * INTERVAL '1 minute';
                        
                        -- 2 минуты стоянки на начальной
                        arrival_time := arrival_time + INTERVAL '2 minutes';
                    END IF;
                    
                    cycle_num := cycle_num + 1;
                END LOOP;
            END LOOP;
        END LOOP;
    END LOOP;
END;
$$ LANGUAGE plpgsql;

-- Выполнение функции генерации расписания
SELECT generate_metro_schedule();

-- Удаление временной таблицы
DROP TABLE IF EXISTS LineParams;