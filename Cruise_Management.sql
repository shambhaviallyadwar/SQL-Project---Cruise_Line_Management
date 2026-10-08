-- ============================================================
-- CRUISE LINE MANAGEMENT SYSTEM — 260 QUESTIONS WITH ANSWERS
-- ============================================================
-- Sample dataset: 30 passengers, 12 ports, 10 ships, 20 cabins,
-- 180 bookings, 180 payments, 12 cancellations, 20 maintenance rows.
-- ============================================================

CREATE DATABASE IF NOT EXISTS Cruise_Line_Management;
USE Cruise_Line_Management;

CREATE TABLE Passenger (passenger_id INT PRIMARY KEY AUTO_INCREMENT, 
first_name VARCHAR(50) NOT NULL,
 last_name VARCHAR(50) NOT NULL,
 gender VARCHAR(10) NOT NULL, dob DATE NOT NULL,
 phone VARCHAR(15) UNIQUE, 
 email VARCHAR(100) UNIQUE, 
 city VARCHAR(50), 
 country VARCHAR(50) DEFAULT 'India', 
 registration_date DATE DEFAULT (CURRENT_DATE));
 
 
CREATE TABLE Port (port_id INT PRIMARY KEY AUTO_INCREMENT,
 port_code VARCHAR(10) UNIQUE, 
 port_name VARCHAR(100) NOT NULL,
 city VARCHAR(50) NOT NULL, country VARCHAR(50) NOT NULL, 
 region VARCHAR(50) NOT NULL, 
 berths INT CHECK (berths>0), 
 port_type VARCHAR(30) DEFAULT 'International');
 
 
CREATE TABLE Ship (ship_id INT PRIMARY KEY AUTO_INCREMENT, 
 ship_number VARCHAR(10) UNIQUE, 
 ship_name VARCHAR(100) NOT NULL, 
 ship_type VARCHAR(30) NOT NULL, 
 home_port_id INT, 
 passenger_capacity INT CHECK (passenger_capacity>0), 
 total_cabins INT CHECK (total_cabins>0), 
 operating_days VARCHAR(50), status VARCHAR(20) DEFAULT 'Active', 
 FOREIGN KEY(home_port_id) REFERENCES Port(port_id));
 
 
CREATE TABLE Cabin (cabin_id INT PRIMARY KEY AUTO_INCREMENT,
 ship_id INT, cabin_number VARCHAR(10) NOT NULL, cabin_type VARCHAR(30) NOT NULL, 
 capacity INT CHECK(capacity>0), 
 fare_multiplier DECIMAL(5,2) DEFAULT 1.00, cabin_status VARCHAR(20) DEFAULT 'Available', 
 FOREIGN KEY(ship_id) REFERENCES Ship(ship_id));
 
 
CREATE TABLE Cruise (cruise_id INT PRIMARY KEY AUTO_INCREMENT, 
cruise_number VARCHAR(10) UNIQUE, 
cruise_name VARCHAR(100) NOT NULL, cruise_type VARCHAR(30) NOT NULL,
ship_id INT, departure_port_id INT, arrival_port_id INT, 
departure_date DATE NOT NULL, 
return_date DATE NOT NULL, duration_days INT CHECK(duration_days>0),
 status VARCHAR(20) DEFAULT 'Scheduled', 
 FOREIGN KEY(ship_id) REFERENCES Ship(ship_id), 
 FOREIGN KEY(departure_port_id) REFERENCES Port(port_id), 
 FOREIGN KEY(arrival_port_id) REFERENCES Port(port_id));
 
 
CREATE TABLE Cruise_Schedule (schedule_id INT PRIMARY KEY AUTO_INCREMENT, 
cruise_id INT, port_id INT, arrival_time TIME, 
departure_time TIME, halt_minutes INT DEFAULT 0,
 sequence_no INT NOT NULL, berth_no INT,
 schedule_status VARCHAR(20) DEFAULT 'Scheduled',
 FOREIGN KEY(cruise_id) REFERENCES Cruise(cruise_id),
 FOREIGN KEY(port_id) REFERENCES Port(port_id));
 
 
CREATE TABLE Booking (booking_id INT PRIMARY KEY AUTO_INCREMENT, 
passenger_id INT, cruise_id INT, cabin_id INT,
 journey_date DATE NOT NULL, booking_date DATE DEFAULT(CURRENT_DATE),
 cabin_number VARCHAR(10), travel_class VARCHAR(20) NOT NULL,
 fare DECIMAL(10,2) CHECK(fare>=0), booking_status VARCHAR(20) DEFAULT 'Confirmed', 
 payment_status VARCHAR(20) DEFAULT 'Pending', 
 FOREIGN KEY(passenger_id) REFERENCES Passenger(passenger_id), 
 FOREIGN KEY(cruise_id) REFERENCES Cruise(cruise_id), 
 FOREIGN KEY(cabin_id) REFERENCES Cabin(cabin_id));
 
 
CREATE TABLE Crew (crew_id INT PRIMARY KEY AUTO_INCREMENT,  
crew_name VARCHAR(100) NOT NULL, designation VARCHAR(50) NOT NULL, 
department VARCHAR(50) NOT NULL, ship_id INT, salary DECIMAL(12,2) CHECK(salary>0),
oining_date DATE NOT NULL, phone VARCHAR(15) UNIQUE, 
employment_status VARCHAR(20) DEFAULT 'Active',
 FOREIGN KEY(ship_id) REFERENCES Ship(ship_id));
 
 
CREATE TABLE Payment (payment_id INT PRIMARY KEY AUTO_INCREMENT,
 booking_id INT UNIQUE, payment_date DATETIME DEFAULT CURRENT_TIMESTAMP,
 amount DECIMAL(10,2) CHECK(amount>0), payment_method VARCHAR(30) NOT NULL, 
 transaction_reference VARCHAR(50) UNIQUE, payment_status VARCHAR(20) DEFAULT 'Successful',
 FOREIGN KEY(booking_id) REFERENCES Booking(booking_id));
 
 
CREATE TABLE Cancellation (cancellation_id INT PRIMARY KEY AUTO_INCREMENT,
 booking_id INT UNIQUE, cancellation_date DATETIME DEFAULT CURRENT_TIMESTAMP, reason VARCHAR(200), 
 refund_amount DECIMAL(10,2) CHECK(refund_amount>=0), cancellation_status VARCHAR(20) DEFAULT 'Processed',
 FOREIGN KEY(booking_id) REFERENCES Booking(booking_id));
 
 
CREATE TABLE Maintenance (maintenance_id INT PRIMARY KEY AUTO_INCREMENT,
 ship_id INT, maintenance_date DATE NOT NULL, 
 maintenance_type VARCHAR(50) NOT NULL,
 cost DECIMAL(12,2) CHECK(cost>=0), engineer_name VARCHAR(100) NOT NULL,
 maintenance_status VARCHAR(30) DEFAULT 'Completed', next_due_date DATE, 
 FOREIGN KEY(ship_id) REFERENCES Ship(ship_id));


INSERT INTO Port(port_code,port_name,city,country,region,berths) VALUES
('MUM', 'Mumbai Cruise Port', 'Mumbai', 'India', 'West', 12),
('GOA', 'Mormugao Cruise Terminal', 'Goa', 'India', 'West', 8),
('COK', 'Cochin Cruise Terminal', 'Kochi', 'India', 'South', 7),
('CHN', 'Chennai Cruise Port', 'Chennai', 'India', 'South', 9),
('CMB', 'Colombo Cruise Terminal', 'Colombo', 'Sri Lanka', 'South Asia', 10),
('SIN', 'Singapore Cruise Centre', 'Singapore', 'Singapore', 'Southeast Asia', 14),
('DXB', 'Dubai Cruise Terminal', 'Dubai', 'UAE', 'Middle East', 15),
('MCT', 'Muscat Cruise Terminal', 'Muscat', 'Oman', 'Middle East', 8),
('BKK', 'Laem Chabang', 'Bangkok', 'Thailand', 'Southeast Asia', 11),
('HKG', 'Kai Tak Terminal', 'Hong Kong', 'Hong Kong', 'East Asia', 13),
('KUL', 'Port Klang', 'Kuala Lumpur', 'Malaysia', 'Southeast Asia', 10),
('BOM', 'Jio World Cruise Terminal', 'Mumbai', 'India', 'West', 6);

INSERT INTO Ship(ship_number,ship_name,ship_type,home_port_id,passenger_capacity,total_cabins,operating_days,status) VALUES
('SH001', 'Ocean 1', 'Luxury', 2, 1500, 620, 'Daily', 'Active'),
('SH002', 'Ocean 2', 'Family', 3, 1600, 640, 'Daily', 'Active'),
('SH003', 'Ocean 3', 'Premium', 4, 1700, 660, 'Daily', 'Active'),
('SH004', 'Ocean 4', 'Luxury', 5, 1800, 680, 'Daily', 'Active'),
('SH005', 'Ocean 5', 'Family', 6, 1900, 700, 'Daily', 'Active'),
('SH006', 'Ocean 6', 'Premium', 7, 2000, 720, 'Daily', 'Active'),
('SH007', 'Ocean 7', 'Luxury', 8, 2100, 740, 'Daily', 'Active'),
('SH008', 'Ocean 8', 'Family', 9, 2200, 760, 'Daily', 'Active'),
('SH009', 'Ocean 9', 'Premium', 10, 2300, 780, 'Daily', 'Active'),
('SH010', 'Ocean 10', 'Luxury', 11, 2400, 800, 'Daily', 'Active');

INSERT INTO Cabin(cabin_id,ship_id,cabin_number,cabin_type,capacity,fare_multiplier,cabin_status) VALUES
(1, 1, '101', 'Ocean View', 2, 1.25, 'Available'),
(2, 2, '202', 'Balcony', 2, 1.5, 'Available'),
(3, 3, '303', 'Suite', 4, 2.2, 'Available'),
(4, 4, '404', 'Standard', 2, 1, 'Available'),
(5, 5, '505', 'Ocean View', 2, 1.25, 'Available'),
(6, 6, '606', 'Balcony', 2, 1.5, 'Available'),
(7, 7, '707', 'Suite', 4, 2.2, 'Available'),
(8, 8, '808', 'Standard', 2, 1, 'Available'),
(9, 9, '909', 'Ocean View', 2, 1.25, 'Available'),
(10, 10, '1010', 'Balcony', 2, 1.5, 'Available'),
(11, 1, '111', 'Suite', 4, 2.2, 'Available'),
(12, 2, '212', 'Standard', 2, 1, 'Available'),
(13, 3, '313', 'Ocean View', 2, 1.25, 'Available'),
(14, 4, '414', 'Balcony', 2, 1.5, 'Available'),
(15, 5, '515', 'Suite', 4, 2.2, 'Available'),
(16, 6, '616', 'Standard', 2, 1, 'Available'),
(17, 7, '717', 'Ocean View', 2, 1.25, 'Available'),
(18, 8, '818', 'Balcony', 2, 1.5, 'Available'),
(19, 9, '919', 'Suite', 4, 2.2, 'Available'),
(20, 10, '1020', 'Standard', 2, 1, 'Available');

INSERT INTO Passenger(passenger_id,first_name,last_name,gender,dob,phone,email,city,country,registration_date) VALUES
(1, 'Ananya', 'Patel', 'M', '1986-02-02', '9000000001', 'passenger1@example.com', 'Pune', 'India', '2025-02-02'),
(2, 'Arjun', 'Verma', 'F', '1987-03-03', '9000000002', 'passenger2@example.com', 'Nashik', 'India', '2025-03-03'),
(3, 'Aisha', 'Shah', 'M', '1988-04-04', '9000000003', 'passenger3@example.com', 'Thane', 'India', '2025-04-04'),
(4, 'Rohan', 'Mehta', 'F', '1989-05-05', '9000000004', 'passenger4@example.com', 'Delhi', 'India', '2025-05-05'),
(5, 'Priya', 'Sharma', 'M', '1990-06-06', '9000000005', 'passenger5@example.com', 'Bengaluru', 'India', '2025-06-06'),
(6, 'Karan', 'Patel', 'F', '1991-07-07', '9000000006', 'passenger6@example.com', 'Mumbai', 'India', '2025-07-07'),
(7, 'Meera', 'Verma', 'M', '1992-08-08', '9000000007', 'passenger7@example.com', 'Pune', 'India', '2025-08-08'),
(8, 'Rahul', 'Shah', 'F', '1993-09-09', '9000000008', 'passenger8@example.com', 'Nashik', 'India', '2025-09-09'),
(9, 'Sneha', 'Mehta', 'M', '1994-10-10', '9000000009', 'passenger9@example.com', 'Thane', 'India', '2025-10-10'),
(10, 'Aarav', 'Sharma', 'F', '1995-11-11', '9000000010', 'passenger10@example.com', 'Delhi', 'India', '2025-11-11'),
(11, 'Ananya', 'Patel', 'M', '1996-12-12', '9000000011', 'passenger11@example.com', 'Bengaluru', 'India', '2025-12-12'),
(12, 'Arjun', 'Verma', 'F', '1997-01-13', '9000000012', 'passenger12@example.com', 'Mumbai', 'India', '2025-01-13'),
(13, 'Aisha', 'Shah', 'M', '1998-02-14', '9000000013', 'passenger13@example.com', 'Pune', 'India', '2025-02-14'),
(14, 'Rohan', 'Mehta', 'F', '1999-03-15', '9000000014', 'passenger14@example.com', 'Nashik', 'India', '2025-03-15'),
(15, 'Priya', 'Sharma', 'M', '1985-04-16', '9000000015', 'passenger15@example.com', 'Thane', 'India', '2025-04-16'),
(16, 'Karan', 'Patel', 'F', '1986-05-17', '9000000016', 'passenger16@example.com', 'Delhi', 'India', '2025-05-17'),
(17, 'Meera', 'Verma', 'M', '1987-06-18', '9000000017', 'passenger17@example.com', 'Bengaluru', 'India', '2025-06-18'),
(18, 'Rahul', 'Shah', 'F', '1988-07-19', '9000000018', 'passenger18@example.com', 'Mumbai', 'India', '2025-07-19'),
(19, 'Sneha', 'Mehta', 'M', '1989-08-20', '9000000019', 'passenger19@example.com', 'Pune', 'India', '2025-08-20'),
(20, 'Aarav', 'Sharma', 'F', '1990-09-21', '9000000020', 'passenger20@example.com', 'Nashik', 'India', '2025-09-21'),
(21, 'Ananya', 'Patel', 'M', '1991-10-22', '9000000021', 'passenger21@example.com', 'Thane', 'India', '2025-10-22'),
(22, 'Arjun', 'Verma', 'F', '1992-11-23', '9000000022', 'passenger22@example.com', 'Delhi', 'India', '2025-11-23'),
(23, 'Aisha', 'Shah', 'M', '1993-12-24', '9000000023', 'passenger23@example.com', 'Bengaluru', 'India', '2025-12-24'),
(24, 'Rohan', 'Mehta', 'F', '1994-01-25', '9000000024', 'passenger24@example.com', 'Mumbai', 'India', '2025-01-25'),
(25, 'Priya', 'Sharma', 'M', '1995-02-26', '9000000025', 'passenger25@example.com', 'Pune', 'India', '2025-02-26'),
(26, 'Karan', 'Patel', 'F', '1996-03-27', '9000000026', 'passenger26@example.com', 'Nashik', 'India', '2025-03-27'),
(27, 'Meera', 'Verma', 'M', '1997-04-01', '9000000027', 'passenger27@example.com', 'Thane', 'India', '2025-04-01'),
(28, 'Rahul', 'Shah', 'F', '1998-05-02', '9000000028', 'passenger28@example.com', 'Delhi', 'India', '2025-05-02'),
(29, 'Sneha', 'Mehta', 'M', '1999-06-03', '9000000029', 'passenger29@example.com', 'Bengaluru', 'India', '2025-06-03'),
(30, 'Aarav', 'Sharma', 'F', '1985-07-04', '9000000030', 'passenger30@example.com', 'Mumbai', 'India', '2025-07-04');


INSERT INTO Cruise(cruise_id,cruise_number,cruise_name,cruise_type,ship_id,departure_port_id,arrival_port_id,departure_date,return_date,duration_days,status) VALUES
(1, 'CR001', 'Cruise 1', 'Luxury', 1, 4, 5, '2026-02-02', '2026-02-07', 5, 'Completed'),
(2, 'CR002', 'Cruise 2', 'Family', 2, 5, 6, '2026-03-03', '2026-03-08', 5, 'Active'),
(3, 'CR003', 'Cruise 3', 'Premium', 3, 6, 7, '2026-04-04', '2026-04-09', 5, 'Scheduled'),
(4, 'CR004', 'Cruise 4', 'Luxury', 4, 7, 8, '2026-05-05', '2026-05-10', 5, 'Completed'),
(5, 'CR005', 'Cruise 5', 'Family', 5, 8, 9, '2026-06-06', '2026-06-11', 5, 'Active'),
(6, 'CR006', 'Cruise 6', 'Premium', 6, 9, 10, '2026-07-07', '2026-07-12', 5, 'Scheduled'),
(7, 'CR007', 'Cruise 7', 'Luxury', 7, 10, 11, '2026-08-08', '2026-08-13', 5, 'Completed'),
(8, 'CR008', 'Cruise 8', 'Family', 8, 11, 12, '2026-09-09', '2026-09-14', 5, 'Active'),
(9, 'CR009', 'Cruise 9', 'Premium', 9, 12, 1, '2026-10-10', '2026-10-15', 5, 'Scheduled'),
(10, 'CR010', 'Cruise 10', 'Luxury', 10, 1, 2, '2026-11-11', '2026-11-16', 5, 'Completed'),
(11, 'CR011', 'Cruise 11', 'Family', 1, 2, 3, '2026-12-12', '2026-12-17', 5, 'Active'),
(12, 'CR012', 'Cruise 12', 'Premium', 2, 3, 4, '2026-01-13', '2026-01-18', 5, 'Scheduled'),
(13, 'CR013', 'Cruise 13', 'Luxury', 3, 4, 5, '2026-02-14', '2026-02-19', 5, 'Completed'),
(14, 'CR014', 'Cruise 14', 'Family', 4, 5, 6, '2026-03-15', '2026-03-20', 5, 'Active'),
(15, 'CR015', 'Cruise 15', 'Premium', 5, 6, 7, '2026-04-16', '2026-04-21', 5, 'Scheduled'),
(16, 'CR016', 'Cruise 16', 'Luxury', 6, 7, 8, '2026-05-17', '2026-05-22', 5, 'Completed'),
(17, 'CR017', 'Cruise 17', 'Family', 7, 8, 9, '2026-06-18', '2026-06-23', 5, 'Active'),
(18, 'CR018', 'Cruise 18', 'Premium', 8, 9, 10, '2026-07-19', '2026-07-24', 5, 'Scheduled'),
(19, 'CR019', 'Cruise 19', 'Luxury', 9, 10, 11, '2026-08-20', '2026-08-25', 5, 'Completed'),
(20, 'CR020', 'Cruise 20', 'Family', 10, 11, 12, '2026-09-01', '2026-09-06', 5, 'Active');

