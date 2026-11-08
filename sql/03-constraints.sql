-- 03-constraints.sql
-- Ограничения целостности базы данных интернет-магазина
-- Внешние ключи, CHECK, UNIQUE, NOT NULL реализованы при создании таблиц.
-- Этот файл дополняет или явно задаёт ограничения, вынесенные отдельно.
-- Выполнять после 02-create-tables.sql, подключённым к базе shopdb.

-- ===========================================================================
-- ВНЕШНИЕ КЛЮЧИ (с правилами удаления и обновления)
-- ===========================================================================

-- users.role_id -> roles.role_id
ALTER TABLE users
    ADD CONSTRAINT fk_users_role_id
    FOREIGN KEY (role_id) REFERENCES roles(role_id)
    ON DELETE RESTRICT
    ON UPDATE CASCADE;

-- products.category_id -> categories.category_id
ALTER TABLE products
    ADD CONSTRAINT fk_products_category_id
    FOREIGN KEY (category_id) REFERENCES categories(category_id)
    ON DELETE RESTRICT
    ON UPDATE CASCADE;

-- orders.customer_id -> customers.customer_id
ALTER TABLE orders
    ADD CONSTRAINT fk_orders_customer_id
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
    ON DELETE RESTRICT
    ON UPDATE CASCADE;

-- order_items.order_id -> orders.order_id
ALTER TABLE order_items
    ADD CONSTRAINT fk_order_items_order_id
    FOREIGN KEY (order_id) REFERENCES orders(order_id)
    ON DELETE CASCADE
    ON UPDATE CASCADE;

-- order_items.product_id -> products.product_id
ALTER TABLE order_items
    ADD CONSTRAINT fk_order_items_product_id
    FOREIGN KEY (product_id) REFERENCES products(product_id)
    ON DELETE RESTRICT
    ON UPDATE CASCADE;

-- payments.order_id -> orders.order_id
ALTER TABLE payments
    ADD CONSTRAINT fk_payments_order_id
    FOREIGN KEY (order_id) REFERENCES orders(order_id)
    ON DELETE CASCADE
    ON UPDATE CASCADE;

-- deliveries.order_id -> orders.order_id
ALTER TABLE deliveries
    ADD CONSTRAINT fk_deliveries_order_id
    FOREIGN KEY (order_id) REFERENCES orders(order_id)
    ON DELETE CASCADE
    ON UPDATE CASCADE;

-- ===========================================================================
-- CHECK-ОГРАНИЧЕНИЯ (бизнес-правила на уровне БД)
-- ===========================================================================

-- Цена товара не отрицательная
ALTER TABLE products
    ADD CONSTRAINT chk_products_price_nonnegative
    CHECK (price >= 0);

-- Остаток товара не отрицательный
ALTER TABLE products
    ADD CONSTRAINT chk_products_stock_nonnegative
    CHECK (stock_quantity >= 0);

-- Общая сумма заказа не отрицательная
ALTER TABLE orders
    ADD CONSTRAINT chk_orders_total_amount_nonnegative
    CHECK (total_amount >= 0);

-- Допустимые статусы заказа
ALTER TABLE orders
    ADD CONSTRAINT chk_orders_status_valid
    CHECK (status IN ('created', 'awaiting_payment', 'paid', 'processing', 'shipped', 'delivered', 'cancelled'));

-- Количество товара в позиции заказа больше нуля
ALTER TABLE order_items
    ADD CONSTRAINT chk_order_items_quantity_positive
    CHECK (quantity > 0);

-- Цена за единицу в позиции не отрицательная
ALTER TABLE order_items
    ADD CONSTRAINT chk_order_items_unit_price_nonnegative
    CHECK (unit_price >= 0);

-- Сумма платежа не отрицательная
ALTER TABLE payments
    ADD CONSTRAINT chk_payments_amount_nonnegative
    CHECK (amount >= 0);

-- Допустимые статусы платежа
ALTER TABLE payments
    ADD CONSTRAINT chk_payments_status_valid
    CHECK (status IN ('pending', 'success', 'cancelled', 'refunded'));

-- Стоимость доставки не отрицательная
ALTER TABLE deliveries
    ADD CONSTRAINT chk_deliveries_cost_nonnegative
    CHECK (delivery_cost >= 0);

-- Допустимые статусы доставки
ALTER TABLE deliveries
    ADD CONSTRAINT chk_deliveries_status_valid
    CHECK (status IN ('scheduled', 'in_transit', 'delivered', 'cancelled'));

-- ===========================================================================
-- UNIQUE-ОГРАНИЧЕНИЯ (уже заданы при создании таблиц через UNIQUE,
-- но явно перечислены здесь для документации)
-- ===========================================================================

-- UNIQUE на roles.role_name (уже создано)
-- UNIQUE на users.username (уже создано)
-- UNIQUE на users.email (уже создано)
-- UNIQUE на customers.email (уже создано)
-- UNIQUE на categories.category_name (уже создано)
-- UNIQUE на products.sku (уже создано)
-- UNIQUE на payments.order_id (уже создано)
-- UNIQUE на deliveries.order_id (уже создано)

-- ===========================================================================
-- Конец файла 03-constraints.sql
-- ===========================================================================