import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
from sqlalchemy import create_engine, text
from sqlalchemy.inspection import inspect
import random
import os

# Подключение к базе данных
engine = create_engine('postgresql://postgres:1202@localhost:5432/metro_db')

# Создание папки analysis, если она не существует
os.makedirs('analysis', exist_ok=True)


## Создание таблицы для пассажиропотока
def create_passenger_stats_table():
    try:
        with engine.connect() as connection:
            connection.execute(text("""
            CREATE TABLE IF NOT EXISTS "PassengerStats" (
                stat_id SERIAL PRIMARY KEY,
                station_id INTEGER NOT NULL REFERENCES Stations(station_id),
                passenger_count INTEGER NOT NULL CHECK (passenger_count > 0),
                measurement_date TIMESTAMP NOT NULL,
                UNIQUE(station_id, measurement_date)
            );
            """))
            connection.commit()
        print("Таблица PassengerStats готова к использованию")
    except Exception as e:
        print(f"Ошибка при создании таблицы: {e}")


## 6a. Генерация и вставка дополнительных данных
def generate_passenger_data():
    try:
        # Проверяем существование таблицы
        create_passenger_stats_table()

        # Получаем список всех станций с информацией о линии
        stations = pd.read_sql("""
        SELECT s.station_id, s.station_name, l.line_name
        FROM Stations s
        JOIN Lines l ON s.line_id = l.line_id
        """, engine)

        # Получаем пересадочные станции (те, что есть в Transitions)
        transfer_stations = pd.read_sql("""
        SELECT DISTINCT from_station_id AS station_id
        FROM Transitions
        """, engine)
        transfer_station_ids = set(transfer_stations['station_id'])

        # Генерируем данные о пассажиропотоке с сильно разной загруженностью
        passenger_data = []
        for _, row in stations.iterrows():
            station_id = row['station_id']
            line_name = row['line_name']

            # Определяем диапазон пассажиропотока
            if station_id in transfer_station_ids:
                passenger_count = random.randint(20000, 50000)
            elif line_name == 'Кольцевая':
                passenger_count = random.randint(10000, 30000)
            else:
                passenger_count = random.randint(500, 5000)

            passenger_data.append({
                'station_id': station_id,
                'passenger_count': passenger_count,
                'measurement_date': pd.to_datetime('2023-06-01')
            })

        # Создаем DataFrame и сохраняем в БД
        passenger_df = pd.DataFrame(passenger_data)
        passenger_df.to_sql('PassengerStats', engine, if_exists='replace', index=False)
        print("Данные о пассажиропотоке успешно добавлены")
    except Exception as e:
        print(f"Ошибка при генерации данных: {e}")


## 6b. Извлечение и агрегация данных
def get_aggregated_data():
    try:
        # Запрос 1: Количество станций на каждой линии
        query1 = """
        SELECT l.line_name, COUNT(s.station_id) as station_count
        FROM Lines l
        LEFT JOIN Stations s ON l.line_id = s.line_id
        GROUP BY l.line_name
        ORDER BY station_count DESC
        """
        station_counts = pd.read_sql(query1, engine)

        # Запрос 2: Среднее время между станциями по линиям
        query2 = """
        SELECT l.line_name, AVG(seg.train_travel_time) as avg_travel_time
        FROM Lines l
        JOIN Stations s ON l.line_id = s.line_id
        JOIN Segments seg ON s.station_id = seg.from_station_id
        GROUP BY l.line_name
        ORDER BY avg_travel_time DESC
        """
        travel_times = pd.read_sql(query2, engine)

        # Запрос 3: Количество пересадок на каждой линии
        query3 = """
        SELECT l.line_name, COUNT(t.transition_id) as transfer_count
        FROM Lines l
        JOIN Stations s ON l.line_id = s.line_id
        JOIN Transitions t ON s.station_id = t.from_station_id
        GROUP BY l.line_name
        ORDER BY transfer_count DESC
        """
        transfer_counts = pd.read_sql(query3, engine)

        return station_counts, travel_times, transfer_counts
    except Exception as e:
        print(f"Ошибка при получении данных: {e}")
        return None, None, None


