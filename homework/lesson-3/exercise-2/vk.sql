# Пересоздать БД
DROP DATABASE IF EXISTS vk;
CREATE DATABASE IF NOT EXISTS vk;

# Выбрать БД по умолчанию
USE vk;

/*
-- Error Code: 1217. Cannot delete or update a parent row: a foreign key constraint fails
SET FOREIGN_KEY_CHECKS = 0;
DROP TABLE IF EXISTS users;
SET FOREIGN_KEY_CHECKS = 1;
*/
-- Таблица пользователей
CREATE TABLE users (
	id INT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT "Идентификатор строки", 
	email VARCHAR(100) NOT NULL UNIQUE COMMENT "Почта",
	phone VARCHAR(100) NOT NULL UNIQUE COMMENT "Телефон",
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "Время создания строки",  
	updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "Время обновления строки",
	-- Назначаем поле "id" PK
	PRIMARY KEY (`id`)
) COMMENT "Учетные записи пользователей";

-- Таблица профилей пользователей
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
	PRIMARY KEY (`id`),
	-- Связываем поле "user_id" таблицы "profiles" с полем "id" таблицы "users" c помощью внешнего ключа
	FOREIGN KEY (user_id) REFERENCES users(id)
) COMMENT "Профили пользователей";

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
	PRIMARY KEY (`id`),
	-- Связываем поле "from_user_id" таблицы "messages" с полем "id" таблицы "users" c помощью внешнего ключа
	FOREIGN KEY (from_user_id) REFERENCES users(id),
	-- Связываем поле "to_user_id" таблицы "messages" с полем "id" таблицы "users" c помощью внешнего ключа
	FOREIGN KEY (to_user_id) REFERENCES users(id)
) COMMENT "Сообщения пользователей";

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
	FOREIGN KEY (user_id) REFERENCES users(id),
	-- Связываем поле "friend_id" таблицы "friendship" с полем "id" таблицы "users" c помощью внешнего ключа
	FOREIGN KEY (friend_id) REFERENCES users(id)
) COMMENT "Участники дружбы, связь между пользователями";

-- Таблица групп
CREATE TABLE communities (
	id INT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT "Идентификатор сроки",
	name VARCHAR(150) NOT NULL UNIQUE COMMENT "Название группы",
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "Время создания строки",  
	updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "Время обновления строки",
	-- Назначаем поле "id" PK
	PRIMARY KEY (`id`)
) COMMENT "Группы или сообщества";

-- Таблица связи пользователей и групп
CREATE TABLE communities_users (
	community_id INT UNSIGNED NOT NULL COMMENT "Ссылка на группу",
	user_id INT UNSIGNED NOT NULL COMMENT "Ссылка на пользователя",
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "Время создания строки",
	-- Назначаем поля "community_id" и "user_id" PK
	PRIMARY KEY (community_id, user_id) COMMENT "Составной первичный ключ",
	-- Связываем поле "user_id" таблицы "communities_users" с полем "id" таблицы "users" c помощью внешнего ключа
	FOREIGN KEY (user_id) REFERENCES users(id),
	-- Связываем поле "community_id" таблицы "communities_users" с полем "id" таблицы "communities" c помощью внешнего ключа
	FOREIGN KEY (community_id) REFERENCES communities(id)
) COMMENT "Участники групп, связь между пользователями и группами";

-- Таблица лайков
CREATE TABLE likes (
	id INT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Идентификатор строки',
	from_user_id INT UNSIGNED NOT NULL COMMENT "Ссылка на пользователя",
	created_at datetime DEFAULT CURRENT_TIMESTAMP COMMENT 'Время создания строки',
	updated_at datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Время обновления строки',
	-- Назначаем поле "id" PK
	PRIMARY KEY (`id`),
	-- Связываем поле "from_user_id" таблицы "likes" с полем "id" таблицы "users" c помощью внешнего ключа
	FOREIGN KEY (from_user_id) REFERENCES users(id)
) COMMENT 'Таблица лайков';

