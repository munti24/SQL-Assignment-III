-- ASSIGNMENT III: SQL TABLE MANIPULATION
-- Business idea: Library Management System
-- DBMS: PostgreSQL (run this file in pgAdmin's Query Tool)
-- IMPORTANT: Replace yourname_yourstudentid_library_system with your own required database name.
-- PostgreSQL note: CREATE DATABASE must be run separately, outside a transaction.
-- First create the database in pgAdmin (right-click Databases > Create > Database),
-- then open Query Tool for that database and run the statements below, starting at TABLE CREATION.

-- 1. TABLE CREATION
CREATE TABLE members (
    member_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(120) NOT NULL UNIQUE,
    phone VARCHAR(25),
    joined_on DATE NOT NULL
);

CREATE TABLE books (
    book_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    title VARCHAR(150) NOT NULL,
    author VARCHAR(100) NOT NULL,
    category VARCHAR(60) NOT NULL,
    published_year SMALLINT,
    available BOOLEAN NOT NULL DEFAULT TRUE
);

CREATE TABLE loans (
    loan_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    member_id INTEGER NOT NULL REFERENCES members(member_id),
    book_id INTEGER NOT NULL REFERENCES books(book_id),
    loan_date DATE NOT NULL,
    due_date DATE NOT NULL,
    returned_on DATE,
    CONSTRAINT chk_loan_dates CHECK (due_date >= loan_date),
    CONSTRAINT chk_return_date CHECK (returned_on IS NULL OR returned_on >= loan_date)
);

-- 2. INITIAL DATA: at least five rows in every table.
-- Do not manually assign identity primary keys.
INSERT INTO members (full_name, email, phone, joined_on) VALUES
('Aline Mukamana', 'aline.mukamana@example.com', '+250780000001', '2026-01-10'),
('Jean Niyonzima', 'jean.niyonzima@example.com', '+250780000002', '2026-01-15'),
('Grace Uwase', 'grace.uwase@example.com', '+250780000003', '2026-02-02'),
('Patrick Habimana', 'patrick.habimana@example.com', '+250780000004', '2026-02-14'),
('Diane Ingabire', 'diane.ingabire@example.com', '+250780000005', '2026-03-01');

INSERT INTO books (title, author, category, published_year, available) VALUES
('Things Fall Apart', 'Chinua Achebe', 'Fiction', 1958, TRUE),
('The River Between', 'Ngugi wa Thiong''o', 'Fiction', 1965, TRUE),
('Atomic Habits', 'James Clear', 'Self-help', 2018, TRUE),
('Clean Code', 'Robert C. Martin', 'Technology', 2008, TRUE),
('Database System Concepts', 'Abraham Silberschatz', 'Technology', 2019, TRUE),
('The Alchemist', 'Paulo Coelho', 'Fiction', 1988, TRUE);

INSERT INTO loans (member_id, book_id, loan_date, due_date, returned_on) VALUES
(1, 1, '2026-09-01', '2026-09-15', '2026-09-12'),
(2, 2, '2026-09-03', '2026-09-17', NULL),
(3, 3, '2026-09-05', '2026-09-19', NULL),
(1, 4, '2026-09-10', '2026-09-24', '2026-09-22'),
(4, 5, '2026-09-12', '2026-09-26', NULL);

-- Verify initial row counts.
SELECT COUNT(*) AS member_count FROM members;
SELECT COUNT(*) AS book_count FROM books;
SELECT COUNT(*) AS loan_count FROM loans;

-- Q1.1 SELECT: Basic data retrieval
SELECT title, author, category FROM books;

-- Q1.2 SELECT: Conditional retrieval
SELECT title, author, published_year
FROM books
WHERE category = 'Technology';

-- Q1.3 SELECT: Sorted retrieval
SELECT title, published_year
FROM books
ORDER BY published_year DESC;

-- Q2.1 INNER JOIN
SELECT l.loan_id, m.full_name, l.loan_date, l.due_date
FROM loans AS l
INNER JOIN members AS m ON l.member_id = m.member_id;

-- Q2.2 LEFT JOIN: all members, including members without loans
SELECT m.member_id, m.full_name, l.loan_id, l.loan_date
FROM members AS m
LEFT JOIN loans AS l ON m.member_id = l.member_id
ORDER BY m.member_id;

-- Q2.3 Multi-table JOIN
SELECT m.full_name, b.title, l.loan_date, l.due_date, l.returned_on
FROM loans AS l
INNER JOIN members AS m ON l.member_id = m.member_id
INNER JOIN books AS b ON l.book_id = b.book_id
ORDER BY l.loan_date;

-- Q3.1 UPDATE one record; verify before and after
SELECT member_id, full_name, phone FROM members WHERE email = 'aline.mukamana@example.com';
UPDATE members
SET phone = '+250788111001'
WHERE email = 'aline.mukamana@example.com';
SELECT member_id, full_name, phone FROM members WHERE email = 'aline.mukamana@example.com';

-- Q3.2 UPDATE multiple records; verify before and after
SELECT book_id, title, category FROM books WHERE category = 'Technology';
UPDATE books
SET category = 'Computing'
WHERE category = 'Technology';
SELECT book_id, title, category FROM books WHERE category = 'Computing';

-- Q3.3 Conditional UPDATE: books on loans that have not been returned
SELECT b.book_id, b.title, b.available
FROM books AS b
JOIN loans AS l ON l.book_id = b.book_id
WHERE l.returned_on IS NULL;
UPDATE books AS b
SET available = FALSE
FROM loans AS l
WHERE l.book_id = b.book_id
  AND l.returned_on IS NULL;
SELECT book_id, title, available FROM books WHERE available = FALSE;

-- Q4.1 ALTER TABLE: rename column
ALTER TABLE members RENAME COLUMN phone TO phone_number;
SELECT column_name, data_type FROM information_schema.columns
WHERE table_name = 'members' ORDER BY ordinal_position;
SELECT full_name, phone_number FROM members;

-- Q4.2 ALTER TABLE: change data type safely
ALTER TABLE books ALTER COLUMN title TYPE VARCHAR(200);
SELECT column_name, data_type, character_maximum_length
FROM information_schema.columns
WHERE table_name = 'books' AND column_name = 'title';
SELECT book_id, title FROM books;

-- Q4.3 ALTER TABLE: add a relevant column
ALTER TABLE members
ADD COLUMN membership_type VARCHAR(20) NOT NULL DEFAULT 'Standard';
SELECT column_name, data_type FROM information_schema.columns
WHERE table_name = 'members' ORDER BY ordinal_position;
SELECT member_id, full_name, membership_type FROM members;

-- Q5.1 INSERT a single record
INSERT INTO members (full_name, email, phone_number, joined_on, membership_type)
VALUES ('Samuel Bizimana', 'samuel.bizimana@example.com', '+250788111006', '2026-10-01', 'Standard');
SELECT member_id, full_name, email FROM members WHERE email = 'samuel.bizimana@example.com';

-- Q5.2 INSERT multiple records
INSERT INTO books (title, author, category, published_year, available) VALUES
('The Pragmatic Programmer', 'Andrew Hunt and David Thomas', 'Technology', 1999, TRUE),
('Introduction to Algorithms', 'Thomas H. Cormen et al.', 'Technology', 2022, TRUE),
('Half of a Yellow Sun', 'Chimamanda Ngozi Adichie', 'Fiction', 2006, TRUE);
SELECT book_id, title, author FROM books
WHERE title IN ('The Pragmatic Programmer', 'Introduction to Algorithms', 'Half of a Yellow Sun');

-- Q5.3 INSERT a related child record using existing parent IDs
INSERT INTO loans (member_id, book_id, loan_date, due_date, returned_on)
VALUES (5, 6, '2026-10-20', '2026-11-03', NULL);
SELECT l.loan_id, m.full_name, b.title, l.loan_date, l.due_date
FROM loans AS l
JOIN members AS m ON l.member_id = m.member_id
JOIN books AS b ON l.book_id = b.book_id
WHERE l.member_id = 5 AND l.book_id = 6 AND l.loan_date = '2026-10-20';

-- FINAL VERIFICATION
SELECT 'members' AS table_name, COUNT(*) AS total_rows FROM members
UNION ALL
SELECT 'books', COUNT(*) FROM books
UNION ALL
SELECT 'loans', COUNT(*) FROM loans;
