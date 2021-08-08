DROP DATABASE IF EXISTS bs;
CREATE DATABASE bs;

# Выбираем БД по умолчанию
USE bs;

/*
	Создаем таблицы
*/
CREATE TABLE books (
    id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    title VARCHAR(100) NOT NULL UNIQUE COMMENT "Название книги",
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP NOT NULL COMMENT "Время создания строки",
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP NOT NULL COMMENT "Время обновления строки",
    PRIMARY KEY (id)
) COMMENT "Книги доступные для выдачи";

CREATE TABLE authors (
	id INT UNSIGNED NOT NULL AUTO_INCREMENT, 
    last_name VARCHAR(25) NOT NULL COMMENT "Фамилия",
    first_name VARCHAR(25) NOT NULL COMMENT "Имя",
    middle_name VARCHAR(25) NULL COMMENT "Отчество",
    date_of_birth DATE NOT NULL COMMENT "Дата рождения",
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP NOT NULL COMMENT "Время создания строки",  
	updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP NOT NULL COMMENT "Время обновления строки",
	PRIMARY KEY (id)
) COMMENT "Авторы книг";

CREATE TABLE book_author (
	book_id INT UNSIGNED NOT NULL, 
    author_id INT UNSIGNED NOT NULL, 
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP NOT NULL COMMENT "Время создания строки",  
	updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP NOT NULL COMMENT "Время обновления строки",
	PRIMARY KEY (book_id, author_id),
    FOREIGN KEY (book_id) REFERENCES books(id),
    FOREIGN KEY (author_id) REFERENCES authors(id)
) COMMENT "Cвязующая таблица для книг и авторов";

CREATE TABLE subjects (
	id INT UNSIGNED NOT NULL AUTO_INCREMENT, 
    name VARCHAR(50) NOT NULL UNIQUE COMMENT "Название тематики",
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP NOT NULL COMMENT "Время создания строки",  
	updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP NOT NULL COMMENT "Время обновления строки",
	PRIMARY KEY (id)
) COMMENT "Книжные тематики";

CREATE TABLE author_subject (
	book_id INT UNSIGNED NOT NULL, 
    subject_id INT UNSIGNED NOT NULL, 
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP NOT NULL COMMENT "Время создания строки",  
	updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP NOT NULL COMMENT "Время обновления строки",
	PRIMARY KEY (book_id, subject_id),
    FOREIGN KEY (book_id) REFERENCES books(id),
    FOREIGN KEY (subject_id) REFERENCES subjects(id)
) COMMENT "Cвязующая таблица для авторов и книжных тематик";

CREATE TABLE publishers (
	id INT UNSIGNED NOT NULL AUTO_INCREMENT, 
    name VARCHAR(25) NOT NULL UNIQUE COMMENT "Название издателя",
    book_id INT UNSIGNED NOT NULL,
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP NOT NULL COMMENT "Время создания строки",  
	updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP NOT NULL COMMENT "Время обновления строки",
	PRIMARY KEY (id),
    FOREIGN KEY (book_id) REFERENCES books (id)
) COMMENT "Издатели книг";

CREATE TABLE readers (
	id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    last_name VARCHAR(25) NOT NULL COMMENT "Фамилия",
    first_name VARCHAR(25) NOT NULL COMMENT "Имя",
    middle_name VARCHAR(25) NULL COMMENT "Отчество",
    date_of_birth DATE NOT NULL COMMENT "Дата рождения",
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP NOT NULL COMMENT "Время создания строки",  
	updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP NOT NULL COMMENT "Время обновления строки",
	PRIMARY KEY (id)
) COMMENT "Читатели книг";

CREATE TABLE passports (
	id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    passport VARCHAR(25) NOT NULL UNIQUE COMMENT "Номер паспорта",
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP NOT NULL COMMENT "Время создания строки",  
	updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP NOT NULL COMMENT "Время обновления строки",
	PRIMARY KEY (id),
    FOREIGN KEY (id) REFERENCES readers (id)
) COMMENT "Документы удостоверяющие личность";

CREATE TABLE tickets (
	id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    ticket VARCHAR(25) NOT NULL UNIQUE COMMENT "Номер читательского билета",
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP NOT NULL COMMENT "Время создания строки",  
	updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP NOT NULL COMMENT "Время обновления строки",
	PRIMARY KEY (id),
    FOREIGN KEY (id) REFERENCES readers (id)
) COMMENT "Читательские билеты";

