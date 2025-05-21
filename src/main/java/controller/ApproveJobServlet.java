package controller;

import dao.JobDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

//@WebServlet("/ApproveJobServlet")
public class ApproveJobServlet extends HttpServlet {
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Check if admin is logged in
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("adminId") == null) {
            response.sendRedirect(request.getContextPath() + "/view/AdminLogin.jsp");
            return;
        }
        
        String jobId = request.getParameter("id");
        
        if (jobId == null || jobId.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/view/Admin_dashboard.jsp?error=Invalid job ID");
            return;
        }
        
        try {
            int id = Integer.parseInt(jobId);
            
            // Use JobDAO to update job status
            JobDAO jobDAO = new JobDAO();
            
            // Try both column names: status and job_status
            boolean success = false;
            try {
                success = jobDAO.updateJobStatus(id, "Approved");
            } catch (Exception e) {
                System.err.println("First attempt failed: " + e.getMessage());
                // Try alternative column name
                success = jobDAO.updateJobStatusAlternative(id, "Approved");
            }
            
            if (success) {
                System.out.println("Job ID " + jobId + " has been approved successfully.");
                // Redirect back to the job detail page
                response.sendRedirect(request.getContextPath() + "/view/JobDetail.jsp?id=" + jobId + "&message=Job approved successfully");
            } else {
                System.out.println("Failed to approve Job ID " + jobId + ". No rows updated.");
                response.sendRedirect(request.getContextPath() + "/view/JobDetail.jsp?id=" + jobId + "&error=Failed to approve job");
            }
        } catch (NumberFormatException e) {
            System.err.println("Invalid job ID format: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/view/Admin_dashboard.jsp?error=Invalid job ID format");
        } catch (Exception e) {
            System.err.println("Error approving job: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/view/Admin_dashboard.jsp?error=Error approving job: " + e.getMessage());
        }
    }
}