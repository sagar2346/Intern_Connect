package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import java.util.stream.Collectors;
import dao.JobDAO;
import model.Job;
import filter.JobFilter;

//@WebServlet("/SearchServlet")
public class SearchServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Get search parameters
        String keyword = request.getParameter("keyword");
        String location = request.getParameter("location");
        
        // Validate inputs
        if (keyword == null) keyword = "";
        if (location == null) location = "";
        
        // Create final variables for use in lambda
        final String finalKeyword = keyword;
        final String finalLocation = location;
        
        // Get all approved jobs
        JobDAO jobDAO = new JobDAO();
        List<Job> allJobs = JobFilter.getApprovedJobs(jobDAO.getAllJobs());
        
        // Filter jobs based on search criteria
        List<Job> filteredJobs = allJobs.stream()
            .filter(job -> 
                (finalKeyword.isEmpty() || 
                 job.getTitle().toLowerCase().contains(finalKeyword.toLowerCase()) ||
                 (job.getDescription() != null && job.getDescription().toLowerCase().contains(finalKeyword.toLowerCase())) ||
                 (job.getCompanyName() != null && job.getCompanyName().toLowerCase().contains(finalKeyword.toLowerCase()))
                ) &&
                (finalLocation.isEmpty() || 
                 (job.getLocation() != null && job.getLocation().toLowerCase().contains(finalLocation.toLowerCase()))
                )
            )
            .collect(Collectors.toList());
        
        // Set attributes for the search results page
        request.setAttribute("jobs", filteredJobs);
        request.setAttribute("keyword", keyword);
        request.setAttribute("location", location);
        request.setAttribute("totalResults", filteredJobs.size());
        
        // Forward to search results page
        request.getRequestDispatcher("/view/SearchResults.jsp").forward(request, response);
    }
}