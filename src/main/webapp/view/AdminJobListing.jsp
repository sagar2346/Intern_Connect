<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="dao.JobDAO" %>
<%@ page import="model.Job" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="filter.JobFilter" %>
<!DOCTYPE html>
<html>
<head>
    <title>Admin Job Listing | InternConnect</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin_dashboard.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <style>
        /* Job Listing Specific Styles */
        .job-listing-container {
            padding: 20px;
        }

        .job-filters {
            display: flex;
            gap: 15px;
            margin-bottom: 20px;
            flex-wrap: wrap;
        }

        .filter-group {
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .filter-group select, .filter-group input {
            padding: 8px 12px;
            border-radius: 8px;
            border: 1px solid #D6C8BE;
            background-color: #EFE6DD;
        }

        .filter-button {
            padding: 8px 16px;
            background-color: #8C7B6B;
            color: white;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            transition: background-color 0.2s;
        }

        .filter-button:hover {
            background-color: #7A6A5B;
        }

        .job-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
            gap: 20px;
        }

        .job-card {
            background-color: #D6C8BE;
            border-radius: 12px;
            padding: 20px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.05);
            transition: transform 0.2s, box-shadow 0.2s;
        }

        .job-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 6px 12px rgba(0, 0, 0, 0.1);
        }

        .job-card h3 {
            margin-top: 0;
            margin-bottom: 10px;
            color: #2A2A2A;
        }

        .job-card p {
            margin: 5px 0;
            color: #2A2A2A;
        }

        .job-card .badge {
            display: inline-block;
            padding: 6px 12px;
            border-radius: 20px;
            font-size: 14px;
            font-weight: 600;
            margin-top: 12px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }
        
        .badge.pending {
            background-color: #FFD966;
            color: #2A2A2A;
        }
        
        .badge.pending::before {
            content: "⏳ ";
        }
        
        .badge.approved {
            background-color: #C6F6C6;
            color: #155724;
        }
        
        .badge.approved::before {
            content: "✓ ";
        }
        
        .badge.rejected {
            background-color: #F8B6B6;
            color: #721C24;
        }
        
        .badge.rejected::before {
            content: "✗ ";
        }
        
        /* Status filter highlight */
        #status option:checked {
            background-color: #D6C8BE;
            font-weight: bold;
        }

        .job-actions {
            display: flex;
            gap: 10px;
            margin-top: 15px;
        }

        .job-actions a {
            padding: 8px 12px;
            border-radius: 6px;
            text-decoration: none;
            font-size: 14px;
            font-weight: 500;
            text-align: center;
            flex: 1;
            transition: background-color 0.2s;
        }

        .view-btn {
            background-color: #8C7B6B;
            color: white;
        }

        .view-btn:hover {
            background-color: #7A6A5B;
        }

        .edit-btn {
            background-color: #FFD966;
            color: #2A2A2A;
        }

        .edit-btn:hover {
            background-color: #E6C35A;
        }

        .delete-btn {
            background-color: #F8B6B6;
            color: #2A2A2A;
        }

        .delete-btn:hover {
            background-color: #E69595;
        }

        .approve-btn {
            background-color: #C6F6C6;
            color: #2A2A2A;
        }

        .approve-btn:hover {
            background-color: #A5E6A5;
        }

        .no-jobs {
            text-align: center;
            padding: 40px;
            background-color: #D6C8BE;
            border-radius: 12px;
            grid-column: 1 / -1;
        }

        .job-count {
            margin-bottom: 20px;
            font-size: 16px;
            color: #2A2A2A;
        }

        .post-job-btn {
            display: inline-block;
            padding: 10px 20px;
            background-color: #8C7B6B;
            color: white;
            text-decoration: none;
            border-radius: 8px;
            margin-bottom: 20px;
            transition: background-color 0.2s;
        }

        .post-job-btn:hover {
            background-color: #7A6A5B;
        }
    </style>
</head>
<body>

<%
    // Check if admin is logged in
    if (session.getAttribute("adminId") == null) {
        response.sendRedirect(request.getContextPath() + "/view/AdminLogin.jsp");
        return;
    }

    // Get filter parameters
    String statusFilter = request.getParameter("status");
    String searchQuery = request.getParameter("search");

    // Get all jobs
    JobDAO jobDAO = new JobDAO();
    List<Job> allJobs = jobDAO.getAllJobs();
    
    // Apply filters if needed
    if (statusFilter != null && !statusFilter.isEmpty() && !statusFilter.equals("all")) {
        allJobs.removeIf(job -> {
            String jobStatus = job.getJobStatus();
            // Handle null status as "Pending"
            if (jobStatus == null) jobStatus = "Pending";
            return !jobStatus.equalsIgnoreCase(statusFilter);
        });
    }
    
    if (searchQuery != null && !searchQuery.isEmpty()) {
        allJobs.removeIf(job -> 
            !job.getTitle().toLowerCase().contains(searchQuery.toLowerCase()) && 
            !job.getCompanyName().toLowerCase().contains(searchQuery.toLowerCase())
        );
    }
    
    // Debug information
    System.out.println("Status filter: " + statusFilter);
    System.out.println("Search query: " + searchQuery);
    System.out.println("Total jobs after filtering: " + allJobs.size());
%>

