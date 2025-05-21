package controller;

import dao.UserDAO;
import model.User;
import util.DatabaseConnection;
import util.PasswordUtil;

import java.io.IOException;
import java.io.PrintWriter;
import java.security.NoSuchAlgorithmException;
import java.sql.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class JobSeekerRegisterServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Set response content type
        response.setContentType("text/html");
        PrintWriter out = response.getWriter();
        
        // Get form data
        String username = request.getParameter("fullname");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address") != null ? request.getParameter("address") : "";
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        
        System.out.println("Form data received:");
        System.out.println("- Username: " + username);
        System.out.println("- Email: " + email);
        System.out.println("- Phone: " + phone);
        System.out.println("- Address: " + address);
        
        // Validate passwords match
        if (!password.equals(confirmPassword)) {
            request.setAttribute("error", "Passwords do not match");
            request.getRequestDispatcher("/view/JobSeekerRegister.jsp").forward(request, response);
            return;
        }

        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            // Get database connection directly
            conn = DatabaseConnection.getConnection();
            
            if (conn == null) {
                System.out.println("ERROR: Database connection is null");
                request.setAttribute("error", "Database connection failed. Please try again later.");
                request.getRequestDispatcher("/view/JobSeekerRegister.jsp").forward(request, response);
                return;
            }
            
            System.out.println("Database connection established successfully");
            
            // Check if email already exists
            String checkSql = "SELECT COUNT(*) FROM user WHERE email = ?";
            stmt = conn.prepareStatement(checkSql);
            stmt.setString(1, email);
            rs = stmt.executeQuery();
            
            if (rs.next() && rs.getInt(1) > 0) {
                System.out.println("Email already exists: " + email);
                request.setAttribute("error", "This email is already registered. Please use a different email or login to your existing account.");
                request.getRequestDispatcher("/view/JobSeekerRegister.jsp").forward(request, response);
                return;
            }
            
            // Close the previous statement and result set
            if (stmt != null) stmt.close();
            if (rs != null) rs.close();
            
            // Hash the password
            String hashedPassword = password;
            try {
                hashedPassword = PasswordUtil.hashPassword(password);
                System.out.println("Password hashed successfully");
            } catch (NoSuchAlgorithmException e) {
                System.out.println("Error hashing password: " + e.getMessage());
                // Continue with unhashed password if hashing fails
            }
            
            // Direct SQL insert with hashed password
            String sql = "INSERT INTO user (username, email, phone, address, password) VALUES (?, ?, ?, ?, ?)";
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, username);
            stmt.setString(2, email);
            stmt.setString(3, phone);
            stmt.setString(4, address);
            stmt.setString(5, hashedPassword); // Now using hashed password
            
            System.out.println("Executing SQL: " + sql);
            System.out.println("With parameters: " + username + ", " + email + ", " + phone + ", " + address + ", [PASSWORD]");
            
            int rowsAffected = stmt.executeUpdate();
            System.out.println("Rows affected: " + rowsAffected);
            
            if (rowsAffected > 0) {
                System.out.println("Registration successful");
                
                // Verify the user was inserted
                if (stmt != null) stmt.close();
                
                String verifySql = "SELECT * FROM user WHERE email = ?";
                stmt = conn.prepareStatement(verifySql);
                stmt.setString(1, email);
                rs = stmt.executeQuery();
                
                if (rs.next()) {
                    System.out.println("User verified in database with ID: " + rs.getInt("user_id"));
                } else {
                    System.out.println("WARNING: User not found in database after insert!");
                }
                
                // Set a more personalized success message in session
                request.getSession().setAttribute("registrationSuccess", 
                    "Welcome to InternConnect, " + username + "! Your account has been created successfully. Please login with your credentials.");
                
                // Check if there's a redirect parameter
                String redirect = request.getParameter("redirect");
                String jobId = request.getParameter("jobId");
                
                if (redirect != null && redirect.equals("job") && jobId != null) {
                    // Redirect to login page with redirect parameters
                    System.out.println("Redirecting to: " + request.getContextPath() + "/view/JobSeekerLogin.jsp?redirect=" + redirect + "&jobId=" + jobId);
                    response.sendRedirect(request.getContextPath() + "/view/JobSeekerLogin.jsp?redirect=" + redirect + "&jobId=" + jobId);
                } else {
                    // Redirect to login page on success
                    System.out.println("Redirecting to: " + request.getContextPath() + "/view/JobSeekerLogin.jsp");
                    response.sendRedirect(request.getContextPath() + "/view/JobSeekerLogin.jsp");
                }
                return;
            } else {
                System.out.println("Registration failed (no rows affected)");
                // Registration failed
                request.setAttribute("error", "Registration failed. No rows were inserted.");
                request.getRequestDispatcher("/view/JobSeekerRegister.jsp").forward(request, response);
            }
        } catch (Exception e) {
            System.out.println("ERROR during registration: " + e.getMessage());
            e.printStackTrace();
            
            // Handle specific errors with more user-friendly messages
            if (e.getMessage() != null && e.getMessage().contains("Duplicate entry")) {
                System.out.println("Duplicate email detected");
                String errorMsg = "This email is already registered. Please use a different email or login to your existing account.";
                request.setAttribute("error", errorMsg);
                System.out.println("Set error attribute: " + errorMsg);
            } else {
                String errorMsg = "Registration failed: " + e.getMessage();
                request.setAttribute("error", errorMsg);
                System.out.println("Set error attribute: " + errorMsg);
            }

            // Debug the request attributes
            System.out.println("Request attributes before forwarding:");
            java.util.Enumeration<String> attributeNames = request.getAttributeNames();
            while (attributeNames.hasMoreElements()) {
                String name = attributeNames.nextElement();
                System.out.println("  " + name + " = " + request.getAttribute(name));
            }

            request.getRequestDispatcher("/view/JobSeekerRegister.jsp").forward(request, response);
        } finally {
            // Close resources
            try {
                if (rs != null) rs.close();
                if (stmt != null) stmt.close();
                if (conn != null) conn.close();
                System.out.println("Database resources closed");
            } catch (Exception e) {
                System.out.println("Error closing resources: " + e.getMessage());
            }
        }
    }
}
