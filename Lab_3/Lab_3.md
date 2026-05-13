# Лабораторна робота №3: Маніпулювання даними SQL (OLTP)

## 1. SQL-скрипт маніпулювання даними

### 1.1 SELECT - Отримання та фільтрація даних

-- 1. Перегляд усіх треків та їх цін (вибір конкретних стовпців)
```sql
SELECT title, duration, rental_price FROM TRACK;
```
<img width="757" height="616" alt="Lab_3 (11)" src="https://github.com/user-attachments/assets/2183e80c-4028-4f5d-8bb9-8bb06de167c3" />

-- 2. Пошук музики конкретного жанру (наприклад, Rock з ID = 1)
```sql
SELECT title, rental_price FROM TRACK WHERE genre_id = 1;
```
<img width="756" height="586" alt="Lab_3 (10)" src="https://github.com/user-attachments/assets/44d312c5-ad1e-49a2-9ec4-51d160103b57" />

-- 3. Пошук альбомів, випущених після 2010 року
```sql
SELECT title, release_year FROM ALBUM WHERE release_year > 2010;
```
<img width="816" height="502" alt="Lab_3 (9)" src="https://github.com/user-attachments/assets/05ce7953-cc2c-4db0-8712-b21c9ae1bfcb" />

### 1.2 INSERT - Додавання нових записів

-- 1. Реєстрація нового артиста (отримає ID 4)
```sql
INSERT INTO ARTIST (name, country) 
VALUES ('Arctic Monkeys', 'UK');
```
<img width="578" height="540" alt="Lab_3 (7)" src="https://github.com/user-attachments/assets/9271c711-dd9e-47e8-b144-4463515b0526" />

-- 2. Додавання альбому для нового артиста (використовуємо artist_id = 6)
```sql
INSERT INTO ALBUM (title, release_year, artist_id) 
VALUES ('AM', 2013, 6);
```
<img width="670" height="540" alt="Lab_3 (6)" src="https://github.com/user-attachments/assets/bc2c41b6-f3ab-492f-b8f4-85932ea803a1" />

-- 3. Додавання нового клієнта
```sql
INSERT INTO CUSTOMER (full_name, email) 
VALUES ('Дмитро Коваленко', 'dima.k@kpi.ua');
```
<img width="580" height="545" alt="Lab_3 (5)" src="https://github.com/user-attachments/assets/9cf22feb-e4b9-49d3-ae83-9889ff1c6115" />

### 1.3 UPDATE - Зміна існуючих даних

-- 1. Встановлення акційної ціни на трек (наприклад, ID = 1)
```sql
UPDATE TRACK 
SET rental_price = 0.99 
WHERE track_id = 1;
```
<img width="816" height="577" alt="Lab_3 (4)" src="https://github.com/user-attachments/assets/2ad4ca62-0629-416a-8f22-ac2b336e5d5d" />

-- 2. Оновлення електронної пошти клієнта
```sql
UPDATE CUSTOMER 
SET email = 'petrenko_new@kpi.ua' 
WHERE customer_id = 1;
```
<img width="583" height="560" alt="Lab_3 (3)" src="https://github.com/user-attachments/assets/d28b94a8-86c3-4793-86d4-cc8174c886f5" />

### 1.4 DELETE - Видалення даних
Видалення запису про оренду
```sql
DELETE FROM RENTAL_ITEM WHERE rental_id = 3;
DELETE FROM RENTAL WHERE rental_id = 3;
```
<img width="580" height="484" alt="Lab_3 (2)" src="https://github.com/user-attachments/assets/665f1093-00d4-4401-8bf4-4ae1dc9c2bd4" />

### 1.5 Складний JOIN-запит
```sql
SELECT c.full_name AS "Клієнт", t.title AS "Трек"
FROM RENTAL r
JOIN CUSTOMER c ON r.customer_id = c.customer_id
JOIN RENTAL_ITEM ri ON r.rental_id = ri.rental_id
JOIN TRACK t ON ri.track_id = t.track_id;
```
<img width="617" height="536" alt="Lab_3 (1)" src="https://github.com/user-attachments/assets/a39a62b7-cac1-4e60-b837-46c376c558a5" />

## Висновок:
У ході лабораторної роботи було протестовано основні операції маніпулювання даними (DML). Я навчився додавати нові записи, враховуючи зв'язки Foreign Key, оновлювати інформацію за допомогою фільтрів WHERE та безпечно видаляти дані. База даних коректно відпрацьовує OLTP-запити та підтримує цілісність інформації.