CREATE TABLE books_in_use (
	id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    book_id INT UNSIGNED NOT NULL,
    reader_id INT UNSIGNED NOT NULL,
    date_of_issue DATE NOT NULL COMMENT "Дата взятия книги",
    date_of_refund DATE NULL COMMENT "Дата возврата книги",
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP NOT NULL COMMENT "Время создания строки",  
	updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP NOT NULL COMMENT "Время обновления строки",
	PRIMARY KEY (id),
    FOREIGN KEY (book_id) REFERENCES books (id),
    FOREIGN KEY (reader_id) REFERENCES readers (id)
) COMMENT "Книги взятые в аренду";

/*
	Создаем триггеры
*/
CREATE TRIGGER ucase_title_insert_books BEFORE INSERT ON books FOR EACH ROW
SET NEW.title = UPPER(NEW.title);
CREATE TRIGGER ucase_title_update_books BEFORE UPDATE ON books FOR EACH ROW
SET NEW.title = UPPER(NEW.title);
CREATE TRIGGER ucase_last_name_insert_authors BEFORE INSERT ON authors FOR EACH ROW
SET NEW.last_name = UPPER(NEW.last_name);
CREATE TRIGGER ucase_last_name_update_authors BEFORE UPDATE ON authors FOR EACH ROW
SET NEW.last_name = UPPER(NEW.last_name);
CREATE TRIGGER ucase_first_name_insert_authors BEFORE INSERT ON authors FOR EACH ROW
SET NEW.first_name = UPPER(NEW.first_name);
CREATE TRIGGER ucase_first_name_update_authors BEFORE UPDATE ON authors FOR EACH ROW
SET NEW.first_name = UPPER(NEW.first_name);
CREATE TRIGGER ucase_middle_name_insert_authors BEFORE INSERT ON authors FOR EACH ROW
SET NEW.middle_name = UPPER(NEW.middle_name);
CREATE TRIGGER ucase_middle_name_update_authors BEFORE UPDATE ON authors FOR EACH ROW
SET NEW.middle_name = UPPER(NEW.middle_name);
CREATE TRIGGER ucase_last_name_insert_readers BEFORE INSERT ON readers FOR EACH ROW
SET NEW.last_name = UPPER(NEW.last_name);
CREATE TRIGGER ucase_last_name_update_readers BEFORE UPDATE ON readers FOR EACH ROW
SET NEW.last_name = UPPER(NEW.last_name);
CREATE TRIGGER ucase_first_name_insert_readers BEFORE INSERT ON readers FOR EACH ROW
SET NEW.first_name = UPPER(NEW.first_name);
CREATE TRIGGER ucase_first_name_update_readers BEFORE UPDATE ON readers FOR EACH ROW
SET NEW.first_name = UPPER(NEW.first_name);
CREATE TRIGGER ucase_middle_name_insert_readers BEFORE INSERT ON readers FOR EACH ROW
SET NEW.middle_name = UPPER(NEW.middle_name);
CREATE TRIGGER ucase_middle_name_update_readers BEFORE UPDATE ON readers FOR EACH ROW
SET NEW.middle_name = UPPER(NEW.middle_name);
CREATE TRIGGER ucase_name_insert_subjects BEFORE INSERT ON subjects FOR EACH ROW
SET NEW.name = UPPER(NEW.name);
CREATE TRIGGER ucase_name_update_subjects BEFORE UPDATE ON subjects FOR EACH ROW
SET NEW.name = UPPER(NEW.name);
CREATE TRIGGER ucase_name_insert_publishers BEFORE INSERT ON publishers FOR EACH ROW
SET NEW.name = UPPER(NEW.name);
CREATE TRIGGER ucase_name_update_publishers BEFORE UPDATE ON publishers FOR EACH ROW
SET NEW.name = UPPER(NEW.name);

/*
	Создаем индексы
*/
CREATE INDEX title_index ON books (title) USING BTREE;
CREATE INDEX last_name_index ON authors (last_name) USING BTREE;
CREATE INDEX name_index ON subjects (name) USING BTREE;
CREATE INDEX name_index ON publishers (name) USING BTREE;
CREATE INDEX last_name_index ON readers (last_name) USING BTREE;

/*
	Создаем представления
*/
CREATE VIEW authors_view AS
    SELECT 
        last_name, first_name, middle_name
    FROM
        authors;
 CREATE VIEW readers_view AS
    SELECT 
        last_name, first_name, middle_name
    FROM
        readers;
 CREATE VIEW people_view AS
    SELECT 
        last_name, first_name, middle_name
    FROM
        authors 
    UNION SELECT 
        last_name, first_name, middle_name
    FROM
        readers;

/*
	Создаем хранимые процедуры
*/
DELIMITER $$
CREATE PROCEDURE calculate_age(IN birthDate DATE, OUT age INT)
BEGIN
    SELECT FLOOR(DATEDIFF(NOW(), DATE(birthdate))/365) INTO age;
END $$
DELIMITER ;