<div class="dashboard-container">
    <!-- Sidebar -->
    <aside class="sidebar">
        <h2 class="sidebar-title"><i class="fa fa-chart-line"></i> Admin Portal</h2>
        <ul class="sidebar-menu">
            <li><a href="${pageContext.request.contextPath}/view/Admin_dashboard.jsp"><i class="fa fa-home"></i> Overview</a></li>
            <li class="active"><i class="fa fa-briefcase"></i> Jobs</li>
            <li><a href="${pageContext.request.contextPath}/view/postjob.jsp" class="post-job-link"><i class="fa fa-plus-circle"></i> Post Job</a></li>
            <li><a href="${pageContext.request.contextPath}/view/ApplicationManagement.jsp"><i class="fa fa-file-alt"></i> Applications</a></li>
            <li><a href="#"><i class="fa fa-users"></i> Users</a></li>
            <li><a href="${pageContext.request.contextPath}/LogoutServlet"><i class="fa fa-sign-out-alt"></i> Logout</a></li>
        </ul>
    </aside>

    <!-- Main Content -->
    <main class="main-content">
        <!-- Header -->
        <div class="dashboard-header">
            <div>
                <h1>Job Listings</h1>
                <p>Manage all job postings</p>
            </div>
            <div class="search-profile-wrapper">
                <div class="search-input-container">
                    <i class="fa fa-search"></i>
                    <input type="text" placeholder="Search...">
                </div>
                <div class="profile-icon">
                    <i class="fa fa-user"></i>
                </div>
            </div>
        </div>

        <div class="job-listing-container">
            <!-- Filters and Actions -->
            <div class="job-filters">
                <form action="${pageContext.request.contextPath}/view/AdminJobListing.jsp" method="get" id="filterForm">
                    <div class="filter-group">
                        <label for="status">Status:</label>
                        <select name="status" id="status" onchange="this.form.submit()">
                            <option value="all" <%= (statusFilter == null || statusFilter.equals("all")) ? "selected" : "" %>>All Jobs</option>
                            <option value="Approved" <%= (statusFilter != null && statusFilter.equals("Approved")) ? "selected" : "" %>>Approved</option>
                            <option value="Pending" <%= (statusFilter != null && statusFilter.equals("Pending")) ? "selected" : "" %>>Pending</option>
                            <option value="Rejected" <%= (statusFilter != null && statusFilter.equals("Rejected")) ? "selected" : "" %>>Rejected</option>
                        </select>
                        
                        <label for="search">Search:</label>
                        <input type="text" name="search" id="search" placeholder="Search by job title or company" value="<%= searchQuery != null ? searchQuery : "" %>">
                        
                        <button type="submit" class="filter-button">
                            <i class="fa fa-filter"></i> Apply Filters
                        </button>
                        


                    </div>
                </form>
            </div>

            <a href="${pageContext.request.contextPath}/view/postjob.jsp" class="post-job-btn">
                <i class="fa fa-plus-circle"></i> Post New Job
            </a>

            <div class="job-count">
                <strong>Total:</strong> <%= allJobs.size() %> jobs found
            </div>

            <!-- Job Grid -->
            <div class="job-grid">
                <% if (allJobs.isEmpty()) { %>
                <div class="no-jobs">
                    <h3>No jobs found</h3>
                    <p>There are no jobs matching your criteria.</p>
                </div>
                <% } else { %>
                <% for (Job job : allJobs) {
                    // Determine badge class based on job status
                    String badgeClass = "pending";
                    if (job.getJobStatus() != null) {
                        if (job.getJobStatus().equalsIgnoreCase("Approved")) {
                            badgeClass = "approved";
                        } else if (job.getJobStatus().equalsIgnoreCase("Rejected")) {
                            badgeClass = "rejected";
                        }
                    }
                %>
                <div class="job-card">
                    <h3><%= job.getTitle() %></h3>
                    <p><strong>Company:</strong> <%= job.getCompanyName() %></p>
                    <p><strong>Location:</strong> <%= job.getLocation() %></p>
                    <% if (job.getSalary() != null && !job.getSalary().isEmpty()) { %>
                    <p><strong>Salary:</strong> <%= job.getSalary() %></p>
                    <% } %>
                    <p><strong>Type:</strong> <%= job.getJobType() %></p>
                    <p><strong>Posted:</strong> <%= job.getPostedDate() %></p>
                    <span class="badge <%= badgeClass %>"><%= job.getJobStatus() != null ? job.getJobStatus() : "Pending" %></span>

                    <div class="job-actions">
                        <a href="${pageContext.request.contextPath}/view/JobDetail.jsp?id=<%= job.getJobId() %>" class="view-btn">
                            <i class="fa fa-eye"></i> View
                        </a>
                        <a href="${pageContext.request.contextPath}/view/EditJob.jsp?id=<%= job.getJobId() %>" class="edit-btn">
                            <i class="fa fa-edit"></i> Edit
                        </a>
                        <% if (job.getJobStatus() == null || job.getJobStatus().equalsIgnoreCase("Pending")) { %>
                        <a href="${pageContext.request.contextPath}/ApproveJobServlet?id=<%= job.getJobId() %>" class="approve-btn">
                            <i class="fa fa-check"></i> Approve
                        </a>
                        <% } else { %>
                        <a href="${pageContext.request.contextPath}/RejectJobServlet?id=<%= job.getJobId() %>" class="delete-btn">
                            <i class="fa fa-trash"></i> Delete
                        </a>
                        <% } %>
                    </div>
                </div>
                <% } %>
                <% } %>
            </div>
        </div>
    </main>
</div>

<script>
    // Function to clear all filters
    function clearFilters() {
        window.location.href = "${pageContext.request.contextPath}/view/AdminJobListing.jsp";
    }
    
    // Function to highlight active filters
    document.addEventListener("DOMContentLoaded", function() {
        const statusFilter = document.getElementById("status");
        if (statusFilter.value !== "all") {
            statusFilter.style.backgroundColor = "#EFE6DD";
            statusFilter.style.fontWeight = "bold";
        }
        
        const searchInput = document.getElementById("search");
        if (searchInput.value !== "") {
            searchInput.style.backgroundColor = "#EFE6DD";
            searchInput.style.fontWeight = "bold";
        }
    });
</script>

</body>
</html>
