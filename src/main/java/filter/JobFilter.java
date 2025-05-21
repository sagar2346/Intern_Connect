package filter;

import model.Job;
import java.util.ArrayList;
import java.util.List;

/**
 * Utility class for filtering jobs based on various criteria
 */
public class JobFilter {
    
    /**
     * Filters a list of jobs to return only those with "Approved" status
     * 
     * @param jobs The list of jobs to filter
     * @return A new list containing only approved jobs
     */
    public static List<Job> getApprovedJobs(List<Job> jobs) {
        List<Job> approvedJobs = new ArrayList<>();
        
        if (jobs == null || jobs.isEmpty()) {
            System.out.println("JobFilter: No jobs to filter");
            return approvedJobs;
        }
        
        for (Job job : jobs) {
            String status = job.getJobStatus();
            System.out.println("JobFilter: Checking job ID " + job.getJobId() + 
                               ", Title: " + job.getTitle() + 
                               ", Status: '" + status + "'");
            
            if (status != null && status.equalsIgnoreCase("Approved")) {
                approvedJobs.add(job);
                System.out.println("JobFilter: Added job ID " + job.getJobId() + 
                                   " to approved jobs list");
            }
        }
        
        System.out.println("JobFilter: Found " + approvedJobs.size() + 
                           " approved jobs out of " + jobs.size() + " total jobs");
        return approvedJobs;
    }
    
    /**
     * Filters a list of jobs to return only those with "Pending" status
     * 
     * @param jobs The list of jobs to filter
     * @return A new list containing only pending jobs
     */
    public static List<Job> getPendingJobs(List<Job> jobs) {
        List<Job> pendingJobs = new ArrayList<>();
        
        if (jobs == null || jobs.isEmpty()) {
            return pendingJobs;
        }
        
        for (Job job : jobs) {
            String status = job.getJobStatus();
            if (status == null || status.equalsIgnoreCase("Pending")) {
                pendingJobs.add(job);
            }
        }
        
        return pendingJobs;
    }
    
    /**
     * Filters a list of jobs by job type
     * 
     * @param jobs The list of jobs to filter
     * @param jobType The job type to filter by (e.g., "Full-time", "Part-time", "Internship")
     * @return A new list containing only jobs of the specified type
     */
    public static List<Job> getJobsByType(List<Job> jobs, String jobType) {
        List<Job> filteredJobs = new ArrayList<>();
        
        if (jobs == null || jobs.isEmpty() || jobType == null) {
            return filteredJobs;
        }
        
        for (Job job : jobs) {
            if (job.getJobType() != null && job.getJobType().equalsIgnoreCase(jobType)) {
                filteredJobs.add(job);
            }
        }
        
        return filteredJobs;
    }
    
    /**
     * Count the number of pending jobs in a list
     * @param jobs List of jobs to filter
     * @return Count of pending jobs
     */
    public static int countPendingJobs(List<Job> jobs) {
        int count = 0;
        for (Job job : jobs) {
            String status = job.getJobStatus();
            if (status == null || status.equalsIgnoreCase("Pending")) {
                count++;
            }
        }
        return count;
    }
    
    /**
     * Count the number of approved jobs in a list
     * @param jobs List of jobs to filter
     * @return Count of approved jobs
     */
    public static int countApprovedJobs(List<Job> jobs) {
        int count = 0;
        for (Job job : jobs) {
            String status = job.getJobStatus();
            if (status != null && status.equalsIgnoreCase("Approved")) {
                count++;
            }
        }
        System.out.println("JobFilter: Counted " + count + " approved jobs");
        return count;
    }
}
