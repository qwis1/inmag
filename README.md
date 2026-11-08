# Система управления заказами интернет-магазина

Учебный проект производственной практики по ПМ.11. Реляционная база данных на PostgreSQL для интернет-магазина: каталог товаров, клиенты, заказы, платежи и доставка.

## Что в проекте

Проект собран вокруг реальной схемы интернет-магазина и включает:

- анализ предметной области и бизнес-правила;
- нормализованную SQL-схему (третья нормальная форма) с таблицами, ограничениями и индексами;
- ER-диаграмму в Mermaid;
- скрипты создания ролей и настройки прав доступа;
- набор реалистичных тестовых данных;
- набор praktических SQL-запросов;
- скрипты резервного копирования и восстановления;
- документацию по администрированию и безопасности.

## Стек

- PostgreSQL 13 или новее
- SQL (диалект PostgreSQL)
- Markdown и Mermaid для документации
- Bash-скрипты для бэкапа и восстановления

## Структура

```
database-practice/
├── README.md
├── docs/
│   ├── 01-domain-analysis.md
│   ├── 02-business-rules.md
│   ├── 03-database-design.md
│   ├── 04-administration.md
│   └── 05-security-and-backup.md
├── diagrams/
│   └── er-diagram.md
├── sql/
│   ├── 01-create-database.sql
│   ├── 02-create-tables.sql
│   ├── 03-constraints.sql
│   ├── 04-indexes.sql
│   ├── 05-roles-and-permissions.sql
│   ├── 06-test-data.sql
│   └── 07-queries.sql
└── scripts/
    ├── backup.sh
    └── restore.sh
```

## Что нужно установить

- PostgreSQL 13 или новее (клиент `psql` и утилиты `pg_dump`, `pg_restore`).
- Для запуска скриптов на Windows подойдёт Git Bash или WSL.

## Подключение

Стандартный порт PostgreSQL — 5432.

```bash
psql -h localhost -U postgres -p 5432
```

Параметры подключения удобно задавать через переменные окружения, чтобы не держать пароли в коде:

```bash
export PGHOST=localhost
export PGPORT=5432
export PGUSER=shop_admin
export PGDATABASE=shopdb
export PGPASSWORD=
```

## Порядок запуска

Все SQL-скрипты запускаются из корня проекта `database-practice/`.

1. Создать базу данных (от имени пользователя с правом на создание баз, например `postgres`):
   ```bash
   psql -U postgres -f sql/01-create-database.sql
   ```

2. Подключиться к созданной базе и создать таблицы:
   ```bash
   psql -U shop_admin -d shopdb -f sql/02-create-tables.sql
   ```

3. Добавить ограничения целостности:
   ```bash
   psql -U shop_admin -d shopdb -f sql/03-constraints.sql
   ```

4. Создать индексы:
   ```bash
   psql -U shop_admin -d shopdb -f sql/04-indexes.sql
   ```

5. Настроить роли и права доступа:
   ```bash
   psql -U postgres -d shopdb -f sql/05-roles-and-permissions.sql
   ```

6. Загрузить тестовые данные:
   ```bash
   psql -U shop_admin -d shopdb -f sql/06-test-data.sql
   ```

7. Проверить работу запросов:
   ```bash
   psql -U shop_readonly -d shopdb -f sql/07-queries.sql
   ```

Первый скрипт (`01-create-database.sql`) выполняется отдельно, потому что `CREATE DATABASE` в PostgreSQL нельзя запускать внутри транзакции, и подключаться нужно к другой базе (обычно к `postgres`).

## Роли и права

Четыре роли по принципу минимальных привилегий:

- `shop_admin` — полный доступ ко всем таблицам и последовательностям.
- `shop_manager` — может вставлять, обновлять и удалять товары, категории, заказы и позиции заказов; читает остальные таблицы.
- `shop_operator` — читает все таблицы, может менять только заказы и доставки.
- `shop_readonly` — только чтение, подходит для отчётов и аналитики.

Пароли не хранятся в репозитории. Задайте их отдельно через `ALTER USER ... WITH PASSWORD` или переменную `PGPASSWORD`.

## Тестовые данные

Скрипт `sql/06-test-data.sql` заполняет базу правдоподобными данными: 5 клиентов, 4 категории, 12 товаров, 4 сотрудника, 6 заказов с позициями, платежи и доставки.

## Резервное копирование и восстановление

Создать копию:

```bash
./scripts/backup.sh
```

Восстановить из копии:

```bash
./scripts/restore.sh ./backups/shopdb_backup_20261009_120000.sql
```

Скрипты берут параметры подключения из переменных окружения и не содержат секретов.

## Документация

- `docs/01-domain-analysis.md` — как работает магазин и какие данные хранятся.
- `docs/02-business-rules.md` — бизнес-правила и их реализация в базе.
- `docs/03-database-design.md` — описание таблиц, связей и ограничений.
- `diagrams/er-diagram.md` — ER-диаграмма в Mermaid.
- `docs/04-administration.md` — развёртывание, подключение, обслуживание.
- `docs/05-security-and-backup.md` — защита данных, роли, SSL, бэкап и восстановление.
