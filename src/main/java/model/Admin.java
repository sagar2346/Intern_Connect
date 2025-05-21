package model;

import java.sql.Timestamp;

/**
 * Represents an administrator in the system
 */
public class Admin {
    private int adminId;
    private String name;
    private String email;
    private String password;
    private Timestamp createdAt;
    
    // Default constructor
    public Admin() {
    }
    
    // Constructor with fields
    public Admin(int adminId, String name, String email, String password) {
        this.adminId = adminId;
        this.name = name;
        this.email = email;
        this.password = password;
    }
    
    // Constructor with all fields including creation date
    public Admin(int adminId, String name, String email, String password, Timestamp createdAt) {
        this.adminId = adminId;
        this.name = name;
        this.email = email;
        this.password = password;
        this.createdAt = createdAt;
    }
    
    // Getters and setters
    public int getAdminId() {
        return adminId;
    }
    
    public void setAdminId(int adminId) {
        this.adminId = adminId;
    }
    
    public String getName() {
        return name;
    }
    
    public void setName(String name) {
        this.name = name;
    }
    
    public String getEmail() {
        return email;
    }
    
    public void setEmail(String email) {
        this.email = email;
    }
    
    public String getPassword() {
        return password;
    }
    
    public void setPassword(String password) {
        this.password = password;
    }
    
    public Timestamp getCreatedAt() {
        return createdAt;
    }
    
    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }
    
    @Override
    public String toString() {
        return "Admin{" +
                "adminId=" + adminId +
                ", name='" + name + '\'' +
                ", email='" + email + '\'' +
                ", createdAt=" + createdAt +
                '}';
    }
}