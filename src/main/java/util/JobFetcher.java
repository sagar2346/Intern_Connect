package util;

import dao.JobDAO;
import model.Job;

import java.util.List;

/**
 * Utility class for fetching jobs
 * This class now uses JobDAO instead of direct database queries
 */
public class JobFetcher {
    
    /**
     * Get all jobs
     * @return List of all jobs
     */
    public static List<Job> getAllJobs() {
        JobDAO jobDAO = new JobDAO();
        return jobDAO.getAllJobs();
    }
    
    /**
     * Get job by ID
     * @param jobId The job ID
     * @return The job with the specified ID, or null if not found
     */
    public static Job getJobById(int jobId) {
        JobDAO jobDAO = new JobDAO();
        return jobDAO.getJobById(jobId);
    }
    
    /**
     * Get jobs by status
     * @param status The job status
     * @return List of jobs with the specified status
     */
    public static List<Job> getJobsByStatus(String status) {
        JobDAO jobDAO = new JobDAO();
        return jobDAO.getJobsByStatus(status);
    }
    
    /**
     * Get jobs by category
     * @param category The job category
     * @return List of jobs in the specified category
     */
    public static List<Job> getJobsByCategory(String category) {
        JobDAO jobDAO = new JobDAO();
        return jobDAO.getJobsByCategory(category);
    }
    
    /**
     * Search jobs by keyword
     * @param keyword The search keyword
     * @return List of jobs matching the keyword
     */
    public static List<Job> searchJobs(String keyword) {
        JobDAO jobDAO = new JobDAO();
        return jobDAO.searchJobs(keyword);
    }
    
    /**
     * Update job status
     * @param jobId The job ID
     * @param status The new status
     * @return true if successful, false otherwise
     */
    public static boolean updateJobStatus(int jobId, String status) {
        JobDAO jobDAO = new JobDAO();
        return jobDAO.updateJobStatus(jobId, status);
    }
}