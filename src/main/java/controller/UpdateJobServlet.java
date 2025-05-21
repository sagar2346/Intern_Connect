package controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import util.DatabaseConnection;

//@WebServlet("/UpdateJobServlet")
public class UpdateJobServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Get form parameters
        String jobIdStr = request.getParameter("jobId");
        String title = request.getParameter("title");
        String companyName = request.getParameter("companyName");
        String jobType = request.getParameter("jobType");
        String location = request.getParameter("location");
        String salary = request.getParameter("salary");
        String description = request.getParameter("description");
        String requirements = request.getParameter("requirements");
        String deadline = request.getParameter("deadline");
        String status = request.getParameter("status");
        
        // Validate required fields
        if (jobIdStr == null || title == null || companyName == null || jobType == null || 
            location == null || description == null || requirements == null) {
            response.sendRedirect(request.getContextPath() + "/view/Admin_dashboard.jsp?error=Missing required fields");
            return;
        }
        
        try {
            int jobId = Integer.parseInt(jobIdStr);
            
            try (Connection conn = DatabaseConnection.getConnection()) {
                String query = "UPDATE jobs SET title = ?, job_type = ?, description = ?, company_name = ?, " +
                               "location = ?, salary = ?, requirements = ?, application_deadline = ?, status = ? " +
                               "WHERE job_id = ?";
                
                PreparedStatement stmt = conn.prepareStatement(query);
                stmt.setString(1, title);
                stmt.setString(2, jobType);
                stmt.setString(3, description);
                stmt.setString(4, companyName);
                stmt.setString(5, location);
                stmt.setString(6, salary);
                stmt.setString(7, requirements);
                stmt.setString(8, deadline);
                stmt.setString(9, status);
                stmt.setInt(10, jobId);
                
                int rowsAffected = stmt.executeUpdate();
                
                if (rowsAffected > 0) {
                    // Redirect to job details page with success message
                    response.sendRedirect(request.getContextPath() + "/view/JobDetail.jsp?id=" + jobId + "&message=Job updated successfully");
                } else {
                    // Redirect to job details page with error message
                    response.sendRedirect(request.getContextPath() + "/view/JobDetail.jsp?id=" + jobId + "&error=Failed to update job");
                }
            } catch (SQLException e) {
                System.err.println("Error updating job: " + e.getMessage());
                response.sendRedirect(request.getContextPath() + "/view/JobDetail.jsp?id=" + jobIdStr + "&error=Database error: " + e.getMessage());
            }
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/view/Admin_dashboard.jsp?error=Invalid job ID format");
        }
    }
}