### Задание 1.
Решил для консистентности сделать объявление табличек по новой (просто без foreign key, чтобы быстрее описать структуру)
Все зпросы описаны ниже: 
```sql
CREATE TABLE book_category (
    ISBN VARCHAR(1024),
    category_id BIGINT
);

CREATE TABLE borrowing (
    reader_id BIGINT,
    ISBN VARCHAR(1024),
    copy_id BIGINT,
    return_date DATE
);

CREATE Table copies (
    ISBN VARCHAR(1024),
    copy_number BIGSERIAL PRIMARY KEY,
    shelf_pos INT
);

CREATE TABLE categories (
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR(1024),
    parent_id BIGINT
);

CREATE TABLE publisher (
    pub_name VARCHAR(1024) PRIMARY KEY,
    pub_address VARCHAR(1024)
);

CREATE Table readers (
    id BIGSERIAL PRIMARY KEY,
    last_name VARCHAR(1024),
    first_name VARCHAR(1024),
    address VARCHAR(1024),
    birth_date DATE
);

CREATE TABLE books (
    ISBN VARCHAR(1024) PRIMARY KEY,
    title VARCHAR(1024),
    author VARCHAR(1024),
    page_number INT,
    pub_year INT,
    pub_name VARCHAR(1024)
);

-- а) Какие фамилии читателей в Москве? <br>
select * from readers where address ~ 'Moscow';

-- Какие книги (author, title) брал Иван Иванов? <br>
select
    b.author,
    b.title
from borrowing bo
join readers r on bo.reader_id = r.id
join books b on b.isbn=bo.isbn
where r.first_name='Иван' and r.last_name='Иванов';

-- Какие книги (ISBN) из категории "Горы" не относятся к категории "Путешествия"? Подкатегории не обязательно принимать во внимание! <br>
select
    distinct bk.isbn
from book_category bk
join categories c on c.id = bk.category_id
where c.name = 'Горы'
and bk.ISBN not in (
    select ISBN
    from book_category bk
    join categories c on c.id = bk.category_id
    where c.name='Путешествия'
);

-- Какие читатели (LastName, FirstName) вернули копию книги? <br>
select distinct r.last_name, r.first_name
from readers r
join Borrowing b on r.ID = b.reader_id
where b.return_date is not null;

-- Какие читатели (LastName, FirstName) брали хотя бы одну книгу (не копию), которую брал также Иван Иванов (не включайте Ивана Иванова в результат)? <br>
select distinct r.last_name, r.first_name
from readers r
join Borrowing b on r.ID = b.reader_id
where b.ISBN IN (
    select b.ISBN
    from Borrowing b
    join readers r ON b.reader_id = r.id
    where r.first_name = 'Иван' and r.last_name = 'Иванов'
)
and not (r.first_name = 'Иван' and r.last_name = 'Иванов');
```

### Задание 2.
```sql

CREATE Table connections (
    from_station_name VARCHAR(1024),
    to_station_name VARCHAR(1024),
    train_id BIGINT,
    departure TIMESTAMP,
    Arrival TIMESTAMP
);

CREATE TABLE trains (
    id BIGSERIAL PRIMARY KEY,
    length int,
    start_station_name VARCHAR(1024),
    end_station_name VARCHAR(1024)
);

CREATE TABLE city (
    name VARCHAR(1024) PRIMARY KEY,
    region VARCHAR(1024)
);

CREATE TABLE stations (
    name VARCHAR(1024) PRIMARY KEY,
    tracks_number INT,
    city_name VARCHAR(1024),
    region VARCHAR(1024)
);


-- а) Найдите все прямые рейсы из Москвы в Тверь.
select
    train_id
from connections c
join stations s_from on s_from.name = c.from_station_name
join stations s_to on s_to.name = c.to_station_name
where s_from.city_name = 'Москва' and s_to.city_name='Тверь';

-- б) Найдите все многосегментные маршруты, имеющие точно однодневный трансфер из Москвы в Санкт-Петербург (первое отправление и прибытие в конечную точку должны быть в одну и ту же дату). Вы можете применить функцию DAY () к атрибутам Departure и Arrival, чтобы определить дату.  
select
    train_id
from connections c
join stations s_from on s_from.name = c.from_station_name
join stations s_to on s_to.name = c.to_station_name
where s_from.city_name = 'Москва' and s_to.city_name='Санкт-Петербург'
and DATE(c.arrival)=DATE(c.departure);
```