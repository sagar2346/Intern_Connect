@echo off
echo Setting up InternConnect database...
echo.

REM Check if MySQL is installed
mysql --version >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo MySQL is not installed or not in your PATH.
    echo Please install MySQL and try again.
    pause
    exit /b 1
)

REM Ask for MySQL root password
set /p MYSQL_PASSWORD="Enter MySQL root password: "

REM Create the database
echo Creating database...
mysql -u root -p%MYSQL_PASSWORD% -e "CREATE DATABASE IF NOT EXISTS internconnect;"

if %ERRORLEVEL% NEQ 0 (
    echo Failed to create database. Please check your MySQL installation and password.
    pause
    exit /b 1
)

REM Create the tables
echo Creating tables...
mysql -u root -p%MYSQL_PASSWORD% internconnect -e "
CREATE TABLE IF NOT EXISTS users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    password VARCHAR(100) NOT NULL,
    role VARCHAR(20) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS job_seeker_profiles (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    resume TEXT,
    skills TEXT,
    education_background TEXT,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS employer_profiles (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    company_name VARCHAR(100) NOT NULL,
    company_description TEXT,
    industry VARCHAR(50),
    contact_number VARCHAR(20),
    company_website VARCHAR(100),
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS job_listings (
    id INT AUTO_INCREMENT PRIMARY KEY,
    employer_id INT NOT NULL,
    title VARCHAR(100) NOT NULL,
    description TEXT NOT NULL,
    location VARCHAR(100),
    job_type VARCHAR(50),
    salary_range VARCHAR(50),
    requirements TEXT,
    posted_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    deadline_date DATE,
    status VARCHAR(20) DEFAULT 'ACTIVE',
    FOREIGN KEY (employer_id) REFERENCES users(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS applications (
    id INT AUTO_INCREMENT PRIMARY KEY,
    job_id INT NOT NULL,
    job_seeker_id INT NOT NULL,
    cover_letter TEXT,
    status VARCHAR(20) DEFAULT 'PENDING',
    applied_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (job_id) REFERENCES job_listings(id) ON DELETE CASCADE,
    FOREIGN KEY (job_seeker_id) REFERENCES users(id) ON DELETE CASCADE
);"

if %ERRORLEVEL% NEQ 0 (
    echo Failed to create tables. Please check your MySQL installation and password.
    pause
    exit /b 1
)

REM Insert default admin user
echo Creating default admin user...
mysql -u root -p%MYSQL_PASSWORD% internconnect -e "
INSERT INTO users (username, email, password, role) 
VALUES ('admin', 'admin@internconnect.com', 'admin123', 'ADMIN')
ON DUPLICATE KEY UPDATE username = 'admin';"

if %ERRORLEVEL% NEQ 0 (
    echo Failed to create default admin user. Please check your MySQL installation and password.
    pause
    exit /b 1
)

echo.
echo Database setup completed successfully!
echo.
echo Default admin user:
echo Email: admin@internconnect.com
echo Password: admin123
echo.

pause
