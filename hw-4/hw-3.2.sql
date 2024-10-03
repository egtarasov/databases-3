CREATE SCHEMA second;

CREATE TABLE second.cities (
  "id" bigserial PRIMARY KEY,
  "name" varchar(1024),
  "region" varchar(1024)
);

CREATE TABLE second.trains (
  "number" bigserial PRIMARY KEY,
  "length" int,
  "start" bigint,
  "end" bigint
);

CREATE TABLE second.stations (
  "id" bigint PRIMARY KEY,
  "name" varchar(1024),
  "tracks_number" int,
  "city_id" bigint
);

CREATE TABLE second.connections (
  "from_station_id" bigint,
  "to_station_id" bigint,
  "train_number" bigint,
  "departure_time" time,
  "arival_time" time
);

ALTER TABLE second.trains ADD FOREIGN KEY ("start") REFERENCES second."stations" ("id");

ALTER TABLE second."trains" ADD FOREIGN KEY ("end") REFERENCES second."stations" ("id");

ALTER TABLE second."stations" ADD FOREIGN KEY ("city_id") REFERENCES second."cities" ("id");

ALTER TABLE second."connections" ADD FOREIGN KEY ("from_station_id") REFERENCES second."stations" ("id");

ALTER TABLE second."connections" ADD FOREIGN KEY ("to_station_id") REFERENCES second."stations" ("id");

ALTER TABLE second."connections" ADD FOREIGN KEY ("train_number") REFERENCES second."trains" ("number");
