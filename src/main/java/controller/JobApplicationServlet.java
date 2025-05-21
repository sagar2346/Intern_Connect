package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import java.io.File;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import util.DatabaseConnection;

//@WebServlet("/JobApplicationServlet")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024, // 1 MB
    maxFileSize = 1024 * 1024 * 10,  // 10 MB
    maxRequestSize = 1024 * 1024 * 50 // 50 MB
)
public class JobApplicationServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        System.out.println("JobApplicationServlet: Starting job application submission process");
        
        // Check if user is logged in
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            System.out.println("JobApplicationServlet: User not logged in, redirecting to login page");
            response.sendRedirect(request.getContextPath() + "/view/JobSeekerLogin.jsp?error=Please login to apply");
            return;
        }
        
        // Declare file path variables at the beginning
        String resumePath = "";
        String coverLetterPath = "";
        
        try {
            // Get form data
            int userId = (Integer) session.getAttribute("userId");
            String firstName = request.getParameter("firstName");
            String lastName = request.getParameter("lastName");
            String userName = firstName + " " + lastName;
            String email = request.getParameter("email");
            String position = request.getParameter("position");
            String jobIdStr = request.getParameter("jobId");
            
            // Get additional form fields
            String address = request.getParameter("address");
            String city = request.getParameter("city");
            String phone = request.getParameter("phone");
            String additionalInfo = request.getParameter("additionalInfo");
            
            System.out.println("JobApplicationServlet: Received form data - User ID: " + userId + 
                              ", Name: " + userName + ", Email: " + email + ", Position: " + position + 
                              ", Job ID: " + jobIdStr);
            
            if (jobIdStr == null || jobIdStr.isEmpty()) {
                System.out.println("JobApplicationServlet: Job ID is missing");
                response.sendRedirect(request.getContextPath() + "/view/JobListing.jsp?error=Missing job ID");
                return;
            }
            
            int jobId = Integer.parseInt(jobIdStr);
            
            // Get job title for position if not provided
            if (position == null || position.isEmpty()) {
                try (Connection conn = DatabaseConnection.getConnection()) {
                    String query = "SELECT title FROM jobs WHERE job_id = ?";
                    PreparedStatement stmt = conn.prepareStatement(query);
                    stmt.setInt(1, jobId);
                    ResultSet rs = stmt.executeQuery();
                    if (rs.next()) {
                        position = rs.getString("title");
                    }
                } catch (SQLException e) {
                    System.out.println("Error getting job title: " + e.getMessage());
                }
            }
            
            // Database operations
            Connection conn = null;
            try {
                conn = DatabaseConnection.getConnection();
                
                if (conn == null) {
                    System.out.println("JobApplicationServlet: Database connection is null");
                    response.sendRedirect(request.getContextPath() + "/view/JobApplication.jsp?jobId=" + jobId + "&error=Database connection failed");
                    return;
                }
                
                // Handle file uploads
                Part resumePart = request.getPart("resume");
                if (resumePart != null && resumePart.getSize() > 0) {
                    String fileName = getSubmittedFileName(resumePart);
                    String uniqueFileName = userId + "_" + System.currentTimeMillis() + "_" + fileName;
                    resumePath = "uploads/resumes/" + uniqueFileName;
                    
                    // Create directory if it doesn't exist
                    String uploadPath = getServletContext().getRealPath("") + File.separator + "uploads" + File.separator + "resumes";
                    File uploadDir = new File(uploadPath);
                    if (!uploadDir.exists()) {
                        uploadDir.mkdirs();
                    }
                    
                    // Save the file
                    resumePart.write(uploadPath + File.separator + uniqueFileName);
                    System.out.println("Resume saved to: " + uploadPath + File.separator + uniqueFileName);
                }
                
                Part coverLetterPart = request.getPart("coverLetter");
                if (coverLetterPart != null && coverLetterPart.getSize() > 0) {
                    String fileName = getSubmittedFileName(coverLetterPart);
                    String uniqueFileName = userId + "_" + System.currentTimeMillis() + "_" + fileName;
                    coverLetterPath = "uploads/coverletters/" + uniqueFileName;
                    
                    // Create directory if it doesn't exist
                    String uploadPath = getServletContext().getRealPath("") + File.separator + "uploads" + File.separator + "coverletters";
                    File uploadDir = new File(uploadPath);
                    if (!uploadDir.exists()) {
                        uploadDir.mkdirs();
                    }
                    
                    // Save the file
                    coverLetterPart.write(uploadPath + File.separator + uniqueFileName);
                    System.out.println("Cover letter saved to: " + uploadPath + File.separator + uniqueFileName);
                }
                
                // Prepare SQL query including user_id
                String query = "INSERT INTO job_applications (job_id, user_id, user_name, address, city, phone, email, " +
                              "additional_info, resume_path, cover_letter_path, position, status, application_date) " +
                              "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, NOW())";
                
                PreparedStatement stmt = conn.prepareStatement(query);
                stmt.setInt(1, jobId);
                stmt.setInt(2, userId);
                stmt.setString(3, userName);
                stmt.setString(4, address != null ? address : "");
                stmt.setString(5, city != null ? city : "");
                stmt.setString(6, phone != null ? phone : "");
                stmt.setString(7, email);
                stmt.setString(8, additionalInfo != null ? additionalInfo : "");
                stmt.setString(9, resumePath); // This is the resume path
                stmt.setString(10, coverLetterPath); // This is the cover letter path
                stmt.setString(11, position != null ? position : "");
                stmt.setString(12, "Pending");

                System.out.println("JobApplicationServlet: Executing query with parameters:");
                System.out.println("Job ID: " + jobId);
                System.out.println("User ID: " + userId);
                System.out.println("User Name: " + userName);
                System.out.println("Resume Path: " + resumePath);
                System.out.println("Cover Letter Path: " + coverLetterPath);
                System.out.println("Position: " + position);
                
                int rowsAffected = stmt.executeUpdate();
                
                System.out.println("JobApplicationServlet: Query executed, rows affected: " + rowsAffected);
                
                if (rowsAffected > 0) {
                    System.out.println("JobApplicationServlet: Application submitted successfully");
                    response.sendRedirect(request.getContextPath() + "/view/UserDashboard.jsp?message=Application submitted successfully");
                } else {
                    System.out.println("JobApplicationServlet: No rows affected by the query");
                    response.sendRedirect(request.getContextPath() + "/view/JobApplication.jsp?jobId=" + jobId + "&error=Failed to submit application");
                }
                
            } catch (SQLException e) {
                System.out.println("JobApplicationServlet: SQL Exception: " + e.getMessage());
                e.printStackTrace();
                
                // Try alternative query if position column doesn't exist
                if (e.getMessage().contains("position") || e.getMessage().contains("Unknown column")) {
                    try {
                        String altQuery = "INSERT INTO job_applications (job_id, user_id, user_name, address, city, phone, email, " +
                                         "additional_info, resume_path, cover_letter_path, status) " +
                                         "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
                        
                        PreparedStatement altStmt = conn.prepareStatement(altQuery);
                        altStmt.setInt(1, jobId);
                        altStmt.setInt(2, userId);
                        altStmt.setString(3, userName);
                        altStmt.setString(4, address != null ? address : "");
                        altStmt.setString(5, city != null ? city : "");
                        altStmt.setString(6, phone != null ? phone : "");
                        altStmt.setString(7, email);
                        altStmt.setString(8, additionalInfo != null ? additionalInfo : "");
                        altStmt.setString(9, resumePath);
                        altStmt.setString(10, coverLetterPath);
                        altStmt.setString(11, "Pending");
                        
                        int altRowsAffected = altStmt.executeUpdate();
                        
                        if (altRowsAffected > 0) {
                            System.out.println("JobApplicationServlet: Application submitted successfully (alternative query)");
                            response.sendRedirect(request.getContextPath() + "/view/UserDashboard.jsp?message=Application submitted successfully");
                            return;
                        }
                    } catch (SQLException ex) {
                        System.out.println("JobApplicationServlet: Alternative SQL Exception: " + ex.getMessage());
                        ex.printStackTrace();
                    }
                }
                
                response.sendRedirect(request.getContextPath() + "/view/JobApplication.jsp?jobId=" + jobId + "&error=Database error: " + e.getMessage());
            } finally {
                if (conn != null) {
                    try {
                        conn.close();
                    } catch (SQLException e) {
                        System.out.println("JobApplicationServlet: Error closing connection: " + e.getMessage());
                    }
                }
            }
            
        } catch (Exception e) {
            System.out.println("JobApplicationServlet: Unexpected error: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/view/JobListing.jsp?error=Application failed: " + e.getMessage());
        }
    }
    
    // Helper method to get the submitted filename from a Part
    private String getSubmittedFileName(Part part) {
        String contentDisp = part.getHeader("content-disposition");
        if (contentDisp != null) {
            String[] tokens = contentDisp.split(";");
            for (String token : tokens) {
                if (token.trim().startsWith("filename")) {
                    return token.substring(token.indexOf('=') + 1).trim().replace("\"", "");
                }
            }
        }
        return null;
    }
}