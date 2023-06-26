---А) какую сумму в среднем в месяц тратит:
--- пользователи в возрастном диапазоне от 18 до 25 лет включительно
SELECT
    MONTH(P.date) AS month, -- Выбираем месяц из даты и присваиваем псевдоним "month"
    SUM(I.price) / COUNT(DISTINCT U.userId) AS average_price -- Вычисляем среднюю цену покупки для каждого месяца и присваиваем псевдоним "month" 
FROM
    Users U -- Таблица пользователей
JOIN
    Purchases P ON U.userId = P.userId -- Соединяем таблицу пользователей с таблицей покупок по идентификатору пользователя
JOIN
    Items I ON P.itemId = I.itemId -- Соединяем таблицу покупок с таблицей товаров по идентификатору товара
WHERE
    U.age > 18 AND U.age <= 25 -- Фильтруем пользователей в возрасте от 19 до 25 лет
GROUP BY
    month -- Группируем результаты по месяцу
ORDER BY
    month; -- Сортируем результаты по возрастанию месяца
    
    
---- пользователи в возрастном диапазоне от 26 до 35 лет включительно

SELECT MONTH(P.date) AS month, SUM(I.price) / COUNT(DISTINCT U.userId) AS average_price
FROM Users U
JOIN Purchases P ON U.userId = P.userId
JOIN Items I ON P.itemId = I.itemId
WHERE U.age > 26 AND U.age <= 35
GROUP BY month
ORDER BY month;



---Б) в каком месяце года выручка от пользователей в возрастном диапазоне 35+ самая большая
SELECT
    MONTH(P.date) AS month, -- Выбираем месяц из даты покупки и присваиваем его псевдоним "month"
    SUM(I.price) AS total_price -- Вычисляем сумму цен на товары и присваиваем ей псевдоним "total_price"
FROM
    Users U
JOIN
    Purchases P ON U.userId = P.userId -- Соединяем таблицу Users с таблицей Purchases по полю userId
JOIN
    Items I ON P.itemId = I.itemId -- Соединяем таблицу Purchases с таблицей Items по полю itemId
WHERE
    U.age > 35 -- Выбираем только пользователей, возраст которых больше 35
GROUP BY
    MONTH(P.date) -- Группируем результаты по месяцу покупки
ORDER BY
    total_price DESC -- Сортируем результаты по общей сумме цен в убывающем порядке
LIMIT 1; -- Возвращаем только первую запись (наибольшую сумму цен)


---В) какой товар обеспечивает дает наибольший вклад в выручку за последний год 
SELECT p.itemId, ROUND(SUM(i.price), 2) AS total_revenue -- Выбираем itemId и округляем общую сумму до двух знаков после запятой
FROM Purchases p
JOIN Items i ON p.itemId = i.itemId
WHERE p.date >= DATE_SUB(CURDATE(), INTERVAL 1 YEAR) -- Фильтруем записи за последний год
GROUP BY p.itemId -- Группируем записи по itemId
ORDER BY total_revenue DESC -- Сортируем по убыванию общей суммы выручки
LIMIT 1; -- Ограничиваем результат одной записью с наибольшей выручкой



---Г) топ-3 товаров по выручке и их доля в общей выручке за любой год
SELECT p.itemId, COUNT(p.itemId) AS purchaseCount, 
       ROUND(i.price * COUNT(p.itemId), 2) AS totalValue, -- Вычисление общей стоимости с округлением до 2 десятичных знаков
       ROUND((i.price * COUNT(p.itemId)) / SUM(i.price * COUNT(p.itemId)) OVER(), 2) AS share -- Вычисление доли с округлением до 2 десятичных знаков
FROM Purchases p
JOIN Items i ON p.itemId = i.itemId
WHERE YEAR(p.date) = 2022 -- Фильтрация записей по году 2022
GROUP BY p.itemId -- Группировка результатов по itemId
ORDER BY totalValue DESC -- Сортировка по убыванию общей стоимости
LIMIT 3; -- Ограничение результатов только 3 самыми большими значениями





