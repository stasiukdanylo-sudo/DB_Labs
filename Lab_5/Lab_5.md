# Лабораторна робота №5: Нормалізація бази даних

## 1. Пошук надлишковості та аномалій

Під час аналізу початкової концепції бази даних було виявлено, що зберігання даних у форматі "широкої таблиці" призводить до таких проблем:
* **Надлишковість:** Назва країни артиста та назва альбому повторюються для кожного треку.
* **Аномалія вставки:** Ми не можемо додати нового артиста в базу, поки він не випустить хоча б один трек.
* **Аномалія оновлення:** Якщо артист змінює назву, доведеться редагувати сотні рядків із треками.
* **Аномалія видалення:** Видалення останнього треку виконавця призведе до повного зникнення інформації про самого виконавця з бази.



## 2. Функціональні залежності

Для забезпечення цілісності в 3NF було визначено такі функціональні залежності:
1.  **artist_id** → `name`, `country` (визначає артиста)
2.  **album_id** → `title`, `release_year`, `artist_id` (альбом належить конкретному артисту)
3.  **track_id** → `title`, `duration`, `rental_price`, `album_id`, `genre_id` (трек належить альбому та жанру)
4.  **customer_id** → `full_name`, `email` (визначає клієнта)
5.  **rental_id** → `start_date`, `end_date`, `customer_id` (заголовок операції оренди)


## 3. Покрокове пояснення нормалізації

### Крок 1: Перша нормальна форма (1NF)
**Умова:** Атомарність атрибутів.
**Дія:** Кожне поле в таблицях містить лише одне значення. Наприклад, ми не записуємо кілька жанрів у поле `genre_name` через кому. Кожен трек має свій унікальний `track_id`.

### Крок 2: Друга нормальна форма (2NF)
**Умова:** Відповідність 1NF та відсутність часткових залежностей.
**Дія:** У таблиці зв’язку `RENTAL_ITEM` ми маємо складений ключ `(rental_id, track_id)`. Ми переконалися, що в цій таблиці немає назви треку або ціни, які залежать лише від `track_id`. Всі дані про трек винесені в окрему таблицю `TRACK`.

### Крок 3: Третя нормальна форма (3NF)
**Умова:** Відповідність 2NF та відсутність транзитивних залежностей.
**Дія:** Ми виявили транзитивну залежність: `track_id -> album_id -> artist_id`. 
Щоб виправити це, ми прибрали `artist_id` з таблиці `TRACK`. Тепер трек посилається тільки на альбом, а вже альбом посилається на артиста. Таким чином, неключові атрибути залежать лише від первинного ключа своєї таблиці.


## 4. SQL DDL Скрипт переробленої схеми (3NF)

```sql

-- Видалення існуючих таблиць
DROP TABLE IF EXISTS RENTAL_ITEM CASCADE;
DROP TABLE IF EXISTS RENTAL CASCADE;
DROP TABLE IF EXISTS TRACK CASCADE;
DROP TABLE IF EXISTS GENRE CASCADE;
DROP TABLE IF EXISTS ALBUM CASCADE;
DROP TABLE IF EXISTS ARTIST CASCADE;
DROP TABLE IF EXISTS CUSTOMER CASCADE;

-- 1. Таблиця артистів
CREATE TABLE ARTIST (
    artist_id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    country VARCHAR(100)
);

-- 2. Таблиця альбомів
CREATE TABLE ALBUM (
    album_id SERIAL PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    release_year INTEGER,
    artist_id INTEGER NOT NULL REFERENCES ARTIST(artist_id) ON DELETE CASCADE
);

-- 3. Таблиця жанрів
CREATE TABLE GENRE (
    genre_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE
);

-- 4. Таблиця треків (3NF: посилання тільки на альбом та жанр)
CREATE TABLE TRACK (
    track_id SERIAL PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    duration INTEGER CHECK (duration > 0),
    rental_price NUMERIC(10, 2) NOT NULL,
    album_id INTEGER REFERENCES ALBUM(album_id) ON DELETE SET NULL,
    genre_id INTEGER REFERENCES GENRE(genre_id) ON DELETE SET NULL
);

-- 5. Таблиця клієнтів
CREATE TABLE CUSTOMER (
    customer_id SERIAL PRIMARY KEY,
    full_name VARCHAR(255) NOT NULL,
    email VARCHAR(150) NOT NULL UNIQUE
);

-- 6. Таблиця оренди
CREATE TABLE RENTAL (
    rental_id SERIAL PRIMARY KEY,
    start_date DATE DEFAULT CURRENT_DATE,
    end_date DATE NOT NULL,
    customer_id INTEGER NOT NULL REFERENCES CUSTOMER(customer_id) ON DELETE CASCADE,
    CONSTRAINT check_dates CHECK (end_date >= start_date)
);

-- 7. Таблиця зв'язку оренди та треків
CREATE TABLE RENTAL_ITEM (
    rental_id INTEGER NOT NULL REFERENCES RENTAL(rental_id) ON DELETE CASCADE,
    track_id INTEGER NOT NULL REFERENCES TRACK(track_id) ON DELETE CASCADE,
    PRIMARY KEY (rental_id, track_id)
);
```
## 5. ER-схема після нормалізації
<img width="693" height="927" alt="Untitled" src="https://github.com/user-attachments/assets/e0a19c5c-ef2d-421f-b6b2-1559081f1221" />


## Висновок:
В результаті нормалізації було створено структуру, що відповідає 3NF. Це дозволило усунути надлишковість даних та захистити базу від аномалій при маніпулюванні даними. Кожен факт (назва артиста, назва альбому, дані клієнта) тепер зберігається в базі рівно один раз.
