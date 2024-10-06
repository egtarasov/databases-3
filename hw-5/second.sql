
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