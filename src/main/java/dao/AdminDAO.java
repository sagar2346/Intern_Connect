package dao;

import model.Admin;
import util.DatabaseConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * Data Access Object for Admin
 * Handles all database operations related to administrators
 */
public class AdminDAO {
    
    /**
     * Get all admins from the database
     * @return List of all admins
     */
    public List<Admin> getAllAdmins() {
        List<Admin> admins = new ArrayList<>();
        
        try (Connection conn = DatabaseConnection.getConnection()) {
            String query = "SELECT * FROM admin ORDER BY admin_id";
            Statement stmt = conn.createStatement();
            ResultSet rs = stmt.executeQuery(query);
            
            while (rs.next()) {
                Admin admin = extractAdminFromResultSet(rs);
                admins.add(admin);
            }
        } catch (SQLException e) {
            System.err.println("Error fetching all admins: " + e.getMessage());
            e.printStackTrace();
        }
        
        return admins;
    }
    
    /**
     * Get admin by ID
     * @param adminId The admin ID
     * @return Admin object or null if not found
     */
    public Admin getAdminById(int adminId) {
        Admin admin = null;
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        
        try {
            conn = DatabaseConnection.getConnection();
            String query = "SELECT * FROM admin WHERE admin_id = ?";
            stmt = conn.prepareStatement(query);
            stmt.setInt(1, adminId);
            rs = stmt.executeQuery();
            
            if (rs.next()) {
                admin = new Admin();
                admin.setAdminId(rs.getInt("admin_id"));
                admin.setName(rs.getString("name"));
                admin.setEmail(rs.getString("email"));
                admin.setPassword(rs.getString("password"));
            }
        } catch (SQLException e) {
            System.out.println("Error getting admin by ID: " + e.getMessage());
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) rs.close();
                if (stmt != null) stmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                System.out.println("Error closing resources: " + e.getMessage());
            }
        }
        
        return admin;
    }
    
    /**
     * Get an admin by email
     * @param email The admin's email
     * @return Admin object or null if not found
     */
    public Admin getAdminByEmail(String email) {
        Admin admin = null;
        
        try (Connection conn = DatabaseConnection.getConnection()) {
            String query = "SELECT * FROM admin WHERE email = ?";
            PreparedStatement stmt = conn.prepareStatement(query);
            stmt.setString(1, email);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                admin = extractAdminFromResultSet(rs);
            }
        } catch (SQLException e) {
            System.err.println("Error fetching admin by email: " + e.getMessage());
            e.printStackTrace();
        }
        
        return admin;
    }
    
    /**
     * Insert a new admin into the database
     * @param admin The Admin object to insert
     * @return true if successful, false otherwise
     */
    public boolean insertAdmin(Admin admin) {
        try (Connection conn = DatabaseConnection.getConnection()) {
            String query = "INSERT INTO admin (name, email, password) VALUES (?, ?, ?)";
            
            PreparedStatement stmt = conn.prepareStatement(query);
            stmt.setString(1, admin.getName());
            stmt.setString(2, admin.getEmail());
            stmt.setString(3, admin.getPassword());
            
            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            System.err.println("Error inserting admin: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Update an existing admin in the database
     * @param admin The Admin object with updated values
     * @return true if successful, false otherwise
     */
    public boolean updateAdmin(Admin admin) {
        try (Connection conn = DatabaseConnection.getConnection()) {
            String query = "UPDATE admin SET name = ?, email = ? WHERE admin_id = ?";
            
            PreparedStatement stmt = conn.prepareStatement(query);
            stmt.setString(1, admin.getName());
            stmt.setString(2, admin.getEmail());
            stmt.setInt(3, admin.getAdminId());
            
            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            System.err.println("Error updating admin: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Update an admin's password
     * @param adminId The admin ID
     * @param newPassword The new password (should be already hashed)
     * @return true if successful, false otherwise
     */
    public boolean updatePassword(int adminId, String newPassword) {
        try (Connection conn = DatabaseConnection.getConnection()) {
            String query = "UPDATE admin SET password = ? WHERE admin_id = ?";
            
            PreparedStatement stmt = conn.prepareStatement(query);
            stmt.setString(1, newPassword);
            stmt.setInt(2, adminId);
            
            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            System.err.println("Error updating admin password: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Delete an admin from the database
     * @param adminId The ID of the admin to delete
     * @return true if successful, false otherwise
     */
    public boolean deleteAdmin(int adminId) {
        try (Connection conn = DatabaseConnection.getConnection()) {
            String query = "DELETE FROM admin WHERE admin_id = ?";
            
            PreparedStatement stmt = conn.prepareStatement(query);
            stmt.setInt(1, adminId);
            
            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            System.err.println("Error deleting admin: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Authenticate an admin with email and password
     * @param email The admin's email
     * @param password The admin's password (already hashed)
     * @return Admin object if authentication successful, null otherwise
     */
    public Admin authenticateAdmin(String email, String password) {
        try (Connection conn = DatabaseConnection.getConnection()) {
            String query = "SELECT * FROM admin WHERE email = ? AND password = ?";
            
            PreparedStatement stmt = conn.prepareStatement(query);
            stmt.setString(1, email);
            stmt.setString(2, password);
            
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return extractAdminFromResultSet(rs);
            }
            
        } catch (SQLException e) {
            System.err.println("Error authenticating admin: " + e.getMessage());
            e.printStackTrace();
        }
        
        return null;
    }
    
    /**
     * Helper method to extract an Admin object from a ResultSet
     */
    private Admin extractAdminFromResultSet(ResultSet rs) throws SQLException {
        Admin admin = new Admin();
        
        admin.setAdminId(rs.getInt("admin_id"));
        admin.setName(rs.getString("name"));
        admin.setEmail(rs.getString("email"));
        admin.setPassword(rs.getString("password"));
        
        // Handle created_at if it exists
        try {
            admin.setCreatedAt(rs.getTimestamp("created_at"));
        } catch (SQLException e) {
            // Column might not exist, ignore
        }
        
        return admin;
    }
    
    /**
     * Check if an email already exists in the admin table
     * @param email The email to check
     * @return true if email exists, false otherwise
     */
    public boolean checkEmailExists(String email) {
        try (Connection conn = DatabaseConnection.getConnection()) {
            String query = "SELECT COUNT(*) FROM admin WHERE email = ?";
            
            PreparedStatement stmt = conn.prepareStatement(query);
            stmt.setString(1, email);
            
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
            
        } catch (SQLException e) {
            System.err.println("Error checking email existence: " + e.getMessage());
            e.printStackTrace();
        }
        
        return false;
    }
}
