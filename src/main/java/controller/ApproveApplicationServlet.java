package controller;

import dao.JobApplicationDAO;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

public class ApproveApplicationServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Check if admin is logged in
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("adminId") == null) {
            response.sendRedirect(request.getContextPath() + "/view/AdminLogin.jsp");
            return;
        }
        
        // Get application ID from request parameter
        String applicationId = request.getParameter("id");
        
        if (applicationId == null || applicationId.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/view/ApplicationManagement.jsp?error=Invalid application ID");
            return;
        }
        
        try {
            int id = Integer.parseInt(applicationId);
            
            // Use JobApplicationDAO to update application status
            JobApplicationDAO applicationDAO = new JobApplicationDAO();
            boolean success = applicationDAO.updateApplicationStatus(id, "Approved");
            
            if (success) {
                response.sendRedirect(request.getContextPath() + "/view/ApplicationManagement.jsp?message=Application approved successfully");
            } else {
                response.sendRedirect(request.getContextPath() + "/view/ApplicationManagement.jsp?error=Failed to approve application");
            }
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/view/ApplicationManagement.jsp?error=Invalid application ID format");
        }
    }
}