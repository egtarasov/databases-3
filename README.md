


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


![alt text](image.png)

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

![alt text](image.png)