## 6c. Анализ данных и визуализация
def analyze_and_visualize():
    try:
        print("=== Анализ данных метрополитена ===")
        # Генерируем и загружаем данные
        generate_passenger_data()

        # Получаем агрегированные данные
        station_counts, travel_times, transfer_counts = get_aggregated_data()
        if station_counts is None:
            return

        # Гипотеза 1: Кольцевая линия имеет больше всего станций
        hypothesis1 = station_counts.iloc[0]['line_name'] == 'Кольцевая'
        print(
            f"Гипотеза 1 (Кольцевая линия имеет больше всего станций): {'Подтверждена' if hypothesis1 else 'Опровергнута'}")

        # Гипотеза 2: Среднее время между станции ≈ 2 минуты
        avg_time = travel_times['avg_travel_time'].mean()
        hypothesis2 = 1.8 <= avg_time <= 2.2
        print(
            f"Гипотеза 2 (Среднее время между станциями ≈ 2 мин): {'Подтверждена' if hypothesis2 else 'Опровергнута'} (среднее: {avg_time:.2f} мин)")

        # Проверяем существование таблицы PassengerStats перед анализом
        inspector = inspect(engine)
        if not inspector.has_table('PassengerStats'):
            print("Таблица PassengerStats не существует, пропускаем гипотезу 3")
            return

        # Гипотеза 3: Станции с большим пассажиропотоком имеют больше пересадок
        passenger_stats = pd.read_sql("""
        SELECT s.station_name, ps.passenger_count, COUNT(t.transition_id) as transfer_count
        FROM "PassengerStats" ps
        JOIN Stations s ON ps.station_id = s.station_id
        LEFT JOIN Transitions t ON s.station_id = t.from_station_id
        GROUP BY s.station_name, ps.passenger_count
        """, engine)

        correlation = passenger_stats['passenger_count'].corr(passenger_stats['transfer_count'])
        hypothesis3 = correlation > 0.5
        print(
            f"Гипотеза 3 (Станции с большим пассажиропотоком имеют больше пересадок): {'Подтверждена' if hypothesis3 else 'Опровергнута'} (корреляция: {correlation:.2f})")

        # Визуализация
        plt.style.use('seaborn-v0_8')

        # Визуализация 1: Среднее время между станциями
        plt.figure(figsize=(12, 6))
        sns.lineplot(x='line_name', y='avg_travel_time', data=travel_times, marker='o', color='magenta', linewidth=2, markersize=10)
        plt.title('Среднее время между станциями', fontsize=14)
        plt.xlabel('Линия метро', fontsize=12)
        plt.ylabel('Среднее время (мин)', fontsize=12)
        plt.xticks(rotation=45, ha='right')
        plt.tight_layout()
        plt.savefig('analysis/avg_travel_time.png', dpi=300)

        # Визуализация 2: Топ-5 станций по пассажиропотоку
        plt.figure(figsize=(12, 6))
        top_stations = pd.read_sql("""
        SELECT s.station_name, ps.passenger_count 
        FROM "PassengerStats" ps
        JOIN Stations s ON ps.station_id = s.station_id
        ORDER BY ps.passenger_count DESC
        LIMIT 5
        """, engine)
        sns.barplot(y='station_name', x='passenger_count', hue='station_name', data=top_stations, palette='Blues_d', legend=False)
        plt.title('Топ-5 самых загруженных станций', fontsize=14)
        plt.xlabel('Пассажиропоток (чел/день)', fontsize=12)
        plt.ylabel('Станция', fontsize=12)
        plt.tight_layout()
        plt.savefig('analysis/top_stations_by_passengers.png', dpi=300)

        # Визуализация 3: Количество пересадок по линиям
        plt.figure(figsize=(12, 6))
        sns.scatterplot(x='line_name', y='transfer_count', size='transfer_count', hue='line_name', data=transfer_counts, palette='viridis', legend=False, sizes=(50, 500))
        plt.title('Количество пересадок по линиям метро', fontsize=14)
        plt.xlabel('Линия метро', fontsize=12)
        plt.ylabel('Количество пересадок', fontsize=12)
        plt.xticks(rotation=45, ha='right')
        plt.tight_layout()
        plt.savefig('analysis/transfers_per_line.png', dpi=300)

        print("\nГрафики успешно сохранены в папку analysis:")
        print("- analysis/avg_travel_time.png")
        print("- analysis/top_stations_by_passengers.png")
        print("- analysis/transfers_per_line.png")

    except Exception as e:
        print(f"Ошибка при анализе данных: {e}")


if __name__ == "__main__":
    analyze_and_visualize()