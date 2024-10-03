CREATE SCHEMA first;

CREATE TABLE first."books" (
  isbn VARCHAR(1024) PRIMARY KEY,
  year int,
  title VARCHAR(1024),
  author_id BIGINT,
  page_count int,
  publisher_id BIGINT
);

CREATE TABLE first."authors" (
  id bigserial PRIMARY KEY,
  first_name VARCHAR(1024),
  second_name VARCHAR(1024)
);

CREATE TABLE first."book_copies" (
  id bigserial PRIMARY KEY,
  isbn VARCHAR(1024),
  shelf_position int
);

CREATE TABLE first.publishers (
  id bigserial PRIMARY KEY,
  name VARCHAR(1024)
);

CREATE TABLE first.categories (
  id bigserial PRIMARY KEY,
  name VARCHAR(1024),
  parent_id BIGINT
);

CREATE TABLE first."book_categories" (
  book_isbn VARCHAR(1024),
  category_id BIGINT
);

CREATE TABLE first."readers" (
  id bigserial PRIMARY KEY,
  first_name VARCHAR(1024),
  second_name VARCHAR(1024),
  user_address VARCHAR(1024),
  birth_date date
);

CREATE TABLE first."taken_books_copy" (
  "book_copy_id" BIGINT,
  "reader_id" BIGINT,
  "return_date" date
);

ALTER TABLE first.taken_books_copy ADD FOREIGN KEY ("book_copy_id") REFERENCES first."book_copies" ("id");

ALTER TABLE first.taken_books_copy ADD FOREIGN KEY ("reader_id") REFERENCES first."readers" ("id");

ALTER TABLE first.book_copies ADD FOREIGN KEY ("isbn") REFERENCES first."books" ("isbn");

ALTER TABLE first.books ADD FOREIGN KEY ("author_id") REFERENCES first."authors" ("id");

ALTER TABLE first.book_categories ADD FOREIGN KEY ("book_isbn") REFERENCES first."books" ("isbn");

ALTER TABLE first.book_categories ADD FOREIGN KEY ("category_id") REFERENCES first."categories" ("id");

ALTER TABLE first.books ADD FOREIGN KEY ("publisher_id") REFERENCES first."publishers" ("id");
