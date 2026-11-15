USE restaurant_db;

DELIMITER $$

DROP PROCEDURE IF EXISTS checkLogin$$
CREATE PROCEDURE `checkLogin`(IN usr VARCHAR(255), IN pwd VARCHAR(255))
BEGIN
	SELECT u.id, u.name, s.role, s.salary
	FROM tblUser6 u, tblStaff6 s, tblManagerStaff6 m
	WHERE u.username = usr AND u.password = pwd
		AND s.tblUser6id = u.id AND m.tblStaff6tblUser6id = s.tblUser6id;
END$$

DROP PROCEDURE IF EXISTS searchDish$$
CREATE PROCEDURE `searchDish`(IN dishName VARCHAR(255))
BEGIN
	SELECT id, name, image, price, category, description
	FROM tblDish6
	WHERE name LIKE CONCAT('%', dishName, '%')
	ORDER BY id;
END$$

DROP PROCEDURE IF EXISTS editDish$$
CREATE PROCEDURE `editDish`(IN dishId VARCHAR(255), IN dishName VARCHAR(255), IN dishImage VARCHAR(255),
    IN dishPrice DECIMAL(19,2), IN dishCategory VARCHAR(255), IN dishDescription VARCHAR(255))
BEGIN
    IF NOT EXISTS (SELECT 1 FROM tblDish6 WHERE id = dishId)
        OR EXISTS (SELECT 1 FROM tblDish6 WHERE name = dishName AND id <> dishId) THEN
        SELECT 0 AS kq;
    ELSE
        UPDATE tblDish6
        SET name = dishName, image = dishImage, price = dishPrice,
            category = dishCategory, description = dishDescription
        WHERE id = dishId;
        SELECT 1 AS kq;
    END IF;
END$$

DROP PROCEDURE IF EXISTS getSupplierStat$$
CREATE PROCEDURE `getSupplierStat`(IN startDate DATE, IN endDate DATE)
BEGIN
	SELECT a.id, a.name, a.phone, a.address, a.email,
		SUM(c.quantity) AS totalImportQuantity
	FROM tblSupplier6 a, tblImportInvoice6 b, tblImportDetail6 c
	WHERE b.tblSupplier6id = a.id AND c.tblImportInvoice6id = b.id
		AND b.importDate BETWEEN startDate AND endDate
	GROUP BY a.id, a.name, a.phone, a.address, a.email
	ORDER BY totalImportQuantity DESC;
END$$

DROP PROCEDURE IF EXISTS getImportInvoice$$
CREATE PROCEDURE `getImportInvoice`(IN idSupplier VARCHAR(255), IN startDate DATE, IN endDate DATE)
BEGIN
	SELECT a.id, a.importDate, a.note,
		IFNULL(SUM(b.quantity * b.price), 0) AS totalAmount
	FROM tblImportInvoice6 a LEFT JOIN tblImportDetail6 b ON b.tblImportInvoice6id = a.id
	WHERE a.tblSupplier6id = idSupplier
		AND a.importDate BETWEEN startDate AND endDate
	GROUP BY a.id, a.importDate, a.note
	ORDER BY a.importDate, a.id;
END$$

DROP PROCEDURE IF EXISTS getImportDetail$$
CREATE PROCEDURE `getImportDetail`(IN idInvoice VARCHAR(255))
BEGIN
	SELECT a.id, a.quantity, a.price,
		b.id AS idIngredient, b.name AS nameIngredient, b.unit, b.description
	FROM tblImportDetail6 a, tblIngredient6 b
	WHERE a.tblImportInvoice6id = idInvoice AND b.id = a.tblIngredient6id
	ORDER BY a.id;
END$$

DELIMITER ;