INSERT INTO Booking(booking_id,passenger_id,cruise_id,cabin_id,journey_date,booking_date,cabin_number,travel_class,fare,booking_status,payment_status) VALUES
(1, 1, 1, 1, '2026-02-02', '2026-09-02', 'C001', 'Premium', 2550, 'Confirmed', 'Successful'),
(2, 2, 2, 2, '2026-03-03', '2026-09-03', 'C002', 'Luxury', 3600, 'Confirmed', 'Successful'),
(3, 3, 3, 3, '2026-04-04', '2026-09-04', 'C003', 'Suite', 4650, 'Confirmed', 'Successful'),
(4, 4, 4, 4, '2026-05-05', '2026-09-05', 'C004', 'Standard', 2500, 'Confirmed', 'Successful'),
(5, 5, 5, 5, '2026-06-06', '2026-09-06', 'C005', 'Premium', 3550, 'Completed', 'Successful'),
(6, 6, 6, 6, '2026-07-07', '2026-09-07', 'C006', 'Luxury', 4600, 'Confirmed', 'Successful'),
(7, 7, 7, 7, '2026-08-08', '2026-09-08', 'C007', 'Suite', 5650, 'Confirmed', 'Pending'),
(8, 8, 8, 8, '2026-09-09', '2026-09-09', 'C008', 'Standard', 3500, 'Confirmed', 'Successful'),
(9, 9, 9, 9, '2026-10-10', '2026-09-10', 'C009', 'Premium', 4550, 'Confirmed', 'Successful'),
(10, 10, 10, 10, '2026-11-11', '2026-09-11', 'C010', 'Luxury', 5600, 'Completed', 'Successful'),
(11, 11, 11, 11, '2026-12-12', '2026-09-12', 'C011', 'Suite', 6650, 'Confirmed', 'Successful'),
(12, 12, 12, 12, '2026-01-13', '2026-09-13', 'C012', 'Standard', 4500, 'Confirmed', 'Successful'),
(13, 13, 13, 13, '2026-02-14', '2026-09-14', 'C013', 'Premium', 5550, 'Confirmed', 'Successful'),
(14, 14, 14, 14, '2026-03-15', '2026-09-15', 'C014', 'Luxury', 6600, 'Confirmed', 'Pending'),
(15, 15, 15, 15, '2026-04-16', '2026-09-16', 'C015', 'Suite', 7650, 'Cancelled', 'Refunded'),
(16, 16, 16, 16, '2026-05-17', '2026-09-17', 'C016', 'Standard', 5500, 'Confirmed', 'Successful'),
(17, 17, 17, 17, '2026-06-18', '2026-09-18', 'C017', 'Premium', 6550, 'Confirmed', 'Successful'),
(18, 18, 18, 18, '2026-07-19', '2026-09-19', 'C018', 'Luxury', 7600, 'Confirmed', 'Successful'),
(19, 19, 19, 19, '2026-08-20', '2026-09-20', 'C019', 'Suite', 8650, 'Confirmed', 'Successful'),
(20, 20, 20, 20, '2026-09-01', '2026-09-21', 'C020', 'Standard', 1500, 'Completed', 'Successful'),
(21, 21, 1, 1, '2026-02-02', '2026-09-22', 'C001', 'Premium', 2550, 'Confirmed', 'Pending'),
(22, 22, 2, 2, '2026-03-03', '2026-09-23', 'C002', 'Luxury', 3600, 'Confirmed', 'Successful'),
(23, 23, 3, 3, '2026-04-04', '2026-09-24', 'C003', 'Suite', 4650, 'Confirmed', 'Successful'),
(24, 24, 4, 4, '2026-05-05', '2026-09-25', 'C004', 'Standard', 2500, 'Confirmed', 'Successful'),
(25, 25, 5, 5, '2026-06-06', '2026-09-26', 'C005', 'Premium', 3550, 'Completed', 'Successful'),
(26, 26, 6, 6, '2026-07-07', '2026-09-27', 'C006', 'Luxury', 4600, 'Confirmed', 'Successful'),
(27, 27, 7, 7, '2026-08-08', '2026-09-01', 'C007', 'Suite', 5650, 'Confirmed', 'Successful'),
(28, 28, 8, 8, '2026-09-09', '2026-09-02', 'C008', 'Standard', 3500, 'Confirmed', 'Pending'),
(29, 29, 9, 9, '2026-10-10', '2026-09-03', 'C009', 'Premium', 4550, 'Confirmed', 'Successful'),
(30, 30, 10, 10, '2026-11-11', '2026-09-04', 'C010', 'Luxury', 5600, 'Cancelled', 'Refunded'),
(31, 1, 11, 11, '2026-12-12', '2026-09-05', 'C011', 'Suite', 6650, 'Confirmed', 'Successful'),
(32, 2, 12, 12, '2026-01-13', '2026-09-06', 'C012', 'Standard', 4500, 'Confirmed', 'Successful'),
(33, 3, 13, 13, '2026-02-14', '2026-09-07', 'C013', 'Premium', 5550, 'Confirmed', 'Successful'),
(34, 4, 14, 14, '2026-03-15', '2026-09-08', 'C014', 'Luxury', 6600, 'Confirmed', 'Successful'),
(35, 5, 15, 15, '2026-04-16', '2026-09-09', 'C015', 'Suite', 7650, 'Completed', 'Pending'),
(36, 6, 16, 16, '2026-05-17', '2026-09-10', 'C016', 'Standard', 5500, 'Confirmed', 'Successful'),
(37, 7, 17, 17, '2026-06-18', '2026-09-11', 'C017', 'Premium', 6550, 'Confirmed', 'Successful'),
(38, 8, 18, 18, '2026-07-19', '2026-09-12', 'C018', 'Luxury', 7600, 'Confirmed', 'Successful'),
(39, 9, 19, 19, '2026-08-20', '2026-09-13', 'C019', 'Suite', 8650, 'Confirmed', 'Successful'),
(40, 10, 20, 20, '2026-09-01', '2026-09-14', 'C020', 'Standard', 1500, 'Completed', 'Successful'),
(41, 11, 1, 1, '2026-02-02', '2026-09-15', 'C001', 'Premium', 2550, 'Confirmed', 'Successful'),
(42, 12, 2, 2, '2026-03-03', '2026-09-16', 'C002', 'Luxury', 3600, 'Confirmed', 'Pending'),
(43, 13, 3, 3, '2026-04-04', '2026-09-17', 'C003', 'Suite', 4650, 'Confirmed', 'Successful'),
(44, 14, 4, 4, '2026-05-05', '2026-09-18', 'C004', 'Standard', 2500, 'Confirmed', 'Successful'),
(45, 15, 5, 5, '2026-06-06', '2026-09-19', 'C005', 'Premium', 3550, 'Cancelled', 'Refunded'),
(46, 16, 6, 6, '2026-07-07', '2026-09-20', 'C006', 'Luxury', 4600, 'Confirmed', 'Successful'),
(47, 17, 7, 7, '2026-08-08', '2026-09-21', 'C007', 'Suite', 5650, 'Confirmed', 'Successful'),
(48, 18, 8, 8, '2026-09-09', '2026-09-22', 'C008', 'Standard', 3500, 'Confirmed', 'Successful'),
(49, 19, 9, 9, '2026-10-10', '2026-09-23', 'C009', 'Premium', 4550, 'Confirmed', 'Pending'),
(50, 20, 10, 10, '2026-11-11', '2026-09-24', 'C010', 'Luxury', 5600, 'Completed', 'Successful'),
(51, 21, 11, 11, '2026-12-12', '2026-09-25', 'C011', 'Suite', 6650, 'Confirmed', 'Successful'),
(52, 22, 12, 12, '2026-01-13', '2026-09-26', 'C012', 'Standard', 4500, 'Confirmed', 'Successful'),
(53, 23, 13, 13, '2026-02-14', '2026-09-27', 'C013', 'Premium', 5550, 'Confirmed', 'Successful'),
(54, 24, 14, 14, '2026-03-15', '2026-09-01', 'C014', 'Luxury', 6600, 'Confirmed', 'Successful'),
(55, 25, 15, 15, '2026-04-16', '2026-09-02', 'C015', 'Suite', 7650, 'Completed', 'Successful'),
(56, 26, 16, 16, '2026-05-17', '2026-09-03', 'C016', 'Standard', 5500, 'Confirmed', 'Pending'),
(57, 27, 17, 17, '2026-06-18', '2026-09-04', 'C017', 'Premium', 6550, 'Confirmed', 'Successful'),
(58, 28, 18, 18, '2026-07-19', '2026-09-05', 'C018', 'Luxury', 7600, 'Confirmed', 'Successful'),
(59, 29, 19, 19, '2026-08-20', '2026-09-06', 'C019', 'Suite', 8650, 'Confirmed', 'Successful'),
(60, 30, 20, 20, '2026-09-01', '2026-09-07', 'C020', 'Standard', 1500, 'Cancelled', 'Refunded'),
(61, 1, 1, 1, '2026-02-02', '2026-09-08', 'C001', 'Premium', 2550, 'Confirmed', 'Successful'),
(62, 2, 2, 2, '2026-03-03', '2026-09-09', 'C002', 'Luxury', 3600, 'Confirmed', 'Successful'),
(63, 3, 3, 3, '2026-04-04', '2026-09-10', 'C003', 'Suite', 4650, 'Confirmed', 'Pending'),
(64, 4, 4, 4, '2026-05-05', '2026-09-11', 'C004', 'Standard', 2500, 'Confirmed', 'Successful'),
(65, 5, 5, 5, '2026-06-06', '2026-09-12', 'C005', 'Premium', 3550, 'Completed', 'Successful'),
(66, 6, 6, 6, '2026-07-07', '2026-09-13', 'C006', 'Luxury', 4600, 'Confirmed', 'Successful'),
(67, 7, 7, 7, '2026-08-08', '2026-09-14', 'C007', 'Suite', 5650, 'Confirmed', 'Successful'),
(68, 8, 8, 8, '2026-09-09', '2026-09-15', 'C008', 'Standard', 3500, 'Confirmed', 'Successful'),
(69, 9, 9, 9, '2026-10-10', '2026-09-16', 'C009', 'Premium', 4550, 'Confirmed', 'Successful'),
(70, 10, 10, 10, '2026-11-11', '2026-09-17', 'C010', 'Luxury', 5600, 'Completed', 'Pending'),
(71, 11, 11, 11, '2026-12-12', '2026-09-18', 'C011', 'Suite', 6650, 'Confirmed', 'Successful'),
(72, 12, 12, 12, '2026-01-13', '2026-09-19', 'C012', 'Standard', 4500, 'Confirmed', 'Successful'),
(73, 13, 13, 13, '2026-02-14', '2026-09-20', 'C013', 'Premium', 5550, 'Confirmed', 'Successful'),
(74, 14, 14, 14, '2026-03-15', '2026-09-21', 'C014', 'Luxury', 6600, 'Confirmed', 'Successful'),
(75, 15, 15, 15, '2026-04-16', '2026-09-22', 'C015', 'Suite', 7650, 'Cancelled', 'Refunded'),
(76, 16, 16, 16, '2026-05-17', '2026-09-23', 'C016', 'Standard', 5500, 'Confirmed', 'Successful'),
(77, 17, 17, 17, '2026-06-18', '2026-09-24', 'C017', 'Premium', 6550, 'Confirmed', 'Pending'),
(78, 18, 18, 18, '2026-07-19', '2026-09-25', 'C018', 'Luxury', 7600, 'Confirmed', 'Successful'),
(79, 19, 19, 19, '2026-08-20', '2026-09-26', 'C019', 'Suite', 8650, 'Confirmed', 'Successful'),
(80, 20, 20, 20, '2026-09-01', '2026-09-27', 'C020', 'Standard', 1500, 'Completed', 'Successful'),
(81, 21, 1, 1, '2026-02-02', '2026-09-01', 'C001', 'Premium', 2550, 'Confirmed', 'Successful'),
(82, 22, 2, 2, '2026-03-03', '2026-09-02', 'C002', 'Luxury', 3600, 'Confirmed', 'Successful'),
(83, 23, 3, 3, '2026-04-04', '2026-09-03', 'C003', 'Suite', 4650, 'Confirmed', 'Successful'),
(84, 24, 4, 4, '2026-05-05', '2026-09-04', 'C004', 'Standard', 2500, 'Confirmed', 'Pending'),
(85, 25, 5, 5, '2026-06-06', '2026-09-05', 'C005', 'Premium', 3550, 'Completed', 'Successful'),
(86, 26, 6, 6, '2026-07-07', '2026-09-06', 'C006', 'Luxury', 4600, 'Confirmed', 'Successful'),
(87, 27, 7, 7, '2026-08-08', '2026-09-07', 'C007', 'Suite', 5650, 'Confirmed', 'Successful'),
(88, 28, 8, 8, '2026-09-09', '2026-09-08', 'C008', 'Standard', 3500, 'Confirmed', 'Successful'),
(89, 29, 9, 9, '2026-10-10', '2026-09-09', 'C009', 'Premium', 4550, 'Confirmed', 'Successful'),
(90, 30, 10, 10, '2026-11-11', '2026-09-10', 'C010', 'Luxury', 5600, 'Cancelled', 'Refunded'),
(91, 1, 11, 11, '2026-12-12', '2026-09-11', 'C011', 'Suite', 6650, 'Confirmed', 'Pending'),
(92, 2, 12, 12, '2026-01-13', '2026-09-12', 'C012', 'Standard', 4500, 'Confirmed', 'Successful'),
(93, 3, 13, 13, '2026-02-14', '2026-09-13', 'C013', 'Premium', 5550, 'Confirmed', 'Successful'),
(94, 4, 14, 14, '2026-03-15', '2026-09-14', 'C014', 'Luxury', 6600, 'Confirmed', 'Successful'),
(95, 5, 15, 15, '2026-04-16', '2026-09-15', 'C015', 'Suite', 7650, 'Completed', 'Successful'),
(96, 6, 16, 16, '2026-05-17', '2026-09-16', 'C016', 'Standard', 5500, 'Confirmed', 'Successful'),
(97, 7, 17, 17, '2026-06-18', '2026-09-17', 'C017', 'Premium', 6550, 'Confirmed', 'Successful'),
(98, 8, 18, 18, '2026-07-19', '2026-09-18', 'C018', 'Luxury', 7600, 'Confirmed', 'Pending'),
(99, 9, 19, 19, '2026-08-20', '2026-09-19', 'C019', 'Suite', 8650, 'Confirmed', 'Successful'),
(100, 10, 20, 20, '2026-09-01', '2026-09-20', 'C020', 'Standard', 1500, 'Completed', 'Successful'),
(101, 11, 1, 1, '2026-02-02', '2026-09-21', 'C001', 'Premium', 2550, 'Confirmed', 'Successful'),
(102, 12, 2, 2, '2026-03-03', '2026-09-22', 'C002', 'Luxury', 3600, 'Confirmed', 'Successful'),
(103, 13, 3, 3, '2026-04-04', '2026-09-23', 'C003', 'Suite', 4650, 'Confirmed', 'Successful'),
(104, 14, 4, 4, '2026-05-05', '2026-09-24', 'C004', 'Standard', 2500, 'Confirmed', 'Successful'),
(105, 15, 5, 5, '2026-06-06', '2026-09-25', 'C005', 'Premium', 3550, 'Cancelled', 'Refunded'),
(106, 16, 6, 6, '2026-07-07', '2026-09-26', 'C006', 'Luxury', 4600, 'Confirmed', 'Successful'),
(107, 17, 7, 7, '2026-08-08', '2026-09-27', 'C007', 'Suite', 5650, 'Confirmed', 'Successful'),
(108, 18, 8, 8, '2026-09-09', '2026-09-01', 'C008', 'Standard', 3500, 'Confirmed', 'Successful'),
(109, 19, 9, 9, '2026-10-10', '2026-09-02', 'C009', 'Premium', 4550, 'Confirmed', 'Successful'),
(110, 20, 10, 10, '2026-11-11', '2026-09-03', 'C010', 'Luxury', 5600, 'Completed', 'Successful'),
(111, 21, 11, 11, '2026-12-12', '2026-09-04', 'C011', 'Suite', 6650, 'Confirmed', 'Successful'),
(112, 22, 12, 12, '2026-01-13', '2026-09-05', 'C012', 'Standard', 4500, 'Confirmed', 'Pending'),
(113, 23, 13, 13, '2026-02-14', '2026-09-06', 'C013', 'Premium', 5550, 'Confirmed', 'Successful'),
(114, 24, 14, 14, '2026-03-15', '2026-09-07', 'C014', 'Luxury', 6600, 'Confirmed', 'Successful'),
(115, 25, 15, 15, '2026-04-16', '2026-09-08', 'C015', 'Suite', 7650, 'Completed', 'Successful'),
(116, 26, 16, 16, '2026-05-17', '2026-09-09', 'C016', 'Standard', 5500, 'Confirmed', 'Successful'),
(117, 27, 17, 17, '2026-06-18', '2026-09-10', 'C017', 'Premium', 6550, 'Confirmed', 'Successful'),
(118, 28, 18, 18, '2026-07-19', '2026-09-11', 'C018', 'Luxury', 7600, 'Confirmed', 'Successful'),
(119, 29, 19, 19, '2026-08-20', '2026-09-12', 'C019', 'Suite', 8650, 'Confirmed', 'Pending'),
(120, 30, 20, 20, '2026-09-01', '2026-09-13', 'C020', 'Standard', 1500, 'Cancelled', 'Refunded'),
(121, 1, 1, 1, '2026-02-02', '2026-09-14', 'C001', 'Premium', 2550, 'Confirmed', 'Successful'),
(122, 2, 2, 2, '2026-03-03', '2026-09-15', 'C002', 'Luxury', 3600, 'Confirmed', 'Successful'),
(123, 3, 3, 3, '2026-04-04', '2026-09-16', 'C003', 'Suite', 4650, 'Confirmed', 'Successful'),
(124, 4, 4, 4, '2026-05-05', '2026-09-17', 'C004', 'Standard', 2500, 'Confirmed', 'Successful'),
(125, 5, 5, 5, '2026-06-06', '2026-09-18', 'C005', 'Premium', 3550, 'Completed', 'Successful'),
(126, 6, 6, 6, '2026-07-07', '2026-09-19', 'C006', 'Luxury', 4600, 'Confirmed', 'Pending'),
(127, 7, 7, 7, '2026-08-08', '2026-09-20', 'C007', 'Suite', 5650, 'Confirmed', 'Successful'),
(128, 8, 8, 8, '2026-09-09', '2026-09-21', 'C008', 'Standard', 3500, 'Confirmed', 'Successful'),
(129, 9, 9, 9, '2026-10-10', '2026-09-22', 'C009', 'Premium', 4550, 'Confirmed', 'Successful'),
(130, 10, 10, 10, '2026-11-11', '2026-09-23', 'C010', 'Luxury', 5600, 'Completed', 'Successful'),
(131, 11, 11, 11, '2026-12-12', '2026-09-24', 'C011', 'Suite', 6650, 'Confirmed', 'Successful'),
(132, 12, 12, 12, '2026-01-13', '2026-09-25', 'C012', 'Standard', 4500, 'Confirmed', 'Successful'),
(133, 13, 13, 13, '2026-02-14', '2026-09-26', 'C013', 'Premium', 5550, 'Confirmed', 'Pending'),
(134, 14, 14, 14, '2026-03-15', '2026-09-27', 'C014', 'Luxury', 6600, 'Confirmed', 'Successful'),
(135, 15, 15, 15, '2026-04-16', '2026-09-01', 'C015', 'Suite', 7650, 'Cancelled', 'Refunded'),
(136, 16, 16, 16, '2026-05-17', '2026-09-02', 'C016', 'Standard', 5500, 'Confirmed', 'Successful'),
(137, 17, 17, 17, '2026-06-18', '2026-09-03', 'C017', 'Premium', 6550, 'Confirmed', 'Successful'),
(138, 18, 18, 18, '2026-07-19', '2026-09-04', 'C018', 'Luxury', 7600, 'Confirmed', 'Successful'),
(139, 19, 19, 19, '2026-08-20', '2026-09-05', 'C019', 'Suite', 8650, 'Confirmed', 'Successful'),
(140, 20, 20, 20, '2026-09-01', '2026-09-06', 'C020', 'Standard', 1500, 'Completed', 'Pending'),
(141, 21, 1, 1, '2026-02-02', '2026-09-07', 'C001', 'Premium', 2550, 'Confirmed', 'Successful'),
(142, 22, 2, 2, '2026-03-03', '2026-09-08', 'C002', 'Luxury', 3600, 'Confirmed', 'Successful'),
(143, 23, 3, 3, '2026-04-04', '2026-09-09', 'C003', 'Suite', 4650, 'Confirmed', 'Successful'),
(144, 24, 4, 4, '2026-05-05', '2026-09-10', 'C004', 'Standard', 2500, 'Confirmed', 'Successful'),
(145, 25, 5, 5, '2026-06-06', '2026-09-11', 'C005', 'Premium', 3550, 'Completed', 'Successful'),
(146, 26, 6, 6, '2026-07-07', '2026-09-12', 'C006', 'Luxury', 4600, 'Confirmed', 'Successful'),
(147, 27, 7, 7, '2026-08-08', '2026-09-13', 'C007', 'Suite', 5650, 'Confirmed', 'Pending'),
(148, 28, 8, 8, '2026-09-09', '2026-09-14', 'C008', 'Standard', 3500, 'Confirmed', 'Successful'),
(149, 29, 9, 9, '2026-10-10', '2026-09-15', 'C009', 'Premium', 4550, 'Confirmed', 'Successful'),
(150, 30, 10, 10, '2026-11-11', '2026-09-16', 'C010', 'Luxury', 5600, 'Cancelled', 'Refunded'),
(151, 1, 11, 11, '2026-12-12', '2026-09-17', 'C011', 'Suite', 6650, 'Confirmed', 'Successful'),
(152, 2, 12, 12, '2026-01-13', '2026-09-18', 'C012', 'Standard', 4500, 'Confirmed', 'Successful'),
(153, 3, 13, 13, '2026-02-14', '2026-09-19', 'C013', 'Premium', 5550, 'Confirmed', 'Successful'),
(154, 4, 14, 14, '2026-03-15', '2026-09-20', 'C014', 'Luxury', 6600, 'Confirmed', 'Pending'),
(155, 5, 15, 15, '2026-04-16', '2026-09-21', 'C015', 'Suite', 7650, 'Completed', 'Successful'),
(156, 6, 16, 16, '2026-05-17', '2026-09-22', 'C016', 'Standard', 5500, 'Confirmed', 'Successful'),
(157, 7, 17, 17, '2026-06-18', '2026-09-23', 'C017', 'Premium', 6550, 'Confirmed', 'Successful'),
(158, 8, 18, 18, '2026-07-19', '2026-09-24', 'C018', 'Luxury', 7600, 'Confirmed', 'Successful'),
(159, 9, 19, 19, '2026-08-20', '2026-09-25', 'C019', 'Suite', 8650, 'Confirmed', 'Successful'),
(160, 10, 20, 20, '2026-09-01', '2026-09-26', 'C020', 'Standard', 1500, 'Completed', 'Successful'),
(161, 11, 1, 1, '2026-02-02', '2026-09-27', 'C001', 'Premium', 2550, 'Confirmed', 'Pending'),
(162, 12, 2, 2, '2026-03-03', '2026-09-01', 'C002', 'Luxury', 3600, 'Confirmed', 'Successful'),
(163, 13, 3, 3, '2026-04-04', '2026-09-02', 'C003', 'Suite', 4650, 'Confirmed', 'Successful'),
(164, 14, 4, 4, '2026-05-05', '2026-09-03', 'C004', 'Standard', 2500, 'Confirmed', 'Successful'),
(165, 15, 5, 5, '2026-06-06', '2026-09-04', 'C005', 'Premium', 3550, 'Cancelled', 'Refunded'),
(166, 16, 6, 6, '2026-07-07', '2026-09-05', 'C006', 'Luxury', 4600, 'Confirmed', 'Successful'),
(167, 17, 7, 7, '2026-08-08', '2026-09-06', 'C007', 'Suite', 5650, 'Confirmed', 'Successful'),
(168, 18, 8, 8, '2026-09-09', '2026-09-07', 'C008', 'Standard', 3500, 'Confirmed', 'Pending'),
(169, 19, 9, 9, '2026-10-10', '2026-09-08', 'C009', 'Premium', 4550, 'Confirmed', 'Successful'),
(170, 20, 10, 10, '2026-11-11', '2026-09-09', 'C010', 'Luxury', 5600, 'Completed', 'Successful'),
(171, 21, 11, 11, '2026-12-12', '2026-09-10', 'C011', 'Suite', 6650, 'Confirmed', 'Successful'),
(172, 22, 12, 12, '2026-01-13', '2026-09-11', 'C012', 'Standard', 4500, 'Confirmed', 'Successful'),
(173, 23, 13, 13, '2026-02-14', '2026-09-12', 'C013', 'Premium', 5550, 'Confirmed', 'Successful'),
(174, 24, 14, 14, '2026-03-15', '2026-09-13', 'C014', 'Luxury', 6600, 'Confirmed', 'Successful'),
(175, 25, 15, 15, '2026-04-16', '2026-09-14', 'C015', 'Suite', 7650, 'Completed', 'Pending'),
(176, 26, 16, 16, '2026-05-17', '2026-09-15', 'C016', 'Standard', 5500, 'Confirmed', 'Successful'),
(177, 27, 17, 17, '2026-06-18', '2026-09-16', 'C017', 'Premium', 6550, 'Confirmed', 'Successful'),
(178, 28, 18, 18, '2026-07-19', '2026-09-17', 'C018', 'Luxury', 7600, 'Confirmed', 'Successful'),
(179, 29, 19, 19, '2026-08-20', '2026-09-18', 'C019', 'Suite', 8650, 'Confirmed', 'Successful'),
(180, 30, 20, 20, '2026-09-01', '2026-09-19', 'C020', 'Standard', 1500, 'Cancelled', 'Refunded');


