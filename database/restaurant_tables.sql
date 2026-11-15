DROP DATABASE IF EXISTS restaurant_db;
CREATE DATABASE restaurant_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE restaurant_db;

CREATE TABLE tblUser6 (
	id VARCHAR(255) PRIMARY KEY,
	username VARCHAR(255) NOT NULL UNIQUE,
	password VARCHAR(255) NOT NULL,
	name VARCHAR(255) NOT NULL,
	dob DATE NOT NULL,
	address VARCHAR(255) NOT NULL,
	phone VARCHAR(255) NOT NULL
) ENGINE=InnoDB;

CREATE TABLE tblStaff6 (
	role VARCHAR(255) NOT NULL,
	salary DECIMAL(19,2) NOT NULL,
	tblUser6id VARCHAR(255) PRIMARY KEY,
	FOREIGN KEY (tblUser6id) REFERENCES tblUser6(id)
) ENGINE=InnoDB;

CREATE TABLE tblManagerStaff6 (
	tblStaff6tblUser6id VARCHAR(255) PRIMARY KEY,
	FOREIGN KEY (tblStaff6tblUser6id) REFERENCES tblStaff6(tblUser6id)
) ENGINE=InnoDB;

CREATE TABLE tblSaleStaff6 (
	tblStaff6tblUser6id VARCHAR(255) PRIMARY KEY,
	FOREIGN KEY (tblStaff6tblUser6id) REFERENCES tblStaff6(tblUser6id)
) ENGINE=InnoDB;

CREATE TABLE tblWarehouseStaff6 (
	tblStaff6id VARCHAR(255) PRIMARY KEY,
	tblStaff6tblUser6id VARCHAR(255) NOT NULL,
	FOREIGN KEY (tblStaff6tblUser6id) REFERENCES tblStaff6(tblUser6id)
) ENGINE=InnoDB;

CREATE TABLE tblCustomer6 (
	id VARCHAR(255) PRIMARY KEY,
	name VARCHAR(255) NOT NULL,
	phone VARCHAR(255) NOT NULL,
	email VARCHAR(255) NOT NULL,
	address VARCHAR(255)
) ENGINE=InnoDB;

CREATE TABLE tblMemberShipCard6 (
	id VARCHAR(255) PRIMARY KEY,
	cardNumber VARCHAR(255) NOT NULL UNIQUE,
	issuedAt DATE NOT NULL,
	tblCustomer6id VARCHAR(255) NOT NULL,
	FOREIGN KEY (tblCustomer6id) REFERENCES tblCustomer6(id)
) ENGINE=InnoDB;

CREATE TABLE tblBill6 (
	id VARCHAR(255) PRIMARY KEY,
	issuedAt DATE NOT NULL,
	paidAt DATE,
	paymentType VARCHAR(255) NOT NULL,
	tblCustomer6id VARCHAR(255),
	tblSaleStaff6tblStaff6tblUser6id VARCHAR(255) NOT NULL,
	FOREIGN KEY (tblCustomer6id) REFERENCES tblCustomer6(id),
	FOREIGN KEY (tblSaleStaff6tblStaff6tblUser6id) REFERENCES tblSaleStaff6(tblStaff6tblUser6id)
) ENGINE=InnoDB;

CREATE TABLE tblTable6 (
	id VARCHAR(255) PRIMARY KEY,
	tableNumber VARCHAR(255) NOT NULL UNIQUE,
	capacity INT NOT NULL
) ENGINE=InnoDB;

CREATE TABLE tblBooking6 (
	id VARCHAR(255) PRIMARY KEY,
	bookedAt DATE NOT NULL,
	customerCount INT NOT NULL,
	contactName VARCHAR(255) NOT NULL,
	contactPhone VARCHAR(255) NOT NULL,
	tblCustomer6id VARCHAR(255) NOT NULL,
	FOREIGN KEY (tblCustomer6id) REFERENCES tblCustomer6(id)
) ENGINE=InnoDB;

CREATE TABLE tblBookedTable6 (
	id VARCHAR(255) PRIMARY KEY,
	startTime DATE NOT NULL,
	endTime DATE NOT NULL,
	note VARCHAR(255),
	tblBooking6id VARCHAR(255) NOT NULL,
	tblTable6id VARCHAR(255) NOT NULL,
	FOREIGN KEY (tblBooking6id) REFERENCES tblBooking6(id),
	FOREIGN KEY (tblTable6id) REFERENCES tblTable6(id)
) ENGINE=InnoDB;

