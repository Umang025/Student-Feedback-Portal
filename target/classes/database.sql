-- ====================================================================
-- Student Feedback Portal - Database Schema & Initial Seed Data
-- Database: student_feedback_db
-- Target: MySQL 8.x / MariaDB (XAMPP)
-- ====================================================================

-- 1. Create the database if it doesn't already exist
CREATE DATABASE IF NOT EXISTS student_feedback_db
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE student_feedback_db;

-- 2. Create the 'admins' table for dashboard authentication
-- Password hash stored using SHA-256 (64 hex characters)
CREATE TABLE IF NOT EXISTS admins (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    password_hash VARCHAR(128) NOT NULL,
    full_name VARCHAR(100) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- 3. Create the 'feedback' table for storing student submissions
CREATE TABLE IF NOT EXISTS feedback (
    id INT AUTO_INCREMENT PRIMARY KEY,
    student_name VARCHAR(100) NOT NULL,
    email VARCHAR(150) NOT NULL,
    category VARCHAR(50) NOT NULL,
    message TEXT NOT NULL,
    rating INT NOT NULL CHECK (rating >= 1 AND rating <= 5),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- 4. Seed initial default Administrator
-- Default credentials:
--   Username: admin
--   Password: admin123
-- SHA-256 for 'admin123': 240be518fabd2724ddb6f04eeb1da5967448d7e831c08c8fa822809f74c720a9
INSERT INTO admins (username, password_hash, full_name)
SELECT 'admin', '240be518fabd2724ddb6f04eeb1da5967448d7e831c08c8fa822809f74c720a9', 'Portal Administrator'
WHERE NOT EXISTS (SELECT 1 FROM admins WHERE username = 'admin');

-- 5. Seed realistic sample feedback records for testing & demonstration
INSERT INTO feedback (student_name, email, category, message, rating, created_at)
SELECT 'Aarav Sharma', 'aarav.sharma@example.edu', 'Teaching', 'The Advanced Java Web Programming lectures are very practical and clear. The lab demos helped understand Servlets.', 5, '2026-10-20 10:30:00'
WHERE NOT EXISTS (SELECT 1 FROM feedback WHERE email = 'aarav.sharma@example.edu');

INSERT INTO feedback (student_name, email, category, message, rating, created_at)
SELECT 'Priya Patel', 'priya.patel@example.edu', 'Laboratory', 'High-speed internet and updated JDK 21 in Lab 3 are really helpful. Would love more dual-monitor systems.', 4, '2026-10-21 11:15:00'
WHERE NOT EXISTS (SELECT 1 FROM feedback WHERE email = 'priya.patel@example.edu');

INSERT INTO feedback (student_name, email, category, message, rating, created_at)
SELECT 'Rohan Verma', 'rohan.v@example.edu', 'Library', 'Great collection of Java, DBMS, and Web Application reference books. Digital library access is seamless.', 5, '2026-10-22 14:00:00'
WHERE NOT EXISTS (SELECT 1 FROM feedback WHERE email = 'rohan.v@example.edu');

INSERT INTO feedback (student_name, email, category, message, rating, created_at)
SELECT 'Sneha Kulkarni', 'sneha.k@example.edu', 'Hostel', 'Wi-Fi connectivity in Hostel Block B has improved significantly. Clean study rooms available on ground floor.', 4, '2026-10-23 16:45:00'
WHERE NOT EXISTS (SELECT 1 FROM feedback WHERE email = 'sneha.k@example.edu');

INSERT INTO feedback (student_name, email, category, message, rating, created_at)
SELECT 'Ananya Sen', 'ananya.sen@example.edu', 'Internet', 'Campus Wi-Fi speed drops occasionally during peak hours in the main auditorium. Please look into router density.', 3, '2026-10-24 09:20:00'
WHERE NOT EXISTS (SELECT 1 FROM feedback WHERE email = 'ananya.sen@example.edu');

INSERT INTO feedback (student_name, email, category, message, rating, created_at)
SELECT 'Vikram Malhotra', 'vikram.m@example.edu', 'Teaching', 'Excellent explanation of JDBC CRUD and MVC architecture in class. Hands-on coding sessions are great.', 5, '2026-10-25 15:10:00'
WHERE NOT EXISTS (SELECT 1 FROM feedback WHERE email = 'vikram.m@example.edu');
