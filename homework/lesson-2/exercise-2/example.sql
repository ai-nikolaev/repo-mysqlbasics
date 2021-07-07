# создать БД 'example':
CREATE DATABASE example;
SHOW DATABASES;

# выбрать БД 'example' по умолчанию:
USE example;

# создать таблицу 'users':
CREATE TABLE users (id INT NOT NULL PRIMARY KEY AUTO_INCREMENT, name VARCHAR(50) NOT NULL);
SHOW TABLES;
DESCRIBE users;
