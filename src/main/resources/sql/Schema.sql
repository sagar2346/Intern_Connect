CREATE TABLE user (
                      user_id INT AUTO_INCREMENT PRIMARY KEY,
                      username VARCHAR(255),
                      email VARCHAR(255),
                      phone VARCHAR(20),
                      address TEXT,
                      password VARCHAR(255)
);
CREATE TABLE admin (
                       admin_id INT AUTO_INCREMENT PRIMARY KEY,
                       name VARCHAR(100),
                       email VARCHAR(100),
                       password VARCHAR(100),
                       created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE job_applications (
                                  application_id INT AUTO_INCREMENT PRIMARY KEY,
                                  job_id INT,
                                  user_id INT,
                                  user_name VARCHAR(255),
                                  address TEXT,
                                  city VARCHAR(255),
                                  phone VARCHAR(20),
                                  email VARCHAR(255),
                                  additional_info TEXT,
                                  resume_path VARCHAR(255),
                                  cover_letter_path VARCHAR(255),
                                  application_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                                  status ENUM('Pending', 'Approved', 'Rejected') DEFAULT 'Pending'
);

CREATE TABLE jobs (
                      job_id INT AUTO_INCREMENT PRIMARY KEY,
                      title VARCHAR(255),
                      description TEXT,
                      job_type VARCHAR(50),
                      company_name VARCHAR(255),
                      location VARCHAR(255),
                      salary VARCHAR(100),
                      requirements TEXT,
                      application_deadline DATE,
                      status VARCHAR(20) DEFAULT 'Pending',
                      posted_by INT,
                      created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
                  );
CREATE TABLE contacts (
                          contact_id INT AUTO_INCREMENT PRIMARY KEY,
                          name VARCHAR(100),
                          email VARCHAR(100),
                          message TEXT,
    };
