package util;

import dao.JobApplicationDAO;
import model.JobApplication;
import java.util.List;

/**
 * Utility class for fetching job applications
 */
public class ApplicationFetcher {
    
    /**
     * Get all job applications
     * @return List of all job applications
     */
    public static List<JobApplication> getAllApplications() {
        JobApplicationDAO applicationDAO = new JobApplicationDAO();
        return applicationDAO.getAllApplications();
    }
    
    /**
     * Get applications by user ID
     * @param userId The user ID to filter by
     * @return List of applications for the specified user
     */
    public static List<JobApplication> getApplicationsByUserId(int userId) {
        JobApplicationDAO applicationDAO = new JobApplicationDAO();
        return applicationDAO.getApplicationsByUserId(userId);
    }
    
    /**
     * Get applications by job ID
     * @param jobId The job ID to filter by
     * @return List of applications for the specified job
     */
    public static List<JobApplication> getApplicationsByJobId(int jobId) {
        JobApplicationDAO applicationDAO = new JobApplicationDAO();
        return applicationDAO.getApplicationsByJobId(jobId);
    }
    
    /**
     * Get applications by status
     * @param status The status to filter by
     * @return List of applications with the specified status
     */
    public static List<JobApplication> getApplicationsByStatus(String status) {
        JobApplicationDAO applicationDAO = new JobApplicationDAO();
        List<JobApplication> allApplications = applicationDAO.getAllApplications();
        
        // Filter by status
        allApplications.removeIf(app -> !app.getStatus().equalsIgnoreCase(status));
        
        return allApplications;
    }
}
