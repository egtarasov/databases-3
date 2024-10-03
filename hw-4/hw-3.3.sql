CREATE SCHEMA third;

CREATE TABLE third."stations" (
  "id" bigserial PRIMARY KEY,
  "number" varchar(1024),
  "name" varchar(1024)
);

CREATE TABLE third."personals" (
  "id" bigserial PRIMARY KEY,
  "number" varchar(1024),
  "name" varchar(1024),
  "work_station_id" bigint
);

CREATE TABLE third."doctors" (
  "personal_id" bigint UNIQUE,
  "area" int,
  "rank" int
);

CREATE TABLE third."caregiver" (
  "personal_id" bigint,
  "qualification" varchar(1024)
);

CREATE TABLE third."rooms" (
  "id" bigserial PRIMARY KEY,
  "number" varchar(1024),
  "station_id" bigint,
  "bed_count" int
);

CREATE TABLE third."patiens" (
  "id" bigserial PRIMARY KEY,
  "number" varchar(1024),
  "name" varchar(1024),
  "disease" varchar(1024),
  "doctor_id" bigint
);

CREATE TABLE third."admissions" (
  "patient_id" bigint,
  "room_id" bigint,
  "from" date,
  "to" date
);

ALTER TABLE third."personals" ADD FOREIGN KEY ("work_station_id") REFERENCES third."stations" ("id");

ALTER TABLE third."doctors" ADD FOREIGN KEY ("personal_id") REFERENCES third."personals" ("id");

ALTER TABLE third."caregiver" ADD FOREIGN KEY ("personal_id") REFERENCES third."personals" ("id");

ALTER TABLE third."rooms" ADD FOREIGN KEY ("station_id") REFERENCES third."stations" ("id");

ALTER TABLE third."patiens" ADD FOREIGN KEY ("doctor_id") REFERENCES third."doctors" ("personal_id");

ALTER TABLE third."admissions" ADD FOREIGN KEY ("patient_id") REFERENCES third."patiens" ("id");

ALTER TABLE third."admissions" ADD FOREIGN KEY ("room_id") REFERENCES third."rooms" ("id");
