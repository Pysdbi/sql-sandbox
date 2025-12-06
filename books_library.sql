-- Самые частые команды:
-- CREATE table
-- CREATE Database
-- DROP Table
-- DROP Database
--
-- INSERT table fields (...) values (...)
-- UPDATE table
-- SELECT from table
-- DELETE from table


-- ============================================
-- Схема базы данных библиотеки
-- ============================================

-- Таблица библиотек
CREATE TABLE libraries (
    -- [name] [type] [params]
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    address VARCHAR(500),
    phone VARCHAR(20),
    created_at timestamp DEFAULT CURRENT_TIMESTAMP
);

-- Таблица авторов
CREATE TABLE authors (
    id SERIAL PRIMARY KEY,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    birth_year INT,
    country VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Таблица книг
CREATE TABLE books (
    id SERIAL PRIMARY KEY, -- PK
    title VARCHAR(500) NOT NULL,
    isbn VARCHAR(20) UNIQUE,
    publish_year INT,
    pages INT,
    library_id INT REFERENCES libraries(id), -- FK
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


-- Связь книг и авторов (многие ко многим)
CREATE TABLE book_authors (
    book_id INT REFERENCES books(id) ON DELETE CASCADE,
    author_id INT REFERENCES authors(id) ON DELETE CASCADE,
    PRIMARY KEY (book_id, author_id)
);

-- Таблица читателей
CREATE TABLE readers (
    id SERIAL PRIMARY KEY,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    email VARCHAR(255) UNIQUE,
    phone VARCHAR(20),
    library_card_number VARCHAR(50) UNIQUE NOT NULL,
    registered_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Статусы выдачи книг
CREATE TYPE loan_status AS ENUM ('issued', 'returned', 'overdue', 'lost');

-- Таблица выдачи книг (какие книги взяты)
CREATE TABLE book_loans (
    id SERIAL PRIMARY KEY,
    book_id INT REFERENCES books(id) ON DELETE CASCADE,
    reader_id INT REFERENCES readers(id) ON DELETE CASCADE,
    library_id INT REFERENCES libraries(id) ON DELETE SET NULL,
    status loan_status DEFAULT 'issued',
    issued_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    due_date DATE NOT NULL,
    returned_at TIMESTAMP,
    notes TEXT
);

-- 1 = m
-- 2 = f

-- Индексы для ускорения запросов
CREATE INDEX idx_books_library ON books(library_id);
CREATE INDEX idx_book_loans_reader ON book_loans(reader_id);
CREATE INDEX idx_book_loans_book ON book_loans(book_id);
CREATE INDEX idx_book_loans_status ON book_loans(status);

-- ============================================
-- Тестовые данные
-- ============================================

-- Библиотеки
INSERT INTO libraries (name, address, phone) VALUES
('Центральная городская библиотека', 'ул. Ленина, 15', '+7-495-123-4567'),
('Библиотека им. Пушкина', 'пр. Мира, 42', '+7-495-234-5678'),
('Детская библиотека №3', 'ул. Гагарина, 8', '+7-495-345-6789');

-- Авторы
INSERT INTO authors (first_name, last_name, birth_year, country) VALUES
('Лев', 'Толстой', 1828, 'Россия'),
('Фёдор', 'Достоевский', 1821, 'Россия'),
('Антон', 'Чехов', 1860, 'Россия'),
('Александр', 'Пушкин', 1799, 'Россия'),
('Михаил', 'Булгаков', 1891, 'Россия'),
('Джордж', 'Оруэлл', 1903, 'Великобритания'),
('Эрнест', 'Хемингуэй', 1899, 'США'),
('Габриэль', 'Гарсиа Маркес', 1927, 'Колумбия');

-- Книги
INSERT INTO books (title, isbn, publish_year, pages, library_id) VALUES
('Война и мир', '978-5-17-090000-1', 1869, 1225, 1),
('Анна Каренина', '978-5-17-090000-2', 1877, 864, 1),
('Преступление и наказание', '978-5-17-090000-3', 1866, 672, 1),
('Братья Карамазовы', '978-5-17-090000-4', 1880, 824, 2),
('Вишнёвый сад', '978-5-17-090000-5', 1904, 96, 2),
('Евгений Онегин', '978-5-17-090000-6', 1833, 224, 1),
('Мастер и Маргарита', '978-5-17-090000-7', 1967, 480, 1),
('1984', '978-5-17-090000-8', 1949, 328, 2),
('Старик и море', '978-5-17-090000-9', 1952, 128, 3),
('Сто лет одиночества', '978-5-17-090001-0', 1967, 480, 3);

-- Связи книг и авторов
INSERT INTO book_authors (book_id, author_id) VALUES
(1, 1), -- Война и мир - Толстой
(2, 1), -- Анна Каренина - Толстой
(3, 2), -- Преступление и наказание - Достоевский
(4, 2), -- Братья Карамазовы - Достоевский
(5, 3), -- Вишнёвый сад - Чехов
(6, 4), -- Евгений Онегин - Пушкин
(7, 5), -- Мастер и Маргарита - Булгаков
(8, 6), -- 1984 - Оруэлл
(9, 7), -- Старик и море - Хемингуэй
(10, 8); -- Сто лет одиночества - Маркес

-- Читатели
INSERT INTO readers (first_name, last_name, email, phone, library_card_number) VALUES
('Иван', 'Петров', 'ivan.petrov@email.ru', '+7-916-111-2233', 'LIB-001'),
('Мария', 'Сидорова', 'maria.sidorova@email.ru', '+7-916-222-3344', 'LIB-002'),
('Алексей', 'Козлов', 'alexey.kozlov@email.ru', '+7-916-333-4455', 'LIB-003'),
('Елена', 'Новикова', 'elena.novikova@email.ru', '+7-916-444-5566', 'LIB-004'),
('Дмитрий', 'Морозов', 'dmitry.morozov@email.ru', '+7-916-555-6677', 'LIB-005');

-- Выдачи книг
INSERT INTO book_loans (book_id, reader_id, library_id, status, issued_at, due_date, returned_at, notes) VALUES
-- Активные выдачи
(1, 1, 1, 'issued', '2024-11-15 10:00:00', '2024-12-15', NULL, 'Первый том'),
(3, 1, 1, 'issued', '2024-11-20 14:30:00', '2024-12-20', NULL, NULL),
(7, 2, 1, 'issued', '2024-11-25 09:15:00', '2024-12-25', NULL, 'Любимая книга'),
(8, 3, 2, 'issued', '2024-12-01 11:00:00', '2025-01-01', NULL, NULL),

-- Просроченные
(4, 4, 2, 'overdue', '2024-10-01 10:00:00', '2024-11-01', NULL, 'Необходимо связаться с читателем'),

-- Возвращённые
(2, 1, 1, 'returned', '2024-09-01 10:00:00', '2024-10-01', '2024-09-28 16:00:00', NULL),
(5, 2, 2, 'returned', '2024-10-15 12:00:00', '2024-11-15', '2024-11-10 14:30:00', NULL),
(6, 3, 1, 'returned', '2024-08-01 09:00:00', '2024-09-01', '2024-08-25 11:00:00', 'Отличное состояние'),
(9, 5, 3, 'returned', '2024-11-01 10:00:00', '2024-12-01', '2024-11-28 15:00:00', NULL),

-- Потерянная книга
(10, 4, 3, 'lost', '2024-07-01 10:00:00', '2024-08-01', NULL, 'Читатель компенсировал стоимость');

-- ============================================
-- Полезные представления (views)
-- ============================================

-- Активные выдачи с полной информацией
CREATE VIEW active_loans AS
SELECT
    bl.id AS loan_id,
    b.title AS book_title,
    a.first_name || ' ' || a.last_name AS author_name,
    r.first_name || ' ' || r.last_name AS reader_name,
    r.library_card_number,
    l.name AS library_name,
    bl.status,
    bl.issued_at,
    bl.due_date,
    CASE
        WHEN bl.due_date < CURRENT_DATE AND bl.status = 'issued' THEN 'Просрочено'
        ELSE 'В срок'
    END AS due_status
FROM book_loans bl
JOIN books b ON bl.book_id = b.id
JOIN readers r ON bl.reader_id = r.id
JOIN libraries l ON bl.library_id = l.id
LEFT JOIN book_authors ba ON b.id = ba.book_id
LEFT JOIN authors a ON ba.author_id = a.id
WHERE bl.status IN ('issued', 'overdue');

-- Статистика по библиотекам
CREATE VIEW library_stats AS
SELECT
    l.id,
    l.name,
    COUNT(DISTINCT b.id) AS total_books,
    COUNT(DISTINCT bl.id) FILTER (WHERE bl.status = 'issued') AS books_issued,
    COUNT(DISTINCT bl.id) FILTER (WHERE bl.status = 'overdue') AS books_overdue
FROM libraries l
LEFT JOIN books b ON l.id = b.library_id
LEFT JOIN book_loans bl ON l.id = bl.library_id
GROUP BY l.id, l.name;

