-- Создаём ENUM тип для направления движения поездов
CREATE TYPE train_direction AS ENUM ('forward', 'backward');

-- Таблица: Lines (Линии метро)
CREATE TABLE Lines (
    line_id SERIAL PRIMARY KEY,
    line_name VARCHAR(100) NOT NULL,
    color VARCHAR(7) CHECK (color ~ '^#[0-9A-Fa-f]{6}$')
);

-- Таблица: Stations (Станции метро)
CREATE TABLE Stations (
    station_id SERIAL PRIMARY KEY,
    line_id INTEGER NOT NULL REFERENCES Lines(line_id),
    station_name VARCHAR(200) NOT NULL,
    order_on_line INTEGER NOT NULL CHECK (order_on_line > 0),
    UNIQUE (line_id, order_on_line)
);

-- Таблица: Station_history (История станций)
CREATE TABLE Station_history (
    history_id SERIAL PRIMARY KEY,
    station_id INTEGER NOT NULL REFERENCES Stations(station_id),
    old_station_name VARCHAR(200) NOT NULL,
    valid_from TIMESTAMP NOT NULL,
    valid_to TIMESTAMP NOT NULL,
    CHECK (valid_from < valid_to)
);

-- Таблица: Trains (Поезда) с использованием ENUM
CREATE TABLE Trains (
    train_id SERIAL PRIMARY KEY,
    line_id INTEGER NOT NULL REFERENCES Lines(line_id),
    direction train_direction NOT NULL
);

-- Таблица: Schedules (Расписание)
CREATE TABLE Schedules (
    schedule_id SERIAL PRIMARY KEY,
    train_id INTEGER NOT NULL REFERENCES Trains(train_id),
    station_id INTEGER NOT NULL REFERENCES Stations(station_id),
    arrival_time TIMESTAMP NOT NULL
);

-- Таблица: Segments (Перегоны между станциями)
CREATE TABLE Segments (
    segment_id SERIAL PRIMARY KEY,
    from_station_id INTEGER NOT NULL REFERENCES Stations(station_id),
    to_station_id INTEGER NOT NULL REFERENCES Stations(station_id),
    train_travel_time INTEGER NOT NULL CHECK (train_travel_time > 0),
    CHECK (from_station_id <> to_station_id)
);

-- Таблица: Transitions (Переходы между линиями)
CREATE TABLE Transitions (
    transition_id SERIAL PRIMARY KEY,
    from_station_id INTEGER NOT NULL REFERENCES Stations(station_id),
    to_station_id INTEGER NOT NULL REFERENCES Stations(station_id),
    walk_time INTEGER NOT NULL CHECK (walk_time > 0),
    CHECK (from_station_id <> to_station_id)
);

-- Создаём триггерную функцию для проверки Segments
CREATE OR REPLACE FUNCTION validate_segment_line()
RETURNS TRIGGER AS $$
BEGIN
    IF (SELECT line_id FROM Stations WHERE station_id = NEW.from_station_id) <>
       (SELECT line_id FROM Stations WHERE station_id = NEW.to_station_id) THEN
        RAISE EXCEPTION 'Сегмент должен соединять станции одной линии';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Создаём триггер для Segments
CREATE TRIGGER segment_line_check
BEFORE INSERT OR UPDATE ON Segments
FOR EACH ROW EXECUTE FUNCTION validate_segment_line();

-- Создаём триггерную функцию для проверки Transitions
CREATE OR REPLACE FUNCTION validate_transition_line()
RETURNS TRIGGER AS $$
BEGIN
    IF (SELECT line_id FROM Stations WHERE station_id = NEW.from_station_id) =
       (SELECT line_id FROM Stations WHERE station_id = NEW.to_station_id) THEN
        RAISE EXCEPTION 'Переход должен соединять станции разных линий';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Создаём триггер для Transitions
CREATE TRIGGER transition_line_check
BEFORE INSERT OR UPDATE ON Transitions
FOR EACH ROW EXECUTE FUNCTION validate_transition_line();