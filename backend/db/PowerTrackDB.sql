-- Drop the database if it exists
DROP DATABASE IF EXISTS PowerTrackDB;

-- Create the database
CREATE DATABASE PowerTrackDB;

-- Use the newly created database
USE PowerTrackDB;

-- Create Users table with profile_image column
CREATE TABLE users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    profile_image VARCHAR(255), -- Column to store profile image URL or file path
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create Meters table
-- Create Meters table with additional columns
CREATE TABLE meters (
    meter_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    meter_number VARCHAR(50) UNIQUE NOT NULL,
    location VARCHAR(255) NOT NULL,
    meter_name VARCHAR(255),
    customer_name VARCHAR(255),
    customer_number VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);


-- Create Transactions table
CREATE TABLE transactions (
    transaction_id INT AUTO_INCREMENT PRIMARY KEY,
    meter_id INT NOT NULL,
    user_id INT NOT NULL,
    amount DECIMAL(10, 2) NOT NULL,
    payment_method ENUM('credit_card', 'debit_card', 'mobile_money') NOT NULL,
    transaction_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status ENUM('pending', 'completed', 'failed') DEFAULT 'pending',
    description VARCHAR(255),
    FOREIGN KEY (meter_id) REFERENCES meters(meter_id),
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

-- Create MeterUsage table
CREATE TABLE meter_usage (
    usage_id INT AUTO_INCREMENT PRIMARY KEY,
    meter_id INT NOT NULL,
    user_id INT NOT NULL,
    usage_date DATE NOT NULL,
    usage_amount DECIMAL(10, 2) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (meter_id) REFERENCES meters(meter_id),
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

-- Create MaintenanceRequests table
CREATE TABLE maintenance_requests (
    request_id INT AUTO_INCREMENT PRIMARY KEY,
    meter_id INT NOT NULL,
    user_id INT NOT NULL,
    request_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status ENUM('pending', 'in_progress', 'completed') DEFAULT 'pending',
    description TEXT NOT NULL,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (meter_id) REFERENCES meters(meter_id),
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

-- Create Notifications table
CREATE TABLE notifications (
    notification_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    message VARCHAR(255) NOT NULL,
    type ENUM('low_credit', 'top_up_success', 'maintenance_update') NOT NULL,
    is_read BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

-- Create Tokens table
CREATE TABLE tokens (
    token_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    token VARCHAR(255) NOT NULL,
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

