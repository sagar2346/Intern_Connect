
ALTER TABLE contacts ADD COLUMN user_id INT NULL;


ALTER TABLE contacts 
ADD CONSTRAINT fk_contacts_users 
FOREIGN KEY (user_id) REFERENCES user(user_id) 
ON DELETE SET NULL;