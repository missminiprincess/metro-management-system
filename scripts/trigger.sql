--Триггер для проверки уникальности порядка станций на линии
CREATE OR REPLACE FUNCTION check_station_order_unique()
RETURNS TRIGGER AS $$
BEGIN
    IF EXISTS (
        SELECT 1 FROM Stations
        WHERE line_id = NEW.line_id
        AND order_on_line = NEW.order_on_line
        AND station_id != NEW.station_id
    ) THEN
        RAISE EXCEPTION 'Order value % is already used for another station on this line', NEW.order_on_line;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS station_order_unique ON Stations;
CREATE TRIGGER station_order_unique
BEFORE INSERT OR UPDATE ON Stations
FOR EACH ROW EXECUTE FUNCTION check_station_order_unique();

-- Триггерная функция для проверки времени перехода между станциями
CREATE OR REPLACE FUNCTION validate_transition_time()
RETURNS TRIGGER AS $$
DECLARE
    from_line_id INT;
    to_line_id INT;
BEGIN
    -- Получаем линии для станций перехода
    SELECT line_id INTO from_line_id FROM Stations WHERE station_id = NEW.from_station_id;
    SELECT line_id INTO to_line_id FROM Stations WHERE station_id = NEW.to_station_id;

    -- Проверяем, что станции принадлежат разным линиям
    IF from_line_id = to_line_id THEN
        RAISE EXCEPTION 'Переход должен соединять станции разных линий';
    END IF;

    -- Проверяем, что время перехода разумное (от 1 до 15 минут)
    IF NEW.walk_time < 1 OR NEW.walk_time > 15 THEN
        RAISE EXCEPTION 'Время перехода должно быть от 1 до 15 минут';
    END IF;

    -- Проверяем, что не создается дубликат перехода (в любом направлении)
    IF EXISTS (
        SELECT 1 FROM Transitions
        WHERE (from_station_id = NEW.from_station_id AND to_station_id = NEW.to_station_id)
        OR (from_station_id = NEW.to_station_id AND to_station_id = NEW.from_station_id)
    ) THEN
        RAISE EXCEPTION 'Переход между этими станциями уже существует';
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Создаем триггер для проверки перед вставкой или обновлением
DROP TRIGGER IF EXISTS check_transition_before_insert ON Transitions;
CREATE TRIGGER check_transition_before_insert
BEFORE INSERT OR UPDATE ON Transitions
FOR EACH ROW EXECUTE FUNCTION validate_transition_time();

--Триггер для проверки корректности времени в расписании
CREATE OR REPLACE FUNCTION validate_schedule_time()
RETURNS TRIGGER AS $$
DECLARE
    prev_arrival TIMESTAMP;
    next_arrival TIMESTAMP;
BEGIN
    -- Проверяем, что время прибытия не в прошлом
    IF NEW.arrival_time < CURRENT_TIMESTAMP THEN
        RAISE EXCEPTION 'Arrival time cannot be in the past';
    END IF;

    -- Проверяем, что время прибытия больше предыдущей станции для этого поезда
    SELECT MAX(arrival_time) INTO prev_arrival
    FROM Schedules
    WHERE train_id = NEW.train_id
    AND arrival_time < NEW.arrival_time;

    IF prev_arrival IS NOT NULL AND NEW.arrival_time <= prev_arrival THEN
        RAISE EXCEPTION 'Arrival time must be after previous station arrival time';
    END IF;

    -- Проверяем, что время прибытия меньше следующей станции для этого поезда
    SELECT MIN(arrival_time) INTO next_arrival
    FROM Schedules
    WHERE train_id = NEW.train_id
    AND arrival_time > NEW.arrival_time;

    IF next_arrival IS NOT NULL AND NEW.arrival_time >= next_arrival THEN
        RAISE EXCEPTION 'Arrival time must be before next station arrival time';
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS schedule_time_validation ON Schedules;
CREATE TRIGGER schedule_time_validation
BEFORE INSERT OR UPDATE ON Schedules
FOR EACH ROW EXECUTE FUNCTION validate_schedule_time();