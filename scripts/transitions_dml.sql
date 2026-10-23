
-- Вставка данных о переходах между станциями с одинаковыми названиями
INSERT INTO Transitions (from_station_id, to_station_id, walk_time) VALUES
-- Белорусская (линии 2, 5, 8)
((SELECT station_id FROM Stations WHERE station_name = 'Белорусская' AND line_id = 2),
 (SELECT station_id FROM Stations WHERE station_name = 'Белорусская' AND line_id = 5), 3),
((SELECT station_id FROM Stations WHERE station_name = 'Белорусская' AND line_id = 5),
 (SELECT station_id FROM Stations WHERE station_name = 'Белорусская' AND line_id = 2), 3),
((SELECT station_id FROM Stations WHERE station_name = 'Белорусская' AND line_id = 2),
 (SELECT station_id FROM Stations WHERE station_name = 'Белорусская' AND line_id = 8), 3),
((SELECT station_id FROM Stations WHERE station_name = 'Белорусская' AND line_id = 8),
 (SELECT station_id FROM Stations WHERE station_name = 'Белорусская' AND line_id = 2), 3),
((SELECT station_id FROM Stations WHERE station_name = 'Белорусская' AND line_id = 5),
 (SELECT station_id FROM Stations WHERE station_name = 'Белорусская' AND line_id = 8), 3),
((SELECT station_id FROM Stations WHERE station_name = 'Белорусская' AND line_id = 8),
 (SELECT station_id FROM Stations WHERE station_name = 'Белорусская' AND line_id = 5), 3),

-- Ботанический сад (линии 6, 13, 14)
((SELECT station_id FROM Stations WHERE station_name = 'Ботанический сад' AND line_id = 6),
 (SELECT station_id FROM Stations WHERE station_name = 'Ботанический сад' AND line_id = 13), 4),
((SELECT station_id FROM Stations WHERE station_name = 'Ботанический сад' AND line_id = 13),
 (SELECT station_id FROM Stations WHERE station_name = 'Ботанический сад' AND line_id = 6), 4),
((SELECT station_id FROM Stations WHERE station_name = 'Ботанический сад' AND line_id = 6),
 (SELECT station_id FROM Stations WHERE station_name = 'Ботанический сад' AND line_id = 14), 4),
((SELECT station_id FROM Stations WHERE station_name = 'Ботанический сад' AND line_id = 14),
 (SELECT station_id FROM Stations WHERE station_name = 'Ботанический сад' AND line_id = 6), 4),
((SELECT station_id FROM Stations WHERE station_name = 'Ботанический сад' AND line_id = 13),
 (SELECT station_id FROM Stations WHERE station_name = 'Ботанический сад' AND line_id = 14), 4),
((SELECT station_id FROM Stations WHERE station_name = 'Ботанический сад' AND line_id = 14),
 (SELECT station_id FROM Stations WHERE station_name = 'Ботанический сад' AND line_id = 13), 4),

-- Владыкино (линии 9, 13, 14)
((SELECT station_id FROM Stations WHERE station_name = 'Владыкино' AND line_id = 9),
 (SELECT station_id FROM Stations WHERE station_name = 'Владыкино' AND line_id = 13), 5),
((SELECT station_id FROM Stations WHERE station_name = 'Владыкино' AND line_id = 13),
 (SELECT station_id FROM Stations WHERE station_name = 'Владыкино' AND line_id = 9), 5),
((SELECT station_id FROM Stations WHERE station_name = 'Владыкино' AND line_id = 9),
 (SELECT station_id FROM Stations WHERE station_name = 'Владыкино' AND line_id = 14), 5),
((SELECT station_id FROM Stations WHERE station_name = 'Владыкино' AND line_id = 14),
 (SELECT station_id FROM Stations WHERE station_name = 'Владыкино' AND line_id = 9), 5),
((SELECT station_id FROM Stations WHERE station_name = 'Владыкино' AND line_id = 13),
 (SELECT station_id FROM Stations WHERE station_name = 'Владыкино' AND line_id = 14), 5),
((SELECT station_id FROM Stations WHERE station_name = 'Владыкино' AND line_id = 14),
 (SELECT station_id FROM Stations WHERE station_name = 'Владыкино' AND line_id = 13), 5),

