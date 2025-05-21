package controller;

import dao.JobApplicationDAO;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.JobApplication;

//@WebServlet("/DeleteApplicationServlet")
public class DeleteApplicationServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Check if user is logged in
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/view/JobSeekerLogin.jsp");
            return;
        }
        
        // Get user ID from session
        int userId = (Integer) session.getAttribute("userId");
        
        // Get application ID from request parameter
        String applicationId = request.getParameter("id");
        
        if (applicationId == null || applicationId.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/view/UserDashboard.jsp?error=Invalid application ID");
            return;
        }
        
        try {
            int id = Integer.parseInt(applicationId);
            
            // Use JobApplicationDAO to get the application
            JobApplicationDAO applicationDAO = new JobApplicationDAO();
            JobApplication application = applicationDAO.getApplicationById(id);
            
            // Check if application exists and belongs to the logged-in user
            if (application == null) {
                response.sendRedirect(request.getContextPath() + "/view/UserDashboard.jsp?error=Application not found");
                return;
            }
            
            if (application.getUserId() != userId) {
                response.sendRedirect(request.getContextPath() + "/view/UserDashboard.jsp?error=You can only delete your own applications");
                return;
            }
            
            // Check if application status is "Pending"
            if (!"Pending".equalsIgnoreCase(application.getStatus())) {
                response.sendRedirect(request.getContextPath() + "/view/UserDashboard.jsp?error=You can only delete pending applications");
                return;
            }
            
            // Delete the application
            boolean success = applicationDAO.deleteApplication(id);
            
            if (success) {
                response.sendRedirect(request.getContextPath() + "/view/UserDashboard.jsp?message=Application deleted successfully");
            } else {
                response.sendRedirect(request.getContextPath() + "/view/UserDashboard.jsp?error=Failed to delete application");
            }
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/view/UserDashboard.jsp?error=Invalid application ID format");
        }
    }
}