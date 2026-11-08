-- 04-indexes.sql
-- Индексы базы данных интернет-магазина.
-- Выполнять после 03-constraints.sql, подключённым к базе shopdb.
-- Индексы на внешние ключи ускоряют JOIN и проверки ссылочной целостности.
-- UNIQUE-ограничения на sku, email, username и order_id уже создают свои индексы,
-- поэтому отдельные индексы на эти поля не нужны и не создаются.

-- Внешние ключи (ускоряют соединения и проверки ссылочной целостности)

CREATE INDEX idx_users_role_id ON users(role_id);
COMMENT ON INDEX idx_users_role_id IS 'Поиск пользователей по роли';

CREATE INDEX idx_products_category_id ON products(category_id);
COMMENT ON INDEX idx_products_category_id IS 'Поиск товаров по категории';

CREATE INDEX idx_orders_customer_id ON orders(customer_id);
COMMENT ON INDEX idx_orders_customer_id IS 'Поиск заказов клиента';

CREATE INDEX idx_order_items_order_id ON order_items(order_id);
COMMENT ON INDEX idx_order_items_order_id IS 'Получение состава заказа';

CREATE INDEX idx_order_items_product_id ON order_items(product_id);
COMMENT ON INDEX idx_order_items_product_id IS 'Поиск позиций по товару';

CREATE INDEX idx_payments_order_id ON payments(order_id);
COMMENT ON INDEX idx_payments_order_id IS 'Поиск платежа по заказу';

CREATE INDEX idx_deliveries_order_id ON deliveries(order_id);
COMMENT ON INDEX idx_deliveries_order_id IS 'Поиск доставки по заказу';

-- Частые условия фильтрации

CREATE INDEX idx_orders_status ON orders(status);
COMMENT ON INDEX idx_orders_status IS 'Фильтрация заказов по статусу';

CREATE INDEX idx_payments_status ON payments(status);
COMMENT ON INDEX idx_payments_status IS 'Фильтрация платежей по статусу';

CREATE INDEX idx_deliveries_status ON deliveries(status);
COMMENT ON INDEX idx_deliveries_status IS 'Фильтрация доставок по статусу';

CREATE INDEX idx_orders_order_date ON orders(order_date);
COMMENT ON INDEX idx_orders_order_date IS 'Фильтрация заказов по дате оформления';

CREATE INDEX idx_products_category_active ON products(category_id, is_active);
COMMENT ON INDEX idx_products_category_active IS 'Поиск активных товаров внутри категории';

-- Конец файла 04-indexes.sql
