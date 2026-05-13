-- 1. Статистика цін та тривалості треків
SELECT 
    COUNT(*) AS total_tracks, 
    ROUND(AVG(rental_price), 2) AS average_price, 
    MAX(duration) AS longest_track_seconds
FROM TRACK;

-- 2. Кількість треків у кожному жанрі
SELECT genre_id, COUNT(*) AS tracks_in_genre
FROM TRACK
GROUP BY genre_id;

-- 3. Загальна вартість усіх пісень по альбомах
SELECT album_id, SUM(rental_price) AS total_album_value
FROM TRACK
GROUP BY album_id;

-- 4. Жанри, де середня ціна прокату > 1.40
SELECT genre_id, AVG(rental_price) AS avg_price
FROM TRACK
GROUP BY genre_id
HAVING AVG(rental_price) > 1.40;

-- 5. INNER JOIN: Клієнти та їхні замовлення
SELECT c.full_name, r.rental_id, r.start_date
FROM CUSTOMER c
INNER JOIN RENTAL r ON c.customer_id = r.customer_id;

-- 6. LEFT JOIN: Усі артисти
SELECT a.name AS artist_name, al.title AS album_title
FROM ARTIST a
LEFT JOIN ALBUM al ON a.artist_id = al.artist_id;

-- 7. RIGHT JOIN: Усі треки та їхні альбоми
SELECT al.title AS album_title, t.title AS track_title
FROM ALBUM al
RIGHT JOIN TRACK t ON al.album_id = t.album_id;

-- 8. Підзапит у WHERE: Треки, що дорожчі за середню ціну по базі
SELECT title, rental_price 
FROM TRACK 
WHERE rental_price > (SELECT AVG(rental_price) FROM TRACK);

-- 9. Підзапит у SELECT: Список клієнтів та кількість їхніх оренд
SELECT c.full_name, 
       (SELECT COUNT(*) FROM RENTAL r WHERE r.customer_id = c.customer_id) AS total_rentals
FROM CUSTOMER c;

-- 10. Підзапит з IN: Артисти, що мають альбоми після 2010 року
SELECT name, country 
FROM ARTIST 
WHERE artist_id IN (SELECT artist_id FROM ALBUM WHERE release_year > 2010);