CREATE TABLE tblOrder6 (
	id VARCHAR(255) PRIMARY KEY,
	orderedAt DATE NOT NULL,
	confirmedAt DATE NOT NULL,
	tblBill6id VARCHAR(255),
	tblBooking6id VARCHAR(255) NOT NULL,
	FOREIGN KEY (tblBill6id) REFERENCES tblBill6(id),
	FOREIGN KEY (tblBooking6id) REFERENCES tblBooking6(id)
) ENGINE=InnoDB;

CREATE TABLE tblDish6 (
	id VARCHAR(255) PRIMARY KEY,
	name VARCHAR(255) NOT NULL UNIQUE,
	image VARCHAR(255),
	price DECIMAL(19,2) NOT NULL,
	category VARCHAR(255) NOT NULL,
	description VARCHAR(255)
) ENGINE=InnoDB;

CREATE TABLE tblCombo6 (
	id VARCHAR(255) PRIMARY KEY,
	name VARCHAR(255) NOT NULL,
	image VARCHAR(255),
	price DECIMAL(19,2) NOT NULL,
	description VARCHAR(255)
) ENGINE=InnoDB;

CREATE TABLE tblComboDish6 (
	id VARCHAR(255) PRIMARY KEY,
	quantity INT NOT NULL,
	note VARCHAR(255),
	tblDish6id VARCHAR(255) NOT NULL,
	tblCombo6id VARCHAR(255) NOT NULL,
	FOREIGN KEY (tblDish6id) REFERENCES tblDish6(id),
	FOREIGN KEY (tblCombo6id) REFERENCES tblCombo6(id)
) ENGINE=InnoDB;

CREATE TABLE tblOrderDishDetail6 (
	id VARCHAR(255) PRIMARY KEY,
	quantity INT NOT NULL,
	price DECIMAL(19,2) NOT NULL,
	note VARCHAR(255),
	tblOrder6id VARCHAR(255) NOT NULL,
	tblDish6id VARCHAR(255) NOT NULL,
	FOREIGN KEY (tblOrder6id) REFERENCES tblOrder6(id),
	FOREIGN KEY (tblDish6id) REFERENCES tblDish6(id)
) ENGINE=InnoDB;

CREATE TABLE tblOrderComboDetail6 (
	id VARCHAR(255) PRIMARY KEY,
	quantity INT NOT NULL,
	price DECIMAL(19,2) NOT NULL,
	note VARCHAR(255),
	tblOrder6id VARCHAR(255) NOT NULL,
	tblCombo6id VARCHAR(255) NOT NULL,
	FOREIGN KEY (tblOrder6id) REFERENCES tblOrder6(id),
	FOREIGN KEY (tblCombo6id) REFERENCES tblCombo6(id)
) ENGINE=InnoDB;

CREATE TABLE tblSupplier6 (
	id VARCHAR(255) PRIMARY KEY,
	name VARCHAR(255) NOT NULL,
	phone VARCHAR(255) NOT NULL,
	address VARCHAR(255) NOT NULL,
	email VARCHAR(255)
) ENGINE=InnoDB;

CREATE TABLE tblIngredient6 (
	id VARCHAR(255) PRIMARY KEY,
	name VARCHAR(255) NOT NULL,
	unit VARCHAR(255) NOT NULL,
	description VARCHAR(255)
) ENGINE=InnoDB;

CREATE TABLE tblImportInvoice6 (
	id VARCHAR(255) PRIMARY KEY,
	importDate DATE NOT NULL,
	note VARCHAR(255),
	tblSupplier6id VARCHAR(255) NOT NULL,
	tblWarehouseStaff6id VARCHAR(255) NOT NULL,
	FOREIGN KEY (tblSupplier6id) REFERENCES tblSupplier6(id),
	FOREIGN KEY (tblWarehouseStaff6id) REFERENCES tblWarehouseStaff6(tblStaff6id)
) ENGINE=InnoDB;

CREATE TABLE tblImportDetail6 (
	id VARCHAR(255) PRIMARY KEY,
	quantity DECIMAL(19,2) NOT NULL,
	price DECIMAL(19,2) NOT NULL,
	tblImportInvoice6id VARCHAR(255) NOT NULL,
	tblIngredient6id VARCHAR(255) NOT NULL,
	FOREIGN KEY (tblImportInvoice6id) REFERENCES tblImportInvoice6(id),
	FOREIGN KEY (tblIngredient6id) REFERENCES tblIngredient6(id)
) ENGINE=InnoDB;
