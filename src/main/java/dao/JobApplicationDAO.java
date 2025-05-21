package dao;

import model.JobApplication;
import util.DatabaseConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * Data Access Object for JobApplication
 * Handles all database operations related to job applications
 */
public class JobApplicationDAO {
    
    /**
     * Get all job applications
     * @return List of all job applications
     */
    public List<JobApplication> getAllApplications() {
        List<JobApplication> applications = new ArrayList<>();
        
        try (Connection conn = DatabaseConnection.getConnection()) {
            String query = "SELECT a.*, j.title, j.company_name FROM job_applications a " +
                          "JOIN jobs j ON a.job_id = j.job_id " +
                          "ORDER BY a.application_date DESC";
            
            Statement stmt = conn.createStatement();
            ResultSet rs = stmt.executeQuery(query);
            
            while (rs.next()) {
                JobApplication application = extractApplicationFromResultSet(rs);
                applications.add(application);
            }
        } catch (SQLException e) {
            System.err.println("Error fetching job applications: " + e.getMessage());
            e.printStackTrace();
        }
        
        return applications;
    }
    
    /**
     * Get applications for a specific job
     * @param jobId The job ID
     * @return List of applications for the job
     */
    public List<JobApplication> getApplicationsByJobId(int jobId) {
        List<JobApplication> applications = new ArrayList<>();
        
        try (Connection conn = DatabaseConnection.getConnection()) {
            String query = "SELECT a.*, j.title, j.company_name FROM job_applications a " +
                          "JOIN jobs j ON a.job_id = j.job_id " +
                          "WHERE a.job_id = ? " +
                          "ORDER BY a.application_date DESC";
            
            PreparedStatement stmt = conn.prepareStatement(query);
            stmt.setInt(1, jobId);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                JobApplication application = extractApplicationFromResultSet(rs);
                applications.add(application);
            }
        } catch (SQLException e) {
            System.err.println("Error fetching applications by job ID: " + e.getMessage());
            e.printStackTrace();
        }
        
