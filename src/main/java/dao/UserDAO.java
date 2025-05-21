package dao;

import model.User;
import util.DatabaseConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * Data Access Object for User
 * Handles all database operations related to users
 */
public class UserDAO {
    
    /**
     * Get all users from the database
     * @return List of all users
     */
    public List<User> getAllUsers() {
        List<User> users = new ArrayList<>();
        
        try (Connection conn = DatabaseConnection.getConnection()) {
            String query = "SELECT * FROM user ORDER BY user_id";
            Statement stmt = conn.createStatement();
            ResultSet rs = stmt.executeQuery(query);
            
            while (rs.next()) {
                User user = extractUserFromResultSet(rs);
                users.add(user);
            }
        } catch (SQLException e) {
            System.err.println("Error fetching all users: " + e.getMessage());
            e.printStackTrace();
        }
        
        return users;
    }
    
    /**
     * Get a user by ID
     * @param userId The user ID
     * @return User object or null if not found
     */
    public User getUserById(int userId) {
        User user = null;
        
        try (Connection conn = DatabaseConnection.getConnection()) {
            String query = "SELECT * FROM user WHERE user_id = ?";
            PreparedStatement stmt = conn.prepareStatement(query);
            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                user = extractUserFromResultSet(rs);
            }
        } catch (SQLException e) {
            System.err.println("Error fetching user by ID: " + e.getMessage());
            e.printStackTrace();
        }
        
        return user;
    }
    
    /**
     * Get a user by email
     * @param email The user's email
     * @return User object or null if not found
     */
    public User getUserByEmail(String email) {
        User user = null;
        
        try (Connection conn = DatabaseConnection.getConnection()) {
            String query = "SELECT * FROM user WHERE email = ?";
            PreparedStatement stmt = conn.prepareStatement(query);
            stmt.setString(1, email);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                user = extractUserFromResultSet(rs);
            }
        } catch (SQLException e) {
            System.err.println("Error fetching user by email: " + e.getMessage());
            e.printStackTrace();
        }
        
        return user;
    }
    
    /**
     * Insert a new user into the database
     * @param user The User object to insert
     * @return true if successful, false otherwise
     */
    public boolean insertUser(User user) throws Exception {
        Connection conn = null;
        PreparedStatement stmt = null;
        
        try {
            conn = DatabaseConnection.getConnection();
            
            // SQL query to insert user data - UPDATED to match your table structure (no role column)
            String sql = "INSERT INTO user (username, email, phone, address, password) VALUES (?, ?, ?, ?, ?)";
            
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, user.getUsername());
            stmt.setString(2, user.getEmail());
            stmt.setString(3, user.getPhone());
            stmt.setString(4, user.getAddress());
            stmt.setString(5, user.getPassword());
            
            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
        } finally {
            if (stmt != null) stmt.close();
            if (conn != null) conn.close();
        }
    }
    
    /**
     * Updates an existing user in the database
     * @param user The user object with updated information
     * @return true if the update was successful, false otherwise
     * @throws Exception if there's a database error
     */
    public boolean updateUser(User user) throws SQLException {
        Connection conn = null;
        PreparedStatement stmt = null;
        
        try {
            conn = DatabaseConnection.getConnection();
            
            // Change "users" to "user" to match your database table name
            String sql = "UPDATE user SET username = ?, email = ?, phone = ?, address = ?";
            
            // Add password to update query if it has been changed
            if (user.getPassword() != null && !user.getPassword().isEmpty()) {
                sql += ", password = ?";
            }
            
            sql += " WHERE user_id = ?";
            
            System.out.println("UserDAO: Executing SQL - " + sql);
            
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, user.getUsername());
            stmt.setString(2, user.getEmail());
            stmt.setString(3, user.getPhone());
            stmt.setString(4, user.getAddress());
            
            int paramIndex = 5;
            if (user.getPassword() != null && !user.getPassword().isEmpty()) {
                stmt.setString(paramIndex++, user.getPassword());
            }
            
            stmt.setInt(paramIndex, user.getUserId());
            
            int rowsAffected = stmt.executeUpdate();
            System.out.println("UserDAO: Rows affected - " + rowsAffected);
            return rowsAffected > 0;
        } catch (SQLException e) {
            System.out.println("UserDAO: SQL Error - " + e.getMessage());
            throw e;
        } finally {
            // Close resources
            if (stmt != null) stmt.close();
            if (conn != null) conn.close();
        }
    }
    
    /**
     * Update a user's password
     * @param userId The user ID
     * @param newPassword The new password
     * @return true if successful, false otherwise
     */
    public boolean updatePassword(int userId, String newPassword) {
        try (Connection conn = DatabaseConnection.getConnection()) {
            String query = "UPDATE user SET password = ? WHERE user_id = ?";
            
            PreparedStatement stmt = conn.prepareStatement(query);
            stmt.setString(1, newPassword);
            stmt.setInt(2, userId);
            
            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            System.err.println("Error updating password: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Delete a user from the database
     * @param userId The ID of the user to delete
     * @return true if successful, false otherwise
     */
    public boolean deleteUser(int userId) {
        try (Connection conn = DatabaseConnection.getConnection()) {
            String query = "DELETE FROM user WHERE user_id = ?";
            
            PreparedStatement stmt = conn.prepareStatement(query);
            stmt.setInt(1, userId);
            
            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            System.err.println("Error deleting user: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Authenticate a user with email and password
     * @param email The user's email
     * @param password The user's password
     * @return User object if authentication successful, null otherwise
     */
    public User authenticateUser(String email, String password) {
        try (Connection conn = DatabaseConnection.getConnection()) {
            String query = "SELECT * FROM user WHERE email = ? AND password = ?";
            
            PreparedStatement stmt = conn.prepareStatement(query);
            stmt.setString(1, email);
            stmt.setString(2, password);
            
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return extractUserFromResultSet(rs);
            }
            
        } catch (SQLException e) {
            System.err.println("Error authenticating user: " + e.getMessage());
            e.printStackTrace();
        }
        
        return null;
    }
    
    /**
     * Helper method to extract a User object from a ResultSet
     */
    private User extractUserFromResultSet(ResultSet rs) throws SQLException {
        User user = new User();
        
        user.setUserId(rs.getInt("user_id"));
        user.setUsername(rs.getString("username"));
        user.setEmail(rs.getString("email"));
        user.setPhone(rs.getString("phone"));
        user.setAddress(rs.getString("address"));
        user.setPassword(rs.getString("password"));
        
        // Try to get role if it exists
        try {
            String role = rs.getString("role");
            if (role != null && !role.isEmpty()) {
                user.setRole(role);
            }
        } catch (SQLException e) {
            // Column might not exist, ignore
        }
        
        // Remove the registration_date handling since User class doesn't support it
        // If you need this data later, you can add it back after updating the User class
        
        return user;
    }

    /**
     * Check if an email exists in the database
     * @param email The email to check
     * @return true if email exists, false otherwise
     */
    public boolean checkEmailExists(String email) {
        try (Connection conn = DatabaseConnection.getConnection()) {
            String query = "SELECT COUNT(*) FROM user WHERE email = ?";
            
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
