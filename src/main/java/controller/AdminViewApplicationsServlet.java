package controller;

import dao.JobApplicationDAO;
import model.JobApplication;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.io.IOException;
import java.util.List;

//@WebServlet(name = "AdminViewApplicationsServlet", value = "/AdminViewApplicationsServlet")
public class AdminViewApplicationsServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Check if admin is logged in
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("adminId") == null) {
            response.sendRedirect(request.getContextPath() + "/view/AdminLogin.jsp");
            return;
        }
        
        // Get filter parameters
        String statusFilter = request.getParameter("status");
        String jobIdFilter = request.getParameter("jobId");
        
        try {
            // Use JobApplicationDAO to get applications
            JobApplicationDAO applicationDAO = new JobApplicationDAO();
            List<JobApplication> applications;
            
            if (jobIdFilter != null && !jobIdFilter.isEmpty()) {
                // Filter by job ID
                int jobId = Integer.parseInt(jobIdFilter);
                applications = applicationDAO.getApplicationsByJobId(jobId);
            } else {
                // Get all applications
                applications = applicationDAO.getAllApplications();
            }
            
            // Apply status filter if needed
            if (statusFilter != null && !statusFilter.isEmpty() && !statusFilter.equals("all")) {
                applications.removeIf(app -> !app.getStatus().equalsIgnoreCase(statusFilter));
            }
            
            // Set applications as request attribute
            request.setAttribute("applications", applications);
            
            // Forward to the applications management page
            request.getRequestDispatcher("/view/ApplicationManagement.jsp").forward(request, response);
            
        } catch (Exception e) {
            System.err.println("Error in AdminViewApplicationsServlet: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + 
                "/view/Admin_dashboard.jsp?error=Error loading applications: " + e.getMessage());
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Just call doGet for now
        doGet(request, response);
    }
}