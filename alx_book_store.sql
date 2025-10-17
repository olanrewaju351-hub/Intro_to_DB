-- FILE: alx_book_store.sql
-- Database for ALX online bookstore

DROP DATABASE IF EXISTS alx_book_store;
CREATE DATABASE alx_book_store CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE alx_book_store;

-- AUTHORS table
CREATE TABLE Authors (
    author_id INT NOT NULL AUTO_INCREMENT,
    author_name VARCHAR(215) NOT NULL,
    PRIMARY KEY (author_id)
) ENGINE=InnoDB;

-- BOOKS table
CREATE TABLE Books (
    book_id INT NOT NULL AUTO_INCREMENT,
    title VARCHAR(130) NOT NULL,
    author_id INT NOT NULL,
    price DOUBLE NOT NULL,
    publication_date DATE,
    PRIMARY KEY (book_id),
    INDEX idx_author_id (author_id),
    CONSTRAINT fk_books_author
        FOREIGN KEY (author_id)
        REFERENCES Authors(author_id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
) ENGINE=InnoDB;

-- CUSTOMERS table
CREATE TABLE Customers (
    customer_id INT NOT NULL AUTO_INCREMENT,
    customer_name VARCHAR(215) NOT NULL,
    email VARCHAR(215) UNIQUE,
    address TEXT,
    PRIMARY KEY (customer_id)
) ENGINE=InnoDB;

-- ORDERS table
CREATE TABLE Orders (
    order_id INT NOT NULL AUTO_INCREMENT,
    customer_id INT NOT NULL,
    order_date DATE NOT NULL,
    PRIMARY KEY (order_id),
    INDEX idx_orders_customer (customer_id),
    CONSTRAINT fk_orders_customer
        FOREIGN KEY (customer_id)
        REFERENCES Customers(customer_id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
) ENGINE=InnoDB;

-- ORDER_DETAILS table
CREATE TABLE Order_Details (
    orderdetailid INT NOT NULL AUTO_INCREMENT,
    order_id INT NOT NULL,
    book_id INT NOT NULL,
    quantity DOUBLE NOT NULL,
    PRIMARY KEY (orderdetailid),
    INDEX idx_od_order (order_id),
    INDEX idx_od_book (book_id),
    CONSTRAINT fk_od_order
        FOREIGN KEY (order_id)
        REFERENCES Orders(order_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT fk_od_book
        FOREIGN KEY (book_id)
        REFERENCES Books(book_id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
) ENGINE=InnoDB;

-- SAMPLE DATA (optional, helpful for testing)
INSERT INTO Authors (author_name) VALUES
('Chinua Achebe'),
('Chimamanda Ngozi Adichie'),
('J. K. Rowling');

INSERT INTO Books (title, author_id, price, publication_date) VALUES
('Things Fall Apart', 1, 9.99, '1958-06-17'),
('Half of a Yellow Sun', 2, 12.50, '2006-09-01'),
('Harry Potter and the Philosopher''s Stone', 3, 19.99, '1997-06-26');

INSERT INTO Customers (customer_name, email, address) VALUES
('Mary Johnson', 'mary.j@example.com', '12 Freedom Road, Lagos'),
('David Olu', 'david.o@example.com', '45 Unity Ave, Abuja');

INSERT INTO Orders (customer_id, order_date) VALUES
(1, '2025-10-01'),
(2, '2025-10-05');

INSERT INTO Order_Details (order_id, book_id, quantity) VALUES
(1, 1, 1),
(1, 3, 2),
(2, 2, 1);

-- Useful query examples
-- 1) List books with their authors
SELECT B.book_id, B.title, A.author_name, B.price, B.publication_date
FROM Books B
JOIN Authors A ON B.author_id = A.author_id
ORDER BY B.title;

-- 2) Get a customer's orders and total per order
SELECT O.order_id, O.order_date, C.customer_name,
       SUM(B.price * OD.quantity) AS order_total
FROM Orders O
JOIN Customers C ON O.customer_id = C.customer_id
JOIN Order_Details OD ON O.order_id = OD.order_id
JOIN Books B ON OD.book_id = B.book_id
GROUP BY O.order_id, O.order_date, C.customer_name
ORDER BY O.order_date DESC;

-- 3) Get details of a specific order (items)
SELECT O.order_id, O.order_date, C.customer_name, B.title, OD.quantity, B.price,
       (OD.quantity * B.price) AS line_total
FROM Orders O
JOIN Customers C ON O.customer_id = C.customer_id
JOIN Order_Details OD ON O.order_id = OD.order_id
JOIN Books B ON OD.book_id = B.book_id
WHERE O.order_id = 1;