INSERT INTO Crew(crew_id,crew_name,designation,department,ship_id,salary,joining_date,phone,employment_status) VALUES
(1, 'Crew Member 1', 'Engineer', 'Engineering', 1, 50000, '2020-02-02', '9100000001', 'Active'),
(2, 'Crew Member 2', 'Manager', 'Operations', 2, 55000, '2020-03-03', '9100000002', 'Active'),
(3, 'Crew Member 3', 'Chef', 'Housekeeping', 3, 60000, '2020-04-04', '9100000003', 'Active'),
(4, 'Crew Member 4', 'Captain', 'Food Services', 4, 65000, '2020-05-05', '9100000004', 'Active'),
(5, 'Crew Member 5', 'Engineer', 'Hospitality', 5, 70000, '2020-06-06', '9100000005', 'Active'),
(6, 'Crew Member 6', 'Manager', 'Engineering', 6, 75000, '2020-07-07', '9100000006', 'Active'),
(7, 'Crew Member 7', 'Chef', 'Operations', 7, 80000, '2020-08-08', '9100000007', 'Active'),
(8, 'Crew Member 8', 'Captain', 'Housekeeping', 8, 45000, '2020-09-09', '9100000008', 'Active'),
(9, 'Crew Member 9', 'Engineer', 'Food Services', 9, 50000, '2020-10-10', '9100000009', 'Active'),
(10, 'Crew Member 10', 'Manager', 'Hospitality', 10, 55000, '2020-11-11', '9100000010', 'Active'),
(11, 'Crew Member 11', 'Chef', 'Engineering', 1, 60000, '2020-12-12', '9100000011', 'Active'),
(12, 'Crew Member 12', 'Captain', 'Operations', 2, 65000, '2020-01-13', '9100000012', 'Active'),
(13, 'Crew Member 13', 'Engineer', 'Housekeeping', 3, 70000, '2020-02-14', '9100000013', 'Active'),
(14, 'Crew Member 14', 'Manager', 'Food Services', 4, 75000, '2020-03-15', '9100000014', 'Active'),
(15, 'Crew Member 15', 'Chef', 'Hospitality', 5, 80000, '2020-04-16', '9100000015', 'Active'),
(16, 'Crew Member 16', 'Captain', 'Engineering', 6, 45000, '2020-05-17', '9100000016', 'Active'),
(17, 'Crew Member 17', 'Engineer', 'Operations', 7, 50000, '2020-06-18', '9100000017', 'Active'),
(18, 'Crew Member 18', 'Manager', 'Housekeeping', 8, 55000, '2020-07-19', '9100000018', 'Active'),
(19, 'Crew Member 19', 'Chef', 'Food Services', 9, 60000, '2020-08-20', '9100000019', 'Active'),
(20, 'Crew Member 20', 'Captain', 'Hospitality', 10, 65000, '2020-09-21', '9100000020', 'Active');

