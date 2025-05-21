package controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import model.Job;
import util.DatabaseConnection;
import util.JobFetcher;
import filter.JobFilter;

//@WebServlet("/TestJobApprovalServlet")
public class TestJobApprovalServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/html");
        PrintWriter out = response.getWriter();
        
        out.println("<html><head><title>Job Approval Test</title>");
        out.println("<style>");
        out.println("body { font-family: Arial, sans-serif; margin: 20px; }");
        out.println("table { border-collapse: collapse; width: 100%; }");
        out.println("th, td { border: 1px solid #ddd; padding: 8px; text-align: left; }");
        out.println("th { background-color: #f2f2f2; }");
        out.println(".approved { background-color: #d4edda; }");
        out.println(".pending { background-color: #fff3cd; }");
        out.println(".rejected { background-color: #f8d7da; }");
        out.println("</style>");
        out.println("</head><body>");
        
        out.println("<h1>Job Approval Test</h1>");
        
        // Test job approval
        String jobId = request.getParameter("jobId");
        if (jobId != null && !jobId.isEmpty()) {
            try {
                int id = Integer.parseInt(jobId);
                Connection conn = DatabaseConnection.getConnection();
                // Use 'status' column instead of 'job_status'
                String sql = "UPDATE jobs SET status = 'Approved' WHERE job_id = ?";
                PreparedStatement stmt = conn.prepareStatement(sql);
                stmt.setInt(1, id);
                
                int rowsUpdated = stmt.executeUpdate();
                
                if (rowsUpdated > 0) {
                    out.println("<p style='color:green'>Job ID " + jobId + " has been approved successfully.</p>");
                } else {
                    out.println("<p style='color:red'>Failed to approve Job ID " + jobId + ". No rows updated.</p>");
                }
                
                stmt.close();
                conn.close();
            } catch (Exception e) {
                out.println("<p style='color:red'>Error: " + e.getMessage() + "</p>");
                e.printStackTrace();
            }
        }
        
        // Display all jobs
        out.println("<h2>All Jobs</h2>");
        out.println("<table>");
        out.println("<tr><th>ID</th><th>Title</th><th>Company</th><th>Status</th><th>Action</th></tr>");
        
        List<Job> allJobs = JobFetcher.getAllJobs();
        for (Job job : allJobs) {
            String statusClass = "pending";
            if (job.getJobStatus().equalsIgnoreCase("Approved")) {
                statusClass = "approved";
            } else if (job.getJobStatus().equalsIgnoreCase("Rejected")) {
                statusClass = "rejected";
            }
            
            out.println("<tr class='" + statusClass + "'>");
            out.println("<td>" + job.getJobId() + "</td>");
            out.println("<td>" + job.getTitle() + "</td>");
            out.println("<td>" + job.getCompanyName() + "</td>");
            out.println("<td>" + job.getJobStatus() + "</td>");
            out.println("<td><a href='?jobId=" + job.getJobId() + "'>Approve</a></td>");
            out.println("</tr>");
        }
        out.println("</table>");
        
        // Display approved jobs
        out.println("<h2>Approved Jobs (These will appear on the Job Listing page)</h2>");
        out.println("<table>");
        out.println("<tr><th>ID</th><th>Title</th><th>Company</th><th>Status</th></tr>");
        
        List<Job> approvedJobs = JobFilter.getApprovedJobs(allJobs);
        if (approvedJobs.isEmpty()) {
            out.println("<tr><td colspan='4'>No approved jobs found</td></tr>");
        } else {
            for (Job job : approvedJobs) {
                out.println("<tr class='approved'>");
                out.println("<td>" + job.getJobId() + "</td>");
                out.println("<td>" + job.getTitle() + "</td>");
                out.println("<td>" + job.getCompanyName() + "</td>");
                out.println("<td>" + job.getJobStatus() + "</td>");
                out.println("</tr>");
            }
        }
        out.println("</table>");
        
        out.println("<p><a href='" + request.getContextPath() + "/view/JobListing.jsp'>Go to Job Listing Page</a></p>");
        out.println("<p><a href='" + request.getContextPath() + "/view/Admin_dashboard.jsp'>Go to Admin Dashboard</a></p>");
        
        out.println("</body></html>");
    }
}