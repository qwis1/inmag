-- 07-queries.sql
-- Практические SQL-запросы для базы данных интернет-магазина
-- Выполнять подключённым к базе shopdb (например, от имени shop_readonly).
-- Каждый запрос снабжён комментарием с номером из ТЗ.

-- ===========================================================================
-- 1. Получение списка товаров
-- ===========================================================================
SELECT
    product_id,
    sku,
    product_name,
    category_id,
    price,
    stock_quantity,
    is_active,
    created_at
FROM products
ORDER BY product_id;

-- ===========================================================================
-- 2. Поиск товаров по категории
-- ===========================================================================
SELECT
    p.product_id,
    p.sku,
    p.product_name,
    p.price,
    p.stock_quantity
FROM products p
JOIN categories c ON p.category_id = c.category_id
WHERE c.category_name = 'Электроника'
ORDER BY p.product_name;

-- ===========================================================================
-- 3. Поиск товара по артикулу (sku)
-- ===========================================================================
SELECT
    product_id,
    sku,
    product_name,
    price,
    stock_quantity
FROM products
WHERE sku = 'SMG-001';

-- ===========================================================================
-- 4. Список заказов клиента
-- ===========================================================================
SELECT
    o.order_id,
    o.order_date,
    o.status,
    o.total_amount,
    o.shipping_address
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
WHERE c.customer_id = 1
ORDER BY o.order_date DESC;

-- ===========================================================================
-- 5. Состав конкретного заказа (заказ №1)
-- ===========================================================================
SELECT
    oi.order_item_id,
    oi.order_id,
    p.product_id,
    p.sku,
    p.product_name,
    oi.quantity,
    oi.unit_price,
    (oi.quantity * oi.unit_price) AS position_total
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
WHERE oi.order_id = 1
ORDER BY oi.order_item_id;

-- ===========================================================================
-- 6. Сумма заказа (пересчёт через позиции)
-- ===========================================================================
SELECT
    o.order_id,
    o.customer_id,
    o.total_amount AS stored_total,
    SUM(oi.quantity * oi.unit_price) AS calculated_total
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.order_id = 1
GROUP BY o.order_id, o.customer_id, o.total_amount;

-- ===========================================================================
-- 7. Список оплаченных заказов (статус платежа = success)
-- ===========================================================================
SELECT
    o.order_id,
    o.order_date,
    c.first_name,
    c.last_name,
    p.amount,
    p.payment_method,
    p.status AS payment_status
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
JOIN payments p ON o.order_id = p.order_id
WHERE p.status = 'success'
ORDER BY o.order_date DESC;

-- ===========================================================================
-- 8. Список заказов по статусу (например, 'processing')
-- ===========================================================================
SELECT
    order_id,
    customer_id,
    order_date,
    status,
    total_amount
FROM orders
WHERE status = 'processing'
ORDER BY order_date;

-- ===========================================================================
-- 9. Продажи товаров (сколько единиц каждого товара продано)
-- ===========================================================================
SELECT
    p.product_id,
    p.sku,
    p.product_name,
    SUM(oi.quantity) AS total_sold_quantity,
    SUM(oi.quantity * oi.unit_price) AS total_sold_amount
FROM products p
JOIN order_items oi ON p.product_id = oi.product_id
JOIN orders o ON oi.order_id = o.order_id
WHERE o.status <> 'cancelled'
GROUP BY p.product_id, p.sku, p.product_name
ORDER BY total_sold_quantity DESC;

-- ===========================================================================
-- 10. Наиболее популярные товары (TOP-5 по количеству продаж)
-- ===========================================================================
SELECT
    p.product_id,
    p.sku,
    p.product_name,
    SUM(oi.quantity) AS total_sold_quantity
FROM products p
JOIN order_items oi ON p.product_id = oi.product_id
JOIN orders o ON oi.order_id = o.order_id
WHERE o.status <> 'cancelled'
GROUP BY p.product_id, p.sku, p.product_name
ORDER BY total_sold_quantity DESC
LIMIT 5;

-- ===========================================================================
-- 11. Количество заказов каждого клиента
-- ===========================================================================
SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    c.email,
    COUNT(o.order_id) AS orders_count,
    COALESCE(SUM(o.total_amount), 0) AS total_spent
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name, c.email
ORDER BY orders_count DESC, total_spent DESC;

-- ===========================================================================
-- 12. Запрос с JOIN минимум трёх таблиц
--     (заказ + клиент + платеж + доставка — 4 таблицы)
-- ===========================================================================
SELECT
    o.order_id,
    o.order_date,
    o.status AS order_status,
    c.first_name,
    c.last_name,
    c.email,
    p.amount AS payment_amount,
    p.status AS payment_status,
    d.delivery_method,
    d.status AS delivery_status
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
LEFT JOIN payments p ON o.order_id = p.order_id
LEFT JOIN deliveries d ON o.order_id = d.order_id
ORDER BY o.order_date DESC;

-- ===========================================================================
-- 13. Агрегатный запрос (общая выручка по статусам заказов)
-- ===========================================================================
SELECT
    o.status,
    COUNT(*) AS orders_count,
    SUM(o.total_amount) AS total_revenue,
    AVG(o.total_amount) AS average_order_value
FROM orders o
GROUP BY o.status
ORDER BY total_revenue DESC;

-- ===========================================================================
-- 14. Запрос с GROUP BY (средняя стоимость позиции заказа по товарам)
-- ===========================================================================
SELECT
    p.product_id,
    p.product_name,
    COUNT(oi.order_item_id) AS positions_count,
    AVG(oi.unit_price) AS avg_unit_price,
    SUM(oi.quantity) AS total_quantity
FROM products p
JOIN order_items oi ON p.product_id = oi.product_id
GROUP BY p.product_id, p.product_name
HAVING COUNT(oi.order_item_id) > 0
ORDER BY total_quantity DESC;

-- ===========================================================================
-- 15. Запрос с CTE (заказы с общим количеством позиций и суммой)
-- ===========================================================================
WITH order_summary AS (
    SELECT
        order_id,
        COUNT(*) AS items_count,
        SUM(quantity * unit_price) AS items_total
    FROM order_items
    GROUP BY order_id
)
SELECT
    o.order_id,
    o.order_date,
    c.first_name,
    c.last_name,
    os.items_count,
    os.items_total,
    o.status
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
JOIN order_summary os ON o.order_id = os.order_id
ORDER BY o.order_date DESC;

-- ===========================================================================
-- Дополнительный запрос: заказы, ожидающие оплаты, старше 1 дня
-- ===========================================================================
SELECT
    o.order_id,
    o.order_date,
    c.email,
    o.total_amount
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
WHERE o.status = 'awaiting_payment'
  AND o.order_date < NOW() - INTERVAL '1 day';

-- Конец файла 07-queries.sql