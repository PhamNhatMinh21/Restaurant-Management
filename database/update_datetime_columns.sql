USE restaurant_db;

-- Upgrade existing tables without recreating the database.
-- Existing DATE values retain their date and receive the time 00:00:00.
ALTER TABLE tblBill6
	MODIFY COLUMN issuedAt TIMESTAMP NOT NULL,
	MODIFY COLUMN paidAt TIMESTAMP NULL DEFAULT NULL;

ALTER TABLE tblBooking6
	MODIFY COLUMN bookedAt TIMESTAMP NOT NULL;

ALTER TABLE tblBookedTable6
	MODIFY COLUMN startTime TIMESTAMP NOT NULL,
	MODIFY COLUMN endTime TIMESTAMP NOT NULL;

ALTER TABLE tblOrder6
	MODIFY COLUMN orderedAt TIMESTAMP NOT NULL,
	MODIFY COLUMN confirmedAt TIMESTAMP NOT NULL;