INSERT INTO Payment(payment_id,booking_id,payment_date,amount,payment_method,transaction_reference,payment_status) VALUES
(1, 1, '2026-09-02 10:00:00', 2550, 'Card', 'TXN000001', 'Successful'),
(2, 2, '2026-09-03 10:00:00', 3600, 'Net Banking', 'TXN000002', 'Successful'),
(3, 3, '2026-09-04 10:00:00', 4650, 'Cash', 'TXN000003', 'Successful'),
(4, 4, '2026-09-05 10:00:00', 2500, 'Wallet', 'TXN000004', 'Successful'),
(5, 5, '2026-09-06 10:00:00', 3550, 'UPI', 'TXN000005', 'Successful'),
(6, 6, '2026-09-07 10:00:00', 4600, 'Card', 'TXN000006', 'Successful'),
(7, 7, '2026-09-08 10:00:00', 5650, 'Net Banking', 'TXN000007', 'Pending'),
(8, 8, '2026-09-09 10:00:00', 3500, 'Cash', 'TXN000008', 'Successful'),
(9, 9, '2026-09-10 10:00:00', 4550, 'Wallet', 'TXN000009', 'Successful'),
(10, 10, '2026-09-11 10:00:00', 5600, 'UPI', 'TXN000010', 'Successful'),
(11, 11, '2026-09-12 10:00:00', 6650, 'Card', 'TXN000011', 'Successful'),
(12, 12, '2026-09-13 10:00:00', 4500, 'Net Banking', 'TXN000012', 'Successful'),
(13, 13, '2026-09-14 10:00:00', 5550, 'Cash', 'TXN000013', 'Successful'),
(14, 14, '2026-09-15 10:00:00', 6600, 'Wallet', 'TXN000014', 'Pending'),
(15, 15, '2026-09-16 10:00:00', 7650, 'UPI', 'TXN000015', 'Refunded'),
(16, 16, '2026-09-17 10:00:00', 5500, 'Card', 'TXN000016', 'Successful'),
(17, 17, '2026-09-18 10:00:00', 6550, 'Net Banking', 'TXN000017', 'Successful'),
(18, 18, '2026-09-19 10:00:00', 7600, 'Cash', 'TXN000018', 'Successful'),
(19, 19, '2026-09-20 10:00:00', 8650, 'Wallet', 'TXN000019', 'Successful'),
(20, 20, '2026-09-21 10:00:00', 1500, 'UPI', 'TXN000020', 'Successful'),
(21, 21, '2026-09-22 10:00:00', 2550, 'Card', 'TXN000021', 'Pending'),
(22, 22, '2026-09-23 10:00:00', 3600, 'Net Banking', 'TXN000022', 'Successful'),
(23, 23, '2026-09-24 10:00:00', 4650, 'Cash', 'TXN000023', 'Successful'),
(24, 24, '2026-09-25 10:00:00', 2500, 'Wallet', 'TXN000024', 'Successful'),
(25, 25, '2026-09-26 10:00:00', 3550, 'UPI', 'TXN000025', 'Successful'),
(26, 26, '2026-09-27 10:00:00', 4600, 'Card', 'TXN000026', 'Successful'),
(27, 27, '2026-09-01 10:00:00', 5650, 'Net Banking', 'TXN000027', 'Successful'),
(28, 28, '2026-09-02 10:00:00', 3500, 'Cash', 'TXN000028', 'Pending'),
(29, 29, '2026-09-03 10:00:00', 4550, 'Wallet', 'TXN000029', 'Successful'),
(30, 30, '2026-09-04 10:00:00', 5600, 'UPI', 'TXN000030', 'Refunded'),
(31, 31, '2026-09-05 10:00:00', 6650, 'Card', 'TXN000031', 'Successful'),
(32, 32, '2026-09-06 10:00:00', 4500, 'Net Banking', 'TXN000032', 'Successful'),
(33, 33, '2026-09-07 10:00:00', 5550, 'Cash', 'TXN000033', 'Successful'),
(34, 34, '2026-09-08 10:00:00', 6600, 'Wallet', 'TXN000034', 'Successful'),
(35, 35, '2026-09-09 10:00:00', 7650, 'UPI', 'TXN000035', 'Pending'),
(36, 36, '2026-09-10 10:00:00', 5500, 'Card', 'TXN000036', 'Successful'),
(37, 37, '2026-09-11 10:00:00', 6550, 'Net Banking', 'TXN000037', 'Successful'),
(38, 38, '2026-09-12 10:00:00', 7600, 'Cash', 'TXN000038', 'Successful'),
(39, 39, '2026-09-13 10:00:00', 8650, 'Wallet', 'TXN000039', 'Successful'),
(40, 40, '2026-09-14 10:00:00', 1500, 'UPI', 'TXN000040', 'Successful'),
(41, 41, '2026-09-15 10:00:00', 2550, 'Card', 'TXN000041', 'Successful'),
(42, 42, '2026-09-16 10:00:00', 3600, 'Net Banking', 'TXN000042', 'Pending'),
(43, 43, '2026-09-17 10:00:00', 4650, 'Cash', 'TXN000043', 'Successful'),
(44, 44, '2026-09-18 10:00:00', 2500, 'Wallet', 'TXN000044', 'Successful'),
(45, 45, '2026-09-19 10:00:00', 3550, 'UPI', 'TXN000045', 'Refunded'),
(46, 46, '2026-09-20 10:00:00', 4600, 'Card', 'TXN000046', 'Successful'),
(47, 47, '2026-09-21 10:00:00', 5650, 'Net Banking', 'TXN000047', 'Successful'),
(48, 48, '2026-09-22 10:00:00', 3500, 'Cash', 'TXN000048', 'Successful'),
(49, 49, '2026-09-23 10:00:00', 4550, 'Wallet', 'TXN000049', 'Pending'),
(50, 50, '2026-09-24 10:00:00', 5600, 'UPI', 'TXN000050', 'Successful'),
(51, 51, '2026-09-25 10:00:00', 6650, 'Card', 'TXN000051', 'Successful'),
(52, 52, '2026-09-26 10:00:00', 4500, 'Net Banking', 'TXN000052', 'Successful'),
(53, 53, '2026-09-27 10:00:00', 5550, 'Cash', 'TXN000053', 'Successful'),
(54, 54, '2026-09-01 10:00:00', 6600, 'Wallet', 'TXN000054', 'Successful'),
(55, 55, '2026-09-02 10:00:00', 7650, 'UPI', 'TXN000055', 'Successful'),
(56, 56, '2026-09-03 10:00:00', 5500, 'Card', 'TXN000056', 'Pending'),
(57, 57, '2026-09-04 10:00:00', 6550, 'Net Banking', 'TXN000057', 'Successful'),
(58, 58, '2026-09-05 10:00:00', 7600, 'Cash', 'TXN000058', 'Successful'),
(59, 59, '2026-09-06 10:00:00', 8650, 'Wallet', 'TXN000059', 'Successful'),
(60, 60, '2026-09-07 10:00:00', 1500, 'UPI', 'TXN000060', 'Refunded'),
(61, 61, '2026-09-08 10:00:00', 2550, 'Card', 'TXN000061', 'Successful'),
(62, 62, '2026-09-09 10:00:00', 3600, 'Net Banking', 'TXN000062', 'Successful'),
(63, 63, '2026-09-10 10:00:00', 4650, 'Cash', 'TXN000063', 'Pending'),
(64, 64, '2026-09-11 10:00:00', 2500, 'Wallet', 'TXN000064', 'Successful'),
(65, 65, '2026-09-12 10:00:00', 3550, 'UPI', 'TXN000065', 'Successful'),
(66, 66, '2026-09-13 10:00:00', 4600, 'Card', 'TXN000066', 'Successful'),
(67, 67, '2026-09-14 10:00:00', 5650, 'Net Banking', 'TXN000067', 'Successful'),
(68, 68, '2026-09-15 10:00:00', 3500, 'Cash', 'TXN000068', 'Successful'),
(69, 69, '2026-09-16 10:00:00', 4550, 'Wallet', 'TXN000069', 'Successful'),
(70, 70, '2026-09-17 10:00:00', 5600, 'UPI', 'TXN000070', 'Pending'),
(71, 71, '2026-09-18 10:00:00', 6650, 'Card', 'TXN000071', 'Successful'),
(72, 72, '2026-09-19 10:00:00', 4500, 'Net Banking', 'TXN000072', 'Successful'),
(73, 73, '2026-09-20 10:00:00', 5550, 'Cash', 'TXN000073', 'Successful'),
(74, 74, '2026-09-21 10:00:00', 6600, 'Wallet', 'TXN000074', 'Successful'),
(75, 75, '2026-09-22 10:00:00', 7650, 'UPI', 'TXN000075', 'Refunded'),
(76, 76, '2026-09-23 10:00:00', 5500, 'Card', 'TXN000076', 'Successful'),
(77, 77, '2026-09-24 10:00:00', 6550, 'Net Banking', 'TXN000077', 'Pending'),
(78, 78, '2026-09-25 10:00:00', 7600, 'Cash', 'TXN000078', 'Successful'),
(79, 79, '2026-09-26 10:00:00', 8650, 'Wallet', 'TXN000079', 'Successful'),
(80, 80, '2026-09-27 10:00:00', 1500, 'UPI', 'TXN000080', 'Successful'),
(81, 81, '2026-09-01 10:00:00', 2550, 'Card', 'TXN000081', 'Successful'),
(82, 82, '2026-09-02 10:00:00', 3600, 'Net Banking', 'TXN000082', 'Successful'),
(83, 83, '2026-09-03 10:00:00', 4650, 'Cash', 'TXN000083', 'Successful'),
(84, 84, '2026-09-04 10:00:00', 2500, 'Wallet', 'TXN000084', 'Pending'),
(85, 85, '2026-09-05 10:00:00', 3550, 'UPI', 'TXN000085', 'Successful'),
(86, 86, '2026-09-06 10:00:00', 4600, 'Card', 'TXN000086', 'Successful'),
(87, 87, '2026-09-07 10:00:00', 5650, 'Net Banking', 'TXN000087', 'Successful'),
(88, 88, '2026-09-08 10:00:00', 3500, 'Cash', 'TXN000088', 'Successful'),
(89, 89, '2026-09-09 10:00:00', 4550, 'Wallet', 'TXN000089', 'Successful'),
(90, 90, '2026-09-10 10:00:00', 5600, 'UPI', 'TXN000090', 'Refunded'),
(91, 91, '2026-09-11 10:00:00', 6650, 'Card', 'TXN000091', 'Pending'),
(92, 92, '2026-09-12 10:00:00', 4500, 'Net Banking', 'TXN000092', 'Successful'),
(93, 93, '2026-09-13 10:00:00', 5550, 'Cash', 'TXN000093', 'Successful'),
(94, 94, '2026-09-14 10:00:00', 6600, 'Wallet', 'TXN000094', 'Successful'),
(95, 95, '2026-09-15 10:00:00', 7650, 'UPI', 'TXN000095', 'Successful'),
(96, 96, '2026-09-16 10:00:00', 5500, 'Card', 'TXN000096', 'Successful'),
(97, 97, '2026-09-17 10:00:00', 6550, 'Net Banking', 'TXN000097', 'Successful'),
(98, 98, '2026-09-18 10:00:00', 7600, 'Cash', 'TXN000098', 'Pending'),
(99, 99, '2026-09-19 10:00:00', 8650, 'Wallet', 'TXN000099', 'Successful'),
(100, 100, '2026-09-20 10:00:00', 1500, 'UPI', 'TXN000100', 'Successful'),
(101, 101, '2026-09-21 10:00:00', 2550, 'Card', 'TXN000101', 'Successful'),
(102, 102, '2026-09-22 10:00:00', 3600, 'Net Banking', 'TXN000102', 'Successful'),
(103, 103, '2026-09-23 10:00:00', 4650, 'Cash', 'TXN000103', 'Successful'),
(104, 104, '2026-09-24 10:00:00', 2500, 'Wallet', 'TXN000104', 'Successful'),
(105, 105, '2026-09-25 10:00:00', 3550, 'UPI', 'TXN000105', 'Refunded'),
(106, 106, '2026-09-26 10:00:00', 4600, 'Card', 'TXN000106', 'Successful'),
(107, 107, '2026-09-27 10:00:00', 5650, 'Net Banking', 'TXN000107', 'Successful'),
(108, 108, '2026-09-01 10:00:00', 3500, 'Cash', 'TXN000108', 'Successful'),
(109, 109, '2026-09-02 10:00:00', 4550, 'Wallet', 'TXN000109', 'Successful'),
(110, 110, '2026-09-03 10:00:00', 5600, 'UPI', 'TXN000110', 'Successful'),
(111, 111, '2026-09-04 10:00:00', 6650, 'Card', 'TXN000111', 'Successful'),
(112, 112, '2026-09-05 10:00:00', 4500, 'Net Banking', 'TXN000112', 'Pending'),
(113, 113, '2026-09-06 10:00:00', 5550, 'Cash', 'TXN000113', 'Successful'),
(114, 114, '2026-09-07 10:00:00', 6600, 'Wallet', 'TXN000114', 'Successful'),
(115, 115, '2026-09-08 10:00:00', 7650, 'UPI', 'TXN000115', 'Successful'),
(116, 116, '2026-09-09 10:00:00', 5500, 'Card', 'TXN000116', 'Successful'),
(117, 117, '2026-09-10 10:00:00', 6550, 'Net Banking', 'TXN000117', 'Successful'),
(118, 118, '2026-09-11 10:00:00', 7600, 'Cash', 'TXN000118', 'Successful'),
(119, 119, '2026-09-12 10:00:00', 8650, 'Wallet', 'TXN000119', 'Pending'),
(120, 120, '2026-09-13 10:00:00', 1500, 'UPI', 'TXN000120', 'Refunded'),
(121, 121, '2026-09-14 10:00:00', 2550, 'Card', 'TXN000121', 'Successful'),
(122, 122, '2026-09-15 10:00:00', 3600, 'Net Banking', 'TXN000122', 'Successful'),
(123, 123, '2026-09-16 10:00:00', 4650, 'Cash', 'TXN000123', 'Successful'),
(124, 124, '2026-09-17 10:00:00', 2500, 'Wallet', 'TXN000124', 'Successful'),
(125, 125, '2026-09-18 10:00:00', 3550, 'UPI', 'TXN000125', 'Successful'),
(126, 126, '2026-09-19 10:00:00', 4600, 'Card', 'TXN000126', 'Pending'),
(127, 127, '2026-09-20 10:00:00', 5650, 'Net Banking', 'TXN000127', 'Successful'),
(128, 128, '2026-09-21 10:00:00', 3500, 'Cash', 'TXN000128', 'Successful'),
(129, 129, '2026-09-22 10:00:00', 4550, 'Wallet', 'TXN000129', 'Successful'),
(130, 130, '2026-09-23 10:00:00', 5600, 'UPI', 'TXN000130', 'Successful'),
(131, 131, '2026-09-24 10:00:00', 6650, 'Card', 'TXN000131', 'Successful'),
(132, 132, '2026-09-25 10:00:00', 4500, 'Net Banking', 'TXN000132', 'Successful'),
(133, 133, '2026-09-26 10:00:00', 5550, 'Cash', 'TXN000133', 'Pending'),
(134, 134, '2026-09-27 10:00:00', 6600, 'Wallet', 'TXN000134', 'Successful'),
(135, 135, '2026-09-01 10:00:00', 7650, 'UPI', 'TXN000135', 'Refunded'),
(136, 136, '2026-09-02 10:00:00', 5500, 'Card', 'TXN000136', 'Successful'),
(137, 137, '2026-09-03 10:00:00', 6550, 'Net Banking', 'TXN000137', 'Successful'),
(138, 138, '2026-09-04 10:00:00', 7600, 'Cash', 'TXN000138', 'Successful'),
(139, 139, '2026-09-05 10:00:00', 8650, 'Wallet', 'TXN000139', 'Successful'),
(140, 140, '2026-09-06 10:00:00', 1500, 'UPI', 'TXN000140', 'Pending'),
(141, 141, '2026-09-07 10:00:00', 2550, 'Card', 'TXN000141', 'Successful'),
(142, 142, '2026-09-08 10:00:00', 3600, 'Net Banking', 'TXN000142', 'Successful'),
(143, 143, '2026-09-09 10:00:00', 4650, 'Cash', 'TXN000143', 'Successful'),
(144, 144, '2026-09-10 10:00:00', 2500, 'Wallet', 'TXN000144', 'Successful'),
(145, 145, '2026-09-11 10:00:00', 3550, 'UPI', 'TXN000145', 'Successful'),
(146, 146, '2026-09-12 10:00:00', 4600, 'Card', 'TXN000146', 'Successful'),
(147, 147, '2026-09-13 10:00:00', 5650, 'Net Banking', 'TXN000147', 'Pending'),
(148, 148, '2026-09-14 10:00:00', 3500, 'Cash', 'TXN000148', 'Successful'),
(149, 149, '2026-09-15 10:00:00', 4550, 'Wallet', 'TXN000149', 'Successful'),
(150, 150, '2026-09-16 10:00:00', 5600, 'UPI', 'TXN000150', 'Refunded'),
(151, 151, '2026-09-17 10:00:00', 6650, 'Card', 'TXN000151', 'Successful'),
(152, 152, '2026-09-18 10:00:00', 4500, 'Net Banking', 'TXN000152', 'Successful'),
(153, 153, '2026-09-19 10:00:00', 5550, 'Cash', 'TXN000153', 'Successful'),
(154, 154, '2026-09-20 10:00:00', 6600, 'Wallet', 'TXN000154', 'Pending'),
(155, 155, '2026-09-21 10:00:00', 7650, 'UPI', 'TXN000155', 'Successful'),
(156, 156, '2026-09-22 10:00:00', 5500, 'Card', 'TXN000156', 'Successful'),
(157, 157, '2026-09-23 10:00:00', 6550, 'Net Banking', 'TXN000157', 'Successful'),
(158, 158, '2026-09-24 10:00:00', 7600, 'Cash', 'TXN000158', 'Successful'),
(159, 159, '2026-09-25 10:00:00', 8650, 'Wallet', 'TXN000159', 'Successful'),
(160, 160, '2026-09-26 10:00:00', 1500, 'UPI', 'TXN000160', 'Successful'),
(161, 161, '2026-09-27 10:00:00', 2550, 'Card', 'TXN000161', 'Pending'),
(162, 162, '2026-09-01 10:00:00', 3600, 'Net Banking', 'TXN000162', 'Successful'),
(163, 163, '2026-09-02 10:00:00', 4650, 'Cash', 'TXN000163', 'Successful'),
(164, 164, '2026-09-03 10:00:00', 2500, 'Wallet', 'TXN000164', 'Successful'),
(165, 165, '2026-09-04 10:00:00', 3550, 'UPI', 'TXN000165', 'Refunded'),
(166, 166, '2026-09-05 10:00:00', 4600, 'Card', 'TXN000166', 'Successful'),
(167, 167, '2026-09-06 10:00:00', 5650, 'Net Banking', 'TXN000167', 'Successful'),
(168, 168, '2026-09-07 10:00:00', 3500, 'Cash', 'TXN000168', 'Pending'),
(169, 169, '2026-09-08 10:00:00', 4550, 'Wallet', 'TXN000169', 'Successful'),
(170, 170, '2026-09-09 10:00:00', 5600, 'UPI', 'TXN000170', 'Successful'),
(171, 171, '2026-09-10 10:00:00', 6650, 'Card', 'TXN000171', 'Successful'),
(172, 172, '2026-09-11 10:00:00', 4500, 'Net Banking', 'TXN000172', 'Successful'),
(173, 173, '2026-09-12 10:00:00', 5550, 'Cash', 'TXN000173', 'Successful'),
(174, 174, '2026-09-13 10:00:00', 6600, 'Wallet', 'TXN000174', 'Successful'),
(175, 175, '2026-09-14 10:00:00', 7650, 'UPI', 'TXN000175', 'Pending'),
(176, 176, '2026-09-15 10:00:00', 5500, 'Card', 'TXN000176', 'Successful'),
(177, 177, '2026-09-16 10:00:00', 6550, 'Net Banking', 'TXN000177', 'Successful'),
(178, 178, '2026-09-17 10:00:00', 7600, 'Cash', 'TXN000178', 'Successful'),
(179, 179, '2026-09-18 10:00:00', 8650, 'Wallet', 'TXN000179', 'Successful'),
(180, 180, '2026-09-19 10:00:00', 1500, 'UPI', 'TXN000180', 'Refunded');

INSERT INTO Cancellation(cancellation_id,booking_id,cancellation_date,reason,refund_amount,cancellation_status) VALUES
(1, 15, '2026-09-02 12:00:00', 'Customer request', 5355.0, 'Processed'),
(2, 30, '2026-09-03 12:00:00', 'Customer request', 3920.0, 'Processed'),
(3, 45, '2026-09-04 12:00:00', 'Customer request', 2485.0, 'Processed'),
(4, 60, '2026-09-05 12:00:00', 'Customer request', 1050.0, 'Processed'),
(5, 75, '2026-09-06 12:00:00', 'Customer request', 5355.0, 'Processed'),
(6, 90, '2026-09-07 12:00:00', 'Customer request', 3920.0, 'Processed'),
(7, 105, '2026-09-08 12:00:00', 'Customer request', 2485.0, 'Processed'),
(8, 120, '2026-09-09 12:00:00', 'Customer request', 1050.0, 'Processed'),
(9, 135, '2026-09-10 12:00:00', 'Customer request', 5355.0, 'Processed'),
(10, 150, '2026-09-11 12:00:00', 'Customer request', 3920.0, 'Processed'),
(11, 165, '2026-09-12 12:00:00', 'Customer request', 2485.0, 'Processed'),
(12, 180, '2026-09-13 12:00:00', 'Customer request', 1050.0, 'Processed');

INSERT INTO Maintenance(maintenance_id,ship_id,maintenance_date,maintenance_type,cost,engineer_name,maintenance_status,next_due_date) VALUES
(1, 1, '2026-02-02', 'Safety', 28000, 'Engineer 1', 'Completed', '2027-02-02'),
(2, 2, '2026-03-03', 'Electrical', 31000, 'Engineer 2', 'Completed', '2027-03-03'),
(3, 3, '2026-04-04', 'General', 34000, 'Engineer 3', 'Completed', '2027-04-04'),
(4, 4, '2026-05-05', 'Engine', 37000, 'Engineer 4', 'Completed', '2027-05-05'),
(5, 5, '2026-06-06', 'Safety', 40000, 'Engineer 5', 'Completed', '2027-06-06'),
(6, 6, '2026-07-07', 'Electrical', 43000, 'Engineer 6', 'Completed', '2027-07-07'),
(7, 7, '2026-08-08', 'General', 46000, 'Engineer 7', 'Completed', '2027-08-08'),
(8, 8, '2026-09-09', 'Engine', 49000, 'Engineer 8', 'Completed', '2027-09-09'),
(9, 9, '2026-01-10', 'Safety', 52000, 'Engineer 9', 'Completed', '2027-01-10'),
(10, 10, '2026-02-11', 'Electrical', 55000, 'Engineer 10', 'Completed', '2027-02-11'),
(11, 1, '2026-03-12', 'General', 58000, 'Engineer 11', 'Completed', '2027-03-12'),
(12, 2, '2026-04-13', 'Engine', 61000, 'Engineer 12', 'Completed', '2027-04-13'),
(13, 3, '2026-05-14', 'Safety', 64000, 'Engineer 13', 'Completed', '2027-05-14'),
(14, 4, '2026-06-15', 'Electrical', 67000, 'Engineer 14', 'Completed', '2027-06-15'),
(15, 5, '2026-07-16', 'General', 70000, 'Engineer 15', 'Completed', '2027-07-16'),
(16, 6, '2026-08-17', 'Engine', 73000, 'Engineer 16', 'Completed', '2027-08-17'),
(17, 7, '2026-09-18', 'Safety', 76000, 'Engineer 17', 'Completed', '2027-09-18'),
(18, 8, '2026-01-19', 'Electrical', 79000, 'Engineer 18', 'Completed', '2027-01-19'),
(19, 9, '2026-02-20', 'General', 82000, 'Engineer 19', 'Completed', '2027-02-20'),
(20, 10, '2026-03-21', 'Engine', 85000, 'Engineer 20', 'Completed', '2027-03-21');



-- ============================================================
-- SECTION A — DATABASE & TABLE CREATION
-- ============================================================

-- Q1. Create the Cruise_Line_Management database.
-- ANSWER:
CREATE DATABASE IF NOT EXISTS Cruise_Line_Management;

-- Q2. Display all databases available on the server.
-- ANSWER:
SHOW DATABASES;

-- Q3. Select the Cruise_Line_Management database.
-- ANSWER:
USE Cruise_Line_Management;

-- Q4. Create the Passenger table with appropriate data types and constraints.
-- ANSWER:
CREATE TABLE Passenger (
    passenger_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    gender VARCHAR(10) NOT NULL,
    dob DATE NOT NULL,
    phone VARCHAR(15) UNIQUE,
    email VARCHAR(100) UNIQUE,
    city VARCHAR(50),
    country VARCHAR(50) DEFAULT 'India',
    registration_date DATE DEFAULT (CURRENT_DATE)
);

-- Q5. Create the Port table.
-- ANSWER:
CREATE TABLE Port (
    port_id INT PRIMARY KEY AUTO_INCREMENT,
    port_code VARCHAR(10) UNIQUE,
    port_name VARCHAR(100) NOT NULL,
    city VARCHAR(50) NOT NULL,
    country VARCHAR(50) NOT NULL,
    region VARCHAR(50) NOT NULL,
    berths INT CHECK (berths > 0),
    port_type VARCHAR(30) DEFAULT 'International'
);

-- Q6. Create the Ship table.
-- ANSWER:
CREATE TABLE Ship (
    ship_id INT PRIMARY KEY AUTO_INCREMENT,
    ship_number VARCHAR(10) UNIQUE,
    ship_name VARCHAR(100) NOT NULL,
    ship_type VARCHAR(30) NOT NULL,
    home_port_id INT,
    passenger_capacity INT CHECK (passenger_capacity > 0),
    total_cabins INT CHECK (total_cabins > 0),
    operating_days VARCHAR(50),
    status VARCHAR(20) DEFAULT 'Active',
    FOREIGN KEY (home_port_id) REFERENCES Port(port_id)
);

-- Q7. Create the Cabin table.
-- ANSWER:
CREATE TABLE Cabin (
    cabin_id INT PRIMARY KEY AUTO_INCREMENT,
    ship_id INT,
    cabin_number VARCHAR(10) NOT NULL,
    cabin_type VARCHAR(30) NOT NULL,
    capacity INT CHECK (capacity > 0),
    fare_multiplier DECIMAL(5,2) DEFAULT 1.00,
    cabin_status VARCHAR(20) DEFAULT 'Available',
    FOREIGN KEY (ship_id) REFERENCES Ship(ship_id)
);

-- Q8. Create the Cruise_Schedule table.
-- ANSWER:
CREATE TABLE Cruise_Schedule (
    schedule_id INT PRIMARY KEY AUTO_INCREMENT,
    cruise_id INT,
    port_id INT,
    arrival_time TIME,
    departure_time TIME,
    halt_minutes INT DEFAULT 0,
    sequence_no INT NOT NULL,
    berth_no INT,
    schedule_status VARCHAR(20) DEFAULT 'Scheduled',
    FOREIGN KEY (cruise_id) REFERENCES Cruise(cruise_id),
    FOREIGN KEY (port_id) REFERENCES Port(port_id)
);

-- Q9. Create the Booking table.
-- ANSWER:
CREATE TABLE Booking (
    booking_id INT PRIMARY KEY AUTO_INCREMENT,
    passenger_id INT,
    cruise_id INT,
    cabin_id INT,
    journey_date DATE NOT NULL,
    booking_date DATE DEFAULT (CURRENT_DATE),
    cabin_number VARCHAR(10),
    travel_class VARCHAR(20) NOT NULL,
    fare DECIMAL(10,2) CHECK (fare >= 0),
    booking_status VARCHAR(20) DEFAULT 'Confirmed',
    payment_status VARCHAR(20) DEFAULT 'Pending',
    FOREIGN KEY (passenger_id) REFERENCES Passenger(passenger_id),
    FOREIGN KEY (cruise_id) REFERENCES Cruise(cruise_id),
    FOREIGN KEY (cabin_id) REFERENCES Cabin(cabin_id)
);

-- Q10. Create the Crew table.
-- ANSWER:
CREATE TABLE Crew (
    crew_id INT PRIMARY KEY AUTO_INCREMENT,
    crew_name VARCHAR(100) NOT NULL,
    designation VARCHAR(50) NOT NULL,
    department VARCHAR(50) NOT NULL,
    ship_id INT,
    salary DECIMAL(12,2) CHECK (salary > 0),
    joining_date DATE NOT NULL,
    phone VARCHAR(15) UNIQUE,
    employment_status VARCHAR(20) DEFAULT 'Active',
    FOREIGN KEY (ship_id) REFERENCES Ship(ship_id)
);