-- Киевская (линии 3, 4, 5)
((SELECT station_id FROM Stations WHERE station_name = 'Киевская' AND line_id = 3),
 (SELECT station_id FROM Stations WHERE station_name = 'Киевская' AND line_id = 4), 3),
((SELECT station_id FROM Stations WHERE station_name = 'Киевская' AND line_id = 4),
 (SELECT station_id FROM Stations WHERE station_name = 'Киевская' AND line_id = 3), 3),
((SELECT station_id FROM Stations WHERE station_name = 'Киевская' AND line_id = 3),
 (SELECT station_id FROM Stations WHERE station_name = 'Киевская' AND line_id = 5), 3),
((SELECT station_id FROM Stations WHERE station_name = 'Киевская' AND line_id = 5),
 (SELECT station_id FROM Stations WHERE station_name = 'Киевская' AND line_id = 3), 3),
((SELECT station_id FROM Stations WHERE station_name = 'Киевская' AND line_id = 4),
 (SELECT station_id FROM Stations WHERE station_name = 'Киевская' AND line_id = 5), 3),
((SELECT station_id FROM Stations WHERE station_name = 'Киевская' AND line_id = 5),
 (SELECT station_id FROM Stations WHERE station_name = 'Киевская' AND line_id = 4), 3),

-- Парк культуры (линии 1, 5, 11)
((SELECT station_id FROM Stations WHERE station_name = 'Парк культуры' AND line_id = 1),
 (SELECT station_id FROM Stations WHERE station_name = 'Парк культуры' AND line_id = 5), 4),
((SELECT station_id FROM Stations WHERE station_name = 'Парк культуры' AND line_id = 5),
 (SELECT station_id FROM Stations WHERE station_name = 'Парк культуры' AND line_id = 1), 4),
((SELECT station_id FROM Stations WHERE station_name = 'Парк культуры' AND line_id = 1),
 (SELECT station_id FROM Stations WHERE station_name = 'Парк культуры' AND line_id = 11), 4),
((SELECT station_id FROM Stations WHERE station_name = 'Парк культуры' AND line_id = 11),
 (SELECT station_id FROM Stations WHERE station_name = 'Парк культуры' AND line_id = 1), 4),
((SELECT station_id FROM Stations WHERE station_name = 'Парк культуры' AND line_id = 5),
 (SELECT station_id FROM Stations WHERE station_name = 'Парк культуры' AND line_id = 11), 4),
((SELECT station_id FROM Stations WHERE station_name = 'Парк культуры' AND line_id = 11),
 (SELECT station_id FROM Stations WHERE station_name = 'Парк культуры' AND line_id = 5), 4),

-- Проспект Мира (линии 5, 6, 14)
((SELECT station_id FROM Stations WHERE station_name = 'Проспект Мира' AND line_id = 5),
 (SELECT station_id FROM Stations WHERE station_name = 'Проспект Мира' AND line_id = 6), 3),
((SELECT station_id FROM Stations WHERE station_name = 'Проспект Мира' AND line_id = 6),
 (SELECT station_id FROM Stations WHERE station_name = 'Проспект Мира' AND line_id = 5), 3),
((SELECT station_id FROM Stations WHERE station_name = 'Проспект Мира' AND line_id = 5),
 (SELECT station_id FROM Stations WHERE station_name = 'Проспект Мира' AND line_id = 14), 3),
((SELECT station_id FROM Stations WHERE station_name = 'Проспект Мира' AND line_id = 14),
 (SELECT station_id FROM Stations WHERE station_name = 'Проспект Мира' AND line_id = 5), 3),
((SELECT station_id FROM Stations WHERE station_name = 'Проспект Мира' AND line_id = 6),
 (SELECT station_id FROM Stations WHERE station_name = 'Проспект Мира' AND line_id = 14), 3),
((SELECT station_id FROM Stations WHERE station_name = 'Проспект Мира' AND line_id = 14),
 (SELECT station_id FROM Stations WHERE station_name = 'Проспект Мира' AND line_id = 6), 3),

-- Авиамоторная (линии 8, 15)
((SELECT station_id FROM Stations WHERE station_name = 'Авиамоторная' AND line_id = 8),
 (SELECT station_id FROM Stations WHERE station_name = 'Авиамоторная' AND line_id = 15), 5),
((SELECT station_id FROM Stations WHERE station_name = 'Авиамоторная' AND line_id = 15),
 (SELECT station_id FROM Stations WHERE station_name = 'Авиамоторная' AND line_id = 8), 5),

