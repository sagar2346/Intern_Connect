package dao;

import model.Contact;
import util.DatabaseConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ContactDAO {
    
    // Insert a new contact message
    public boolean insertContact(Contact contact) {
        String sql = "INSERT INTO contacts (name, email, message, submitted_at, is_read, user_id) VALUES (?, ?, ?, NOW(), ?, ?)";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, contact.getName());
            stmt.setString(2, contact.getEmail());
            stmt.setString(3, contact.getMessage());
            stmt.setBoolean(4, contact.isRead());
            
            // Handle null userId
            if (contact.getUserId() != null) {
                stmt.setInt(5, contact.getUserId());
            } else {
                stmt.setNull(5, java.sql.Types.INTEGER);
            }
            
            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            System.err.println("Error inserting contact message: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    // Get all contact messages
    public List<Contact> getAllContacts() {
        List<Contact> contacts = new ArrayList<>();
        String sql = "SELECT * FROM contacts ORDER BY submitted_at DESC";
        
        try (Connection conn = DatabaseConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                Contact contact = new Contact(
                    rs.getInt("contact_id"),
                    rs.getString("name"),
                    rs.getString("email"),
                    rs.getString("message"),
                    rs.getTimestamp("submitted_at"),
                    rs.getBoolean("is_read"),
                    rs.getObject("user_id") != null ? rs.getInt("user_id") : null
                );
                contacts.add(contact);
            }
            
        } catch (SQLException e) {
            System.err.println("Error retrieving contacts: " + e.getMessage());
            e.printStackTrace();
        }
        
        return contacts;
    }
    
    // Get contact messages by user ID
    public List<Contact> getContactsByUserId(int userId) {
        List<Contact> contacts = new ArrayList<>();
        String sql = "SELECT * FROM contacts WHERE user_id = ? ORDER BY submitted_at DESC";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, userId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Contact contact = new Contact(
                        rs.getInt("contact_id"),
                        rs.getString("name"),
                        rs.getString("email"),
                        rs.getString("message"),
                        rs.getTimestamp("submitted_at"),
                        rs.getBoolean("is_read"),
                        rs.getInt("user_id")
                    );
                    contacts.add(contact);
                }
            }
            
        } catch (SQLException e) {
            System.err.println("Error retrieving user contacts: " + e.getMessage());
            e.printStackTrace();
        }
        
        return contacts;
    }
    
    // Get unread contact messages count
    public int getUnreadCount() {
        String sql = "SELECT COUNT(*) FROM contacts WHERE is_read = false";
        
        try (Connection conn = DatabaseConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            if (rs.next()) {
                return rs.getInt(1);
            }
            
        } catch (SQLException e) {
            System.err.println("Error counting unread messages: " + e.getMessage());
            e.printStackTrace();
        }
        
        return 0;
    }
    
    // Mark a message as read
    public boolean markAsRead(int contactId) {
        String sql = "UPDATE contacts SET is_read = true WHERE contact_id = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, contactId);
            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            System.err.println("Error marking message as read: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
}