        return applications;
    }
    
    /**
     * Get applications for a specific user
     * @param userId The user ID
     * @return List of applications submitted by the user
     */
    public List<JobApplication> getApplicationsByUserId(int userId) {
        List<JobApplication> applications = new ArrayList<>();
        
        try (Connection conn = DatabaseConnection.getConnection()) {
            String query = "SELECT a.*, j.title, j.company_name FROM job_applications a " +
                          "JOIN jobs j ON a.job_id = j.job_id " +
                          "WHERE a.user_id = ? " +
                          "ORDER BY a.application_date DESC";
            
            PreparedStatement stmt = conn.prepareStatement(query);
            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                JobApplication application = extractApplicationFromResultSet(rs);
                applications.add(application);
            }
        } catch (SQLException e) {
            System.err.println("Error fetching applications by user ID: " + e.getMessage());
            e.printStackTrace();
        }
        
        return applications;
    }
    
    /**
     * Get a specific application by ID
     * @param applicationId The application ID
     * @return JobApplication object or null if not found
     */
    public JobApplication getApplicationById(int applicationId) {
        JobApplication application = null;
        
        try (Connection conn = DatabaseConnection.getConnection()) {
            String query = "SELECT a.*, j.title, j.company_name FROM job_applications a " +
                          "JOIN jobs j ON a.job_id = j.job_id " +
                          "WHERE a.application_id = ?";
            
            PreparedStatement stmt = conn.prepareStatement(query);
            stmt.setInt(1, applicationId);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                application = extractApplicationFromResultSet(rs);
            }
        } catch (SQLException e) {
            System.err.println("Error fetching application by ID: " + e.getMessage());
            e.printStackTrace();
        }
        
        return application;
    }
    
    /**
     * Insert a new job application into the database
     * @param application The JobApplication object to insert
     * @return true if successful, false otherwise
     */
    public boolean insertApplication(JobApplication application) {
        try (Connection conn = DatabaseConnection.getConnection()) {
            String query = "INSERT INTO job_applications (job_id, user_id, user_name, address, city, phone, email, " +
                          "additional_info, resume_path, cover_letter_path) " +
                          "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
            
            PreparedStatement stmt = conn.prepareStatement(query);
            stmt.setInt(1, application.getJobId());
            stmt.setInt(2, application.getUserId());
            stmt.setString(3, application.getUserName());
            stmt.setString(4, application.getAddress() != null ? application.getAddress() : "");
            stmt.setString(5, application.getCity() != null ? application.getCity() : "");
            stmt.setString(6, application.getPhone() != null ? application.getPhone() : "");
            stmt.setString(7, application.getEmail());
            stmt.setString(8, application.getAdditionalInfo() != null ? application.getAdditionalInfo() : "");
            stmt.setString(9, application.getResumePath() != null ? application.getResumePath() : "");
            stmt.setString(10, application.getCoverLetterPath() != null ? application.getCoverLetterPath() : "");
            
            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            System.err.println("Error inserting job application: " + e.getMessage());
            e.printStackTrace();
            
            // Try alternative query if position column exists
            if (e.getMessage().contains("position")) {
                return insertApplicationWithPosition(application);
            }
            
            return false;
        }
    }
    
    /**
     * Insert application with position field (fallback method)
     */
    private boolean insertApplicationWithPosition(JobApplication application) {
        try (Connection conn = DatabaseConnection.getConnection()) {
            String query = "INSERT INTO job_applications (job_id, user_id, user_name, address, city, phone, email, " +
                          "additional_info, position, resume_path, cover_letter_path) " +
                          "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
            
            PreparedStatement stmt = conn.prepareStatement(query);
            stmt.setInt(1, application.getJobId());
            stmt.setInt(2, application.getUserId());
            stmt.setString(3, application.getUserName());
            stmt.setString(4, application.getAddress() != null ? application.getAddress() : "");
            stmt.setString(5, application.getCity() != null ? application.getCity() : "");
            stmt.setString(6, application.getPhone() != null ? application.getPhone() : "");
            stmt.setString(7, application.getEmail());
            stmt.setString(8, application.getAdditionalInfo() != null ? application.getAdditionalInfo() : "");
            stmt.setString(9, application.getPosition() != null ? application.getPosition() : "");
            stmt.setString(10, application.getResumePath() != null ? application.getResumePath() : "");
            stmt.setString(11, application.getCoverLetterPath() != null ? application.getCoverLetterPath() : "");
            
            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            System.err.println("Error in fallback insert: " + e.getMessage());
            return false;
        }
    }
    
    /**
     * Update the status of a job application
     * @param applicationId The application ID
     * @param status The new status (e.g., "Approved", "Rejected", "Pending")
     * @return true if successful, false otherwise
     */
    public boolean updateApplicationStatus(int applicationId, String status) {
        try (Connection conn = DatabaseConnection.getConnection()) {
            String query = "UPDATE job_applications SET status = ? WHERE application_id = ?";
            
            PreparedStatement stmt = conn.prepareStatement(query);
            stmt.setString(1, status);
            stmt.setInt(2, applicationId);
            
            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            System.err.println("Error updating application status: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Update an existing job application
     * @param application The JobApplication object with updated values
     * @return true if successful, false otherwise
     */
    public boolean updateApplication(JobApplication application) {
        try (Connection conn = DatabaseConnection.getConnection()) {
            String query = "UPDATE job_applications SET user_name = ?, address = ?, city = ?, " +
                          "phone = ?, email = ?, additional_info = ?, status = ? " +
                          "WHERE application_id = ?";
            
            PreparedStatement stmt = conn.prepareStatement(query);
            stmt.setString(1, application.getUserName());
            stmt.setString(2, application.getAddress());
            stmt.setString(3, application.getCity());
            stmt.setString(4, application.getPhone());
            stmt.setString(5, application.getEmail());
            stmt.setString(6, application.getAdditionalInfo());
            stmt.setString(7, application.getStatus());
            stmt.setInt(8, application.getApplicationId());
            
            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            System.err.println("Error updating job application: " + e.getMessage());
            e.printStackTrace();
            
            // Try with position if that column exists
            if (e.getMessage().contains("position")) {
                try (Connection conn = DatabaseConnection.getConnection()) {
                    String query = "UPDATE job_applications SET user_name = ?, address = ?, city = ?, " +
                                  "phone = ?, email = ?, additional_info = ?, position = ?, status = ? " +
                                  "WHERE application_id = ?";
                    
                    PreparedStatement stmt = conn.prepareStatement(query);
                    stmt.setString(1, application.getUserName());
                    stmt.setString(2, application.getAddress());
                    stmt.setString(3, application.getCity());
                    stmt.setString(4, application.getPhone());
                    stmt.setString(5, application.getEmail());
                    stmt.setString(6, application.getAdditionalInfo());
                    stmt.setString(7, application.getPosition());
                    stmt.setString(8, application.getStatus());
                    stmt.setInt(9, application.getApplicationId());
                    
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
     * Delete a job application from the database
     * @param applicationId The ID of the application to delete
     * @return true if successful, false otherwise
     */
    public boolean deleteApplication(int applicationId) {
        try (Connection conn = DatabaseConnection.getConnection()) {
            String query = "DELETE FROM job_applications WHERE application_id = ?";
            
            PreparedStatement stmt = conn.prepareStatement(query);
            stmt.setInt(1, applicationId);
            
            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            System.err.println("Error deleting job application: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Helper method to extract a JobApplication object from a ResultSet
     */
    private JobApplication extractApplicationFromResultSet(ResultSet rs) throws SQLException {
        JobApplication application = new JobApplication();
        
        application.setApplicationId(rs.getInt("application_id"));
        application.setJobId(rs.getInt("job_id"));
        
        // Handle user_id if it exists
        try {
            application.setUserId(rs.getInt("user_id"));
        } catch (SQLException e) {
            // Column might not exist, ignore
        }
        
        application.setUserName(rs.getString("user_name"));
        
        // Handle applicant_name if it exists (for backward compatibility)
        try {
            String applicantName = rs.getString("applicant_name");
            if (applicantName != null && !applicantName.isEmpty()) {
                application.setApplicantName(applicantName);
            }
        } catch (SQLException e) {
            // Column might not exist, ignore
        }
        
        application.setAddress(rs.getString("address"));
        application.setCity(rs.getString("city"));
        application.setPhone(rs.getString("phone"));
        application.setEmail(rs.getString("email"));
        application.setAdditionalInfo(rs.getString("additional_info"));
        
        // Handle position if it exists
        try {
            application.setPosition(rs.getString("position"));
        } catch (SQLException e) {
            // Column might not exist, ignore
        }
        
        application.setResumePath(rs.getString("resume_path"));
        application.setCoverLetterPath(rs.getString("cover_letter_path"));
        
        // Handle application_date
        try {
            application.setApplicationDate(rs.getDate("application_date"));
        } catch (SQLException e) {
            // Column might not exist or be null
        }
        
        // Handle status
        try {
            application.setStatus(rs.getString("status"));
        } catch (SQLException e) {
            // Column might not exist, set default
            application.setStatus("Pending");
        }
        
        // Set job details for display
        try {
            application.setJobTitle(rs.getString("title"));
            application.setCompanyName(rs.getString("company_name"));
        } catch (SQLException e) {
            // These columns might not be in the result set if not joined with jobs table
        }
        
        return application;
    }
}