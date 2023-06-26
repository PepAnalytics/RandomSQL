import mysql.connector
import random
from datetime import datetime, timedelta

# Создаем подключение к локальной базе данных MySQL
conn = mysql.connector.connect(
    host="localhost",
    user="root",
    password="Qwerty123",
    database="preview_test")
cursor = conn.cursor()

# Создаем таблицу Items
cursor.execute('''CREATE TABLE IF NOT EXISTS Items
                  (itemId INT PRIMARY KEY,
                  price FLOAT)''')

# Создаем таблицу Users
cursor.execute('''CREATE TABLE IF NOT EXISTS Users
                  (userId INT PRIMARY KEY,
                  age INT)''')

# Создаем таблицу Purchases
cursor.execute('''CREATE TABLE IF NOT EXISTS Purchases
                  (purchaseId INT PRIMARY KEY,
                  userId INT,
                  itemId INT,
                  date DATE,
                  FOREIGN KEY (userId) REFERENCES Users(userId),
                  FOREIGN KEY (itemId) REFERENCES Items(itemId))''')

# Генерируем случайные данные для таблиц Users и Items
users_data = [(i, random.randint(20, 50)) for i in range(1, 101)]
items_data = [(i, round(random.uniform(5.0, 50.0), 2)) for i in range(1, 36)]

# Заполняем таблицы Users и Items
cursor.executemany("INSERT INTO Users VALUES (%s, %s)", users_data)
cursor.executemany("INSERT INTO Items VALUES (%s, %s)", items_data)

# Заполняем таблицу Purchases случайными данными
purchases_data = []
start_date = datetime.now() - timedelta(days=3 * 365)  # Начальная дата - 3 года назад

for i in range(1, 101):  # Создаем 100 покупок
    purchase_id = i
    user_id = random.randint(1, 40)  # Выбираем случайного пользователя (user_id ограничен до 40)
    item_id = random.randint(1, 35)  # Выбираем случайный товар (itemId ограничен до 35)
    random_days = random.randint(0, 3 * 365)  # Случайное количество дней от начальной даты
    date = start_date + timedelta(days=random_days)  # Случайная дата за последние 3 года
    purchases_data.append((purchase_id, user_id, item_id, date))

cursor.executemany("INSERT INTO Purchases VALUES (%s, %s, %s, %s)", purchases_data)

# Сохраняем изменения и закрываем соединение
conn.commit()
conn.close()
