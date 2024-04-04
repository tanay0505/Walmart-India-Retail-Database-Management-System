-- CalculateTaxCOGSGrossMarginIncomeTrigger
DELIMITER //
CREATE TRIGGER CalculateTaxCOGSGrossMarginIncomeTrigger BEFORE INSERT ON Transactions
FOR EACH ROW
BEGIN
    DECLARE tax_val DECIMAL(10, 2);
    DECLARE cogs_val DECIMAL(10, 2);
    DECLARE gross_margin_val DECIMAL(10, 2);
    DECLARE gross_income_val DECIMAL(10, 2);
    
    -- Calculate tax
    SET tax_val = NEW.unit_price * NEW.quantity * 0.18;
    -- Calculate COGS
    SET cogs_val = NEW.unit_price * NEW.quantity;
    
    -- Calculate total amount (unit price * quantity + tax)
    SET NEW.total_amount = cogs_val + tax_val;
    
    -- Calculate gross income
    SET gross_income_val = NEW.total_amount - cogs_val;
    
    -- Calculate gross margin
    IF NEW.total_amount > 0 THEN
        SET gross_margin_val = ((NEW.total_amount - cogs_val) / NEW.total_amount) * 100;
    ELSE
        SET gross_margin_val = 0;
    END IF;
    
    -- Update tax
    SET NEW.tax = tax_val;
    -- Update COGS
    SET NEW.cogs = cogs_val;
    -- Update gross margin
    SET NEW.gross_margin = gross_margin_val;
    -- Update gross income
    SET NEW.gross_income = gross_income_val;
END //
DELIMITER ;

select*from Transactions;

-- UpdateProductQuantity
DELIMITER $$
CREATE TRIGGER AfterSaleInsert
AFTER INSERT ON Sales
FOR EACH ROW
BEGIN
    UPDATE Products 
    SET product_quantity = product_quantity - NEW.quantity 
    WHERE product_id = NEW.product_id;
END$$
DELIMITER ;

SELECT * FROM Products WHERE product_id = 1;
select* from sales;

-- EnforceMinimumProductPrice
DELIMITER //
CREATE TRIGGER EnforceMinimumProductPrice BEFORE INSERT ON Products
FOR EACH ROW
BEGIN
    IF NEW.product_price < 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Product price cannot be negative';
    END IF;
END;
//
DELIMITER ;

INSERT INTO Products (product_name, product_description, product_quantity, product_price, supplier_id, category_id, category_type) VALUES
('ABC', 'ABC',100,-0.1,1,1,1);

-- UniqueProductName
DELIMITER //
CREATE TRIGGER EnforceUniqueProductName BEFORE INSERT ON Products
FOR EACH ROW
BEGIN
    DECLARE count_products INT;
    SELECT COUNT(*) INTO count_products
    FROM Products
    WHERE product_name = NEW.product_name;
    IF count_products > 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Product name must be unique';
    END IF;
END;
//
DELIMITER ;

INSERT INTO Products (product_name, product_description, product_quantity, product_price, supplier_id, category_id, category_type) VALUES
('LuminaX Pro Laptop', 'Powerful laptop with high-performance specifications, perfect for gaming and professional use.', 100, 1299.99, 1, 1, 'Electronics');

-- Ensure Review Rating is between 1 and 5
DELIMITER //
CREATE TRIGGER validate_review_rating BEFORE INSERT ON Reviews
FOR EACH ROW
BEGIN
    IF NEW.rating < 1 OR NEW.rating > 5 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Review rating must be between 1 and 5';
    END IF;
END //
DELIMITER ;

INSERT INTO Reviews (product_id, review_text, rating, reviewer_name)
VALUES (1, 'Example review', 0, 'John Doe');