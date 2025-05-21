package model;

import java.sql.Timestamp;

public class Contact {
    private int contactId;
    private String name;
    private String email;
    private String message;
    private Timestamp submittedAt;
    private boolean isRead;
    private Integer userId; // New field to store user ID (can be null for anonymous users)

    // Constructors
    public Contact() {
    }

    public Contact(String name, String email, String message) {
        this.name = name;
        this.email = email;
        this.message = message;
        this.isRead = false;
    }

    // Constructor with userId
    public Contact(String name, String email, String message, Integer userId) {
        this.name = name;
        this.email = email;
        this.message = message;
        this.isRead = false;
        this.userId = userId;
    }

    // Full constructor
    public Contact(int contactId, String name, String email, String message, Timestamp submittedAt, boolean isRead, Integer userId) {
        this.contactId = contactId;
        this.name = name;
        this.email = email;
        this.message = message;
        this.submittedAt = submittedAt;
        this.isRead = isRead;
        this.userId = userId;
    }

    // Getters and Setters
    public int getContactId() {
        return contactId;
    }

    public void setContactId(int contactId) {
        this.contactId = contactId;
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

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public Timestamp getSubmittedAt() {
        return submittedAt;
    }

    public void setSubmittedAt(Timestamp submittedAt) {
        this.submittedAt = submittedAt;
    }

    public boolean isRead() {
        return isRead;
    }

    public void setRead(boolean read) {
        isRead = read;
    }

    // New getter and setter for userId
    public Integer getUserId() {
        return userId;
    }

    public void setUserId(Integer userId) {
        this.userId = userId;
    }
}
