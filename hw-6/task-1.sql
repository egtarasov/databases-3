-- * Показать все названия книг вместе с именами издателей.
select title, publisher_name from book;
-- * В какой книге наибольшее количество страниц?
select title, number_of_pages from book where number_of_pages = (select max(number_of_pages) from book);
-- * Какие авторы написали более 5 книг?
select author, count(*) books_written from book group by author having count(*) > 5;
-- * В каких книгах более чем в два раза больше страниц, чем среднее количество страниц для всех книг?
select title from book where number_of_pages > 2*(select avg(number_of_pages) from book);
-- * Какие категории содержат подкатегории?
select distinct parentcat from category where parentcat is not null;
-- * У какого автора (предположим, что имена авторов уникальны) написано максимальное количество книг?
select author, count(*) from book group by author order by count(*) desc limit 1;
-- * Какие читатели забронировали все книги (не копии), написанные "Марком Твеном"?
select r.id, r.firstname, r.lastname from reader r
                                              join borrowing b on r.id = b.id
                                              join book b2 on b.isbn = b2.isbn
where b2.author = 'Марк Твен'
group by r.id
having count(distinct b2.isbn) = (select count(*) from book where author='Марк Твен');
-- * Какие книги имеют более одной копии?
select isbn, title from  book where isbn IN (select isbn from copy group by isbn having count(*) > 1);
-- * ТОП 10 самых старых книг
select title, year from book order by year limit 10;
-- * Перечислите все категории в категории “Спорт” (с любым уровнем вложености).
with recursive category_tree as (
    select categoryname, parentcat
    from category
    where categoryname = 'Спорт'
    union all
    select c.categoryname, c.parentcat
    from Category c
    join category_tree ct ON ct.categoryname = c.parentcat
)
select categoryname from category_tree;