-- Q11. Create the Payment table.
-- ANSWER:
CREATE TABLE Payment (
    payment_id INT PRIMARY KEY AUTO_INCREMENT,
    booking_id INT UNIQUE,
    payment_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    amount DECIMAL(10,2) CHECK (amount > 0),
    payment_method VARCHAR(30) NOT NULL,
    transaction_reference VARCHAR(50) UNIQUE,
    payment_status VARCHAR(20) DEFAULT 'Successful',
    FOREIGN KEY (booking_id) REFERENCES Booking(booking_id)
);

-- Q12. Create the Cancellation table.
-- ANSWER:
CREATE TABLE Cancellation (
    cancellation_id INT PRIMARY KEY AUTO_INCREMENT,
    booking_id INT UNIQUE,
    cancellation_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    reason VARCHAR(200),
    refund_amount DECIMAL(10,2) CHECK (refund_amount >= 0),
    cancellation_status VARCHAR(20) DEFAULT 'Processed',
    FOREIGN KEY (booking_id) REFERENCES Booking(booking_id)
);

-- Q13. Create the Maintenance table.
-- ANSWER:
CREATE TABLE Maintenance (
    maintenance_id INT PRIMARY KEY AUTO_INCREMENT,
    ship_id INT,
    maintenance_date DATE NOT NULL,
    maintenance_type VARCHAR(50) NOT NULL,
    cost DECIMAL(12,2) CHECK (cost >= 0),
    engineer_name VARCHAR(100) NOT NULL,
    maintenance_status VARCHAR(30) DEFAULT 'Completed',
    next_due_date DATE,
    FOREIGN KEY (ship_id) REFERENCES Ship(ship_id)
);

-- Q14. Explain the relationship between Passenger and Booking.
-- ANSWER:
-- Passenger 1-to-many Booking relationship through Booking.passenger_id.

-- Q15. Explain the relationship between Ship and Cabin.
-- ANSWER:
-- Ship 1-to-many Cabin relationship through Cabin.ship_id.

-- Q16. Explain the relationship between Cruise and Cruise_Schedule.
-- ANSWER:
-- Cruise 1-to-many Cruise_Schedule relationship through Cruise_Schedule.cruise_id.

-- Q17. Identify all primary keys in the database.
-- ANSWER:
SELECT TABLE_NAME,COLUMN_NAME FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE 
WHERE TABLE_SCHEMA=DATABASE() AND CONSTRAINT_NAME='PRIMARY';

-- Q18. Identify all foreign keys.
-- ANSWER:
SELECT TABLE_NAME,COLUMN_NAME,REFERENCED_TABLE_NAME,REFERENCED_COLUMN_NAME FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE
 WHERE TABLE_SCHEMA=DATABASE() AND REFERENCED_TABLE_NAME IS NOT NULL;

-- Q19. Identify all candidate keys.
-- ANSWER:
-- Candidate keys include unique phone/email/port_code/cruise_number/ship_number/transaction_reference columns.

-- Q20. Identify the associative table in the database.
-- ANSWER:
-- Booking is the associative transaction table connecting Passenger, Cruise and Cabin.

-- ============================================================
-- SECTION B — CONSTRAINTS
-- ============================================================

-- Q21. Ensure that passenger phone numbers cannot be duplicated.
-- ANSWER:
ALTER TABLE Passenger ADD CONSTRAINT uq_passenger_phone UNIQUE(phone);

-- Q22. Ensure that port codes are unique.
-- ANSWER:
ALTER TABLE Port ADD CONSTRAINT uq_port_code UNIQUE(port_code);

-- Q23. Ensure that cruise numbers are unique.
-- ANSWER:
ALTER TABLE Cruise ADD CONSTRAINT uq_cruise_number UNIQUE(cruise_number);

-- Q24. Ensure that crew phone numbers are unique.
-- ANSWER:
ALTER TABLE Crew ADD CONSTRAINT uq_crew_phone UNIQUE(phone);

-- Q25. Prevent negative cruise booking fares.
-- ANSWER:
ALTER TABLE Booking ADD CONSTRAINT chk_booking_fare CHECK(fare>=0);

-- Q26. Prevent negative crew salaries.
-- ANSWER:
ALTER TABLE Crew ADD CONSTRAINT chk_crew_salary CHECK(salary>0);

-- Q27. Prevent negative maintenance costs.
-- ANSWER:
ALTER TABLE Maintenance ADD CONSTRAINT chk_maintenance_cost CHECK(cost>=0);

-- Q28. Ensure port berth count is greater than zero.
-- ANSWER:
ALTER TABLE Port ADD CONSTRAINT chk_port_berths CHECK(berths>0);

-- Q29. Ensure cabin capacity is greater than zero.
-- ANSWER:
ALTER TABLE Cabin ADD CONSTRAINT chk_cabin_capacity CHECK(capacity>0);

-- Q30. Attempt to insert a duplicate cruise number and observe the result.
-- ANSWER:
-- INSERT INTO Cruise(cruise_number,cruise_name,cruise_type,ship_id,departure_port_id,arrival_port_id,departure_date,return_date,duration_days) VALUES('CR001','Duplicate','Premium',1,1,2,'2027-01-01','2027-01-05',4); -- expected duplicate-key error

-- Q31. Attempt to insert a booking for a passenger ID that does not exist.
-- ANSWER:
-- INSERT INTO Booking(passenger_id,cruise_id,cabin_id,journey_date,travel_class,fare) VALUES(9999,1,1,'2027-01-01','Standard',2000); -- expected FK error

-- Q32. Attempt to insert a cabin for a non-existing ship.
-- ANSWER:
-- INSERT INTO Cabin(ship_id,cabin_number,cabin_type,capacity) VALUES(9999,'X01','Suite',2); -- expected FK error

-- Q33. Attempt to insert a payment for a non-existing booking.
-- ANSWER:
-- INSERT INTO Payment(booking_id,amount,payment_method,transaction_reference) VALUES(9999,5000,'Card','TEST9999'); -- expected FK error

-- Q34. Explain how foreign keys maintain referential integrity.
-- ANSWER:
-- Foreign keys prevent child rows from referencing non-existing parent rows.

-- Q35. Explain the difference between PRIMARY KEY, UNIQUE KEY and FOREIGN KEY.
-- ANSWER:
-- PRIMARY KEY identifies rows; UNIQUE prevents duplicates; FOREIGN KEY creates a relationship.

-- ============================================================
-- SECTION C — DDL OPERATIONS
-- ============================================================

-- Q36. Add a nationality column to Passenger.
-- ANSWER:
ALTER TABLE Passenger ADD nationality VARCHAR(50);

-- Q37. Modify the email column to allow 150 characters.
-- ANSWER:
ALTER TABLE Passenger MODIFY email VARCHAR(150) UNIQUE;

-- Q38. Add an emergency_contact column.
-- ANSWER:
ALTER TABLE Passenger ADD emergency_contact VARCHAR(15);

-- Q39. Remove the emergency contact column.
-- ANSWER:
ALTER TABLE Passenger DROP COLUMN emergency_contact;

-- Q40. Add a CHECK constraint to ensure that passenger DOB is not in the future.
-- ANSWER:
ALTER TABLE Passenger ADD CONSTRAINT chk_dob CHECK(dob<='2026-09-27');

-- Q41. Add a default status of Active to Ship.
-- ANSWER:
ALTER TABLE Ship ALTER COLUMN status SET DEFAULT 'Active';

-- Q42. Add a default status of Confirmed to Booking.
-- ANSWER:
ALTER TABLE Booking ALTER COLUMN booking_status SET DEFAULT 'Confirmed';

-- Q43. Rename a column in the Port table.
-- ANSWER:
ALTER TABLE Port RENAME COLUMN port_name TO terminal_name;

-- Q44. Rename the Cruise table temporarily and rename it back.
-- ANSWER:
RENAME TABLE Cruise TO Cruise_Temp; RENAME TABLE Cruise_Temp TO Cruise;

-- Q45. Create an index on passenger phone.
-- ANSWER:
CREATE INDEX idx_passenger_phone ON Passenger(phone);

-- Q46. Create an index on cruise number.
-- ANSWER:
CREATE INDEX idx_cruise_number ON Cruise(cruise_number);

-- Q47. Create a composite index using cruise_id and journey_date.
-- ANSWER:
CREATE INDEX idx_booking_cruise_date ON Booking(cruise_id,journey_date);

-- Q48. Remove an index.
-- ANSWER:
DROP INDEX idx_passenger_phone ON Passenger;

-- Q49. Create a temporary table containing confirmed bookings.
-- ANSWER:
CREATE TEMPORARY TABLE Temp_Confirmed_Bookings AS SELECT * FROM Booking WHERE booking_status='Confirmed';

-- Q50. Explain the difference between DELETE, TRUNCATE and DROP.
-- ANSWER:
-- DELETE removes selected rows; TRUNCATE removes all rows; DROP removes the table itself.

-- ============================================================
-- SECTION D — INSERT DATA
-- ============================================================

-- Q51. Insert at least 10 passenger records.
-- ANSWER:
-- Insert at least 10 Passenger rows; the dataset section supplies 30 rows.

-- Q52. Insert at least 10 port records.
-- ANSWER:
-- Insert at least 10 Port rows; the dataset section supplies 12 rows.

-- Q53. Insert at least 10 ship records.
-- ANSWER:
-- Insert at least 10 Ship rows; the dataset section supplies 10 rows.

-- Q54. Insert at least 10 cabin records.
-- ANSWER:
-- Insert at least 10 Cabin rows; the dataset section supplies 20 rows.

-- Q55. Insert at least 10 cruise schedule records.
-- ANSWER:
-- Insert at least 10 Cruise_Schedule rows; the dataset section supplies 60 rows.

-- Q56. Insert at least 10 booking records.
-- ANSWER:
-- Insert at least 10 Booking rows; the dataset section supplies 180 rows.

-- Q57. Insert at least 10 crew records.
-- ANSWER:
-- Insert at least 10 Crew rows; the dataset section supplies 20 rows.

-- Q58. Insert at least 10 payment records.
-- ANSWER:
-- Insert at least 10 Payment rows; the dataset section supplies 180 rows.

-- Q59. Insert at least 10 cancellation records.
-- ANSWER:
-- Insert at least 10 Cancellation rows; the dataset section supplies 12 rows.

-- Q60. Insert at least 10 maintenance records.
-- ANSWER:
-- Insert at least 10 Maintenance rows; the dataset section supplies 20 rows.

-- Q61. Insert multiple passengers using a single INSERT statement.
-- ANSWER:
INSERT INTO Passenger(first_name,last_name,gender,dob,city) VALUES
('Test','One','M','1995-01-01','Mumbai'),('Test','Two','F','1996-02-02','Pune');

-- Q62. Insert a passenger without specifying the registration date.
-- ANSWER:
INSERT INTO Passenger(first_name,last_name,gender,dob,phone,email,city) VALUES
('Default','Date','F','1998-03-03','9111111111','default@example.com','Mumbai');

-- Q63. Insert a cruise without specifying its status.
-- ANSWER:

INSERT INTO Cruise(cruise_number,cruise_name,cruise_type,ship_id,departure_port_id,arrival_port_id,departure_date,return_date,duration_days) VALUES
('CR999','Demo Cruise','Premium',1,1,2,'2027-01-01','2027-01-06',5);

-- Q64. Insert a cabin using the default fare multiplier.
-- ANSWER:

INSERT INTO Cabin(ship_id,cabin_number,cabin_type,capacity) VALUES
(1,'D99','Standard',2);

-- Q65. Insert a booking using default booking and payment status.
-- ANSWER:
INSERT INTO Booking(passenger_id,cruise_id,cabin_id,journey_date,travel_class,fare) VALUES
(1,1,1,'2026-10-01','Standard',2500);

-- ============================================================
-- SECTION E — FILTERING & OPERATORS
-- ============================================================

-- Q66. Find passengers whose first name starts with the letter A.
-- ANSWER:
SELECT * FROM Passenger
 WHERE first_name LIKE 'A%';

-- Q67. Find passengers whose name contains the characters an.
-- ANSWER:
SELECT * FROM Passenger
 WHERE CONCAT(first_name,' ',last_name) LIKE '%an%';

-- Q68. Find ports whose names contain more than one word.
-- ANSWER:
SELECT * FROM Port
 WHERE port_name LIKE '% %';

-- Q69. Find crew members earning between ₹40,000 and ₹80,000.
-- ANSWER:
SELECT * FROM Crew 
WHERE salary BETWEEN 40000 AND 80000;

-- Q70. Find passengers from Mumbai, Pune or Nashik.
-- ANSWER:
SELECT * FROM Passenger
WHERE city IN('Mumbai','Pune','Nashik');

-- Q71. Find ships that are not currently active.
-- ANSWER:
SELECT * FROM Ship
 WHERE status<>'Active';

-- Q72. Find bookings whose fare is greater than ₹1,500.
-- ANSWER:
SELECT * FROM Booking
 WHERE fare>1500;

-- Q73. Find bookings made more than 15 days before the journey.
-- ANSWER:
SELECT * FROM Booking
 WHERE DATEDIFF(journey_date,booking_date)>15;

-- Q74. Find bookings made within two days of the journey date.
-- ANSWER:
SELECT * FROM Booking
 WHERE DATEDIFF(journey_date,booking_date) BETWEEN 0 AND 2;

-- Q75. Find passengers whose email address is missing.
-- ANSWER:
SELECT * FROM Passenger
 WHERE email IS NULL;

-- Q76. Find bookings where cabin number has not yet been assigned.
-- ANSWER:
SELECT * FROM Booking 
WHERE cabin_number IS NULL;

-- Q77. Find ships whose passenger capacity is between 1,000 and 2,500.
-- ANSWER:
SELECT * FROM Ship WHERE passenger_capacity BETWEEN 1000 AND 2500;

-- Q78. Find crew members who are not working in the Operations department.
-- ANSWER:
SELECT * FROM Crew WHERE department<>'Operations';

-- Q79. Find ports with more than 5 berths.
-- ANSWER:
SELECT * FROM Port WHERE berths>5;

-- Q80. Find cabins having capacity between 2 and 4.
-- ANSWER:
SELECT * FROM Cabin WHERE capacity BETWEEN 2 AND 4;

SET SQL_SAFE_UPDATES = 0;
 

-- ============================================================
-- SECTION F — UPDATE & DELETE
-- ============================================================

-- Q81. Increase all crew salaries by 5%.
-- ANSWER:
UPDATE Crew SET salary=salary*1.05;

-- Q82. Increase salaries of crew members earning below ₹50,000 by 10%.
-- ANSWER:
UPDATE Crew SET salary=salary*1.10 WHERE salary<50000;

-- Q83. Increase Premium and Luxury booking fares by 15%.
-- ANSWER:
UPDATE Booking SET fare=fare*1.15 WHERE travel_class IN('Premium','Luxury');

-- Q84. Change pending bookings to confirmed where payment is successful.
-- ANSWER:
UPDATE Booking SET booking_status='Confirmed' WHERE booking_status='Pending' AND payment_status='Successful';

-- Q85. Change a ship's status based on its maintenance status.
-- ANSWER:
UPDATE Ship s JOIN (SELECT ship_id,MAX(maintenance_status='Pending') pending FROM Maintenance GROUP BY ship_id)m ON s.ship_id=m.ship_id SET s.status=CASE WHEN m.pending=1 THEN 'Maintenance' ELSE 'Active' END;

-- Q86. Update passenger city information.
-- ANSWER:
UPDATE Passenger SET city='Mumbai' WHERE passenger_id=1;

-- Q87. Change a crew member's department.
-- ANSWER:
UPDATE Crew SET department='Operations' WHERE crew_id=1;

-- Q88. Update the next maintenance date.
-- ANSWER:
UPDATE Maintenance SET next_due_date=DATE_ADD(next_due_date,INTERVAL 30 DAY) WHERE maintenance_id=1;

-- Q89. Delete passengers who have never made a booking.
-- ANSWER:
DELETE FROM Passenger WHERE passenger_id NOT IN(SELECT DISTINCT passenger_id FROM Booking);

-- Q90. Delete maintenance records older than a specified date.
-- ANSWER:
DELETE FROM Maintenance WHERE maintenance_date<'2026-03-01';

-- Q91. Delete unpaid bookings.
-- ANSWER:
DELETE FROM Booking WHERE payment_status='Pending';

-- Q92. Delete cancelled bookings after creating a backup table.
-- ANSWER:
CREATE TABLE Booking_Cancelled_Backup AS SELECT * FROM Booking WHERE booking_status='Cancelled'; DELETE FROM Booking WHERE booking_status='Cancelled';

-- Q93. Delete crew members who are no longer active.
-- ANSWER:
DELETE FROM Crew WHERE employment_status<>'Active';

-- Q94. Explain why deleting a passenger with existing bookings may violate referential integrity.
-- ANSWER:
-- Passenger is a parent row; existing Booking rows reference it through a foreign key.

-- Q95. Use a transaction to safely perform a DELETE operation.
-- ANSWER:
START TRANSACTION; DELETE FROM Passenger WHERE passenger_id=30; ROLLBACK;

-- ============================================================
-- SECTION G — AGGREGATE FUNCTIONS
-- ============================================================

-- Q96. Find the total number of passengers.
-- ANSWER:
SELECT COUNT(*) total_passengers FROM Passenger;

-- Q97. Find the total number of confirmed bookings.
-- ANSWER:
SELECT COUNT(*) confirmed_bookings FROM Booking WHERE booking_status='Confirmed';

-- Q98. Find the total booking revenue.
-- ANSWER:
SELECT SUM(fare) total_revenue FROM Booking WHERE booking_status<>'Cancelled';

-- Q99. Find the average booking fare.
-- ANSWER:
SELECT AVG(fare) average_fare FROM Booking;

-- Q100. Find the highest booking fare.
-- ANSWER:
SELECT MAX(fare) highest_fare FROM Booking;

-- Q101. Find the lowest booking fare.
-- ANSWER:
SELECT MIN(fare) lowest_fare FROM Booking;

-- Q102. Find the total salary expenditure.
-- ANSWER:
SELECT SUM(salary) total_salary FROM Crew;

-- Q103. Find the average crew salary.
-- ANSWER:
SELECT AVG(salary) average_salary FROM Crew;

-- Q104. Find the total maintenance expenditure.
-- ANSWER:
SELECT SUM(cost) total_maintenance FROM Maintenance;

-- Q105. Find the number of cancelled bookings.
-- ANSWER:
SELECT COUNT(*) cancelled_bookings FROM Booking WHERE booking_status='Cancelled';

-- Q106. Find the average refund amount.
-- ANSWER:
SELECT AVG(refund_amount) average_refund FROM Cancellation;

-- Q107. Find the total successful payment amount.
-- ANSWER:
SELECT SUM(amount) successful_payments FROM Payment WHERE payment_status='Successful';

-- Q108. Find the number of passengers from each city.
-- ANSWER:
SELECT city,COUNT(*) passenger_count FROM Passenger GROUP BY city;

-- Q109. Find the number of bookings for each cruise.
-- ANSWER:
SELECT cruise_id,COUNT(*) booking_count FROM Booking GROUP BY cruise_id;

-- Q110. Find the total revenue generated by each travel class.
-- ANSWER:
SELECT travel_class,SUM(fare) revenue FROM Booking GROUP BY travel_class;

-- ============================================================
-- SECTION H — GROUP BY / HAVING
-- ============================================================