-- Автозаводская (линии 2, 11)
((SELECT station_id FROM Stations WHERE station_name = 'Автозаводская' AND line_id = 2),
 (SELECT station_id FROM Stations WHERE station_name = 'Автозаводская' AND line_id = 11), 4),
((SELECT station_id FROM Stations WHERE station_name = 'Автозаводская' AND line_id = 11),
 (SELECT station_id FROM Stations WHERE station_name = 'Автозаводская' AND line_id = 2), 4),

-- Алексеевская (линии 6, 14)
((SELECT station_id FROM Stations WHERE station_name = 'Алексеевская' AND line_id = 6),
 (SELECT station_id FROM Stations WHERE station_name = 'Алексеевская' AND line_id = 14), 3),
((SELECT station_id FROM Stations WHERE station_name = 'Алексеевская' AND line_id = 14),
 (SELECT station_id FROM Stations WHERE station_name = 'Алексеевская' AND line_id = 6), 3),

-- Арбатская (линии 3, 4)
((SELECT station_id FROM Stations WHERE station_name = 'Арбатская' AND line_id = 3),
 (SELECT station_id FROM Stations WHERE station_name = 'Арбатская' AND line_id = 4), 2),
((SELECT station_id FROM Stations WHERE station_name = 'Арбатская' AND line_id = 4),
 (SELECT station_id FROM Stations WHERE station_name = 'Арбатская' AND line_id = 3), 2),

-- Бабушкинская (линии 6, 14)
((SELECT station_id FROM Stations WHERE station_name = 'Бабушкинская' AND line_id = 6),
 (SELECT station_id FROM Stations WHERE station_name = 'Бабушкинская' AND line_id = 14), 4),
((SELECT station_id FROM Stations WHERE station_name = 'Бабушкинская' AND line_id = 14),
 (SELECT station_id FROM Stations WHERE station_name = 'Бабушкинская' AND line_id = 6), 4),

-- Бульвар Рокоссовского (линии 1, 13)
((SELECT station_id FROM Stations WHERE station_name = 'Бульвар Рокоссовского' AND line_id = 1),
 (SELECT station_id FROM Stations WHERE station_name = 'Бульвар Рокоссовского' AND line_id = 13), 5),
((SELECT station_id FROM Stations WHERE station_name = 'Бульвар Рокоссовского' AND line_id = 13),
 (SELECT station_id FROM Stations WHERE station_name = 'Бульвар Рокоссовского' AND line_id = 1), 5),

-- ВДНХ (линии 6, 14)
((SELECT station_id FROM Stations WHERE station_name = 'ВДНХ' AND line_id = 6),
 (SELECT station_id FROM Stations WHERE station_name = 'ВДНХ' AND line_id = 14), 3),
((SELECT station_id FROM Stations WHERE station_name = 'ВДНХ' AND line_id = 14),
 (SELECT station_id FROM Stations WHERE station_name = 'ВДНХ' AND line_id = 6), 3),

-- Деловой центр (линии 4, 8)
((SELECT station_id FROM Stations WHERE station_name = 'Деловой центр' AND line_id = 4),
 (SELECT station_id FROM Stations WHERE station_name = 'Деловой центр' AND line_id = 8), 2),
((SELECT station_id FROM Stations WHERE station_name = 'Деловой центр' AND line_id = 8),
 (SELECT station_id FROM Stations WHERE station_name = 'Деловой центр' AND line_id = 4), 2),

-- Дубровка (линии 10, 13)
((SELECT station_id FROM Stations WHERE station_name = 'Дубровка' AND line_id = 10),
 (SELECT station_id FROM Stations WHERE station_name = 'Дубровка' AND line_id = 13), 4),
((SELECT station_id FROM Stations WHERE station_name = 'Дубровка' AND line_id = 13),
 (SELECT station_id FROM Stations WHERE station_name = 'Дубровка' AND line_id = 10), 4),

-- Китай-город (линии 6, 7)
((SELECT station_id FROM Stations WHERE station_name = 'Китай-город' AND line_id = 6),
 (SELECT station_id FROM Stations WHERE station_name = 'Китай-город' AND line_id = 7), 3),
((SELECT station_id FROM Stations WHERE station_name = 'Китай-город' AND line_id = 7),
 (SELECT station_id FROM Stations WHERE station_name = 'Китай-город' AND line_id = 6), 3),