-- Таблица постов
CREATE TABLE posts (
	id INT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Идентификатор строки',
	from_user_id INT UNSIGNED NOT NULL COMMENT "Ссылка на пользователя",
    body TEXT NOT NULL COMMENT "Содержимое поста",
	created_at datetime DEFAULT CURRENT_TIMESTAMP COMMENT 'Время создания строки',
	updated_at datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Время обновления строки',
	-- Назначаем поле "id" PK
	PRIMARY KEY (`id`),
	-- Связываем поле "from_user_id" таблицы "likes" с полем "id" таблицы "users" c помощью внешнего ключа
	FOREIGN KEY (from_user_id) REFERENCES users(id)
) COMMENT 'Таблица постов';

-- Таблица медиа контента
CREATE TABLE mediafiles (
	id INT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Идентификатор строки',
	from_user_id INT UNSIGNED NOT NULL COMMENT "Ссылка на пользователя",
    name VARCHAR(100) NOT NULL UNIQUE COMMENT "Ссылка на медиа контент",
	created_at datetime DEFAULT CURRENT_TIMESTAMP COMMENT 'Время создания строки',
	updated_at datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Время обновления строки',
	-- Назначаем поле "id" PK
	PRIMARY KEY (`id`),
	-- Связываем поле "from_user_id" таблицы "likes" с полем "id" таблицы "users" c помощью внешнего ключа
	FOREIGN KEY (from_user_id) REFERENCES users(id)
) COMMENT 'Таблица постов';

-- Таблица связи лайков и медиа файлы
CREATE TABLE likes_mediafiles (
	like_id INT UNSIGNED NOT NULL COMMENT "Ссылка на лайк",
	mediafiles_id INT UNSIGNED NOT NULL COMMENT "Ссылка на медиа файл",
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "Время создания строки",
	-- Назначаем поля "community_id" и "user_id" PK
	PRIMARY KEY (like_id, mediafiles_id) COMMENT "Составной первичный ключ",
	-- Связываем поле "like_id" таблицы "likes_mediafiles" с полем "id" таблицы "likes" c помощью внешнего ключа
	FOREIGN KEY (like_id) REFERENCES likes(id),
	-- Связываем поле "mediafiles_id" таблицы "likes_mediafiles" с полем "id" таблицы "mediafiles" c помощью внешнего ключа
	FOREIGN KEY (mediafiles_id) REFERENCES mediafiles(id)
);

-- Таблица связи лайков и постов
CREATE TABLE likes_posts (
	like_id INT UNSIGNED NOT NULL COMMENT "Ссылка на лайк",
	post_id INT UNSIGNED NOT NULL COMMENT "Ссылка на пост",
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "Время создания строки",
	-- Назначаем поля "community_id" и "user_id" PK
	PRIMARY KEY (like_id, post_id) COMMENT "Составной первичный ключ",
	-- Связываем поле "like_id" таблицы "likes_posts" с полем "id" таблицы "likes" c помощью внешнего ключа
	FOREIGN KEY (like_id) REFERENCES likes(id),
	-- Связываем поле "post_id" таблицы "likes_posts" с полем "id" таблицы "posts" c помощью внешнего ключа
	FOREIGN KEY (post_id) REFERENCES posts(id)
);

-- Таблица связи лайков и пользователей (их профилей)
CREATE TABLE likes_profiles (
	like_id INT UNSIGNED NOT NULL COMMENT "Ссылка на лайк",
	profile_id INT UNSIGNED NOT NULL COMMENT "Ссылка на профиль",
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "Время создания строки",
	-- Назначаем поля "community_id" и "user_id" PK
	PRIMARY KEY (like_id, profile_id) COMMENT "Составной первичный ключ",
	-- Связываем поле "like_id" таблицы "likes_profiles" с полем "id" таблицы "likes" c помощью внешнего ключа
	FOREIGN KEY (like_id) REFERENCES likes(id),
	-- Связываем поле "profile_id" таблицы "likes_profiles" с полем "id" таблицы "profiles" c помощью внешнего ключа
	FOREIGN KEY (profile_id) REFERENCES profiles(id)
);