-- Q111. Find cities having more than two registered passengers.
-- ANSWER:
SELECT city,COUNT(*) passenger_count FROM Passenger GROUP BY city HAVING COUNT(*)>2;

-- Q112. Find departments having more than two crew members.
-- ANSWER:
SELECT department,COUNT(*) crew_count FROM Crew GROUP BY department HAVING COUNT(*)>2;

-- Q113. Find cruises having more than five bookings.
-- ANSWER:
SELECT cruise_id,COUNT(*) bookings FROM Booking GROUP BY cruise_id HAVING COUNT(*)>5;

-- Q114. Find travel classes whose average fare exceeds ₹1,000.
-- ANSWER:
SELECT travel_class,AVG(fare) avg_fare FROM Booking GROUP BY travel_class HAVING AVG(fare)>1000;

-- Q115. Find cruises generating more than ₹50,000 revenue.
-- ANSWER:
SELECT cruise_id,SUM(fare) revenue FROM Booking GROUP BY cruise_id HAVING SUM(fare)>50000;

-- Q116. Find ports having more than three crew members assigned through their home ships.
-- ANSWER:
SELECT p.port_id,p.port_name,COUNT(cr.crew_id) crew_count FROM Port p JOIN Ship s ON p.port_id=s.home_port_id JOIN Crew cr ON s.ship_id=cr.ship_id GROUP BY p.port_id,p.port_name HAVING COUNT(cr.crew_id)>3;

-- Q117. Find payment methods used for more than five transactions.
-- ANSWER:
SELECT payment_method,COUNT(*) transactions FROM Payment GROUP BY payment_method HAVING COUNT(*)>5;

-- Q118. Find cruise types having average booking fare above the overall average.
-- ANSWER:
SELECT c.cruise_type,AVG(b.fare) avg_fare FROM Cruise c JOIN Booking b ON c.cruise_id=b.cruise_id GROUP BY c.cruise_type HAVING AVG(b.fare)>(SELECT AVG(fare) FROM Booking);

-- Q119. Find departments whose total salary expenditure exceeds ₹2,00,000.
-- ANSWER:
SELECT department,SUM(salary) total_salary FROM Crew GROUP BY department HAVING SUM(salary)>200000;

-- Q120. Find cruises whose cancellation count exceeds the average cancellation count.
-- ANSWER:
SELECT cruise_id,COUNT(*) cancellations FROM Booking WHERE booking_status='Cancelled' GROUP BY cruise_id HAVING COUNT(*)>(SELECT AVG(cnt) FROM(SELECT cruise_id,COUNT(*) cnt FROM Booking WHERE booking_status='Cancelled' GROUP BY cruise_id)x);

-- ============================================================
-- SECTION I — COMPLEX JOINS
-- ============================================================

-- Q121. Display passenger name, cruise name, journey date and fare.
-- ANSWER:
SELECT CONCAT(p.first_name,' ',p.last_name) passenger_name,c.cruise_name,b.journey_date,b.fare FROM Passenger p JOIN Booking b ON p.passenger_id=b.passenger_id JOIN Cruise c ON b.cruise_id=c.cruise_id;

-- Q122. Display passenger, cruise, cabin and payment information together.
-- ANSWER:
SELECT CONCAT(p.first_name,' ',p.last_name) passenger_name,c.cruise_name,ca.cabin_number,b.fare,py.amount,py.payment_method FROM Passenger p JOIN Booking b ON p.passenger_id=b.passenger_id JOIN Cruise c ON b.cruise_id=c.cruise_id JOIN Cabin ca ON b.cabin_id=ca.cabin_id LEFT JOIN Payment py ON b.booking_id=py.booking_id;

-- Q123. Display cruise name along with departure and arrival port names.
-- ANSWER:
SELECT c.cruise_name,dp.port_name departure_port,ap.port_name arrival_port FROM Cruise c JOIN Port dp ON c.departure_port_id=dp.port_id JOIN Port ap ON c.arrival_port_id=ap.port_id;

-- Q124. Display crew members along with their assigned ship.
-- ANSWER:
SELECT cr.crew_name,s.ship_name,cr.department,cr.salary FROM Crew cr JOIN Ship s ON cr.ship_id=s.ship_id;

-- Q125. Display bookings with passenger name and payment status.
-- ANSWER:
SELECT b.booking_id,CONCAT(p.first_name,' ',p.last_name) passenger_name,b.fare,b.payment_status FROM Booking b JOIN Passenger p ON b.passenger_id=p.passenger_id;

-- Q126. Display cancelled bookings with passenger and cruise details.
-- ANSWER:
SELECT b.booking_id,p.first_name,p.last_name,c.cruise_name,x.refund_amount FROM Booking b JOIN Passenger p ON b.passenger_id=p.passenger_id JOIN Cruise c ON b.cruise_id=c.cruise_id JOIN Cancellation x ON b.booking_id=x.booking_id;

-- Q127. Display ships with their total number of cabins.
-- ANSWER:
SELECT s.ship_id,s.ship_name,COUNT(c.cabin_id) total_cabins FROM Ship s LEFT JOIN Cabin c ON s.ship_id=c.ship_id GROUP BY s.ship_id,s.ship_name;

-- Q128. Display cruises with their total number of bookings.
-- ANSWER:
SELECT c.cruise_id,c.cruise_name,COUNT(b.booking_id) total_bookings FROM Cruise c LEFT JOIN Booking b ON c.cruise_id=b.cruise_id GROUP BY c.cruise_id,c.cruise_name;

-- Q129. Find passengers who have never booked a cruise using a LEFT JOIN.
-- ANSWER:
SELECT p.* FROM Passenger p LEFT JOIN Booking b ON p.passenger_id=b.passenger_id WHERE b.booking_id IS NULL;

-- Q130. Find cruises that have never received a booking.
-- ANSWER:
SELECT c.* FROM Cruise c LEFT JOIN Booking b ON c.cruise_id=b.cruise_id WHERE b.booking_id IS NULL;

-- Q131. Find ships that have maintenance records but no bookings on cruises using those ships.
-- ANSWER:
SELECT s.* FROM Ship s JOIN Maintenance m ON s.ship_id=m.ship_id WHERE NOT EXISTS(SELECT 1 FROM Booking b JOIN Cabin ca ON b.cabin_id=ca.cabin_id JOIN Cruise c ON b.cruise_id=c.cruise_id WHERE ca.ship_id=s.ship_id);

-- Q132. Find passengers who have both booking and cancellation records.
-- ANSWER:
SELECT DISTINCT p.* FROM Passenger p JOIN Booking b ON p.passenger_id=b.passenger_id JOIN Cancellation c ON b.booking_id=c.booking_id;

-- Q133. Find crew members working on ships whose home port is also a cruise departure port.
-- ANSWER:
SELECT DISTINCT cr.crew_name,s.ship_name,p.port_name FROM Crew cr JOIN Ship s ON cr.ship_id=s.ship_id JOIN Port p ON s.home_port_id=p.port_id JOIN Cruise c ON c.departure_port_id=p.port_id;

-- Q134. Find ports through which at least three different cruises operate.
-- ANSWER:
SELECT p.port_id,p.port_name,COUNT(DISTINCT cs.cruise_id) cruise_count FROM Port p JOIN Cruise_Schedule cs ON p.port_id=cs.port_id GROUP BY p.port_id,p.port_name HAVING COUNT(DISTINCT cs.cruise_id)>=3;

-- Q135. Display the complete booking journey using at least five tables.
-- ANSWER:
SELECT b.booking_id,CONCAT(p.first_name,' ',p.last_name) passenger_name,c.cruise_name,s.ship_name,ca.cabin_number,b.journey_date,b.fare,py.payment_status FROM Booking b JOIN Passenger p ON b.passenger_id=p.passenger_id JOIN Cruise c ON b.cruise_id=c.cruise_id JOIN Cabin ca ON b.cabin_id=ca.cabin_id JOIN Ship s ON ca.ship_id=s.ship_id LEFT JOIN Payment py ON b.booking_id=py.booking_id;

-- ============================================================
-- SECTION J — COMPLEX SUBQUERIES
-- ============================================================

-- Q136. Find crew members whose salary is greater than the overall average salary.
-- ANSWER:
SELECT * FROM Crew WHERE salary>(SELECT AVG(salary) FROM Crew);

-- Q137. Find passengers whose total spending exceeds the average passenger spending.
-- ANSWER:
SELECT p.passenger_id,p.first_name,p.last_name,SUM(b.fare) spending FROM Passenger p
 JOIN Booking b ON p.passenger_id=b.passenger_id
 GROUP BY p.passenger_id,p.first_name,p.last_name
 HAVING SUM(b.fare)>(SELECT AVG(total) 
 FROM(SELECT passenger_id,SUM(fare) total FROM Booking GROUP BY passenger_id)x);

-- Q138. Find cruises whose revenue is higher than the average cruise revenue.
-- ANSWER:
SELECT c.cruise_id,c.cruise_name,SUM(b.fare) revenue FROM Cruise c JOIN Booking b ON c.cruise_id=b.cruise_id GROUP BY c.cruise_id,c.cruise_name HAVING SUM(b.fare)>(SELECT AVG(total) FROM(SELECT cruise_id,SUM(fare) total FROM Booking GROUP BY cruise_id)x);

-- Q139. Find the second-highest crew salary without using LIMIT.
-- ANSWER:
SELECT MAX(salary) second_highest FROM Crew WHERE salary<(SELECT MAX(salary) FROM Crew);

-- Q140. Find the third-highest crew salary.
-- ANSWER:
SELECT MAX(salary) third_highest FROM Crew WHERE salary<(SELECT MAX(salary) FROM Crew WHERE salary<(SELECT MAX(salary) FROM Crew));

-- Q141. Find the passenger who made the most expensive booking.
-- ANSWER:
SELECT p.*,b.fare FROM Passenger p 
JOIN Booking b ON p.passenger_id=b.passenger_id
 WHERE b.fare=(SELECT MAX(fare) FROM Booking);

-- Q142. Find passengers who booked the same cruise as the highest-spending passenger.
-- ANSWER:
SELECT DISTINCT p.* FROM Passenger p JOIN Booking b ON p.passenger_id=b.passenger_id WHERE b.cruise_id=(SELECT cruise_id FROM Booking GROUP BY cruise_id ORDER BY SUM(fare) DESC LIMIT 1);

-- Q143. Find ships whose maintenance expenditure is greater than the average maintenance expenditure.
-- ANSWER:
SELECT s.ship_id,s.ship_name,SUM(m.cost) total_cost FROM Ship s JOIN Maintenance m ON s.ship_id=m.ship_id GROUP BY s.ship_id,s.ship_name HAVING SUM(m.cost)>(SELECT AVG(total) FROM(SELECT ship_id,SUM(cost) total FROM Maintenance GROUP BY ship_id)x);

-- Q144. Find ports having more crew members assigned through their home ships than the average number per port.
-- ANSWER:
SELECT p.port_id,p.port_name,COUNT(cr.crew_id) crew_count FROM Port p JOIN Ship s ON p.port_id=s.home_port_id JOIN Crew cr ON s.ship_id=cr.ship_id GROUP BY p.port_id,p.port_name HAVING COUNT(cr.crew_id)>(SELECT AVG(cnt) FROM(SELECT s.home_port_id,COUNT(cr.crew_id) cnt FROM Ship s LEFT JOIN Crew cr ON s.ship_id=cr.ship_id GROUP BY s.home_port_id)x);

-- Q145. Find bookings whose fare is greater than the average fare for the same cruise.
-- ANSWER:
SELECT * FROM Booking b WHERE fare>(SELECT AVG(fare) FROM Booking b2 WHERE b2.cruise_id=b.cruise_id);

-- Q146. Find passengers whose latest booking fare is greater than their own average fare.
-- ANSWER:
SELECT * FROM Booking b WHERE booking_date=(SELECT MAX(booking_date) 
FROM Booking x WHERE x.passenger_id=b.passenger_id) 
AND fare>(SELECT AVG(fare) FROM Booking x WHERE x.passenger_id=b.passenger_id);

-- Q147. Find the highest-paid crew member in each department.
-- ANSWER:
SELECT * FROM Crew c WHERE salary=(SELECT MAX(salary) FROM Crew x WHERE x.department=c.department);

-- Q148. Find the most expensive booking for each cruise.
-- ANSWER:
SELECT * FROM Booking b WHERE fare=(SELECT MAX(fare) FROM Booking x WHERE x.cruise_id=b.cruise_id);

-- Q149. Find passengers whose number of bookings is greater than the average number of bookings.
-- ANSWER:

SELECT passenger_id,COUNT(*) booking_count FROM Booking
 GROUP BY passenger_id HAVING COUNT(*)>(SELECT AVG(cnt) FROM (SELECT passenger_id,COUNT(*) cnt
 FROM Booking GROUP BY passenger_id)x);

-- Q150. Find cruises that have more bookings than the average cruise.
-- ANSWER:
SELECT cruise_id,COUNT(*) booking_count FROM Booking GROUP BY cruise_id HAVING COUNT(*)>(SELECT AVG(cnt) FROM(SELECT cruise_id,COUNT(*) cnt FROM Booking GROUP BY cruise_id)x);

-- ============================================================
-- SECTION K — EXISTS / NOT EXISTS
-- ============================================================

-- Q151. Find passengers for whom at least one booking exists.
-- ANSWER:
SELECT p.* FROM Passenger p WHERE EXISTS(SELECT 1 FROM Booking b WHERE b.passenger_id=p.passenger_id);

-- Q152. Find passengers for whom no booking exists.
-- ANSWER:
SELECT p.* FROM Passenger p WHERE NOT EXISTS(SELECT 1 FROM Booking b WHERE b.passenger_id=p.passenger_id);

-- Q153. Find cruises for which at least one booking exists.
-- ANSWER:
SELECT c.* FROM Cruise c WHERE EXISTS(SELECT 1 FROM Booking b WHERE b.cruise_id=c.cruise_id);

-- Q154. Find cruises without bookings.
-- ANSWER:
SELECT c.* FROM Cruise c WHERE NOT EXISTS(SELECT 1 FROM Booking b WHERE b.cruise_id=c.cruise_id);

-- Q155. Find ships with at least one maintenance record.
-- ANSWER:
SELECT s.* FROM Ship s WHERE EXISTS(SELECT 1 FROM Maintenance m WHERE m.ship_id=s.ship_id);

-- Q156. Find ships without maintenance records.
-- ANSWER:
SELECT s.* FROM Ship s WHERE NOT EXISTS(SELECT 1 FROM Maintenance m WHERE m.ship_id=s.ship_id);

-- Q157. Find passengers who have both a successful payment and a cancellation.
-- ANSWER:
SELECT p.* FROM Passenger p WHERE EXISTS(SELECT 1 FROM Booking b JOIN Payment py ON b.booking_id=py.booking_id WHERE b.passenger_id=p.passenger_id AND py.payment_status='Successful') AND EXISTS(SELECT 1 FROM Booking b JOIN Cancellation c ON b.booking_id=c.booking_id WHERE b.passenger_id=p.passenger_id);

-- Q158. Find passengers who have bookings but no successful payment.
-- ANSWER:
SELECT p.* FROM Passenger p WHERE EXISTS(SELECT 1 FROM Booking b WHERE b.passenger_id=p.passenger_id) AND NOT EXISTS(SELECT 1 FROM Booking b JOIN Payment py ON b.booking_id=py.booking_id WHERE b.passenger_id=p.passenger_id AND py.payment_status='Successful');

-- Q159. Find ports having ships or crew but no cruise departures.
-- ANSWER:
SELECT p.* FROM Port p WHERE EXISTS(SELECT 1 FROM Ship s WHERE s.home_port_id=p.port_id) AND NOT EXISTS(SELECT 1 FROM Cruise c WHERE c.departure_port_id=p.port_id);

-- Q160. Find cruises having bookings but no maintenance records on their cabins' ships.
-- ANSWER:
SELECT DISTINCT c.* FROM Cruise c WHERE EXISTS(SELECT 1 FROM Booking b WHERE b.cruise_id=c.cruise_id) AND NOT EXISTS(SELECT 1 FROM Booking b JOIN Cabin ca ON b.cabin_id=ca.cabin_id JOIN Maintenance m ON ca.ship_id=m.ship_id WHERE b.cruise_id=c.cruise_id);

-- ============================================================
-- SECTION L — COMPLEX BUSINESS QUERIES
-- ============================================================

-- Q161. Identify passengers who have made at least three bookings and cancelled less than 20% of their bookings.
-- ANSWER:
SELECT passenger_id,COUNT(*) bookings,SUM(booking_status='Cancelled') cancellations,ROUND(100*SUM(booking_status='Cancelled')/COUNT(*),2) cancellation_pct 
FROM Booking GROUP BY passenger_id HAVING COUNT(*)>=3 AND SUM(booking_status='Cancelled')/COUNT(*)<0.20;

-- Q162. Find passengers who have travelled on at least two different cruises and spent more than ₹10,000.
-- ANSWER:
SELECT p.passenger_id,p.first_name,p.last_name,COUNT(DISTINCT b.cruise_id) cruises,SUM(b.fare) spending FROM Passenger p 
JOIN Booking b ON p.passenger_id=b.passenger_id GROUP BY p.passenger_id,p.first_name,p.last_name HAVING COUNT(DISTINCT b.cruise_id)>=2 AND SUM(b.fare)>10000;

-- Q163. Find the five passengers who have spent the most money.
-- ANSWER:
SELECT p.passenger_id,p.first_name,p.last_name,SUM(b.fare) spending FROM Passenger p 
JOIN Booking b ON p.passenger_id=b.passenger_id GROUP BY p.passenger_id,p.first_name,p.last_name ORDER BY spending DESC LIMIT 5;

-- Q164. Find the five cruises generating the highest revenue.
-- ANSWER:
SELECT c.cruise_id,c.cruise_name,SUM(b.fare) revenue FROM Cruise c 
JOIN Booking b ON c.cruise_id=b.cruise_id GROUP BY c.cruise_id,c.cruise_name ORDER BY revenue DESC LIMIT 5;

-- Q165. Find the cruise having the highest average fare among cruises with at least five bookings.
-- ANSWER:
SELECT c.cruise_id,c.cruise_name,AVG(b.fare) avg_fare FROM Cruise c
 JOIN Booking b ON c.cruise_id=b.cruise_id GROUP BY c.cruise_id,c.cruise_name HAVING COUNT(*)>=5 ORDER BY avg_fare DESC LIMIT 1;

-- Q166. Find cruises where confirmed bookings exceed 80% of the ship capacity.
-- ANSWER:
SELECT c.cruise_id,c.cruise_name,COUNT(b.booking_id) confirmed,s.passenger_capacity FROM Cruise c
 JOIN Booking b ON c.cruise_id=b.cruise_id JOIN Cabin ca ON b.cabin_id=ca.cabin_id
 JOIN Ship s ON ca.ship_id=s.ship_id WHERE b.booking_status='Confirmed'
 GROUP BY c.cruise_id,c.cruise_name,s.passenger_capacity HAVING COUNT(b.booking_id)>0.8*s.passenger_capacity;

