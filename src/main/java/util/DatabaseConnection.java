package util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DatabaseConnection {
    // Database connection parameters with corrected database name
    private static final String URL = "jdbc:mysql://localhost:3306/intern_connect?useSSL=false&allowPublicKeyRetrieval=true";
    private static final String USER = "root";
    private static final String PASSWORD = ""; // Update if your MySQL has a password
    
    // Get database connection
    public static Connection getConnection() throws SQLException {
        try {
            // Load the JDBC driver
            Class.forName("com.mysql.cj.jdbc.Driver");
            
            // Create and return connection
            Connection conn = DriverManager.getConnection(URL, USER, PASSWORD);
            
            // Debug output
            if (conn != null) {
                System.out.println("Database connection established successfully");
            } else {
                System.out.println("Failed to establish database connection");
            }
            
            return conn;
        } catch (ClassNotFoundException e) {
            System.out.println("MySQL JDBC Driver not found: " + e.getMessage());
            throw new SQLException("JDBC Driver not found", e);
        } catch (SQLException e) {
            System.out.println("Database connection error: " + e.getMessage());
            throw e;
        }
    }
}