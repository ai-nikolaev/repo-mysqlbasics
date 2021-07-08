DROP DATABASE IF EXISTS vk;
CREATE DATABASE IF NOT EXISTS vk;

-- Выбрать БД по умолчанию
USE vk;

-- Error Code: 1217. Cannot delete or update a parent row: a foreign key constraint fails
-- SET FOREIGN_KEY_CHECKS = 0;
-- DROP TABLE IF EXISTS users;
-- SET FOREIGN_KEY_CHECKS = 1;
-- Таблица пользователей
CREATE TABLE users (
	id INT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT "Идентификатор строки", 
	email VARCHAR(100) NOT NULL UNIQUE COMMENT "Почта",
	phone VARCHAR(100) NOT NULL UNIQUE COMMENT "Телефон",
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "Время создания строки",  
	updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "Время обновления строки",
	-- Назначаем поле "id" PK
	PRIMARY KEY (`id`) COMMENT "Первичный ключ"
) COMMENT "Зарегестрированные пользователи";

-- DROP TABLE IF EXISTS profiles;
-- Таблица профилей
CREATE TABLE profiles (
	id INT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT "Идентификатор строки", 
	user_id INT UNSIGNED UNIQUE NOT NULL COMMENT "Ссылка на пользователя", 
	first_name VARCHAR(100) NOT NULL COMMENT "Имя пользователя",
	last_name VARCHAR(100) NOT NULL COMMENT "Фамилия пользователя",
	birth_date DATE COMMENT "Дата рождения",    
	country VARCHAR(100) COMMENT "Страна проживания",
	city VARCHAR(100) COMMENT "Город проживания",
	`status` ENUM('ONLINE', 'OFFLINE') COMMENT "Текущий статус",
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "Время создания строки",  
	updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "Время обновления строки",
	-- Назначаем поле "id" PK
	PRIMARY KEY (`id`) COMMENT "Первичный ключ",
	-- Связываем поле "user_id" таблицы "profiles" с полем "id" таблицы "users" c помощью внешнего ключа
	FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
) COMMENT "Профили пользователей";

-- DROP TABLE IF EXISTS messages;
-- Таблица сообщений
CREATE TABLE messages (
	id INT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT "Идентификатор строки", 
	from_user_id INT UNSIGNED NOT NULL COMMENT "Ссылка на отправителя сообщения",
	to_user_id INT UNSIGNED NOT NULL COMMENT "Ссылка на получателя сообщения",
	message_header VARCHAR(255) COMMENT "Заголовок сообщения",
	message_body TEXT NOT NULL COMMENT "Текст сообщения",
	is_delivered BOOLEAN NOT NULL COMMENT "Признак доставки",
	is_edited BOOLEAN NOT NULL COMMENT "Признак правки заголовка или тела сообщения",
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "Время создания строки",
	updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "Время обновления строки",
	-- Назначаем поле "id" PK
	PRIMARY KEY (`id`) COMMENT "Первичный ключ",
	-- Связываем поле "from_user_id" таблицы "messages" с полем "id" таблицы "users" c помощью внешнего ключа
	FOREIGN KEY (from_user_id) REFERENCES users(id) ON DELETE CASCADE,
	-- Связываем поле "to_user_id" таблицы "messages" с полем "id" таблицы "users" c помощью внешнего ключа
	FOREIGN KEY (to_user_id) REFERENCES users(id) ON DELETE CASCADE
) COMMENT "Сообщения отправляемые пользователями";

-- DROP TABLE IF EXISTS friendship;
-- Таблица дружбы
CREATE TABLE friendship (
	user_id INT UNSIGNED NOT NULL COMMENT "Ссылка на инициатора дружеских отношений",
	friend_id INT UNSIGNED NOT NULL COMMENT "Ссылка на получателя приглашения дружить",
	friendship_status ENUM('FRIENDSHIP', 'FOLLOWING', 'BLOCKED') COMMENT "Cтатус (текущее состояние) отношений",
	requested_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "Время отправления приглашения дружить",
	confirmed_at DATETIME COMMENT "Время подтверждения приглашения",
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "Время создания строки",  
	updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "Время обновления строки",  
	-- Назначаем поля "user_id" и "friend_id" PK
	PRIMARY KEY (user_id, friend_id) COMMENT "Составной первичный ключ",
	-- Связываем поле "user_id" таблицы "friendship" с полем "id" таблицы "users" c помощью внешнего ключа
	FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
	-- Связываем поле "friend_id" таблицы "friendship" с полем "id" таблицы "users" c помощью внешнего ключа
	FOREIGN KEY (friend_id) REFERENCES users(id) ON DELETE CASCADE
) COMMENT "Участники дружбы, связь между пользователями";

-- Error Code: 1217. Cannot delete or update a parent row: a foreign key constraint fails
-- SET FOREIGN_KEY_CHECKS = 0;
-- DROP TABLE IF EXISTS communities;
-- SET FOREIGN_KEY_CHECKS = 1;
-- Таблица групп
CREATE TABLE communities (
	id INT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT "Идентификатор сроки",
	name VARCHAR(150) NOT NULL UNIQUE COMMENT "Название группы",
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "Время создания строки",  
	updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "Время обновления строки",
	-- Назначаем поле "id" PK
	PRIMARY KEY (`id`) COMMENT "Первичный ключ"
) COMMENT "Группы или сообщества";

-- DROP TABLE IF EXISTS communities_users;
-- Таблица связи пользователей и групп
CREATE TABLE communities_users (
	community_id INT UNSIGNED NOT NULL COMMENT "Ссылка на группу",
	user_id INT UNSIGNED NOT NULL COMMENT "Ссылка на пользователя",
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "Время создания строки",
	-- Назначаем поля "community_id" и "user_id" PK
	PRIMARY KEY (community_id, user_id) COMMENT "Составной первичный ключ",
	-- Связываем поле "user_id" таблицы "communities_users" с полем "id" таблицы "users" c помощью внешнего ключа
	FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
	-- Связываем поле "community_id" таблицы "communities_users" с полем "id" таблицы "communities" c помощью внешнего ключа
	FOREIGN KEY (community_id) REFERENCES communities(id) ON DELETE CASCADE
) COMMENT "Участники групп, связь между пользователями и группами";