-- Q167. Find cruises where maintenance expenditure is greater than 25% of booking revenue.
-- ANSWER:
SELECT c.cruise_id,c.cruise_name,SUM(b.fare) revenue,SUM(DISTINCT m.cost) maintenance FROM 
Cruise c JOIN Booking b ON c.cruise_id=b.cruise_id 
JOIN Cabin ca ON b.cabin_id=ca.cabin_id 
JOIN Maintenance m ON ca.ship_id=m.ship_id GROUP BY c.cruise_id,c.cruise_name HAVING SUM(DISTINCT m.cost)>0.25*SUM(b.fare);

-- Q168. Find the port having the highest number of cruise arrivals.
-- ANSWER:
SELECT p.port_id,p.port_name,COUNT(*) arrivals FROM Port p 
JOIN Cruise c ON p.port_id=c.arrival_port_id GROUP BY p.port_id,p.port_name ORDER BY arrivals DESC LIMIT 1;

-- Q169. Find passengers who have travelled using both Premium/Luxury and Standard classes.
-- ANSWER:
SELECT p.passenger_id,p.first_name,p.last_name FROM Passenger p 
JOIN Booking b ON p.passenger_id=b.passenger_id
 GROUP BY p.passenger_id,p.first_name,p.last_name
 HAVING SUM(b.travel_class='Standard')>0 AND SUM(b.travel_class IN('Premium','Luxury'))>0;

-- Q170. Find passengers who have used at least three different payment methods.
-- ANSWER:
SELECT p.passenger_id,p.first_name,p.last_name,COUNT(DISTINCT py.payment_method) methods
 FROM Passenger p JOIN Booking b ON p.passenger_id=b.passenger_id 
 JOIN Payment py ON b.booking_id=py.booking_id GROUP BY p.passenger_id,p.first_name,p.last_name
 HAVING COUNT(DISTINCT py.payment_method)>=3;

-- Q171. Find the most popular cruise based on number of unique passengers.
-- ANSWER:
SELECT c.cruise_id,c.cruise_name,COUNT(DISTINCT b.passenger_id) passengers
 FROM Cruise c JOIN Booking b ON c.cruise_id=b.cruise_id 
 GROUP BY c.cruise_id,c.cruise_name ORDER BY passengers DESC LIMIT 1;

-- Q172. Find the least popular active cruise.
-- ANSWER:
SELECT c.cruise_id,c.cruise_name,COUNT(DISTINCT b.passenger_id) passengers 
FROM Cruise c LEFT JOIN Booking b ON c.cruise_id=b.cruise_id 
WHERE c.status IN('Active','Scheduled') GROUP BY c.cruise_id,c.cruise_name ORDER BY passengers LIMIT 1;

-- Q173. Find the most frequently used travel class.
-- ANSWER:
SELECT travel_class,COUNT(*) usage_count FROM Booking GROUP BY travel_class ORDER BY usage_count DESC LIMIT 1;

-- Q174. Find the cruise with the highest cancellation percentage.
-- ANSWER:
SELECT c.cruise_id,c.cruise_name,ROUND(100*SUM(b.booking_status='Cancelled')/COUNT(*),2) cancellation_pct
FROM Cruise c JOIN Booking b ON c.cruise_id=b.cruise_id GROUP BY c.cruise_id,c.cruise_name ORDER BY cancellation_pct DESC LIMIT 1;

-- Q175. Find passengers whose cancellation percentage is below the overall average cancellation percentage.
-- ANSWER:
SELECT p.passenger_id,ROUND(100*SUM(b.booking_status='Cancelled')/COUNT(*),2) cancellation_pct
FROM Passenger p JOIN Booking b ON p.passenger_id=b.passenger_id 
GROUP BY p.passenger_id HAVING cancellation_pct<(SELECT 100*SUM(booking_status='Cancelled')/COUNT(*) FROM Booking);

-- ============================================================
-- SECTION M — WINDOW FUNCTIONS
-- ============================================================

-- Q176. Rank crew members according to salary.
-- ANSWER:
SELECT crew_id,crew_name,salary,RANK() OVER(ORDER BY salary DESC) salary_rank FROM Crew;

-- Q177. Rank crew members separately within each department.
-- ANSWER:
SELECT crew_id,crew_name,department,salary,RANK() OVER(PARTITION BY department ORDER BY salary DESC) dept_rank FROM Crew;

-- Q178. Display the top two highest-paid crew members from every department.
-- ANSWER:
SELECT * FROM(SELECT crew_id,crew_name,department,salary,ROW_NUMBER() OVER(PARTITION BY department ORDER BY salary DESC) rn FROM Crew)x WHERE rn<=2;

-- Q179. Rank cruises based on total revenue.
-- ANSWER:
SELECT cruise_id,cruise_name,revenue,RANK() OVER(ORDER BY revenue DESC) revenue_rank 
FROM(SELECT c.cruise_id,c.cruise_name,SUM(b.fare) revenue 
FROM Cruise c LEFT JOIN Booking b ON c.cruise_id=b.cruise_id GROUP BY c.cruise_id,c.cruise_name)x;

-- Q180. Rank passengers according to total spending.
-- ANSWER:
SELECT passenger_id,first_name,last_name,total_spending,RANK() OVER(ORDER BY total_spending DESC) spending_rank
FROM(SELECT p.passenger_id,p.first_name,p.last_name,SUM(b.fare) total_spending 
FROM Passenger p JOIN Booking b ON p.passenger_id=b.passenger_id GROUP BY p.passenger_id,p.first_name,p.last_name)x;

-- Q181. Calculate cumulative revenue ordered by journey date.
-- ANSWER:
SELECT journey_date,fare,SUM(fare) OVER(ORDER BY journey_date,booking_id) cumulative_revenue FROM Booking;

-- Q182. Calculate cumulative revenue separately for each cruise.
-- ANSWER:
SELECT cruise_id,journey_date,fare,SUM(fare) OVER(PARTITION BY cruise_id 
ORDER BY journey_date,booking_id) cumulative_revenue FROM Booking;

-- Q183. Use LAG() to display the previous journey date for every passenger.
-- ANSWER:
SELECT passenger_id,journey_date,LAG(journey_date) OVER(PARTITION BY passenger_id ORDER BY journey_date,booking_id) previous_journey FROM Booking;

-- Q184. Calculate the number of days between consecutive journeys of each passenger.
-- ANSWER:
SELECT passenger_id,journey_date,DATEDIFF(journey_date,LAG(journey_date) OVER(PARTITION BY passenger_id ORDER BY journey_date,booking_id)) days_since_previous FROM Booking;

-- Q185. Use LEAD() to display the next journey date.
-- ANSWER:
SELECT passenger_id,journey_date,LEAD(journey_date) OVER(PARTITION BY passenger_id ORDER BY journey_date,booking_id) next_journey FROM Booking;

-- Q186. Find the highest-fare booking for every cruise using ROW_NUMBER().
-- ANSWER:
SELECT * FROM(SELECT b.*,ROW_NUMBER() OVER(PARTITION BY cruise_id ORDER BY fare DESC) rn FROM Booking b)x WHERE rn=1;

-- Q187. Find the second-highest booking fare for every cruise.
-- ANSWER:
SELECT * FROM(SELECT b.*,DENSE_RANK() OVER(PARTITION BY cruise_id ORDER BY fare DESC) rnk FROM Booking b)x WHERE rnk=2;

-- Q188. Find the top three passengers from every city using RANK().
-- ANSWER:
SELECT * FROM(SELECT p.city,p.passenger_id,p.first_name,p.last_name,SUM(b.fare) spending,RANK() OVER(PARTITION BY p.city 
ORDER BY SUM(b.fare) DESC) rnk FROM Passenger p 
JOIN Booking b ON p.passenger_id=b.passenger_id GROUP BY p.city,p.passenger_id,p.first_name,p.last_name)x WHERE rnk<=3;

-- Q189. Compare each crew member's salary with the average salary of their department.
-- ANSWER:
SELECT crew_id,crew_name,department,salary,AVG(salary) OVER(PARTITION BY department) dept_avg,salary-AVG(salary) OVER(PARTITION BY department) difference FROM Crew;

-- Q190. Calculate each cruise's percentage contribution to total revenue.
-- ANSWER:
SELECT cruise_id,cruise_name,revenue,ROUND(100*revenue/SUM(revenue) OVER(),2) contribution_pct 
FROM(SELECT c.cruise_id,c.cruise_name,SUM(b.fare) revenue 
FROM Cruise c LEFT JOIN Booking b ON c.cruise_id=b.cruise_id GROUP BY c.cruise_id,c.cruise_name)x;

-- Q191. Find passengers belonging to the top 10% of spenders.
-- ANSWER:
WITH ranked AS(SELECT passenger_id,total_spending,NTILE(10) OVER(ORDER BY total_spending DESC) bucket 
FROM(SELECT passenger_id,SUM(fare) total_spending FROM Booking GROUP BY passenger_id)x) SELECT * FROM ranked WHERE bucket=1;

-- Q192. Find cruises whose revenue increased compared with the previous month.
-- ANSWER:
WITH m AS(SELECT DATE_FORMAT(journey_date,'%Y-%m') month,cruise_id,SUM(fare) revenue 
FROM Booking GROUP BY DATE_FORMAT(journey_date,'%Y-%m'),cruise_id) 
SELECT * FROM(SELECT *,LAG(revenue) OVER(PARTITION BY cruise_id ORDER BY month) prev FROM m)x WHERE revenue>prev;

-- Q193. Calculate month-over-month revenue growth.
-- ANSWER:
WITH m AS(SELECT DATE_FORMAT(journey_date,'%Y-%m') month,SUM(fare) revenue 
FROM Booking GROUP BY DATE_FORMAT(journey_date,'%Y-%m')) SELECT month,revenue,LAG(revenue) 
OVER(ORDER BY month) prev,ROUND(100*(revenue-LAG(revenue) OVER(ORDER BY month))/NULLIF(LAG(revenue) OVER(ORDER BY month),0),2) growth_pct FROM m;

-- Q194. Find passengers whose spending increased with every subsequent booking.
-- ANSWER:
WITH x AS(SELECT passenger_id,fare,LAG(fare) OVER(PARTITION BY passenger_id 
ORDER BY booking_date,booking_id) prev FROM Booking) SELECT passenger_id FROM x GROUP BY passenger_id 
HAVING SUM(prev IS NOT NULL AND fare<=prev)=0;

-- Q195. Find passengers whose booking fare decreased with every subsequent journey.
-- ANSWER:
WITH x AS(SELECT passenger_id,fare,LAG(fare) 
OVER(PARTITION BY passenger_id ORDER BY journey_date,booking_id) prev FROM Booking) 
SELECT passenger_id FROM x GROUP BY passenger_id HAVING SUM(prev IS NOT NULL AND fare>=prev)=0;

-- ============================================================
-- SECTION N — CTE
-- ============================================================

-- Q196. Create a CTE containing total revenue by cruise.
-- ANSWER:
WITH cruise_revenue AS(SELECT cruise_id,SUM(fare) total_revenue FROM Booking GROUP BY cruise_id) SELECT * FROM cruise_revenue;

-- Q197. Use a CTE to find cruises whose revenue exceeds average cruise revenue.
-- ANSWER:
WITH cruise_revenue AS(SELECT cruise_id,SUM(fare) revenue 
FROM Booking GROUP BY cruise_id) SELECT * FROM cruise_revenue WHERE revenue>(SELECT AVG(revenue) FROM cruise_revenue);

-- Q198. Use a CTE to calculate passenger-wise spending.
-- ANSWER:
WITH passenger_spend AS(SELECT passenger_id,SUM(fare) total_spending FROM Booking GROUP BY passenger_id) SELECT * FROM passenger_spend;

-- Q199. Use a CTE to find the top five passengers by spending.
-- ANSWER:
WITH passenger_spend AS(SELECT passenger_id,SUM(fare) total_spending FROM Booking GROUP BY passenger_id) SELECT * FROM passenger_spend ORDER BY total_spending DESC LIMIT 5;

-- Q200. Use two CTEs to compare booking revenue and maintenance expenditure.
-- ANSWER:
WITH revenue AS(SELECT cruise_id,SUM(fare) revenue 
FROM Booking GROUP BY cruise_id), maintenance AS(SELECT ship_id,SUM(cost) maintenance
FROM Maintenance GROUP BY ship_id) SELECT * FROM revenue CROSS JOIN maintenance;

-- Q201. Use a CTE with a window function to rank cruises.
-- ANSWER:
WITH revenue AS(SELECT cruise_id,SUM(fare) total_revenue FROM Booking GROUP BY cruise_id) SELECT *,RANK() OVER(ORDER BY total_revenue DESC) revenue_rank FROM revenue;

-- Q202. Use a CTE to calculate monthly revenue.
-- ANSWER:
WITH monthly AS(SELECT DATE_FORMAT(journey_date,'%Y-%m') month,SUM(fare) revenue 
FROM Booking GROUP BY DATE_FORMAT(journey_date,'%Y-%m')) SELECT * FROM monthly ORDER BY month;

-- Q203. Use LAG() with a CTE to calculate month-over-month revenue growth.
-- ANSWER:
WITH monthly AS(SELECT DATE_FORMAT(journey_date,'%Y-%m') month,SUM(fare) revenue 
FROM Booking GROUP BY DATE_FORMAT(journey_date,'%Y-%m')),growth AS(SELECT month,revenue,LAG(revenue) OVER(ORDER BY month) prev FROM monthly) 
SELECT month,revenue,prev,ROUND(100*(revenue-prev)/NULLIF(prev,0),2) growth_pct FROM growth;

-- Q204. Create a recursive CTE to generate sequence numbers.
-- ANSWER:
WITH RECURSIVE numbers AS(SELECT 1 n UNION ALL SELECT n+1 FROM numbers WHERE n<10) SELECT * FROM numbers;

-- Q205. Use a CTE to identify passengers having more than three bookings.
-- ANSWER:
WITH booking_counts AS(SELECT passenger_id,COUNT(*) booking_count FROM Booking GROUP BY passenger_id) SELECT * FROM booking_counts WHERE booking_count>3;

-- ============================================================
-- SECTION O — VIEWS
-- ============================================================

-- Q206. Create a view containing passenger booking information.
-- ANSWER:
CREATE OR REPLACE VIEW vw_passenger_booking 
AS SELECT b.booking_id,p.passenger_id,CONCAT(p.first_name,' ',p.last_name) passenger_name,b.cruise_id,b.journey_date,
b.travel_class,b.fare,b.booking_status,b.payment_status FROM Passenger p JOIN Booking b ON p.passenger_id=b.passenger_id;

-- Q207. Create a view containing cruise revenue information.
-- ANSWER:
CREATE OR REPLACE VIEW vw_cruise_revenue AS SELECT c.cruise_id,c.cruise_name,COALESCE(SUM(b.fare),0) total_revenue 
FROM Cruise c LEFT JOIN Booking b ON c.cruise_id=b.cruise_id GROUP BY c.cruise_id,c.cruise_name;

-- Q208. Create a view showing passenger travel history.
-- ANSWER:
CREATE OR REPLACE VIEW vw_passenger_travel_history 
AS SELECT p.passenger_id,CONCAT(p.first_name,' ',p.last_name) passenger_name,c.cruise_name,b.journey_date,b.travel_class,b.fare 
FROM Passenger p JOIN Booking b ON p.passenger_id=b.passenger_id JOIN Cruise c ON b.cruise_id=c.cruise_id;

-- Q209. Create a view showing active ships.
-- ANSWER:
CREATE OR REPLACE VIEW vw_active_ships AS SELECT * FROM Ship WHERE status='Active';

-- Q210. Create a view showing cancelled bookings.
-- ANSWER:
CREATE OR REPLACE VIEW vw_cancelled_bookings AS SELECT b.*,c.refund_amount,c.cancellation_date FROM Booking b JOIN Cancellation c ON b.booking_id=c.booking_id;

-- Q211. Create a view showing successful payments.
-- ANSWER:
CREATE OR REPLACE VIEW vw_successful_payments AS SELECT * FROM Payment WHERE payment_status='Successful';

-- Q212. Create a view showing ship maintenance expenditure.
-- ANSWER:
CREATE OR REPLACE VIEW vw_ship_maintenance 
AS SELECT s.ship_id,s.ship_name,COALESCE(SUM(m.cost),0) maintenance_expenditure 
FROM Ship s LEFT JOIN Maintenance m ON s.ship_id=m.ship_id GROUP BY s.ship_id,s.ship_name;

-- Q213. Create a view showing crew members and their ships.
-- ANSWER:
CREATE OR REPLACE VIEW vw_crew_ships AS SELECT cr.crew_id,cr.crew_name,cr.department,s.ship_name FROM Crew cr LEFT JOIN Ship s ON cr.ship_id=s.ship_id;

-- Q214. Create a view showing top-performing cruises.
-- ANSWER:
CREATE OR REPLACE VIEW vw_top_cruises AS SELECT c.cruise_id,c.cruise_name,SUM(b.fare) revenue 
FROM Cruise c JOIN Booking b ON c.cruise_id=b.cruise_id GROUP BY c.cruise_id,c.cruise_name ORDER BY revenue DESC LIMIT 5;

-- Q215. Create a view showing high-value passengers.
-- ANSWER:
CREATE OR REPLACE VIEW vw_high_value_passengers AS SELECT p.passenger_id,CONCAT(p.first_name,' ',p.last_name) passenger_name,SUM(b.fare) total_spending 
FROM Passenger p JOIN Booking b ON p.passenger_id=b.passenger_id GROUP BY p.passenger_id,p.first_name,p.last_name HAVING SUM(b.fare)>10000;

-- ============================================================
-- SECTION P — STORED PROCEDURES & FUNCTIONS
-- ============================================================

-- Q216. Create a stored procedure that accepts a passenger ID and displays complete booking history.
-- ANSWER:
DELIMITER //
CREATE PROCEDURE get_passenger_booking_history(IN p_id INT)
BEGIN
 SELECT p.passenger_id,CONCAT(p.first_name,' ',p.last_name) passenger_name,b.booking_id,c.cruise_name,b.journey_date,b.fare,b.booking_status FROM Passenger p JOIN Booking b ON p.passenger_id=b.passenger_id JOIN Cruise c ON b.cruise_id=c.cruise_id WHERE p.passenger_id=p_id;
END //
DELIMITER ;

-- Q217. Create a stored procedure that accepts a cruise ID and displays its revenue, bookings and cancellations.
-- ANSWER:
DELIMITER //
CREATE PROCEDURE get_cruise_summary(IN p_id INT)
BEGIN
 SELECT c.cruise_id,c.cruise_name,COUNT(b.booking_id) bookings,COALESCE(SUM(b.fare),0) revenue,SUM(b.booking_status='Cancelled') cancellations FROM Cruise c LEFT JOIN Booking b ON c.cruise_id=b.cruise_id WHERE c.cruise_id=p_id GROUP BY c.cruise_id,c.cruise_name;
END //
DELIMITER ;

-- Q218. Create a procedure that accepts departure and arrival port IDs and returns matching cruises.
-- ANSWER:
DELIMITER //
CREATE PROCEDURE get_cruises_by_ports(IN p_departure INT,IN p_arrival INT)
BEGIN SELECT * FROM Cruise WHERE departure_port_id=p_departure AND arrival_port_id=p_arrival; END //
DELIMITER ;

-- Q219. Create a procedure that accepts a date range and returns total booking revenue.
-- ANSWER:
DELIMITER //
CREATE PROCEDURE get_revenue_by_date(IN p_start DATE,IN p_end DATE)
BEGIN SELECT SUM(fare) total_revenue FROM Booking WHERE journey_date BETWEEN p_start AND p_end; END //
DELIMITER ;

