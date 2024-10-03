
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
    c.train_id
from connections c
where c.from_station_name='Москва' and c.to_station_name='Тверь';


-- б) Найдите все многосегментные маршруты, имеющие точно однодневный трансфер из Москвы в Санкт-Петербург (первое отправление и прибытие в конечную точку должны быть в одну и ту же дату). Вы можете применить функцию DAY () к атрибутам Departure и Arrival, чтобы определить дату.  
