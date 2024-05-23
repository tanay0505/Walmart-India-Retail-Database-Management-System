-- GetCustomerOrders
DELIMITER $$
CREATE PROCEDURE GetCustomerOrders(in_customer_id INT)
BEGIN
    SELECT * FROM CustomerOrders WHERE customer_id = in_customer_id;
END$$
DELIMITER ;

CALL GetCustomerOrders(1);
select*from CustomerOrders;


-- GetSupplierProducts: Retrieves all products supplied by a specific supplier 
DELIMITER $$
CREATE FUNCTION GetSupplierProducts(supplier_id_param INT) RETURNS INT
READS SQL DATA
BEGIN
    DECLARE product_count INT;
    SELECT COUNT(*) INTO product_count FROM Products WHERE supplier_id = supplier_id_param;
    RETURN product_count;
END$$
DELIMITER ;

SELECT GetSupplierProducts(1) AS product_count;


-- GetProductReviews: Retrieves all reviews for a specific product
DELIMITER $$
CREATE PROCEDURE GetProductReviews(IN prod_id INT)
BEGIN
    SELECT * FROM Reviews WHERE product_id = prod_id;
END$$
DELIMITER ;

CALL GetProductReviews(123);


-- UpdateProductPrice: Updates the price of a product.
DELIMITER //
CREATE PROCEDURE UpdateProductPrice (
    IN product_id_param INT,
    IN new_price DECIMAL(10, 2)
)
BEGIN
    UPDATE Products SET product_price = new_price WHERE product_id = product_id_param;
END //
DELIMITER ;

select*from Products;
CALL UpdateProductPrice(123, 19.99);


-- Update Customer Information
DELIMITER //
CREATE PROCEDURE UpdateCustomerInfo(
    IN customerId INT,
    IN newName VARCHAR(100),
    IN newEmail VARCHAR(100),
    IN newPhone VARCHAR(20),
    IN newAddress VARCHAR(255),
    IN newGender ENUM('male', 'female', 'other')
)
BEGIN
    UPDATE Customers
    SET customer_name = newName,
        customer_email = newEmail,
        customer_phone = newPhone,
        customer_address = newAddress,
        customer_gender = newGender
    WHERE customer_id = customerId;
END //
DELIMITER ;

CALL UpdateCustomerInfo(1,'John Doe', 'john.doe@example.com', '1234567890', '123 Main Street', 'male');
select*from Customers;


-- Search Products
DELIMITER //
CREATE PROCEDURE SearchProducts(
    IN searchKeyword VARCHAR(100),
    IN categoryName VARCHAR(50),
    IN minPrice DECIMAL(10,2),
    IN maxPrice DECIMAL(10,2)
)
BEGIN
    SELECT *
    FROM Products
    WHERE product_name LIKE CONCAT('%', searchKeyword, '%')
        AND category_type = categoryName
        AND product_price BETWEEN minPrice AND maxPrice;
END //
DELIMITER ;

CALL SearchProducts('shirt', 'Fashion', 10.00, 50.00);
select*from Products;


-- Get Top Selling Products
DELIMITER //
CREATE PROCEDURE GetTopSellingProducts(limit_count INT)
BEGIN
    SELECT p.product_id, p.product_name, SUM(s.quantity) AS total_sales
    FROM Sales s
    INNER JOIN Products p ON s.product_id = p.product_id
    GROUP BY p.product_id, p.product_name
    ORDER BY total_sales DESC
    LIMIT limit_count;
END//
DELIMITER ;

CALL GetTopSellingProducts(10);


-- Update Product Quantity
DELIMITER //
CREATE PROCEDURE UpdateProductQuantity (
    IN product_id_param INT,
    IN new_quantity INT
)
BEGIN
    UPDATE Products SET product_quantity = new_quantity WHERE product_id = product_id_param;
END //
DELIMITER ;

CALL UpdateProductQuantity(123, 50);
select*from Products;


-- Check Stock Availability
DELIMITER $$
CREATE FUNCTION CheckStockAvailability(product_id_param INT, required_quantity INT) RETURNS BOOLEAN
READS SQL DATA
BEGIN
    DECLARE available_quantity INT;
    SELECT product_quantity INTO available_quantity FROM Products WHERE product_id = product_id_param;
    IF available_quantity >= required_quantity THEN
        RETURN TRUE;
    ELSE
        RETURN FALSE;
    END IF;
END$$
DELIMITER ;

SELECT CheckStockAvailability(123, 20) AS is_available;
SELECT CheckStockAvailability(122, 120) AS is_available;


-- GetMonthlySalesByStore
DELIMITER $$
CREATE FUNCTION GetMonthlySalesByStore(store_number int, month_number int, year_number int) RETURNS DECIMAL(10, 2)
READS SQL DATA
BEGIN
    DECLARE total_sales DECIMAL(10, 2);

    SELECT SUM(total_amount) INTO total_sales
    FROM Sales
    WHERE store_id=store_number and month(sale_date)=month_number and year(sale_date)=year_number;

    RETURN total_sales;
END$$
DELIMITER ;

SELECT GetMonthlySalesByStore(1,4,2024) AS monthly_sales;
SELECT GetMonthlySalesByStore(2,4,2024) AS monthly_sales;
SELECT GetMonthlySalesByStore(3,4,2024) AS monthly_sales;
SELECT GetMonthlySalesByStore(4,4,2024) AS monthly_sales;
SELECT GetMonthlySalesByStore(5,4,2024) AS monthly_sales;


-- GetMonthlyTransactionsByStore
DELIMITER $$
CREATE FUNCTION GetMonthlyTransactionsByStore(store_number INT, month_number INT, year_number INT) RETURNS INT
READS SQL DATA
BEGIN
    DECLARE total_transactions INT;

    SELECT COUNT(*) INTO total_transactions
    FROM Transactions
    WHERE store_id = store_number AND MONTH(transaction_date) = month_number AND YEAR(transaction_date) = year_number;

    RETURN total_transactions;
END$$
DELIMITER ;

SELECT GetMonthlyTransactionsByStore(1, 4, 2024);
SELECT GetMonthlyTransactionsByStore(2, 4, 2024);
SELECT GetMonthlyTransactionsByStore(3, 4, 2024);
SELECT GetMonthlyTransactionsByStore(4, 4, 2024);
SELECT GetMonthlyTransactionsByStore(5, 4, 2024);
