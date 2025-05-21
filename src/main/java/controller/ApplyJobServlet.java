package controller;

import dao.JobApplicationDAO;
import model.JobApplication;

import java.io.IOException;
import java.sql.Timestamp;
import java.util.Date;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

public class ApplyJobServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Check if user is logged in
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            // Redirect to login page with return URL
            String jobId = request.getParameter("jobId");
            response.sendRedirect(request.getContextPath() + "/view/JobSeekerLogin.jsp?redirect=job&jobId=" + jobId);
            return;
        }
        
        // Get form data
        String jobId = request.getParameter("jobId");
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String coverLetter = request.getParameter("coverLetter");
        String resumeUrl = request.getParameter("resumeUrl"); // This would be a file upload in a real app
        
        // Get user ID from session
        Integer userId = (Integer) session.getAttribute("userId");
        
        try {
            // Create JobApplication object
            JobApplication application = new JobApplication();
            application.setJobId(Integer.parseInt(jobId));
            application.setUserId(userId);
            application.setApplicantName(name);
            application.setEmail(email);
            application.setPhone(phone);
            application.setCoverLetterPath(coverLetter);
            application.setResumePath(resumeUrl);
            application.setStatus("Pending");
            application.setApplicationDate(new Date(System.currentTimeMillis()));
            
            // Use JobApplicationDAO to insert the application
            JobApplicationDAO applicationDAO = new JobApplicationDAO();
            boolean success = applicationDAO.insertApplication(application);
            
            if (success) {
                response.sendRedirect(request.getContextPath() + "/view/UserDashboard.jsp?message=Application submitted successfully");
            } else {
                response.sendRedirect(request.getContextPath() + "/view/JobApplication.jsp?jobId=" + jobId + "&error=Failed to submit application");
            }
        } catch (Exception e) {
            System.err.println("Error applying for job: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/view/JobApplication.jsp?jobId=" + jobId + "&error=Error: " + e.getMessage());
        }
    }
}