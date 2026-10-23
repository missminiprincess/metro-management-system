-- Удаляем индексы, если они существуют
DROP INDEX IF EXISTS idx_schedules_station_id_arrival_time;
DROP INDEX IF EXISTS idx_station_name_pattern;

-- Индекс для ускорения поиска маршрутов
CREATE INDEX idx_schedules_station_id_arrival_time ON Schedules (station_id, arrival_time);
-- Индекс для ускорения поиска станций по части имени
CREATE INDEX idx_station_name_pattern ON Stations(station_name varchar_pattern_ops);