-- Q220. Create a procedure to cancel a booking and calculate its refund.
-- ANSWER:
DELIMITER //
CREATE PROCEDURE cancel_booking(IN p_booking INT)
BEGIN DECLARE v_fare DECIMAL(10,2); SELECT fare INTO v_fare FROM Booking WHERE booking_id=p_booking; UPDATE Booking SET booking_status='Cancelled' WHERE booking_id=p_booking; INSERT INTO Cancellation(booking_id,reason,refund_amount) VALUES(p_booking,'Customer request',v_fare*0.70); END //
DELIMITER ;

-- Q221. Create a procedure that returns the top N passengers by spending.
-- ANSWER:
DELIMITER //
CREATE PROCEDURE top_n_passengers(IN p_n INT)
BEGIN SET @q=CONCAT('SELECT passenger_id,SUM(fare) total_spending FROM Booking GROUP BY passenger_id ORDER BY total_spending DESC LIMIT ',p_n); PREPARE s FROM @q; EXECUTE s; DEALLOCATE PREPARE s; END //
DELIMITER ;

-- Q222. Create a function to calculate passenger age.
-- ANSWER:
DELIMITER //
CREATE FUNCTION passenger_age(p_dob DATE) RETURNS INT DETERMINISTIC RETURN TIMESTAMPDIFF(YEAR,p_dob,CURDATE()) //
DELIMITER ;

-- Q223. Create a function to calculate GST on cruise fare.
-- ANSWER:
DELIMITER //
CREATE FUNCTION calculate_gst(p_fare DECIMAL(10,2)) RETURNS DECIMAL(10,2) DETERMINISTIC RETURN ROUND(p_fare*0.18,2) //
DELIMITER ;

-- Q224. Create a function to calculate refund based on cancellation timing.
-- ANSWER:
DELIMITER //
CREATE FUNCTION calculate_refund(p_fare DECIMAL(10,2),p_days_before INT) RETURNS DECIMAL(10,2) DETERMINISTIC BEGIN IF p_days_before>=30 THEN RETURN p_fare*0.90; ELSEIF p_days_before>=15 THEN RETURN p_fare*0.70; ELSE RETURN p_fare*0.50; END IF; END //
DELIMITER ;

-- Q225. Create a function that categorizes passengers as Regular, Frequent or VIP.
-- ANSWER:
DELIMITER //
CREATE FUNCTION passenger_category(p_count INT) RETURNS VARCHAR(20) DETERMINISTIC BEGIN IF p_count>=10 THEN RETURN 'VIP'; ELSEIF p_count>=5 THEN RETURN 'Frequent'; ELSE RETURN 'Regular'; END IF; END //
DELIMITER ;

-- ============================================================
-- SECTION Q — TRIGGERS
-- ============================================================

-- Q226. Create a trigger that prevents negative booking fares.
-- ANSWER:
DELIMITER //
CREATE TRIGGER trg_booking_fare BEFORE INSERT ON Booking FOR EACH ROW BEGIN IF NEW.fare<0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Booking fare cannot be negative'; END IF; END //
DELIMITER ;

-- Q227. Create a trigger that prevents cancellation after the journey date.
-- ANSWER:
DELIMITER //
CREATE TRIGGER trg_before_cancellation BEFORE INSERT ON Cancellation FOR EACH ROW BEGIN IF NEW.cancellation_date>(SELECT journey_date FROM Booking WHERE booking_id=NEW.booking_id) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Cancellation cannot be after journey date'; END IF; END //
DELIMITER ;

-- Q228. Create a trigger that automatically changes booking status to Cancelled when a cancellation is recorded.
-- ANSWER:
DELIMITER //
CREATE TRIGGER trg_after_cancellation AFTER INSERT ON Cancellation FOR EACH ROW BEGIN UPDATE Booking SET booking_status='Cancelled' WHERE booking_id=NEW.booking_id; END //
DELIMITER ;

-- Q229. Create a trigger that calculates refund amount when a booking is cancelled.
-- ANSWER:
DELIMITER //
CREATE TRIGGER trg_calculate_refund BEFORE INSERT ON Cancellation FOR EACH ROW BEGIN IF NEW.refund_amount IS NULL THEN SET NEW.refund_amount=(SELECT fare*0.70 FROM Booking WHERE booking_id=NEW.booking_id); END IF; END //
DELIMITER ;

-- Q230. Create a trigger that records old and new booking fares in an audit table.
-- ANSWER:
CREATE TABLE IF NOT EXISTS Booking_Fare_Audit(audit_id INT PRIMARY KEY AUTO_INCREMENT,booking_id INT,old_fare DECIMAL(10,2),new_fare DECIMAL(10,2),changed_at DATETIME DEFAULT CURRENT_TIMESTAMP);
DELIMITER //
CREATE TRIGGER trg_booking_fare_audit AFTER UPDATE ON Booking FOR EACH ROW BEGIN IF OLD.fare<>NEW.fare THEN INSERT INTO Booking_Fare_Audit(booking_id,old_fare,new_fare) VALUES(OLD.booking_id,OLD.fare,NEW.fare); END IF; END //
DELIMITER ;

-- Q231. Create a trigger that records crew salary changes.
-- ANSWER:
CREATE TABLE IF NOT EXISTS Crew_Salary_Audit(audit_id INT PRIMARY KEY AUTO_INCREMENT,crew_id INT,old_salary DECIMAL(12,2),new_salary DECIMAL(12,2),changed_at DATETIME DEFAULT CURRENT_TIMESTAMP);
DELIMITER //
CREATE TRIGGER trg_crew_salary_audit AFTER UPDATE ON Crew FOR EACH ROW BEGIN IF OLD.salary<>NEW.salary THEN INSERT INTO Crew_Salary_Audit(crew_id,old_salary,new_salary) VALUES(OLD.crew_id,OLD.salary,NEW.salary); END IF; END //
DELIMITER ;

-- Q232. Create a trigger that prevents deletion of a passenger who has completed a journey.
-- ANSWER:
DELIMITER //
CREATE TRIGGER trg_prevent_completed_delete BEFORE DELETE ON Passenger FOR EACH ROW BEGIN IF EXISTS(SELECT 1 FROM Booking WHERE passenger_id=OLD.passenger_id AND booking_status='Completed') THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Passenger has completed a cruise'; END IF; END //
DELIMITER ;

-- Q233. Create a trigger that automatically updates booking payment status after a successful payment.
-- ANSWER:
DELIMITER //
CREATE TRIGGER trg_payment_success AFTER INSERT ON Payment FOR EACH ROW BEGIN IF NEW.payment_status='Successful' THEN UPDATE Booking SET payment_status='Successful' WHERE booking_id=NEW.booking_id; END IF; END //
DELIMITER ;

-- Q234. Create a trigger that marks a ship for maintenance when its maintenance due date has passed.
-- ANSWER:
DELIMITER //
CREATE TRIGGER trg_maintenance_due BEFORE INSERT ON Maintenance FOR EACH ROW BEGIN IF NEW.next_due_date<CURDATE() THEN SET NEW.maintenance_status='Due'; END IF; END //
DELIMITER ;

-- Q235. Display all triggers created in the database.
-- ANSWER:
SHOW TRIGGERS;

-- ============================================================
-- SECTION R — TRANSACTIONS
-- ============================================================

-- Q236. Start a transaction for creating a booking.
-- ANSWER:
START TRANSACTION;

-- Q237. Insert a booking and corresponding payment within one transaction.
-- ANSWER:
START TRANSACTION; INSERT INTO Booking(passenger_id,cruise_id,cabin_id,journey_date,travel_class,fare) VALUES
(1,1,1,'2026-10-01','Standard',2500); SET @b=LAST_INSERT_ID();
 INSERT INTO Payment(booking_id,amount,payment_method,transaction_reference,payment_status) VALUES(@b,2500,'UPI','TXN_NEW_001','Successful');

-- Q238. Commit the transaction after successful payment.
-- ANSWER:
COMMIT;

-- Q239. Rollback the transaction if payment fails.
-- ANSWER:
START TRANSACTION; -- perform booking/payment; use ROLLBACK if payment fails.
ROLLBACK;

-- Q240. Use a SAVEPOINT between booking creation and payment creation.
-- ANSWER:
START TRANSACTION; INSERT INTO Booking(passenger_id,cruise_id,cabin_id,journey_date,travel_class,fare) VALUES
(1,1,1,'2026-10-01','Standard',2500); 
SAVEPOINT booking_created;

-- Q241. Rollback to the SAVEPOINT when payment insertion fails.
-- ANSWER:
ROLLBACK TO SAVEPOINT booking_created;

-- Q242. Demonstrate the difference between COMMIT and ROLLBACK.
-- ANSWER:
-- COMMIT permanently saves the transaction; ROLLBACK undoes uncommitted changes.

-- ============================================================
-- SECTION S — ADVANCED INTEGRATED PROBLEMS
-- ============================================================

-- Q243. Find the top three passengers in every city based on total spending. Display passenger name, city, number of bookings, total spending and rank.
-- ANSWER:
SELECT * FROM(SELECT p.city,p.passenger_id,CONCAT(p.first_name,' ',p.last_name) passenger_name,COUNT(b.booking_id) bookings,SUM(b.fare) spending,RANK() 
OVER(PARTITION BY p.city ORDER BY SUM(b.fare) DESC) rnk FROM Passenger p 
JOIN Booking b ON p.passenger_id=b.passenger_id GROUP BY p.city,p.passenger_id,p.first_name,p.last_name)x WHERE rnk<=3;

-- Q244. For every cruise, calculate total bookings, confirmed bookings, cancelled bookings, total revenue, average fare, maintenance expenditure, profit and occupancy percentage.
-- ANSWER:
SELECT c.cruise_id,c.cruise_name,COUNT(b.booking_id) total_bookings,SUM(b.booking_status='Confirmed') 
confirmed,SUM(b.booking_status='Cancelled') cancelled,SUM(b.fare) revenue,AVG(b.fare) avg_fare FROM Cruise c 
LEFT JOIN Booking b ON c.cruise_id=b.cruise_id GROUP BY c.cruise_id,c.cruise_name;

-- Q245. Identify the most profitable cruise after subtracting maintenance expenditure from booking revenue.
-- ANSWER:
SELECT c.cruise_id,c.cruise_name,SUM(b.fare)-COALESCE(SUM(DISTINCT m.cost),0) profit FROM Cruise c 
JOIN Booking b ON c.cruise_id=b.cruise_id 
JOIN Cabin ca ON b.cabin_id=ca.cabin_id LEFT JOIN Maintenance m ON ca.ship_id=m.ship_id 
GROUP BY c.cruise_id,c.cruise_name ORDER BY profit DESC LIMIT 1;

-- Q246. Find cruises where occupancy is above 80% but revenue is below the average cruise revenue.
-- ANSWER:
WITH x AS(SELECT c.cruise_id,c.cruise_name,COUNT(b.booking_id) confirmed,SUM(b.fare) revenue 
FROM Cruise c JOIN Booking b ON c.cruise_id=b.cruise_id WHERE b.booking_status='Confirmed' 
GROUP BY c.cruise_id,c.cruise_name) SELECT * FROM x WHERE revenue<(SELECT AVG(revenue) FROM x);

-- Q247. Find passengers who have made at least three journeys, have a cancellation rate below the average cancellation rate and have spending above the average passenger spending.
-- ANSWER:
WITH x AS(SELECT passenger_id,COUNT(*) journeys,SUM(booking_status='Cancelled') cancelled,SUM(fare) spending FROM Booking GROUP BY passenger_id) 
SELECT * FROM x WHERE journeys>=3 AND cancelled/journeys<(SELECT AVG(cancelled/journeys) FROM x) AND spending>(SELECT AVG(spending) FROM x);

-- Q248. Find the highest-revenue cruise for every month.
-- ANSWER:
WITH m AS(SELECT DATE_FORMAT(journey_date,'%Y-%m') month,cruise_id,SUM(fare) revenue 
FROM Booking GROUP BY DATE_FORMAT(journey_date,'%Y-%m'),cruise_id) SELECT * FROM(SELECT *,RANK() OVER(PARTITION BY month ORDER BY revenue DESC) rnk FROM m)x WHERE rnk=1;

-- Q249. Find the highest-paid crew member in every department and show the difference between their salary and departmental average salary.
-- ANSWER:
SELECT * FROM(SELECT crew_id,crew_name,department,salary,AVG(salary) 
OVER(PARTITION BY department) dept_avg,RANK() OVER(PARTITION BY department ORDER BY salary DESC) rnk FROM Crew)x WHERE rnk=1;

-- Q250. Find passengers whose latest journey was more expensive than their first journey.
-- ANSWER:
WITH x AS(SELECT passenger_id,fare,ROW_NUMBER() OVER(PARTITION BY passenger_id 
ORDER BY journey_date,booking_id) first_rn,ROW_NUMBER() OVER(PARTITION BY passenger_id 
ORDER BY journey_date DESC,booking_id DESC) last_rn FROM Booking) SELECT passenger_id 
FROM x GROUP BY passenger_id HAVING MAX(CASE WHEN first_rn=1 THEN fare END)<MAX(CASE WHEN last_rn=1 THEN fare END);

-- Q251. Find passengers whose first booking was made at least 30 days before their first journey.
-- ANSWER:
SELECT passenger_id,MIN(booking_date) first_booking,MIN(journey_date) first_journey 
FROM Booking GROUP BY passenger_id HAVING DATEDIFF(MIN(journey_date),MIN(booking_date))>=30;

-- Q252. Find cruises whose revenue increased for at least three consecutive months.
-- ANSWER:
WITH m AS(SELECT cruise_id,DATE_FORMAT(journey_date,'%Y-%m') month,SUM(fare) revenue FROM Booking GROUP BY cruise_id,DATE_FORMAT(journey_date,'%Y-%m')),x 
AS(SELECT *,LAG(revenue) 
OVER(PARTITION BY cruise_id ORDER BY month) prev1,LAG(revenue,2) 
OVER(PARTITION BY cruise_id ORDER BY month) prev2 FROM m) SELECT DISTINCT cruise_id FROM x WHERE revenue>prev1 AND prev1>prev2;

-- Q253. Find the longest gap between two journeys made by the same passenger.
-- ANSWER:
WITH x AS(SELECT passenger_id,journey_date,LAG(journey_date) 
OVER(PARTITION BY passenger_id ORDER BY journey_date) prev FROM Booking) 
SELECT passenger_id,MAX(DATEDIFF(journey_date,prev)) longest_gap FROM x GROUP BY passenger_id ORDER BY longest_gap DESC LIMIT 1;

-- Q254. Find the passenger who has travelled on the greatest number of distinct cruise types.
-- ANSWER:
SELECT p.passenger_id,p.first_name,p.last_name,COUNT(DISTINCT c.cruise_type) types 
FROM Passenger p JOIN Booking b ON p.passenger_id=b.passenger_id 
JOIN Cruise c ON b.cruise_id=c.cruise_id GROUP BY p.passenger_id,p.first_name,p.last_name ORDER BY types DESC LIMIT 1;

-- Q255. Find the port with the highest ratio of cruise arrivals to number of crew members assigned through home ships.
-- ANSWER:
SELECT p.port_id,p.port_name,COUNT(DISTINCT c.cruise_id)/NULLIF(COUNT(DISTINCT cr.crew_id),0) ratio 
FROM Port p LEFT JOIN Cruise c ON p.port_id=c.arrival_port_id LEFT JOIN Ship s ON p.port_id=s.home_port_id LEFT JOIN Crew cr ON s.ship_id=cr.ship_id 
GROUP BY p.port_id,p.port_name ORDER BY ratio DESC LIMIT 1;

-- Q256. Find the cruise with the highest revenue per confirmed passenger.
-- ANSWER:
SELECT c.cruise_id,c.cruise_name,SUM(b.fare)/NULLIF(SUM(b.booking_status='Confirmed'),0) revenue_per_confirmed 
FROM Cruise c JOIN Booking b ON c.cruise_id=b.cruise_id GROUP BY c.cruise_id,c.cruise_name ORDER BY revenue_per_confirmed DESC LIMIT 1;

-- Q257. Find passengers who have travelled on the same cruise more than three times but have never used the same cabin twice.
-- ANSWER:
SELECT passenger_id,cruise_id,COUNT(*) bookings,COUNT(DISTINCT cabin_id) cabins_used 
FROM Booking GROUP BY passenger_id,cruise_id HAVING COUNT(*)>3 AND COUNT(*)=COUNT(DISTINCT cabin_id);

-- Q258. Find the most expensive booking for every passenger and determine whether that booking was cancelled.
-- ANSWER:
SELECT * FROM(SELECT b.*,RANK() OVER(PARTITION BY passenger_id ORDER BY fare DESC) rnk FROM Booking b)x WHERE rnk=1;

-- Q259. Calculate the percentage contribution of every passenger to total cruise revenue.
-- ANSWER:
SELECT p.passenger_id,CONCAT(p.first_name,' ',p.last_name) passenger_name,SUM(b.fare) spending,ROUND(100*SUM(b.fare)/(SELECT SUM(fare) 
FROM Booking),2) contribution_pct FROM Passenger p JOIN Booking b ON p.passenger_id=b.passenger_id 
GROUP BY p.passenger_id,p.first_name,p.last_name;

-- Q260. Create a complete Cruise Line Management Performance Report containing total passengers, total ships, total bookings, confirmed bookings, cancelled bookings, total revenue, refund amount, average fare, top-performing cruise, top passenger, highest-revenue port, total maintenance expenditure and net revenue.
-- ANSWER:
SELECT (SELECT COUNT(*) FROM Passenger) total_passengers,(SELECT COUNT(*) FROM Ship) total_ships,(SELECT COUNT(*) FROM Booking) total_bookings,(SELECT COUNT(*) 
FROM Booking WHERE booking_status='Confirmed') confirmed_bookings,(SELECT COUNT(*) FROM Booking WHERE booking_status='Cancelled') cancelled_bookings,(SELECT SUM(fare) 
FROM Booking) total_revenue,(SELECT SUM(refund_amount) FROM Cancellation) refund_amount,(SELECT AVG(fare) FROM Booking) average_fare,(SELECT c.cruise_name FROM Cruise c 
JOIN Booking b ON c.cruise_id=b.cruise_id GROUP BY c.cruise_id,c.cruise_name ORDER BY SUM(b.fare) DESC LIMIT 1) top_cruise,(SELECT CONCAT(p.first_name,' ',p.last_name) 
FROM Passenger p JOIN Booking b ON p.passenger_id=b.passenger_id 
GROUP BY p.passenger_id,p.first_name,p.last_name 
ORDER BY SUM(b.fare) DESC LIMIT 1) top_passenger,(SELECT p.port_name FROM Port p JOIN Cruise c ON p.port_id=c.arrival_port_id 
JOIN Booking b ON c.cruise_id=b.cruise_id GROUP BY p.port_id,p.port_name 
ORDER BY SUM(b.fare) DESC LIMIT 1) highest_revenue_port,(SELECT SUM(cost) 
FROM Maintenance) maintenance_expenditure,(SELECT SUM(fare) FROM Booking)-(SELECT SUM(refund_amount) FROM Cancellation)-(SELECT SUM(cost) 
FROM Maintenance) net_revenue;
