--Функция для расчета времени пути между двумя станциями
CREATE OR REPLACE FUNCTION calculate_travel_time(
    start_station_name VARCHAR(200),
    end_station_name VARCHAR(200),
    p_line_name VARCHAR(100)
) RETURNS INT AS $$
DECLARE
    total_time INT := 0;
    current_station INT;
    next_station INT;
    segment_time INT;
    station_order INT[];
    start_station_id INT;
    end_station_id INT;
    target_line_id INT;
BEGIN
    -- Находим ID линии по названию
    SELECT line_id INTO target_line_id
    FROM Lines
    WHERE Lines.line_name = p_line_name;

    IF target_line_id IS NULL THEN
        RAISE EXCEPTION 'Линия "%" не найдена', p_line_name;
    END IF;

    -- Находим station_id для начальной станции
    SELECT station_id INTO start_station_id
    FROM Stations
    WHERE station_name = start_station_name
    AND line_id = target_line_id;

    IF start_station_id IS NULL THEN
        RAISE EXCEPTION 'Станция "%" не найдена на линии "%"', start_station_name, p_line_name;
    END IF;

    -- Находим station_id для конечной станции
    SELECT station_id INTO end_station_id
    FROM Stations
    WHERE station_name = end_station_name
    AND line_id = target_line_id;

    IF end_station_id IS NULL THEN
        RAISE EXCEPTION 'Станция "%" не найдена на линии "%"', end_station_name, p_line_name;
    END IF;

    -- Получаем порядок станций на линии
    SELECT ARRAY(
        SELECT station_id FROM Stations
        WHERE line_id = target_line_id
        ORDER BY order_on_line
    ) INTO station_order;

    IF station_order IS NULL OR array_length(station_order, 1) = 0 THEN
        RAISE EXCEPTION 'На линии "%" нет станций', p_line_name;
    END IF;

    -- Находим позиции станций в массиве
    FOR i IN 1..array_length(station_order, 1) LOOP
        IF station_order[i] = start_station_id THEN
            current_station := i;
        END IF;
        IF station_order[i] = end_station_id THEN
            next_station := i;
        END IF;
    END LOOP;

    -- Проверяем, что обе станции найдены
    IF current_station IS NULL OR next_station IS NULL THEN
        RAISE EXCEPTION 'Ошибка: не удалось определить позиции станций "%" и "%" на линии "%"',
              start_station_name, end_station_name, p_line_name;
    END IF;

    -- Определяем направление движения
    IF current_station < next_station THEN
        -- Движение вперед
        FOR i IN current_station..next_station-1 LOOP
            SELECT train_travel_time INTO segment_time
            FROM Segments
            WHERE from_station_id = station_order[i]
            AND to_station_id = station_order[i+1];

            total_time := total_time + COALESCE(segment_time, 0);
            -- Добавляем время стоянки (2 минуты на каждой станции, кроме последней)
            IF i < next_station-1 THEN
                total_time := total_time + 2;
            END IF;
        END LOOP;
    ELSE
        -- Движение назад
        FOR i IN next_station..current_station-1 LOOP
            SELECT train_travel_time INTO segment_time
            FROM Segments
            WHERE from_station_id = station_order[i+1]
            AND to_station_id = station_order[i];

            total_time := total_time + COALESCE(segment_time, 0);
            -- Добавляем время стоянки (2 минуты на каждой станции, кроме последней)
            IF i < current_station-1 THEN
                total_time := total_time + 2;
            END IF;
        END LOOP;
    END IF;

    RETURN total_time;
END;
$$ LANGUAGE plpgsql;

--Функция для поиска ближайшего поезда до указанной станции
CREATE OR REPLACE FUNCTION find_next_train(
    p_station_name VARCHAR(200),
    p_line_name VARCHAR(100),
    search_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) RETURNS TABLE(
    train_id INT,
    arrival_time TIMESTAMP,
    direction train_direction,
    line_name VARCHAR(100),
    line_color VARCHAR(7),
    minutes_until_arrival INT
) AS $$
DECLARE
    target_station_id INT;
    target_line_id INT;
BEGIN
    -- Находим ID линии по названию
    SELECT line_id INTO target_line_id
    FROM Lines
    WHERE Lines.line_name = p_line_name;

    IF target_line_id IS NULL THEN
        RAISE EXCEPTION 'Линия "%" не найдена', p_line_name;
    END IF;

    -- Находим station_id для станции
    SELECT station_id INTO target_station_id
    FROM Stations
    WHERE station_name = p_station_name
    AND line_id = target_line_id;

    IF target_station_id IS NULL THEN
        RAISE EXCEPTION 'Станция "%" не найдена на линии "%"', p_station_name, p_line_name;
    END IF;

    -- Выполняем основной запрос
    RETURN QUERY
    SELECT
        sch.train_id,
        sch.arrival_time,
        t.direction,
        l.line_name,
        l.color AS line_color,
        (EXTRACT(EPOCH FROM (sch.arrival_time - search_time))/60)::INT AS minutes_until_arrival
    FROM Schedules sch
    JOIN Trains t ON sch.train_id = t.train_id
    JOIN Stations s ON sch.station_id = s.station_id
    JOIN Lines l ON s.line_id = l.line_id
    WHERE sch.station_id = target_station_id
    AND sch.arrival_time >= search_time
    ORDER BY sch.arrival_time
    LIMIT 5;
END;
$$ LANGUAGE plpgsql;


--Процедура для обновления имени станции с сохранением истории
CREATE OR REPLACE PROCEDURE update_station_name(
    station_id INT,
    new_name VARCHAR(200),
    change_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) AS $$
BEGIN
    -- Закрываем текущую запись в истории
    UPDATE Station_history
    SET valid_to = change_time
    WHERE Station_history.station_id = $1
    AND valid_to = '9999-12-31 23:59:59';

    -- Добавляем новую запись в историю
    INSERT INTO Station_history (station_id, old_station_name, valid_from, valid_to)
    SELECT
        $1,
        station_name,
        change_time,
        '9999-12-31 23:59:59'
    FROM Stations
    WHERE Stations.station_id = $1;

    -- Обновляем имя станции
    UPDATE Stations
    SET station_name = new_name
    WHERE Stations.station_id = $1;
END;
$$ LANGUAGE plpgsql;