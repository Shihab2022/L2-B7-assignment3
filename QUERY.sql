-- =========================================================================
-- SYSTEM: Football Ticket Booking System Database Setup Template
-- DESCRIPTION: Pseudo-DDL Template for Table Creation & Data Insertion
-- INSTRUCTIONS: Replace 'TYPE' and the constraint placeholders with your own
--               actual data types, relational keys, and check criteria.
-- =========================================================================

-- DROP TABLES IF THEY ALREADY EXIST TO PREVENT CONFLICTS
DROP TABLE IF EXISTS Bookings;
DROP TABLE IF EXISTS Matches;
DROP TABLE IF EXISTS Users;

-- =========================================================================
-- 1. CREATE USERS TABLE
-- =========================================================================
CREATE TABLE Users (
    user_id INT PRIMARY KEY,
    full_name VARCHAR(50),
    email VARCHAR(50) UNIQUE,
    role TEXT NOT NULL DEFAULT 'Football Fan' ,
    phone_number VARCHAR(20),
    CHECK (role IN ('Ticket Manager', 'Football Fan'))
);

-- =========================================================================
-- 2. CREATE MATCHES TABLE
-- =========================================================================
CREATE TABLE Matches (
    match_id INT PRIMARY KEY,
    fixture VARCHAR(255),
    tournament_category VARCHAR(100),
    base_ticket_price DECIMAL(10, 2),
    match_status VARCHAR(50),
    CHECK (base_ticket_price >= 0),
    CHECK (match_status IN ('Available', 'Selling Fast', 'Sold Out', 'Postponed'))
);

-- =========================================================================
-- 3. CREATE BOOKINGS TABLE
-- =========================================================================
CREATE TABLE Bookings (
    booking_id INT PRIMARY KEY,
    user_id INT REFERENCES Users(user_id),
    match_id INT REFERENCES Matches(match_id),
    seat_number VARCHAR(10),
    payment_status VARCHAR(20),
    total_cost DECIMAL(10, 2),
    CHECK (total_cost >= 0),
    CHECK (payment_status IN ('Pending', 'Confirmed', 'Cancelled', 'Refunded')),
    CONSTRAINT uq_match_seat UNIQUE (match_id, seat_number)
);


-- =========================================================================
-- DATA SEEDING: INSERT SAMPLE DATA INTO USERS
-- =========================================================================
INSERT INTO Users (user_id, full_name, email, role, phone_number) VALUES
(166, ' RahmanTanvir', 'tanyviRRr@mail.com', 'Football Fan', '+8801711111111'),
(266, 'HaqueAsif', 'asifRTyR@mail.com', 'Football Fan', '+8801722222222'),
(366, 'Sajjad Rahman', 'sajjyad@mail.com', 'Ticket Manager', '+8801733333333'),
(466, 'Jannat Ara', 'jannyatRE@mail.com', 'Football Fan', NULL);

-- =========================================================================
-- DATA SEEDING: INSERT SAMPLE DATA INTO MATCHES
-- =========================================================================
INSERT INTO Matches (match_id, fixture, tournament_category, base_ticket_price, match_status) VALUES
(101, 'Real Madrid vs Barcelona', 'Champions League', 150.00, 'Available'),
(102, 'Man City vs Liverpool', 'Premier League', 120.00, 'Selling Fast'),
(103, 'Bayern Munich vs PSG', 'Champions League', 130.00, 'Available'),
(104, 'AC Milan vs Inter Milan', 'Serie A', 90.00, 'Sold Out'),
(105, 'Juventus vs Roma', 'Serie A', 80.00, 'Available');

-- =========================================================================
-- DATA SEEDING: INSERT SAMPLE DATA INTO BOOKINGS
-- =========================================================================
INSERT INTO Bookings (booking_id, user_id, match_id, seat_number, payment_status, total_cost) VALUES
(081, 166, 101, 'F-12', 'Confirmed', 150.00),
(288, 266, 102, 'R-04', 'Confirmed', 120.00),
(388, 366, 101, 'T-13', 'Confirmed', 150.00),
(488, 466, 101, 'D-08', NULL, 150.00),
(588, 166, 102, 'W-20', 'Pending', 120.00);


-- Query 1: Retrieve all upcoming football matches belonging to the 'Champions League' where the match status is 'Available'.

SELECT match_id ,fixture,ROUND(base_ticket_price) AS base_ticket_price FROM Matches WHERE match_status = 'Available' ;



-- Query 2: Search for all users whose full names start with 'Tanvir' or contain the phrase 'Haque' (case-insensitive).
-- Concepts used: LIKE, ILIKE

SELECT user_id,full_name ,email  FROM users 
WHERE full_name ILIKE 'tanvir%' 
   OR full_name ILIKE '%haque%';


-- Query 3: Retrieve all booking records where the payment status is missing (NULL), replacing the empty result with 'Action Required'.
-- Concepts used: IS NULL, COALESCE

SELECT booking_id, user_id, match_id, COALESCE(payment_status, 'Action Required') AS systematic_status
FROM Bookings
WHERE payment_status IS NULL;       