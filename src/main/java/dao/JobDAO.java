package dao;

import model.Job;
import util.DatabaseConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.Set;
import java.util.HashSet;

/**
 * Data Access Object for Job
 * Handles all database operations related to jobs
 */
public class JobDAO {
    
    /**
     * Retrieves all jobs from the database
     * @return List of Job objects
     */
    public List<Job> getAllJobs() {
        List<Job> jobs = new ArrayList<>();
        
        try (Connection conn = DatabaseConnection.getConnection()) {
            if (conn == null) {
                System.err.println("ERROR: Database connection is null in JobDAO.getAllJobs()");
                return jobs;
            }
            
            String query = "SELECT * FROM jobs ORDER BY job_id DESC";
            PreparedStatement stmt = conn.prepareStatement(query);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                jobs.add(extractJobFromResultSet(rs));
            }
        } catch (SQLException e) {
            System.err.println("ERROR in JobDAO.getAllJobs(): " + e.getMessage());
            e.printStackTrace();
        }
        
        return jobs;
    }

    /**
     * Retrieves a specific job by ID
     * @param jobId The ID of the job to retrieve
     * @return Job object or null if not found
     */
    public Job getJobById(int jobId) {
        Job job = null;

        try (Connection conn = DatabaseConnection.getConnection()) {
            String query = "SELECT * FROM jobs WHERE job_id = ?";
            PreparedStatement stmt = conn.prepareStatement(query);
            stmt.setInt(1, jobId);
            ResultSet rs = stmt.executeQuery();

            // Get column names to check which columns exist
            ResultSetMetaData metaData = rs.getMetaData();
            int columnCount = metaData.getColumnCount();
            Set<String> columnNames = new HashSet<>();
            
            for (int i = 1; i <= columnCount; i++) {
                columnNames.add(metaData.getColumnName(i).toLowerCase());
            }

            if (rs.next()) {
                job = extractJobFromResultSet(rs, columnNames);
            }
        } catch (SQLException e) {
            System.err.println("Error fetching job by ID: " + e.getMessage());
            e.printStackTrace();
        }

        return job;
    }

    /**
     * Retrieves jobs by type (e.g., Full-time, Part-time, Internship)
     * @param jobType The type of jobs to retrieve
     * @return List of Job objects matching the specified type
     */
    public List<Job> getJobsByType(String jobType) {
        List<Job> jobList = new ArrayList<>();

        try (Connection conn = DatabaseConnection.getConnection()) {
            String query = "SELECT * FROM jobs WHERE job_type = ? ORDER BY posted_date DESC";
            PreparedStatement stmt = conn.prepareStatement(query);
            stmt.setString(1, jobType);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                jobList.add(extractJobFromResultSet(rs));
            }
        } catch (SQLException e) {
            System.err.println("Error fetching jobs by type: " + e.getMessage());
            e.printStackTrace();
        }

        return jobList;
    }
    
    /**
     * Insert a new job into the database
     * @param job The Job object to insert
     * @return true if successful, false otherwise
     */
    public boolean insertJob(Job job) {
        try (Connection conn = DatabaseConnection.getConnection()) {
            String query = "INSERT INTO jobs (title, job_type, description, company_name, location, " +
                          "salary, requirements, application_deadline, status, posted_date, posted_by) " +
                          "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
            
            PreparedStatement stmt = conn.prepareStatement(query);
            stmt.setString(1, job.getTitle());
            stmt.setString(2, job.getJobType());
            stmt.setString(3, job.getDescription());
            stmt.setString(4, job.getCompanyName());
            stmt.setString(5, job.getLocation());
            stmt.setString(6, job.getSalary());
            stmt.setString(7, job.getRequirements());
            stmt.setString(8, job.getApplicationDeadline());
            stmt.setString(9, job.getJobStatus());
            stmt.setString(10, job.getPostedDate());
            
            if (job.getPostedBy() != null) {
                stmt.setInt(11, job.getPostedBy());
            } else {
                stmt.setNull(11, Types.INTEGER);
            }
            
            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            System.err.println("Error inserting job: " + e.getMessage());
            e.printStackTrace();
            
            // Try alternative queries if columns don't exist
            if (e.getMessage().contains("posted_date")) {
                return insertJobWithoutPostedDate(job);
            } else if (e.getMessage().contains("status")) {
                return insertJobWithoutStatus(job);
            } else if (e.getMessage().contains("posted_by")) {
                return insertJobWithoutPostedBy(job);
            }
            
            return false;
        }
    }
    
    /**
     * Insert job without posted_date field (fallback method)
     */
    private boolean insertJobWithoutPostedDate(Job job) {
        try (Connection conn = DatabaseConnection.getConnection()) {
            String query = "INSERT INTO jobs (title, job_type, description, company_name, location, " +
                          "salary, requirements, application_deadline, status, posted_by) " +
                          "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
            
            PreparedStatement stmt = conn.prepareStatement(query);
            stmt.setString(1, job.getTitle());
            stmt.setString(2, job.getJobType());
            stmt.setString(3, job.getDescription());
            stmt.setString(4, job.getCompanyName());
            stmt.setString(5, job.getLocation());
            stmt.setString(6, job.getSalary());
            stmt.setString(7, job.getRequirements());
            stmt.setString(8, job.getApplicationDeadline());
            stmt.setString(9, job.getJobStatus());
            
            if (job.getPostedBy() != null) {
                stmt.setInt(10, job.getPostedBy());
            } else {
                stmt.setNull(10, Types.INTEGER);
            }
            
            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            System.err.println("Error in fallback insert: " + e.getMessage());
            return false;
        }
    }
    
    /**
     * Insert job without status field (fallback method)
     */
    private boolean insertJobWithoutStatus(Job job) {
        try (Connection conn = DatabaseConnection.getConnection()) {
            String query = "INSERT INTO jobs (title, job_type, description, company_name, location, " +
                          "salary, requirements, application_deadline, posted_date, posted_by) " +
                          "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
            
            PreparedStatement stmt = conn.prepareStatement(query);
            stmt.setString(1, job.getTitle());
            stmt.setString(2, job.getJobType());
            stmt.setString(3, job.getDescription());
            stmt.setString(4, job.getCompanyName());
            stmt.setString(5, job.getLocation());
            stmt.setString(6, job.getSalary());
            stmt.setString(7, job.getRequirements());
            stmt.setString(8, job.getApplicationDeadline());
            stmt.setString(9, job.getPostedDate());
            
            if (job.getPostedBy() != null) {
                stmt.setInt(10, job.getPostedBy());
            } else {
                stmt.setNull(10, Types.INTEGER);
            }
            
            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            System.err.println("Error in fallback insert: " + e.getMessage());
            return false;
        }
    }
    
    /**
     * Insert job without posted_by field (fallback method)
     */
    private boolean insertJobWithoutPostedBy(Job job) {
        try (Connection conn = DatabaseConnection.getConnection()) {
            String query = "INSERT INTO jobs (title, job_type, description, company_name, location, " +
                          "salary, requirements, application_deadline, status, posted_date) " +
                          "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
            
            PreparedStatement stmt = conn.prepareStatement(query);
            stmt.setString(1, job.getTitle());
            stmt.setString(2, job.getJobType());
            stmt.setString(3, job.getDescription());
            stmt.setString(4, job.getCompanyName());
            stmt.setString(5, job.getLocation());
            stmt.setString(6, job.getSalary());
            stmt.setString(7, job.getRequirements());
            stmt.setString(8, job.getApplicationDeadline());
            stmt.setString(9, job.getJobStatus());
            stmt.setString(10, job.getPostedDate());
            
            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            System.err.println("Error in fallback insert: " + e.getMessage());
            return false;
        }
    }
    
    /**
     * Update an existing job in the database
     * @param job The Job object with updated values
     * @return true if successful, false otherwise
     */
    public boolean updateJob(Job job) {
        try (Connection conn = DatabaseConnection.getConnection()) {
            String query = "UPDATE jobs SET title = ?, job_type = ?, description = ?, company_name = ?, " +
                          "location = ?, salary = ?, requirements = ?, application_deadline = ?, status = ? " +
                          "WHERE job_id = ?";
            
            PreparedStatement stmt = conn.prepareStatement(query);
            stmt.setString(1, job.getTitle());
            stmt.setString(2, job.getJobType());
            stmt.setString(3, job.getDescription());
            stmt.setString(4, job.getCompanyName());
            stmt.setString(5, job.getLocation());
            stmt.setString(6, job.getSalary());
            stmt.setString(7, job.getRequirements());
            stmt.setString(8, job.getApplicationDeadline());
            stmt.setString(9, job.getJobStatus());
            stmt.setInt(10, job.getJobId());
            
            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            System.err.println("Error updating job: " + e.getMessage());
            e.printStackTrace();
            
            // Try with job_status instead of status if that's the issue
            if (e.getMessage().contains("status")) {
                try (Connection conn = DatabaseConnection.getConnection()) {
                    String query = "UPDATE jobs SET title = ?, job_type = ?, description = ?, company_name = ?, " +
                                  "location = ?, salary = ?, requirements = ?, application_deadline = ?, job_status = ? " +
                                  "WHERE job_id = ?";
                    
                    PreparedStatement stmt = conn.prepareStatement(query);
                    stmt.setString(1, job.getTitle());
                    stmt.setString(2, job.getJobType());
                    stmt.setString(3, job.getDescription());
                    stmt.setString(4, job.getCompanyName());
                    stmt.setString(5, job.getLocation());
                    stmt.setString(6, job.getSalary());
                    stmt.setString(7, job.getRequirements());
                    stmt.setString(8, job.getApplicationDeadline());
                    stmt.setString(9, job.getJobStatus());
                    stmt.setInt(10, job.getJobId());
                    
                    int rowsAffected = stmt.executeUpdate();
                    return rowsAffected > 0;
                } catch (SQLException ex) {
                    System.err.println("Error in fallback update: " + ex.getMessage());
                    return false;
                }
            }
            
            return false;
        }
    }
    
    /**
     * Update job status using the 'status' column
     * @param jobId The job ID
     * @param status The new status
     * @return true if successful, false otherwise
     */
    public boolean updateJobStatus(int jobId, String status) {
        String sql = "UPDATE jobs SET status = ? WHERE job_id = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, status);
            stmt.setInt(2, jobId);
            
            int rowsAffected = stmt.executeUpdate();
            System.out.println("JobDAO.updateJobStatus: Rows affected: " + rowsAffected + " for job ID: " + jobId + " with status: " + status);
            
            return rowsAffected > 0;
        } catch (SQLException e) {
            System.err.println("Error updating job status: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Update job status using the 'job_status' column (alternative)
     * @param jobId The job ID
     * @param status The new status
     * @return true if successful, false otherwise
     */
    public boolean updateJobStatusAlternative(int jobId, String status) {
        String sql = "UPDATE jobs SET job_status = ? WHERE job_id = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, status);
            stmt.setInt(2, jobId);
            
            int rowsAffected = stmt.executeUpdate();
            System.out.println("JobDAO.updateJobStatusAlternative: Rows affected: " + rowsAffected);
            
            return rowsAffected > 0;
        } catch (SQLException e) {
            System.err.println("Error updating job status (alternative): " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Delete a job from the database
     * @param jobId The job ID to delete
     * @return true if successful, false otherwise
     */
    public boolean deleteJob(int jobId) {
        Connection conn = null;
        try {
            conn = DatabaseConnection.getConnection();
            
            // Start transaction
            conn.setAutoCommit(false);
            
            // First, delete any job applications for this job
            String deleteAppsSQL = "DELETE FROM job_applications WHERE job_id = ?";
            try (PreparedStatement deleteAppsStmt = conn.prepareStatement(deleteAppsSQL)) {
                deleteAppsStmt.setInt(1, jobId);
                deleteAppsStmt.executeUpdate();
                System.out.println("Deleted related job applications for job ID: " + jobId);
            }
            
            // Then delete the job
            String deleteJobSQL = "DELETE FROM jobs WHERE job_id = ?";
            try (PreparedStatement deleteJobStmt = conn.prepareStatement(deleteJobSQL)) {
                deleteJobStmt.setInt(1, jobId);
                int rowsAffected = deleteJobStmt.executeUpdate();
                System.out.println("JobDAO.deleteJob: Rows affected: " + rowsAffected);
                
                // Commit the transaction
                conn.commit();
                
                return rowsAffected > 0;
            }
        } catch (SQLException e) {
            // Rollback the transaction if there's an error
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException ex) {
                    System.err.println("Error rolling back transaction: " + ex.getMessage());
                }
            }
            System.err.println("Error deleting job: " + e.getMessage());
            e.printStackTrace();
            return false;
        } finally {
            // Reset auto-commit and close connection
            if (conn != null) {
                try {
                    conn.setAutoCommit(true);
                    conn.close();
                } catch (SQLException e) {
                    System.err.println("Error closing connection: " + e.getMessage());
                }
            }
        }
    }
    
    /**
     * Helper method to extract a Job object from a ResultSet
     */
    private Job extractJobFromResultSet(ResultSet rs) throws SQLException {
        int jobId = rs.getInt("job_id");
        String title = rs.getString("title");
        String jobType = rs.getString("job_type");
        String description = rs.getString("description");
        String companyName = rs.getString("company_name");
        String location = rs.getString("location");
        String salary = rs.getString("salary");
        String requirements = rs.getString("requirements");
        String applicationDeadline = rs.getString("application_deadline");
        
        // Get job status from 'status' column instead of 'job_status'
        String jobStatus = "Pending";
        try {
            jobStatus = rs.getString("status");
            if (rs.wasNull() || jobStatus == null || jobStatus.isEmpty()) {
                jobStatus = "Pending";
            }
        } catch (SQLException e) {
            // Try job_status column
            try {
                jobStatus = rs.getString("job_status");
                if (rs.wasNull() || jobStatus == null || jobStatus.isEmpty()) {
                    jobStatus = "Pending";
                }
            } catch (SQLException ex) {
                // Column might not exist, use default
                System.out.println("Warning: status/job_status column not found, using default 'Pending'");
            }
        }
        
        // Get posted date
        String postedDate = "";
        try {
            postedDate = rs.getString("posted_date");
            if (rs.wasNull()) {
                postedDate = "";
            }
        } catch (SQLException e) {
            // Try created_at column
            try {
                postedDate = rs.getString("created_at");
                if (rs.wasNull()) {
                    postedDate = "";
                }
            } catch (SQLException ex) {
                // Column might not exist
            }
        }
        
        // Get posted_by with fallback to null if not found
        Integer postedBy = null;
        try {
            int postedById = rs.getInt("posted_by");
            if (!rs.wasNull()) {
                postedBy = postedById;
            }
        } catch (SQLException e) {
            // Column might not exist, use default
        }
        
        return new Job(jobId, title, jobType, description, companyName, 
                      location, salary, requirements, applicationDeadline,
                      jobStatus, postedDate, postedBy);
    }
    
    /**
     * Helper method to extract a Job object from a ResultSet with column names
     */
    private Job extractJobFromResultSet(ResultSet rs, Set<String> columnNames) throws SQLException {
        int jobId = rs.getInt("job_id");
        String title = rs.getString("title");
        String jobType = rs.getString("job_type");
        String description = rs.getString("description");
        String companyName = rs.getString("company_name");
        String location = rs.getString("location");
        
        // Get optional fields with column checking
        String salary = columnNames.contains("salary") ? rs.getString("salary") : null;
        String requirements = columnNames.contains("requirements") ? rs.getString("requirements") : null;
        String applicationDeadline = columnNames.contains("application_deadline") ? rs.getString("application_deadline") : null;
        
        // Get posted_by value with error handling
        Integer postedBy = null;
        if (columnNames.contains("posted_by")) {
            postedBy = rs.getInt("posted_by");
            if (rs.wasNull()) {
                postedBy = null;
            }
        }
        
        // Get job_status with fallback
        String jobStatus = "Pending";
        if (columnNames.contains("job_status")) {
            jobStatus = rs.getString("job_status");
            if (rs.wasNull() || jobStatus == null || jobStatus.isEmpty()) {
                jobStatus = "Pending";
            }
        } else if (columnNames.contains("status")) {
            jobStatus = rs.getString("status");
            if (rs.wasNull() || jobStatus == null || jobStatus.isEmpty()) {
                jobStatus = "Pending";
            }
        }
        
        // Get posted_date with fallback
        String postedDate = "N/A";
        if (columnNames.contains("posted_date")) {
            postedDate = rs.getString("posted_date");
            if (rs.wasNull() || postedDate == null || postedDate.isEmpty()) {
                postedDate = "N/A";
            }
        } else if (columnNames.contains("created_at")) {
            postedDate = rs.getString("created_at");
            if (rs.wasNull() || postedDate == null || postedDate.isEmpty()) {
                postedDate = "N/A";
            }
        }
        
        return new Job(jobId, title, jobType, description, companyName, 
                      location, salary, requirements, applicationDeadline,
                      jobStatus, postedDate, postedBy);
    }
    
    /**
     * Retrieves jobs by status (e.g., Approved, Pending, Rejected)
     * @param status The status of jobs to retrieve
     * @return List of Job objects matching the specified status
     */
    public List<Job> getJobsByStatus(String status) {
        List<Job> jobList = new ArrayList<>();

        try (Connection conn = DatabaseConnection.getConnection()) {
            // First check if the column is 'status' or 'job_status'
            String columnName = "status";
            try {
                // Try to query with 'job_status' first
                String checkQuery = "SELECT job_status FROM jobs LIMIT 1";
                PreparedStatement checkStmt = conn.prepareStatement(checkQuery);
                checkStmt.executeQuery();
                columnName = "job_status"; // If no exception, use job_status
            } catch (SQLException e) {
                // If exception, use 'status' column
                columnName = "status";
            }
            
            String query = "SELECT * FROM jobs WHERE " + columnName + " = ? ORDER BY posted_date DESC";
            PreparedStatement stmt = conn.prepareStatement(query);
            stmt.setString(1, status);
            ResultSet rs = stmt.executeQuery();

            // Get column names to check which columns exist
            ResultSetMetaData metaData = rs.getMetaData();
            int columnCount = metaData.getColumnCount();
            Set<String> columnNames = new HashSet<>();
            
            for (int i = 1; i <= columnCount; i++) {
                columnNames.add(metaData.getColumnName(i).toLowerCase());
            }

            while (rs.next()) {
                jobList.add(extractJobFromResultSet(rs, columnNames));
            }
        } catch (SQLException e) {
            System.err.println("Error fetching jobs by status: " + e.getMessage());
            e.printStackTrace();
        }

        return jobList;
    }
    
    /**
     * Retrieves jobs by category
     * @param category The category of jobs to retrieve
     * @return List of Job objects in the specified category
     */
    public List<Job> getJobsByCategory(String category) {
        List<Job> jobList = new ArrayList<>();

        try (Connection conn = DatabaseConnection.getConnection()) {
            // Check if category column exists
            String columnName = "category";
            boolean categoryExists = false;
            
            try {
                DatabaseMetaData metaData = conn.getMetaData();
                ResultSet columns = metaData.getColumns(null, null, "jobs", "category");
                categoryExists = columns.next();
            } catch (SQLException e) {
                System.err.println("Error checking for category column: " + e.getMessage());
            }
            
            if (!categoryExists) {
                // If category column doesn't exist, use job_type instead
                columnName = "job_type";
            }
            
            String query = "SELECT * FROM jobs WHERE " + columnName + " = ? ORDER BY posted_date DESC";
            PreparedStatement stmt = conn.prepareStatement(query);
            stmt.setString(1, category);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                jobList.add(extractJobFromResultSet(rs));
            }
        } catch (SQLException e) {
            System.err.println("Error fetching jobs by category: " + e.getMessage());
            e.printStackTrace();
        }

        return jobList;
    }
    
    /**
     * Search for jobs by keyword
     * @param keyword The keyword to search for
     * @return List of Job objects matching the keyword
     */
    public List<Job> searchJobs(String keyword) {
        List<Job> jobList = new ArrayList<>();
        
        if (keyword == null || keyword.trim().isEmpty()) {
            return jobList;
        }
        
        // Format the keyword for SQL LIKE
        String searchTerm = "%" + keyword.trim() + "%";

        try (Connection conn = DatabaseConnection.getConnection()) {
            String query = "SELECT * FROM jobs WHERE " +
                          "title LIKE ? OR " +
                          "description LIKE ? OR " +
                          "company_name LIKE ? OR " +
                          "location LIKE ? OR " +
                          "job_type LIKE ? " +
                          "ORDER BY posted_date DESC";
            
            PreparedStatement stmt = conn.prepareStatement(query);
            stmt.setString(1, searchTerm);
            stmt.setString(2, searchTerm);
            stmt.setString(3, searchTerm);
            stmt.setString(4, searchTerm);
            stmt.setString(5, searchTerm);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                jobList.add(extractJobFromResultSet(rs));
            }
        } catch (SQLException e) {
            System.err.println("Error searching jobs: " + e.getMessage());
            e.printStackTrace();
        }

        return jobList;
    }
}
