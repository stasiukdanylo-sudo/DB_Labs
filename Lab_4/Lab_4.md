# Лабораторна робота №4: Аналітичні SQL-запити (OLAP)

## 1. SQL-скрипт аналітичних запитів
### 1.1 Агрегація та групування даних
-- Запит 1: Загальна статистика щодо треків (кількість, середня та максимальна ціна)
```sql
SELECT 
    COUNT(*) AS total_tracks, 
    ROUND(AVG(rental_price), 2) AS average_price, 
    MAX(duration) AS longest_track_seconds
FROM TRACK;
```
<img width="641" height="453" alt="Lab_4 (10)" src="https://github.com/user-attachments/assets/d29b8f3c-1c39-4660-89b1-8d2e2bf5df0d" />

-- Запит 2: Кількість треків у кожному жанрі
```sql
SELECT genre_id, COUNT(*) AS tracks_in_genre
FROM TRACK
GROUP BY genre_id;
```
<img width="566" height="532" alt="Lab_4 (9)" src="https://github.com/user-attachments/assets/253348d6-650f-4569-980a-f86d83fce6ef" />

-- Запит 3: Загальна вартість прокату всіх пісень для кожного альбому
```sql
SELECT album_id, SUM(rental_price) AS total_album_rental_cost
FROM TRACK
GROUP BY album_id;
```
<img width="724" height="514" alt="Lab_4 (8)" src="https://github.com/user-attachments/assets/e29a3a33-e16b-449d-bcf3-7c7a3d8b0f85" />

-- Запит 4: Жанри, у яких середня вартість прокату треку вища за 1.40
```sql
SELECT genre_id, AVG(rental_price) AS avg_price
FROM TRACK
GROUP BY genre_id
HAVING AVG(rental_price) > 1.40;
```
<img width="601" height="491" alt="Lab_4 (7)" src="https://github.com/user-attachments/assets/c3143b21-9906-42fd-84f0-00a739920bef" />

### 1.2 Використання різних типів JOIN

-- Запит 5: INNER JOIN - Список клієнтів та ID їхніх замовлень
```sql
SELECT c.full_name, r.rental_id, r.start_date
FROM CUSTOMER c
INNER JOIN RENTAL r ON c.customer_id = r.customer_id;
```
<img width="641" height="483" alt="Lab_4 (6)" src="https://github.com/user-attachments/assets/dcc3120e-2db2-4bc9-ab88-76eda117757a" />

-- Запит 6: LEFT JOIN - Усі артисти та їхні альбоми
```sql
SELECT a.name AS artist_name, al.title AS album_title
FROM ARTIST a
LEFT JOIN ALBUM al ON a.artist_id = al.artist_id;
```
<img width="660" height="528" alt="Lab_4 (5)" src="https://github.com/user-attachments/assets/46d0923e-5243-4de4-8f28-ad32195edce8" />

-- Запит 7: RIGHT JOIN - Усі треки та назви їхніх альбомів
```sql
SELECT al.title AS album_title, t.title AS track_title
FROM ALBUM al
RIGHT JOIN TRACK t ON al.album_id = t.album_id;
```
<img width="646" height="576" alt="Lab_4 (4)" src="https://github.com/user-attachments/assets/2167b54d-e92e-48bc-89fa-f818560ba189" />

### 1.3 Запити з підзапитами

-- Запит 8: Підзапит у WHERE — Знайти треки, ціна яких вища за середню по базі
```sql
SELECT title, rental_price 
FROM TRACK 
WHERE rental_price > (SELECT AVG(rental_price) FROM TRACK);
```
<img width="718" height="505" alt="Lab_4 (3)" src="https://github.com/user-attachments/assets/a93b129a-c3f7-49a5-8ad9-e767fd9e95c7" />

-- Запит 9: Підзапит у SELECT — Вивести клієнтів та кількість зроблених ними оренд
```sql
SELECT c.full_name, 
       (SELECT COUNT(*) FROM RENTAL r WHERE r.customer_id = c.customer_id) AS total_rentals
FROM CUSTOMER c;
```
<img width="1039" height="543" alt="Lab_4 (2)" src="https://github.com/user-attachments/assets/d0ff777a-d461-45b1-af26-cdf5302ccdf5" />

-- Запит 10: Підзапит у WHERE (через IN) — Знайти артистів, які випускали альбоми після 2010 року
```sql
SELECT name, country 
FROM ARTIST 
WHERE artist_id IN (SELECT artist_id FROM ALBUM WHERE release_year > 2010);
```
<img width="868" height="490" alt="Lab_4 (1)" src="https://github.com/user-attachments/assets/943e3f4f-787c-4401-bed9-a00c7b6f3ef1" />

## 2. Опис та інтерпретація результатів

| № | Тип запиту | Що робить запит (простими словами) | Очікуваний результат |
| :-- | :--- | :--- | :--- |
| **1** | **Агрегація** | Рахує скільки всього треків є в базі, яка їх середня ціна та показує найдовший трек. | Один рядок із загальними цифрами статистики (кількість, середня ціна, макс. тривалість). |
| **2** | **GROUP BY** | Групує треки за жанрами та показує, скільки пісень є в кожному стилі. | Список ID жанрів та кількість треків, що до них відносяться. |
| **3** | **GROUP BY** | Рахує сумарну вартість альбому, додаючи ціни всіх його пісень. | Список альбомів із загальною сумою вартості всіх треків у них. |
| **4** | **HAVING** | Показує лише ті жанри, де середня ціна треку перевищує 1.40. | Відфільтрований список "дорогих" жанрів, що пройшли перевірку умови. |
| **5** | **INNER JOIN** | З'єднує клієнтів з їхніми орендами. Показує лише тих, хто реально щось замовляв. | Список імен клієнтів та дат їхніх замовлень (без порожніх записів). |
| **6** | **LEFT JOIN** | Виводить абсолютно всіх артистів із бази. Якщо у когось немає альбому, замість назви буде пусте поле (NULL). | Повний список авторів, включаючи нових артистів без доданих пісень. |
| **7** | **RIGHT JOIN** | Виводить усі треки. Якщо пісня не належить жодному альбому (сингл), назва альбому буде порожньою. | Список усіх пісень із інформацією про альбоми (або NULL для синглів). |
| **8** | **Підзапит у WHERE** | Спочатку рахує середню ціну треку по всій базі, а потім виводить ті пісні, які коштують більше цієї цифри. | Список треків, вартість яких вища за середньоринкову. |
| **9** | **Підзапит у SELECT** | Для кожного клієнта окремо прораховує та додає колонку з кількістю його замовлень прямо в таблицю. | Список клієнтів, де поруч із іменем стоїть кількість зроблених замовлень. |
| **10** | **Підзапит з IN** | Шукає ID сучасних альбомів (після 2010), а потім виводить імена артистів, які їх випустили. | Список імен та країн походження сучасних музикантів. |

## Висновок:

Під час виконання лабораторної роботи №4 я опанував інструменти аналізу даних (OLAP) в СУБД PostgreSQL. Я навчився групувати інформацію за різними критеріями, використовувати фільтрацію груп через HAVING, комбінувати дані з декількох таблиць за допомогою різних типів JOIN та будувати складні звіти через вкладені підзапити. База даних успішно виконує всі аналітичні операції.