-- Комсомольская (линии 1, 5)
((SELECT station_id FROM Stations WHERE station_name = 'Комсомольская' AND line_id = 1),
 (SELECT station_id FROM Stations WHERE station_name = 'Комсомольская' AND line_id = 5), 3),
((SELECT station_id FROM Stations WHERE station_name = 'Комсомольская' AND line_id = 5),
 (SELECT station_id FROM Stations WHERE station_name = 'Комсомольская' AND line_id = 1), 3),

-- Кропоткинская (линии 1, 11)
((SELECT station_id FROM Stations WHERE station_name = 'Кропоткинская' AND line_id = 1),
 (SELECT station_id FROM Stations WHERE station_name = 'Кропоткинская' AND line_id = 11), 4),
((SELECT station_id FROM Stations WHERE station_name = 'Кропоткинская' AND line_id = 11),
 (SELECT station_id FROM Stations WHERE station_name = 'Кропоткинская' AND line_id = 1), 4),

-- Кунцевская (линии 3, 4)
((SELECT station_id FROM Stations WHERE station_name = 'Кунцевская' AND line_id = 3),
 (SELECT station_id FROM Stations WHERE station_name = 'Кунцевская' AND line_id = 4), 2),
((SELECT station_id FROM Stations WHERE station_name = 'Кунцевская' AND line_id = 4),
 (SELECT station_id FROM Stations WHERE station_name = 'Кунцевская' AND line_id = 3), 2),

-- Курская (линии 3, 5)
((SELECT station_id FROM Stations WHERE station_name = 'Курская' AND line_id = 3),
 (SELECT station_id FROM Stations WHERE station_name = 'Курская' AND line_id = 5), 3),
((SELECT station_id FROM Stations WHERE station_name = 'Курская' AND line_id = 5),
 (SELECT station_id FROM Stations WHERE station_name = 'Курская' AND line_id = 3), 3),

-- Медведково (линии 6, 14)
((SELECT station_id FROM Stations WHERE station_name = 'Медведково' AND line_id = 6),
 (SELECT station_id FROM Stations WHERE station_name = 'Медведково' AND line_id = 14), 4),
((SELECT station_id FROM Stations WHERE station_name = 'Медведково' AND line_id = 14),
 (SELECT station_id FROM Stations WHERE station_name = 'Медведково' AND line_id = 6), 4),

-- Нижегородская (линии 13, 15)
((SELECT station_id FROM Stations WHERE station_name = 'Нижегородская' AND line_id = 13),
 (SELECT station_id FROM Stations WHERE station_name = 'Нижегородская' AND line_id = 15), 5),
((SELECT station_id FROM Stations WHERE station_name = 'Нижегородская' AND line_id = 15),
 (SELECT station_id FROM Stations WHERE station_name = 'Нижегородская' AND line_id = 13), 5),

-- Октябрьская (линии 5, 6)
((SELECT station_id FROM Stations WHERE station_name = 'Октябрьская' AND line_id = 5),
 (SELECT station_id FROM Stations WHERE station_name = 'Октябрьская' AND line_id = 6), 3),
((SELECT station_id FROM Stations WHERE station_name = 'Октябрьская' AND line_id = 6),
 (SELECT station_id FROM Stations WHERE station_name = 'Октябрьская' AND line_id = 5), 3),

-- Павелецкая (линии 2, 5)
((SELECT station_id FROM Stations WHERE station_name = 'Павелецкая' AND line_id = 2),
 (SELECT station_id FROM Stations WHERE station_name = 'Павелецкая' AND line_id = 5), 3),
((SELECT station_id FROM Stations WHERE station_name = 'Павелецкая' AND line_id = 5),
 (SELECT station_id FROM Stations WHERE station_name = 'Павелецкая' AND line_id = 2), 3),

-- Парк Победы (линии 3, 4)
((SELECT station_id FROM Stations WHERE station_name = 'Парк Победы' AND line_id = 3),
 (SELECT station_id FROM Stations WHERE station_name = 'Парк Победы' AND line_id = 4), 2),
((SELECT station_id FROM Stations WHERE station_name = 'Парк Победы' AND line_id = 4),
 (SELECT station_id FROM Stations WHERE station_name = 'Парк Победы' AND line_id = 3), 2),

