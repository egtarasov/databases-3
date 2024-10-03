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

```