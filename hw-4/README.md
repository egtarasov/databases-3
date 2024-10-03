sql scripts for database were generated from dbdiagrams and slightly modified.


```yaml
version: '3.9'

services:
  db-01:
    image: postgres:16
    container_name: postgres_db_1
    environment:
      POSTGRES_USER: postgres
      POSTGRES_PASSWORD: postgres
      POSTGRES_DB: postgres
    ports:
      - "5432:5432"
    volumes:
      - postgres_data_1:/var/lib/postgresql/data
  db-02:
    image: postgres:16
    container_name: postgres_db_2
    environment:
      POSTGRES_USER: postgres
      POSTGRES_PASSWORD: postgres
      POSTGRES_DB: postgres
    ports:
      - "5433:5432"
    volumes:
      - postgres_data_2:/var/lib/postgresql/data


volumes:
  postgres_data_1:
  postgres_data_2:
```

```bash
docker-compose up -d
```

```bash
psql -h localhost -p 5432 -U postgres postgres -f hw-3.1.sql -1
psql -h localhost -p 5432 -U postgres postgres -f hw-3.2.sql -1
psql -h localhost -p 5432 -U postgres postgres -f hw-3.3.sql -1
```
```
postgres=# SELECT * FROM pg_catalog.pg_tables where schemaname in ('first', 'second', 'third');
 schemaname |    tablename     | tableowner | tablespace | hasindexes | hasrules | hastriggers | rowsecurity 
------------+------------------+------------+------------+------------+----------+-------------+-------------
 third      | stations         | postgres   |            | t          | f        | t           | f
 third      | personals        | postgres   |            | t          | f        | t           | f
 third      | doctors          | postgres   |            | t          | f        | t           | f
 third      | caregiver        | postgres   |            | f          | f        | t           | f
 third      | rooms            | postgres   |            | t          | f        | t           | f
 third      | patiens          | postgres   |            | t          | f        | t           | f
 third      | admissions       | postgres   |            | f          | f        | t           | f
 second     | stations         | postgres   |            | t          | f        | t           | f
 second     | trains           | postgres   |            | t          | f        | t           | f
 second     | cities           | postgres   |            | t          | f        | t           | f
 second     | connections      | postgres   |            | f          | f        | t           | f
 first      | book_copies      | postgres   |            | t          | f        | t           | f
 first      | taken_books_copy | postgres   |            | f          | f        | t           | f
 first      | readers          | postgres   |            | t          | f        | t           | f
 first      | books            | postgres   |            | t          | f        | t           | f
 first      | authors          | postgres   |            | t          | f        | t           | f
 first      | book_categories  | postgres   |            | f          | f        | t           | f
 first      | categories       | postgres   |            | t          | f        | t           | f
 first      | publishers       | postgres   |            | t          | f        | t           | f
(19 rows)
```

```bash
docker-compose down
```

```bash
# Just in case
docker rm $(docker ps -aq)
```

```bash
docker-compose up -d --build
```

```postgres=# SELECT * FROM pg_catalog.pg_tables where schemaname in ('first', 'second', 'third');
 schemaname |    tablename     | tableowner | tablespace | hasindexes | hasrules | hastriggers | rowsecurity 
------------+------------------+------------+------------+------------+----------+-------------+-------------
 third      | stations         | postgres   |            | t          | f        | t           | f
 third      | personals        | postgres   |            | t          | f        | t           | f
 third      | doctors          | postgres   |            | t          | f        | t           | f
 third      | caregiver        | postgres   |            | f          | f        | t           | f
 third      | rooms            | postgres   |            | t          | f        | t           | f
 third      | patiens          | postgres   |            | t          | f        | t           | f
 third      | admissions       | postgres   |            | f          | f        | t           | f
 second     | stations         | postgres   |            | t          | f        | t           | f
 second     | trains           | postgres   |            | t          | f        | t           | f
 second     | cities           | postgres   |            | t          | f        | t           | f
 second     | connections      | postgres   |            | f          | f        | t           | f
 first      | book_copies      | postgres   |            | t          | f        | t           | f
 first      | taken_books_copy | postgres   |            | f          | f        | t           | f
 first      | readers          | postgres   |            | t          | f        | t           | f
 first      | books            | postgres   |            | t          | f        | t           | f
 first      | authors          | postgres   |            | t          | f        | t           | f
 first      | book_categories  | postgres   |            | f          | f        | t           | f
 first      | categories       | postgres   |            | t          | f        | t           | f
 first      | publishers       | postgres   |            | t          | f        | t           | f
(19 rows)
```