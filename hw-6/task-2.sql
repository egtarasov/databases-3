-- * Добавьте запись о бронировании читателем ‘Василеем Петровым’ книги с ISBN 123456 и номером копии 4.
insert into borrowing
    (isbn, copynumber, id)
values
    ('ISBN123456', 4, (select id from reader where firstname='Василий' and lastname='Петров' limit 1));
-- * Удалить все книги, год публикации которых превышает 2000 год.
-- Assumed, that there is no need to remove 'copy', 'borrowings'
delete from book where year > 2000;
-- * Измените дату возврата для всех книг категории "Базы данных", начиная с 01.01.2016, чтобы они были в заимствовании на 30 дней дольше (предположим, что в SQL можно добавлять числа к датам).
with recursive category_tree as (
    select categoryname
    from category
    where categoryname = 'Базы данных'
    union all
    select c.categoryname
    from Category c
             join category_tree ct ON ct.categoryname = c.parentcat
)

update borrowing
set returndate = returndate + interval '30 days'
where isbn in (
    select isbn from bookcategory where categoryname in (select categoryname from category_tree)
    )
and returndate >= DATE('2016-01-01');