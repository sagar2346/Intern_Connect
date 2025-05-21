package controller;

import dao.JobDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

//@WebServlet("/RejectJobServlet")
public class RejectJobServlet extends HttpServlet {
    
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
            
            // Use JobDAO to update job status or delete the job
            JobDAO jobDAO = new JobDAO();
            
            // Try to delete the job first
            boolean success = jobDAO.deleteJob(id);
            
            if (!success) {
                // If delete fails, try to update status to Rejected
                try {
                    success = jobDAO.updateJobStatus(id, "Rejected");
                } catch (Exception e) {
                    System.err.println("Status update failed: " + e.getMessage());
                    // Try alternative column name
                    success = jobDAO.updateJobStatusAlternative(id, "Rejected");
                }
            }
            
            if (success) {
                System.out.println("Job ID " + jobId + " has been deleted/rejected successfully.");
                // Redirect back to the admin dashboard
                response.sendRedirect(request.getContextPath() + "/view/Admin_dashboard.jsp?message=Job deleted successfully");
            } else {
                System.out.println("Failed to delete/reject Job ID " + jobId + ". No rows updated.");
                response.sendRedirect(request.getContextPath() + "/view/JobDetail.jsp?id=" + jobId + "&error=Failed to delete job");
            }
        } catch (NumberFormatException e) {
            System.err.println("Invalid job ID format: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/view/Admin_dashboard.jsp?error=Invalid job ID format");
        } catch (Exception e) {
            System.err.println("Error deleting job: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/view/Admin_dashboard.jsp?error=Error deleting job: " + e.getMessage());
        }
    }
}
