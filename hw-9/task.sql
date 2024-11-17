-- Note: all inserts generating via chat-gpt with minor correction.

-- First

CREATE TABLE demographics (
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR(1024),
    birthday DATE,
    race VARCHAR(1024)
);

INSERT INTO demographics (name, birthday, race) VALUES
('Alice', '1992-06-01', 'Caucasian'),
('Bob', '1985-09-15', 'African American'),
('Carlos', '1990-11-23', 'Hispanic'),
('Dana', '1988-01-16', 'Asian'),
('Verlie', '2001-04-24', 'Caucasian');

SELECT bit_length(name) + length(race) AS calculation
FROM demographics;


-- Second

SELECT
    id,
    bit_length(name) AS name,
    birthday,
    bit_length(race) AS race
FROM demographics;

-- Third

SELECT
    id,
    ASCII(name) AS name,
    birthday,
    ASCII(race) AS race
FROM demographics;

-- Forth

CREATE TABLE names (
    id BIGSERIAL PRIMARY KEY,
    prefix VARCHAR(1024) NOT NULL,
    first VARCHAR(1024) NOT NULL,
    last VARCHAR(1024) NOT NULL,
    suffix VARCHAR(1024) NOT NULL
);

INSERT INTO names (prefix, first, last, suffix) VALUES
('Mr.', 'John', 'Doe', 'Jr.'),
('Dr.', 'Jane', 'Smith', ''),
('Mrs.', 'Emily', 'Brown', ''),
('Ms.', 'Anna', 'Jones', 'PhD');



SELECT
    CONCAT(prefix, ' ', first, ' ', last, ' ', suffix) AS titel
FROM names;

-- Fifth

CREATE TABLE encryption (
    md5 VARCHAR(1024),
    sha1 VARCHAR(1024),
    sha256 VARCHAR(1024)
);

INSERT INTO encryption (md5, sha1, sha256) VALUES
('c3fcd3d76192e4007dfb496cca67e13b', '2ef7bde608ce5404e97d5f042f95f89f1c232871', '3dbd2b0f329b988e0dbc39f84bda1cd833f66d76c73fc12c5ea91964f504d112'),
('f065f90090907a9324ea5c8b1a64ca82', '3cd7244f7f9748170b41102ec542d5d518f5bf3a', '9735a0edb7ac10bd31189ea0c1c1df1e952bcf7ff75e7f656f6c9361ec48c1be'),
('934bfdc8417c0979b9b5cc2531b30f07', '6b4867fd0381ddd7e5902525a2ae12fbc54e6f01', '92eb5ffee6ae2fec3ad71c777531578f586a2a6944df5e7cb6ce5d05dffb0b4e');


SELECT
    CONCAT(md5, repeat('1', length(sha256) - length(md5))) AS md5,
    CONCAT(repeat('0', length(sha256) - length(sha1)), sha1) AS sha1,
    sha256
FROM encryption;

-- Sixth

CREATE TABLE repositories (
    project VARCHAR(1024),
    commits INT,
    contributors INT,
    address VARCHAR(1024)
);

INSERT INTO repositories (project, commits, contributors, address) VALUES
('Bitcoin', 2, 15, '1BoatSLRHtKNngkdXEeobR76b53LETtpyT'),
('Ethereum', 3, 10, '0x4ece35572c5e89d8c4d19f2bca8da9205eabd564'),
('Cardano', 4, 2000, 'addr1q9stacku83jx3kj2728p3emvdtl6vks9ye0zd70xwvp786vf5hm7h0juz535h6clw4en6rymnuvzwqxgvcehvyl4tzlst58lqp');


SELECT
    LEFT(project, commits) AS project,
    RIGHT(address, contributors) AS address
FROM repositories;

-- Seventh

SELECT
    project,
    commits,
    contributors,
    REGEXP_REPLACE(address, '[0-9]', '!', 'g') AS address
FROM repositories;

-- Eighth

CREATE TABLE products (
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR(255),
    price FLOAT,
    stock INT,
    weight FLOAT,
    producer VARCHAR(255),
    country VARCHAR(255)
);

INSERT INTO products (id, name, price, stock, weight, producer, country) VALUES
(1, 'Tomatoes', 3.50, 150, 500, 'Fresh Farms', 'USA'),
(2, 'Potatoes', 2.25, 300, 1000, 'Best Harvest', 'Canada'),
(3, 'Carrots', 1.80, 200, 600, 'Veggie Delight', 'Mexico'),
(4, 'Chocolate Bar', 1.50, 180, 100, 'Cocoa Indulge', 'Belgium'),
(5, 'Cheese', 5.00, 95, 250, 'Dairy Fresh', 'France');

SELECT
    name,
    weight,
    price,
    ROUND((price / (weight / 1000))::numeric, 2) AS price_per_kg
FROM
    products
ORDER BY price_per_kg, name;

