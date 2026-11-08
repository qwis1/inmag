-- 02-create-tables.sql
-- Создание таблиц базы данных интернет-магазина.
-- Таблицы идут в порядке, который учитывает зависимости внешних ключей:
-- сначала независимые, затем зависящие от них.
-- Выполнять после подключения к базе shopdb: \c shopdb

-- Роли доступа сотрудников системы. Ноль зависимостей.
CREATE TABLE roles (
    role_id SMALLINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    role_name VARCHAR(50) NOT NULL UNIQUE,
    description TEXT NOT NULL DEFAULT ''
);

COMMENT ON TABLE roles IS 'Роли доступа пользователей системы';
COMMENT ON COLUMN roles.role_name IS 'Название роли (admin, manager, operator, readonly)';

-- Учётные записи сотрудников. Зависят от roles.
CREATE TABLE users (
    user_id SMALLINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    email VARCHAR(255) NOT NULL UNIQUE,
    role_id SMALLINT NOT NULL,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP
);

COMMENT ON TABLE users IS 'Учётные записи сотрудников интернет-магазина';
COMMENT ON COLUMN users.role_id IS 'Ссылка на роль пользователя, определяет его права';

-- Клиенты интернет-магазина. Ноль зависимостей.
CREATE TABLE customers (
    customer_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    phone VARCHAR(30) NOT NULL,
    address TEXT NOT NULL,
    created_at TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP
);

COMMENT ON TABLE customers IS 'Клиенты интернет-магазина';

-- Категории товаров каталога. Ноль зависимостей.
CREATE TABLE categories (
    category_id SMALLINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    category_name VARCHAR(100) NOT NULL UNIQUE,
    description TEXT NOT NULL DEFAULT ''
);

COMMENT ON TABLE categories IS 'Категории товаров каталога';

-- Товары каталога. Зависят от categories.
CREATE TABLE products (
    product_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    sku VARCHAR(50) NOT NULL UNIQUE,
    product_name VARCHAR(200) NOT NULL,
    description TEXT NOT NULL DEFAULT '',
    category_id SMALLINT NOT NULL,
    price NUMERIC(12,2) NOT NULL DEFAULT 0.00,
    stock_quantity INTEGER NOT NULL DEFAULT 0,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP
);

COMMENT ON TABLE products IS 'Товары каталога интернет-магазина';
COMMENT ON COLUMN products.sku IS 'Артикул товара, уникален в рамках каталога';
COMMENT ON COLUMN products.category_id IS 'Ссылка на категорию товара';

-- Заказы клиентов. Зависят от customers.
CREATE TABLE orders (
    order_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    customer_id INTEGER NOT NULL,
    order_date TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    status VARCHAR(20) NOT NULL DEFAULT 'created',
    total_amount NUMERIC(12,2) NOT NULL DEFAULT 0.00,
    shipping_address TEXT NOT NULL
);

COMMENT ON TABLE orders IS 'Заказы клиентов интернет-магазина';

-- Позиции заказов. Зависят от orders и products.
CREATE TABLE order_items (
    order_item_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    order_id INTEGER NOT NULL,
    product_id INTEGER NOT NULL,
    quantity INTEGER NOT NULL DEFAULT 1,
    unit_price NUMERIC(12,2) NOT NULL DEFAULT 0.00
);

COMMENT ON TABLE order_items IS 'Позиции (строки) заказов';
COMMENT ON COLUMN order_items.unit_price IS 'Цена за единицу на момент оформления заказа, фиксируется явно';

-- Платежи по заказам. Зависят от orders.
CREATE TABLE payments (
    payment_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    order_id INTEGER NOT NULL UNIQUE,
    payment_date TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    amount NUMERIC(12,2) NOT NULL DEFAULT 0.00,
    payment_method VARCHAR(50) NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'pending'
);

COMMENT ON TABLE payments IS 'Платежи по заказам';
COMMENT ON COLUMN payments.order_id IS 'Один платёж на заказ';

-- Доставки заказов. Зависят от orders.
CREATE TABLE deliveries (
    delivery_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    order_id INTEGER NOT NULL UNIQUE,
    delivery_date TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    delivery_method VARCHAR(50) NOT NULL,
    delivery_address TEXT NOT NULL,
    delivery_cost NUMERIC(12,2) NOT NULL DEFAULT 0.00,
    status VARCHAR(20) NOT NULL DEFAULT 'scheduled'
);

COMMENT ON TABLE deliveries IS 'Доставки заказов';
COMMENT ON COLUMN deliveries.order_id IS 'Одна доставка на заказ';

-- Конец файла 02-create-tables.sql