-- Рижская (линии 6, 10)
((SELECT station_id FROM Stations WHERE station_name = 'Рижская' AND line_id = 6),
 (SELECT station_id FROM Stations WHERE station_name = 'Рижская' AND line_id = 14), 4),
((SELECT station_id FROM Stations WHERE station_name = 'Рижская' AND line_id = 14),
 (SELECT station_id FROM Stations WHERE station_name = 'Рижская' AND line_id = 6), 4),

-- Савёловская (линии 8, 9)
((SELECT station_id FROM Stations WHERE station_name = 'Савёловская' AND line_id = 8),
 (SELECT station_id FROM Stations WHERE station_name = 'Савёловская' AND line_id = 9), 3),
((SELECT station_id FROM Stations WHERE station_name = 'Савёловская' AND line_id = 9),
 (SELECT station_id FROM Stations WHERE station_name = 'Савёловская' AND line_id = 8), 3),

-- Смоленская (линии 3, 4)
((SELECT station_id FROM Stations WHERE station_name = 'Смоленская' AND line_id = 3),
 (SELECT station_id FROM Stations WHERE station_name = 'Смоленская' AND line_id = 4), 2),
((SELECT station_id FROM Stations WHERE station_name = 'Смоленская' AND line_id = 4),
 (SELECT station_id FROM Stations WHERE station_name = 'Смоленская' AND line_id = 3), 2),

-- Спортивная (линии 1, 11)
((SELECT station_id FROM Stations WHERE station_name = 'Спортивная' AND line_id = 1),
 (SELECT station_id FROM Stations WHERE station_name = 'Спортивная' AND line_id = 11), 4),
((SELECT station_id FROM Stations WHERE station_name = 'Спортивная' AND line_id = 11),
 (SELECT station_id FROM Stations WHERE station_name = 'Спортивная' AND line_id = 1), 4),

-- Таганская (линии 5, 7)
((SELECT station_id FROM Stations WHERE station_name = 'Таганская' AND line_id = 5),
 (SELECT station_id FROM Stations WHERE station_name = 'Таганская' AND line_id = 7), 3),
((SELECT station_id FROM Stations WHERE station_name = 'Таганская' AND line_id = 7),
 (SELECT station_id FROM Stations WHERE station_name = 'Таганская' AND line_id = 5), 3),

-- Тимирязевская (линии 9, 14)
((SELECT station_id FROM Stations WHERE station_name = 'Тимирязевская' AND line_id = 9),
 (SELECT station_id FROM Stations WHERE station_name = 'Тимирязевская' AND line_id = 14), 5),
((SELECT station_id FROM Stations WHERE station_name = 'Тимирязевская' AND line_id = 14),
 (SELECT station_id FROM Stations WHERE station_name = 'Тимирязевская' AND line_id = 9), 5),

-- Третьяковская (линии 6, 8)
((SELECT station_id FROM Stations WHERE station_name = 'Третьяковская' AND line_id = 6),
 (SELECT station_id FROM Stations WHERE station_name = 'Третьяковская' AND line_id = 8), 3),
((SELECT station_id FROM Stations WHERE station_name = 'Третьяковская' AND line_id = 8),
 (SELECT station_id FROM Stations WHERE station_name = 'Третьяковская' AND line_id = 6), 3),

-- Фрунзенская (линии 1, 11)
((SELECT station_id FROM Stations WHERE station_name = 'Фрунзенская' AND line_id = 1),
 (SELECT station_id FROM Stations WHERE station_name = 'Фрунзенская' AND line_id = 11), 4),
((SELECT station_id FROM Stations WHERE station_name = 'Фрунзенская' AND line_id = 11),
 (SELECT station_id FROM Stations WHERE station_name = 'Фрунзенская' AND line_id = 1), 4),

-- Шоссе Энтузиастов (линии 8, 13)
((SELECT station_id FROM Stations WHERE station_name = 'Шоссе Энтузиастов' AND line_id = 8),
 (SELECT station_id FROM Stations WHERE station_name = 'Шоссе Энтузиастов' AND line_id = 13), 5),
((SELECT station_id FROM Stations WHERE station_name = 'Шоссе Энтузиастов' AND line_id = 13),
 (SELECT station_id FROM Stations WHERE station_name = 'Шоссе Энтузиастов' AND line_id = 8), 5);