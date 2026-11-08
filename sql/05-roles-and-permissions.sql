-- 05-roles-and-permissions.sql
-- Создание ролей и настройка прав доступа для интернет-магазина
-- Выполнять от имени суперпользователя (postgres) после создания таблиц.
-- Реальные пароли не хранятся в репозитории. Задайте их отдельно через
-- ALTER USER ... WITH PASSWORD или переменную окружения PGPASSWORD.

-- ---------------------------------------------------------------------------
-- Роли базы данных (GROUP ROLES)
-- ---------------------------------------------------------------------------

CREATE ROLE shop_admin;
CREATE ROLE shop_manager;
CREATE ROLE shop_operator;
CREATE ROLE shop_readonly;

COMMENT ON ROLE shop_admin IS 'Администратор базы данных: полный доступ';
COMMENT ON ROLE shop_manager IS 'Менеджер интернет-магазина: товары, заказы, категории';
COMMENT ON ROLE shop_operator IS 'Оператор службы доставки: просмотр всех таблиц, изменение заказов и доставок';
COMMENT ON ROLE shop_readonly IS 'Пользователь только для чтения: аналитика и отчёты';

-- ---------------------------------------------------------------------------
-- Демонстрационные пользователи (LOGIN ROLES)
-- ---------------------------------------------------------------------------

CREATE USER shop_admin_user WITH LOGIN;
CREATE USER shop_manager_user WITH LOGIN;
CREATE USER shop_operator_user WITH LOGIN;
CREATE USER shop_readonly_user WITH LOGIN;

-- Назначить пользователям роли (членство)
GRANT shop_admin TO shop_admin_user;
GRANT shop_manager TO shop_manager_user;
GRANT shop_operator TO shop_operator_user;
GRANT shop_readonly TO shop_readonly_user;

-- Пример задания пароля (выполняйте отдельно, не храните в скрипте):
-- ALTER USER shop_admin_user WITH PASSWORD ' your_secure_password ';

-- ---------------------------------------------------------------------------
-- Права на схему public
-- ---------------------------------------------------------------------------

-- Администратор: полный доступ ко схеме
GRANT ALL ON SCHEMA public TO shop_admin;
GRANT ALL ON SCHEMA public TO shop_manager;
GRANT USAGE ON SCHEMA public TO shop_operator;
GRANT USAGE ON SCHEMA public TO shop_readonly;

-- ---------------------------------------------------------------------------
-- Права на все таблицы (текущие и будущие)
-- ---------------------------------------------------------------------------

-- shop_admin: полный доступ ко всем таблицам и последовательностям
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO shop_admin;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO shop_admin;

-- shop_manager: DML на товары, заказы, позиции, категории; SELECT на остальные
GRANT SELECT, INSERT, UPDATE, DELETE ON products TO shop_manager;
GRANT SELECT, INSERT, UPDATE, DELETE ON categories TO shop_manager;
GRANT SELECT, INSERT, UPDATE, DELETE ON orders TO shop_manager;
GRANT SELECT, INSERT, UPDATE, DELETE ON order_items TO shop_manager;
GRANT SELECT ON customers TO shop_manager;
GRANT SELECT ON payments TO shop_manager;
GRANT SELECT ON deliveries TO shop_manager;
GRANT SELECT ON users TO shop_manager;
GRANT SELECT ON roles TO shop_manager;

-- shop_operator: SELECT на все таблицы, UPDATE только на orders и deliveries
GRANT SELECT ON ALL TABLES IN SCHEMA public TO shop_operator;
GRANT UPDATE ON orders TO shop_operator;
GRANT UPDATE ON deliveries TO shop_operator;
-- Последовательности не нужны оператору для вставки, но USAGE может пригодиться
GRANT USAGE ON ALL SEQUENCES IN SCHEMA public TO shop_operator;

-- shop_readonly: только SELECT на все таблицы
GRANT SELECT ON ALL TABLES IN SCHEMA public TO shop_readonly;

-- ---------------------------------------------------------------------------
-- Права на последовательности (для автоинкремента при вставке)
-- ---------------------------------------------------------------------------

-- shop_admin и shop_manager могут вставлять, значит нужны USAGE на sequences
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public TO shop_manager;

-- ---------------------------------------------------------------------------
-- Примеры REVOKE (отзыв прав, если требуется ужесточить доступ)
-- ---------------------------------------------------------------------------

-- Оператор не должен удалять заказы
REVOKE DELETE ON orders FROM shop_operator;
REVOKE DELETE ON deliveries FROM shop_operator;
REVOKE INSERT ON orders FROM shop_operator;
REVOKE INSERT ON deliveries FROM shop_operator;
REVOKE INSERT ON order_items FROM shop_operator;
REVOKE INSERT ON payments FROM shop_operator;
REVOKE INSERT ON products FROM shop_operator;
REVOKE INSERT ON categories FROM shop_operator;
REVOKE INSERT ON customers FROM shop_operator;
REVOKE INSERT ON users FROM shop_operator;
REVOKE INSERT ON roles FROM shop_operator;

-- Readonly не имеет никаких прав на изменение (уже только SELECT)

-- ---------------------------------------------------------------------------
-- Права на будущие таблицы (ALTER DEFAULT PRIVILEGES)
-- ---------------------------------------------------------------------------

ALTER DEFAULT PRIVILEGES IN SCHEMA public
    GRANT ALL PRIVILEGES ON TABLES TO shop_admin;

ALTER DEFAULT PRIVILEGES IN SCHEMA public
    GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES TO shop_manager;

ALTER DEFAULT PRIVILEGES IN SCHEMA public
    GRANT SELECT ON TABLES TO shop_operator;

ALTER DEFAULT PRIVILEGES IN SCHEMA public
    GRANT SELECT ON TABLES TO shop_readonly;

-- ---------------------------------------------------------------------------
-- Конец файла 05-roles-and-permissions.sql
-- ---------------------------------------------------------------------------