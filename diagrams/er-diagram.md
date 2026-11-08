# ER-диаграмма (Mermaid)

Диаграмма отражает реальную схему базы данных: девять таблиц, их первичные и внешние ключи, уникальные поля и виды связей. Подписи к связям даны на русском языке.

```mermaid
erDiagram
    roles ||--o{ users : "назначается многим пользователям"
    categories ||--o{ products : "содержит много товаров"
    customers ||--o{ orders : "клиент оформляет много заказов"
    orders ||--|{ order_items : "содержит много позиций"
    products ||--o{ order_items : "входит в позиции разных заказов"
    orders ||--|| payments : "один платёж на заказ"
    orders ||--|| deliveries : "одна доставка на заказ"

    roles {
        smallint role_id PK
        varchar role_name UK
        text description
    }

    users {
        smallint user_id PK
        varchar username UK
        varchar email UK
        smallint role_id FK
        boolean is_active
        timestamp created_at
    }

    customers {
        integer customer_id PK
        varchar first_name
        varchar last_name
        varchar email UK
        varchar phone
        text address
        timestamp created_at
    }

    categories {
        smallint category_id PK
        varchar category_name UK
        text description
    }

    products {
        integer product_id PK
        varchar sku UK
        varchar product_name
        text description
        smallint category_id FK
        numeric price
        integer stock_quantity
        boolean is_active
        timestamp created_at
    }

    orders {
        integer order_id PK
        integer customer_id FK
        timestamp order_date
        varchar status
        numeric total_amount
        text shipping_address
    }

    order_items {
        integer order_item_id PK
        integer order_id FK
        integer product_id FK
        integer quantity
        numeric unit_price
    }

    payments {
        integer payment_id PK
        integer order_id UK FK
        timestamp payment_date
        numeric amount
        varchar payment_method
        varchar status
    }

    deliveries {
        integer delivery_id PK
        integer order_id UK FK
        timestamp delivery_date
        varchar delivery_method
        text delivery_address
        numeric delivery_cost
        varchar status
    }
```

## Виды связей

Роли и пользователи — «один ко многим»: одной роли соответствует много пользователей, у пользователя ровно одна роль. Категории и товары — тоже «один ко многим». Клиенты и заказы — один клиент оформляет много заказов. Заказы и позиции — один заказ содержит много позиций, позиция относится к одному заказу. Товары и позиции — один товар может входить в позиции разных заказов. К заказу относится не более одного платежа и не более одной доставки — связь «один к одному или одному к нулю».

## Согласованность со схемой

Диаграмма соответствует файлам `sql/02-create-tables.sql` и `sql/03-constraints.sql`: все девять таблиц, первичные ключи, внешние ключи, уникальные поля и типы связей совпадают с SQL-схемой. Поля, типы и порядок создания таблиц также согласованы.
