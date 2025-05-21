package model;

public class Job {
    private int jobId;
    private String title;
    private String jobType;
    private String description;
    private String companyName;
    private String location;
    private String salary;
    private String requirements;
    private String applicationDeadline;
    private String jobStatus;
    private String postedDate;
    private Integer postedBy;

    // Constructor
    public Job(int jobId, String title, String jobType, String description, String companyName,
               String location, String salary, String requirements, String applicationDeadline,
               String jobStatus, String postedDate, Integer postedBy) {
        this.jobId = jobId;
        this.title = title;
        this.jobType = jobType;
        this.description = description;
        this.companyName = companyName;
        this.location = location;
        this.salary = salary;
        this.requirements = requirements;
        this.applicationDeadline = applicationDeadline;
        this.jobStatus = jobStatus;
        this.postedDate = postedDate;
        this.postedBy = postedBy;
    }

    // Getters and Setters
    public int getJobId() {
        return jobId;
    }

    public void setJobId(int jobId) {
        this.jobId = jobId;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getJobType() {
        return jobType;
    }

    public void setJobType(String jobType) {
        this.jobType = jobType;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getCompanyName() {
        return companyName;
    }

    public void setCompanyName(String companyName) {
        this.companyName = companyName;
    }

    public String getLocation() {
        return location;
    }

    public void setLocation(String location) {
        this.location = location;
    }

    public String getSalary() {
        return salary;
    }

    public void setSalary(String salary) {
        this.salary = salary;
    }

    public String getRequirements() {
        return requirements;
    }

    public void setRequirements(String requirements) {
        this.requirements = requirements;
    }

    public String getApplicationDeadline() {
        return applicationDeadline;
    }

    public void setApplicationDeadline(String applicationDeadline) {
        this.applicationDeadline = applicationDeadline;
    }

    /**
     * Get the job status
     * @return The job status
     */
    public String getJobStatus() {
        // If status is null or empty, return "Pending" as default
        if (jobStatus == null || jobStatus.trim().isEmpty()) {
            return "Pending";
        }
        return jobStatus;
    }

    /**
     * Set the job status
     * @param jobStatus The job status to set
     */
    public void setJobStatus(String jobStatus) {
        this.jobStatus = jobStatus;
    }

    public String getPostedDate() {
        return postedDate;
    }

    public void setPostedDate(String postedDate) {
        this.postedDate = postedDate;
    }

    public Integer getPostedBy() {
        return postedBy;
    }

    public void setPostedBy(Integer postedBy) {
        this.postedBy = postedBy;
    }
}