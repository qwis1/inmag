-- 01-create-database.sql
-- Создание базы данных интернет-магазина.
-- Выполнять отдельно от остальных скриптов от имени пользователя с правом CREATEDB
-- (например, postgres). CREATE DATABASE нельзя запускать внутри транзакции,
-- поэтому подключаться нужно к другой базе, обычно к postgres.

-- Пример запуска:
--   psql -U postgres -f sql/01-create-database.sql

-- Раскомментируйте строку ниже, если нужно пересоздать базу с нуля во время разработки:
-- DROP DATABASE IF EXISTS shopdb;

CREATE DATABASE shopdb
    WITH
    OWNER = postgres
    ENCODING = 'UTF8'
    LC_COLLATE = 'C'
    LC_CTYPE = 'C'
    TABLESPACE = pg_default
    CONNECTION LIMIT = -1;

COMMENT ON DATABASE shopdb IS 'База данных системы управления заказами интернет-магазина';

-- После создания подключиться к новой базе:
--   \c shopdb
-- а затем выполнять остальные скрипты по порядку: 02, 03, 04, 05, 06.
