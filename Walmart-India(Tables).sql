CREATE DATABASE IF NOT EXISTS Walmart_India;
USE Walmart_India;
 
CREATE TABLE Users (
	user_id INT PRIMARY KEY AUTO_INCREMENT,
	username VARCHAR(50) UNIQUE NOT NULL,
	password VARCHAR(100) NOT NULL,
	role ENUM('admin', 'customer') DEFAULT 'customer'
);
ALTER TABLE Users AUTO_INCREMENT = 1;

CREATE TABLE Suppliers (
	supplier_id INT PRIMARY KEY AUTO_INCREMENT,
	name VARCHAR(100) NOT NULL,
	address VARCHAR(255) NOT NULL,
	contact_name VARCHAR(100),
	contact_email VARCHAR(100),
	contact_phone VARCHAR(20) 
);
ALTER TABLE Suppliers AUTO_INCREMENT = 1;

CREATE TABLE Categories (
	category_id INT AUTO_INCREMENT,
	category_type VARCHAR(50) NOT NULL,
    PRIMARY KEY (category_id, category_type)
);
ALTER TABLE Categories AUTO_INCREMENT = 1;

CREATE TABLE Stores (
	store_id INT PRIMARY KEY AUTO_INCREMENT,
	store_name VARCHAR(100) NOT NULL,
	store_location VARCHAR(255) not null
);
ALTER TABLE Stores AUTO_INCREMENT = 1;

CREATE TABLE Customers (
	customer_id INT PRIMARY KEY AUTO_INCREMENT,
	customer_name VARCHAR(100) NOT NULL,
	customer_gender ENUM('male', 'female', 'other'),
	customer_email VARCHAR(100),
	customer_phone VARCHAR(20),
	customer_address VARCHAR(255)
);
ALTER TABLE Customers AUTO_INCREMENT = 1;

CREATE TABLE Products (
    product_id INT PRIMARY KEY AUTO_INCREMENT,
    product_name VARCHAR(100) NOT NULL,
    product_description TEXT,
    product_quantity INT NOT NULL,
    product_price DECIMAL(10, 2) NOT NULL,
    supplier_id INT,
    category_id INT,
    category_type VARCHAR(50) NOT NULL,
    FOREIGN KEY (supplier_id) REFERENCES Suppliers(supplier_id),
    FOREIGN KEY (category_id, category_type) REFERENCES Categories(category_id, category_type)
);
ALTER TABLE Products AUTO_INCREMENT = 1;

CREATE TABLE Transactions (
    transaction_id INT PRIMARY KEY AUTO_INCREMENT,
    transaction_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    payment_type ENUM('cash', 'credit_card', 'debit_card', 'online_payment', 'cheque', 'other') DEFAULT 'cash',
    unit_price DECIMAL(10, 2) NOT NULL,
    quantity INT NOT NULL,
    tax DECIMAL(10, 2) DEFAULT (total_amount * 0.18), 
    total_amount DECIMAL(10, 2) NOT NULL,
    cogs DECIMAL(10, 2) DEFAULT 0.00,
    gross_margin DECIMAL(10, 2) DEFAULT 0.00,
    gross_income DECIMAL(10, 2) DEFAULT 0.00, 
    customer_id INT,
    store_id INT,
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id),
    FOREIGN KEY (store_id) REFERENCES Stores(store_id)
);
ALTER TABLE Transactions AUTO_INCREMENT = 1;

CREATE TABLE Sales (
    sale_id INT PRIMARY KEY AUTO_INCREMENT,
    sale_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    unit_price DECIMAL(10, 2) NOT NULL,
    sale_quantity INT NOT NULL,
    total_amount DECIMAL(10, 2) AS (unit_price * sale_quantity) STORED,
    product_id INT,
    store_id INT,
    transaction_id INT,
    FOREIGN KEY (product_id) REFERENCES Products(product_id),
    FOREIGN KEY (store_id) REFERENCES Stores(store_id),
    FOREIGN KEY (transaction_id) REFERENCES Transactions(transaction_id)
);
ALTER TABLE Sales AUTO_INCREMENT = 1;
 
CREATE TABLE CustomerOrders (
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    unit_price DECIMAL(10, 2) NOT NULL,
    quantity INT NOT NULL,
    total DECIMAL(10, 2) AS (unit_price * quantity) STORED, 
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    expected_delivery_date TIMESTAMP DEFAULT (CURRENT_TIMESTAMP + INTERVAL 7 DAY),
    status ENUM('pending', 'shipped', 'delivered') DEFAULT 'pending',
    customer_id INT,
    product_id INT,
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id),
    FOREIGN KEY (product_id) REFERENCES Products(product_id)
);
ALTER TABLE CustomerOrders AUTO_INCREMENT = 1;

CREATE TABLE Reviews (
    review_id INT PRIMARY KEY AUTO_INCREMENT,
    product_id INT,
    review_text TEXT,
    rating INT,
    reviewer_name VARCHAR(100),
    review_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (product_id) REFERENCES Products(product_id)
);
ALTER TABLE Reviews AUTO_INCREMENT = 1;

ALTER TABLE Products
ADD COLUMN review_id INT,
ADD FOREIGN KEY (review_id) REFERENCES Reviews(review_id);

CREATE TABLE Supplier_Store (
    supplier_id INT,
    store_id INT,
    PRIMARY KEY (supplier_id, store_id),
    FOREIGN KEY (supplier_id) REFERENCES Suppliers(supplier_id),
    FOREIGN KEY (store_id) REFERENCES Stores(store_id)
);

CREATE TABLE Store_Products (
    store_product_id INT PRIMARY KEY AUTO_INCREMENT,
    store_id INT,
    product_id INT,
    FOREIGN KEY (store_id) REFERENCES Stores(store_id),
    FOREIGN KEY (product_id) REFERENCES Products(product_id)
);
ALTER TABLE Store_Products AUTO_INCREMENT = 1;