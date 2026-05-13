# Лабораторна робота №2: Перетворення ER-діаграми на схему PostgreSQL

## 1. SQL DDL та DML запити

Код для створення таблиць та їх заповнення тестовими даними.
```sql
DROP TABLE IF EXISTS RENTAL_ITEM;
DROP TABLE IF EXISTS RENTAL;
DROP TABLE IF EXISTS TRACK;
DROP TABLE IF EXISTS GENRE;
DROP TABLE IF EXISTS ALBUM;
DROP TABLE IF EXISTS ARTIST;
DROP TABLE IF EXISTS CUSTOMER;

CREATE TABLE ARTIST (
    artist_id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    country VARCHAR(100)
);

CREATE TABLE ALBUM (
    album_id SERIAL PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    release_year INTEGER CHECK (release_year > 1800),
    artist_id INTEGER NOT NULL REFERENCES ARTIST(artist_id) ON DELETE CASCADE
);

CREATE TABLE GENRE (
    genre_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE TRACK (
    track_id SERIAL PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    duration INTEGER NOT NULL CHECK (duration > 0),
    rental_price NUMERIC(10, 2) NOT NULL CHECK (rental_price >= 0),
    album_id INTEGER REFERENCES ALBUM(album_id) ON DELETE SET NULL,
    genre_id INTEGER REFERENCES GENRE(genre_id) ON DELETE SET NULL
);

CREATE TABLE CUSTOMER (
    customer_id SERIAL PRIMARY KEY,
    full_name VARCHAR(255) NOT NULL,
    email VARCHAR(150) NOT NULL UNIQUE
);

CREATE TABLE RENTAL (
    rental_id SERIAL PRIMARY KEY,
    start_date DATE NOT NULL DEFAULT CURRENT_DATE,
    end_date DATE NOT NULL,
    customer_id INTEGER NOT NULL REFERENCES CUSTOMER(customer_id) ON DELETE CASCADE,
    CONSTRAINT check_dates CHECK (end_date >= start_date)
);

CREATE TABLE RENTAL_ITEM (
    rental_id INTEGER NOT NULL REFERENCES RENTAL(rental_id) ON DELETE CASCADE,
    track_id INTEGER NOT NULL REFERENCES TRACK(track_id) ON DELETE CASCADE,
    PRIMARY KEY (rental_id, track_id)
);

INSERT INTO ARTIST (name, country) VALUES
('Linkin Park', 'USA'),
('The Weeknd', 'Canada'),
('Океан Ельзи', 'Ukraine');

INSERT INTO ALBUM (title, release_year, artist_id) VALUES
('Hybrid Theory', 2000, 1),
('After Hours', 2020, 2),
('Суперсиметрія', 2003, 3);

INSERT INTO GENRE (name) VALUES
('Rock'),
('Pop'),
('R&B');

INSERT INTO TRACK (title, duration, rental_price, album_id, genre_id) VALUES
('In the End', 216, 1.50, 1, 1),
('Blinding Lights', 200, 2.00, 2, 2),
('Майже весна', 182, 1.20, 3, 1),
('Save Your Tears', 215, 1.80, 2, 3),
('Crawling', 209, 1.50, 1, 1);

INSERT INTO CUSTOMER (full_name, email) VALUES
('Іван Петренко', 'ivan.p@kpi.ua'),
('Марія Ковальчук', 'mariya.k@gmail.com'),
('Олексій Швець', 'shvets@outlook.com');

INSERT INTO RENTAL (start_date, end_date, customer_id) VALUES
('2026-05-01', '2026-05-08', 1),
('2026-05-10', '2026-05-15', 2),
('2026-05-12', '2026-05-14', 3);

INSERT INTO RENTAL_ITEM (rental_id, track_id) VALUES
(1, 1),
(1, 5),
(2, 2),
(2, 4),
(3, 3);
```
## 2. Короткий опис схеми та обмежень

Створена реляційна схема базується на принципах цілісності даних:

- Первинні ключі (Primary Keys): Унікально ідентифікують кожен рядок у всіх таблицях.

- Зовнішні ключі (Foreign Keys): Забезпечують зв'язки між таблицями (наприклад, ARTIST до ALBUM). Використано ON DELETE CASCADE для автоматичного видалення залежних записів.

- Обмеження (Constraints):

  CHECK гарантує, що ціни та тривалість треків не можуть бути від'ємними.

  UNIQUE запобігає дублюванню електронних адрес клієнтів.

  NOT NULL забезпечує обов'язковість заповнення критично важливих полів.

## 3. Результати

<img width="934" height="605" alt="Lab_2_Artists" src="https://github.com/user-attachments/assets/15288eb6-3dbc-4767-aa71-a2121617b1d1" />

<img width="772" height="587" alt="Lab_2_Albums" src="https://github.com/user-attachments/assets/153bf88b-da97-4f75-9a25-4242800ed951" />

<img width="815" height="557" alt="Lab_2_Genre" src="https://github.com/user-attachments/assets/83f7212d-76ae-406c-a6b1-4a6912ab5cac" />

<img width="810" height="611" alt="Lab_2_Track" src="https://github.com/user-attachments/assets/1ee709bf-cda6-4cbd-858f-be48509f23e9" />

<img width="764" height="568" alt="Lab_2_Customer" src="https://github.com/user-attachments/assets/b20c31bb-facc-46b7-a548-9f3363037b45" />

<img width="744" height="555" alt="Lab_2_Rental" src="https://github.com/user-attachments/assets/6673d30f-054c-4761-9697-c3e06a169d4e" />

<img width="728" height="608" alt="Lab_2_Rental_item" src="https://github.com/user-attachments/assets/08402548-05df-4854-9783-d66ae548360c" />

## Висновок

Під час виконання лабораторної роботи №2 було практично реалізовано реляційну модель у PostgreSQL. Використання DDL-інструкцій дозволило побудувати надійну структуру з усіма необхідними зв'язками, а DML-запити наповнили базу даними для тестування. Всі обмеження цілісності працюють коректно.
