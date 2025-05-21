<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="dao.JobDAO" %>
<%@ page import="dao.JobApplicationDAO" %>
<%@ page import="dao.AdminDAO" %>
<%@ page import="model.Job" %>
<%@ page import="model.JobApplication" %>
<%@ page import="model.Contact" %>
<%@ page import="filter.JobFilter" %>
<%@ page import="java.util.List" %>
<%@ page import="java.sql.*" %>
<%@ page import="util.DatabaseConnection" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="util.ApplicationFetcher" %>
<%@ page import="dao.ContactDAO" %>
<!DOCTYPE html>
<html>
<head>
    <title>Admin Dashboard | InternConnect</title>
    <!-- Link to CSS with dynamic context path -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin_dashboard.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
</head>
<style>


    /* General Styles */
    body {
        margin: 0;
        font-family: 'Segoe UI', sans-serif;
        background-color: #EFE6DD;
        color: #2A2A2A;
        min-height: 100vh;
        width: 100%;
    }

    .dashboard-container {
        display: flex;
        min-height: 100vh;
        width: 100%;
    }

    /* Sidebar */
    .sidebar {
        width: 250px;
        background-color: #D6C8BE;
        padding: 30px 20px;
        min-height: 100vh;
        position: sticky;
        top: 0;
    }

    .sidebar-title {
        font-size: 30px;
        font-weight: bold;
        margin-bottom: 40px;
    }

    .sidebar-menu {
        list-style: none;
        padding: 0;
    }

    .sidebar-menu li {
        padding: 12px 0;
        font-size: 20px;
        cursor: pointer;
    }

    .sidebar-menu li i {
        margin-right: 10px;
    }

    .sidebar-menu li a {
        text-decoration: none;
        color: inherit;
        font-size: 20px;
        display: block;
    }


    /* Main Content */
    .main-content {
        flex: 1;
        padding: 30px 50px;
        width: calc(100% - 250px);
        overflow-x: hidden;
    }

    /* Header */
    .dashboard-header {
        display: flex;
        justify-content: space-between;
        align-items: center;
        padding: 30px 0;
        background-color: #EFE6DD;
    }

    .dashboard-header h1 {
        font-size: 38px;
        margin: 0;
        color: #2A2A2A;
    }

    .dashboard-header p {
        font-size: 18px;
        color: #444;
        margin: 4px 0 0 0;
    }

    .search-profile-wrapper {
        display: flex;
        align-items: center;
        gap: 18px;
    }

    .search-input-container {
        position: relative;
        background-color: #fff;
        border-radius: 10px;
        box-shadow: 0 4px 10px rgba(0, 0, 0, 0.08);
        padding: 14px 18px;
        display: flex;
        align-items: center;
        width: 330px;
    }

    .search-input-container i {
        font-size: 18px;
        color: #999;
        margin-right: 10px;
    }

    .search-input-container input[type="text"] {
        border: none;
        outline: none;
        font-size: 16px;
        flex: 1;
        color: #2A2A2A;
        background-color: transparent;
    }

    .profile-icon {
        background-color: #D6C8BE;
        width: 48px;
        height: 48px;
        border-radius: 50%;
        display: flex;
        justify-content: center;
        align-items: center;
    }

    .profile-icon i {
        font-size: 22px;
        color: #2A2A2A;
    }

    /* Stats Cards */
    .stats-cards {
        display: flex;
        flex-wrap: wrap;
        gap: 20px;
        margin-bottom: 40px;
        width: 100%;
    }

    .card, .stat-card {
        background-color: #D6C8BE;
        padding: 30px;
        border-radius: 12px;
        flex: 1;
        min-width: 200px;
        text-align: center;
        box-shadow: 0 5px 10px rgba(0, 0, 0, 0.05);
    }

    .card i {
        font-size: 26px;
        margin-bottom: 10px;
    }

    .card h3 {
        font-size: 26px;
        margin: 5px 0;
    }

    /* Section Wrapper */
    .section {
        margin-bottom: 40px;
    }

    .section h2 {
        margin-bottom: 20px;
    }

    /* Table */
    table {
        width: 100%;
        border-collapse: collapse;
        font-size: 16px;
    }

    /* Scrollable Table Container */
    .table-container {
        width: 100%;
        max-height: 400px;
        overflow-y: auto;
        margin-bottom: 20px;
        border-radius: 8px;
        box-shadow: 0 2px 5px rgba(0,0,0,0.1);
    }

    /* Sticky Table Header */
    .table-container thead th {
        position: sticky;
        top: 0;
        z-index: 10;
        background-color: #D6C8BE;
    }

    /* Scrollbar Styling */
    .table-container::-webkit-scrollbar {
        width: 8px;
    }

    .table-container::-webkit-scrollbar-track {
        background: #f1f1f1;
        border-radius: 4px;
    }

    .table-container::-webkit-scrollbar-thumb {
        background: #D6C8BE;
        border-radius: 4px;
    }

    .table-container::-webkit-scrollbar-thumb:hover {
        background: #C6B5A8;
    }

    /* Job Actions Styling */
    .job-actions {
        display: flex;
        gap: 5px;
        margin-top: 5px;
    }

    .approve-btn, .reject-btn {
        padding: 3px 8px;
        border-radius: 4px;
        font-size: 12px;
        text-decoration: none;
        text-align: center;
        cursor: pointer;
        transition: all 0.2s ease;
    }

    .approve-btn {
        background-color: #C6F6C6;
        color: #2A2A2A;
    }

    .reject-btn {
        background-color: #F8B6B6;
        color: #2A2A2A;
    }

    .approve-btn:hover {
        background-color: #A5E6A5;
    }

    .reject-btn:hover {
        background-color: #E69595;
    }

    .job-status {
        font-size: 12px;
        padding: 3px 8px;
        border-radius: 4px;
        display: inline-block;
        margin-top: 5px;
    }

    .job-status.approved {
        background-color: #C6F6C6;
        color: #2A2A2A;
    }

    .job-status.rejected {
        background-color: #F8B6B6;
        color: #2A2A2A;
    }

    thead th {
        background-color: #D6C8BE;
        color: #2A2A2A;
        padding: 16px 20px;
        text-align: left;
    }

    tbody td {
        padding: 16px 20px;
        vertical-align: middle;
        background-color: #EFE6DD;
        color: #2A2A2A;
        border-bottom: 2px solid #D6C8BE;
        font-size: 16px;
        line-height: 1.5;
    }

    td i {
        font-size: 18px;
        margin-right: 10px;
        cursor: pointer;
    }

    /* Badges */
    .badge {
        padding: 5px 12px;
        border-radius: 20px;
        font-size: 14px;
        font-weight: bold;
        display: inline-block;
        text-align: center;
    }

    .badge.pending {
        background-color: #FFD966;
        color: #2A2A2A;
    }

    .badge.approved {
        background-color: #C6F6C6;
        color: #2A2A2A;
    }

    .badge.rejected {
        background-color: #F8B6B6;
        color: #2A2A2A;
    }

    /* Active Users Section */
    .users-list {
        display: flex;
        flex-wrap: wrap;

    }

    .user-card {
        display: flex;
        align-items: center;
        background-color: #D6C8BE;
        padding: 16px 10px;
        border-radius: 16px;
        width: 30%;
        margin:1%;
        box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
        transition: transform 0.2s ease;
    }

    .user-card:hover {
        transform: translateY(-3px);
    }

    .user-card i {
        font-size: 40px;
        color: #2A2A2A;
        background-color: #EFE6DD;
        border-radius: 50%;
        padding: 12px;
        margin-right: 20px;
    }

    .user-card h4 {
        margin: 0;
        font-size: 18px;
        color: #2A2A2A;
    }

    .user-card p {
        margin: 6px 0;
        font-size: 14px;
        color: #2A2A2A;
    }

    .status-badge {
        display: inline-block;
        padding: 6px 12px;
        font-size: 12px;
        border-radius: 16px;
        font-weight: 600;
        margin-top: 4px;
    }

    .status-active {
        background-color: #C6F6C6;
        color: #2A2A2A;
    }

    .status-away {
        background-color: #E0E0E0;
        color: #2A2A2A;
    }

    /* Responsive Layouts */
    @media (max-width: 1200px) {
        .user-card {
            width: calc(48%);
        }

        .stats-cards {
            flex-wrap: wrap;
        }

        .card, .stat-card {
            min-width: calc(50% - 20px);
        }
    }

    @media (max-width: 768px) {
        .dashboard-container {
            flex-direction: column;
        }

        .sidebar {
            width: 100%;
            min-height: auto;
            padding: 20px;
        }

        .main-content {
            width: 100%;
            padding: 20px;
        }

        .card, .stat-card {
            min-width: 100%;
        }
    }

    .view-all-link {
        text-align: right;
        margin-top: 15px;
    }

    .view-all-link a {
        display: inline-block;
        color: #2A2A2A;
        text-decoration: none;
        font-weight: bold;
        font-size: 16px;
        transition: color 0.2s;
    }

    .view-all-link a:hover {
        color: #8C7B6B;
    }

    .view-all-link i {
        margin-left: 5px;
    }


</style>
<body>

<%
    // Get admin details from session
    Integer adminId = (Integer) session.getAttribute("adminId");
    String adminName = (String) session.getAttribute("adminName");

    // Default name if not logged in
    if (adminName == null) {
        adminName = "Admin";
    }

    // Fetch recent jobs using JobDAO
    JobDAO jobDAO = new JobDAO();
    List<Job> recentJobs = jobDAO.getAllJobs();

    // Count statistics using the JobFilter
    int totalJobs = recentJobs.size();
    int pendingJobs = 0;
    int approvedJobs = 0;

    // Count manually if JobFilter methods aren't working
    for (Job job : recentJobs) {
        if (job.getJobStatus() != null) {
            if (job.getJobStatus().equalsIgnoreCase("Approved")) {
                approvedJobs++;
            } else if (job.getJobStatus().equalsIgnoreCase("Pending")) {
                pendingJobs++;
            }
        } else {
            pendingJobs++; // Count null status as pending
        }
    }

    // Count total users using direct database query
    int totalUsers = 0;
    try (Connection conn = DatabaseConnection.getConnection();
         Statement stmt = conn.createStatement();
         ResultSet rs = stmt.executeQuery("SELECT COUNT(*) AS user_count FROM user")) {
        if (rs.next()) {
            totalUsers = rs.getInt("user_count");
        }
    } catch (Exception e) {
        System.err.println("Error counting users: " + e.getMessage());
    }
%>

<%
    ContactDAO contactDAO = new ContactDAO();
    int unreadMessages = contactDAO.getUnreadCount();
%>

<div class="dashboard-container">

    <!-- Sidebar -->
    <aside class="sidebar">
        <h2 class="sidebar-title"><i class="fa fa-chart-line"></i> Admin Portal</h2>
        <ul class="sidebar-menu">
            <li class="active"><i class="fa fa-home"></i> Overview</li>
            <li><a href="${pageContext.request.contextPath}/view/AdminJobListing.jsp"><i class="fa fa-briefcase"></i> Jobs</a></li>
            <li><a href="${pageContext.request.contextPath}/view/postjob.jsp" class="post-job-link"><i class="fa fa-plus-circle"></i> Post Job</a></li>
            <li><a href="${pageContext.request.contextPath}/view/ApplicationManagement.jsp"><i class="fa fa-file-alt"></i> Applications</a></li>
            <li><i class="fa fa-users"></i> Users</li>
            <li><a href="${pageContext.request.contextPath}/LogoutServlet"><i class="fa fa-sign-out-alt"></i> Logout</a></li>
        </ul>
    </aside>

    <!-- Main Content -->
    <main class="main-content">

        <!-- Header -->
        <div class="dashboard-header">
            <div>
                <h1>Dashboard</h1>
                <p>Welcome back, <%= adminName %></p>
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

        <!-- Stats Cards -->
        <div class="stats-cards">
            <div class="card">
                <i class="fa fa-briefcase"></i>
                <h3><%= totalJobs %></h3>
                <p>Total Jobs</p>
            </div>
            <div class="card">
                <i class="fa fa-check-circle"></i>
                <h3><%= approvedJobs %></h3>
                <p>Approved Jobs</p>
            </div>
            <div class="card">
                <i class="fa fa-clock"></i>
                <h3><%= pendingJobs %></h3>
                <p>Pending Approval</p>
            </div>
            <div class="card">
                <i class="fa fa-users"></i>
                <h3><%= totalUsers %></h3>
                <p>Active Users</p>
            </div>
            <div class="stat-card">
                <div class="stat-icon">
                    <i class="fas fa-envelope"></i>
                </div>
                <div class="stat-info">
                    <h3><%= unreadMessages %></h3>
                    <p>Unread Messages</p>
                </div>
                <a href="${pageContext.request.contextPath}/view/AdminContactMessages.jsp" class="stat-link">
                    View All
                </a>
            </div>
        </div>

        <!-- Recent Jobs Table -->
        <div class="section">
            <h2>Recent Job Postings</h2>
            <div class="table-container">
                <table>
                    <thead>
                    <tr>
                        <th>Job Title</th>
                        <th>Company</th>
                        <th>Status</th>
                        <th>Posted Date</th>
                        <th>Posted By</th>
                        <th>Actions</th>
                    </tr>
                    </thead>
                    <tbody>
                    <%
                        // Display all jobs with scrolling
                        int count = 0;
                        for (Job job : recentJobs) {
                            // Get admin name who posted the job
                            String postedByName = "Admin";
                            if (job.getPostedBy() != null) {
                                try (Connection conn = DatabaseConnection.getConnection()) {
                                    PreparedStatement stmt = conn.prepareStatement("SELECT name FROM admin WHERE admin_id = ?");
                                    stmt.setInt(1, job.getPostedBy());
                                    ResultSet rs = stmt.executeQuery();
                                    if (rs.next()) {
                                        postedByName = rs.getString("name");
                                    }
                                } catch (Exception e) {
                                    // Use default name if query fails
                                }
                            }

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
                    <tr>
                        <td><%= job.getTitle() %></td>
                        <td><%= job.getCompanyName() %></td>
                        <td><span class="badge <%= badgeClass %>"><%= job.getJobStatus() != null ? job.getJobStatus() : "Pending" %></span></td>
                        <td><%= job.getPostedDate() %></td>
                        <td><%= postedByName %></td>
                        <td>
                            <a href="${pageContext.request.contextPath}/view/JobDetail.jsp?id=<%= job.getJobId() %>" title="View Details"><i class="fa fa-eye"></i></a>
                            <!-- For pending jobs, show approve/reject buttons -->
                            <% if (job.getJobStatus() == null || job.getJobStatus().equalsIgnoreCase("Pending")) { %>
                                <div class="job-actions">
                                    <a href="${pageContext.request.contextPath}/ApproveJobServlet?id=<%= job.getJobId() %>" class="approve-btn">Approve</a>
                                    <a href="${pageContext.request.contextPath}/RejectJobServlet?id=<%= job.getJobId() %>" class="reject-btn">Reject</a>
                                </div>
                            <% } else if (job.getJobStatus().equalsIgnoreCase("Approved")) { %>
                                <div class="job-status approved">Approved</div>
                            <% } else if (job.getJobStatus().equalsIgnoreCase("Rejected")) { %>
                                <div class="job-status rejected">Rejected</div>
                            <% } %>
                        </td>
                    </tr>
                    <%
                            count++;
                        }

                        // If no jobs found, display a message
                        if (recentJobs.isEmpty()) {
                    %>
                    <tr>
                        <td colspan="6" style="text-align: center;">No job postings found</td>
                    </tr>
                    <%
                        }
                    %>
                    </tbody>
                </table>
            </div>
        </div>

        <div class="view-all-link">
            <a href="${pageContext.request.contextPath}/view/AdminJobListing.jsp">View All Jobs <i class="fa fa-arrow-right"></i></a>
        </div>

        <!-- Recent Applications Table -->
        <div class="section">
            <h2>Recent Applications</h2>
            <div class="table-container">
                <table>
                    <thead>
                    <tr>
                        <th>Applicant</th>
                        <th>Job Title</th>
                        <th>Company</th>
                        <th>Status</th>
                        <th>Applied Date</th>
                        <th>Actions</th>
                    </tr>
                    </thead>
                    <tbody>
                    <%
                        // Fetch recent applications directly using JobApplicationDAO
                        JobApplicationDAO applicationDAO = new JobApplicationDAO();
                        List<JobApplication> recentApplications = applicationDAO.getAllApplications();

                        // Display applications with scrolling
                        if (recentApplications != null && !recentApplications.isEmpty()) {
                            for (JobApplication app : recentApplications) {
                                // Determine badge class based on application status
                                String appBadgeClass = "pending";
                                if (app.getStatus() != null) {
                                    if (app.getStatus().equalsIgnoreCase("Approved")) {
                                        appBadgeClass = "approved";
                                    } else if (app.getStatus().equalsIgnoreCase("Rejected")) {
                                        appBadgeClass = "rejected";
                                    }
                                }
                    %>
                    <tr>
                        <td><%= app.getUserName() != null ? app.getUserName() : "Unknown" %></td>
                        <td><%= app.getJobTitle() != null ? app.getJobTitle() : "Unknown" %></td>
                        <td><%= app.getCompanyName() != null ? app.getCompanyName() : "Unknown" %></td>
                        <td><span class="badge <%= appBadgeClass %>"><%= app.getStatus() != null ? app.getStatus() : "Pending" %></span></td>
                        <td><%= app.getApplicationDate() != null ? app.getApplicationDate() : "Unknown" %></td>
                        <td>
                            <a href="${pageContext.request.contextPath}/view/ApplicationDetail.jsp?id=<%= app.getApplicationId() %>" title="View Details"><i class="fa fa-eye"></i></a>
                            <!-- For pending applications, show approve/reject buttons -->
                            <% if (app.getStatus() == null || app.getStatus().equalsIgnoreCase("Pending")) { %>
                                <div class="job-actions">
                                    <a href="${pageContext.request.contextPath}/ApproveApplicationServlet?id=<%= app.getApplicationId() %>" class="approve-btn">Approve</a>
                                    <a href="${pageContext.request.contextPath}/RejectApplicationServlet?id=<%= app.getApplicationId() %>" class="reject-btn">Reject</a>
                                </div>
                            <% } %>
                        </td>
                    </tr>
                    <%
                            }
                        } else {
                    %>
                    <tr>
                        <td colspan="6" style="text-align: center;">No applications found</td>
                    </tr>
                    <%
                        }
                    %>
                    </tbody>
                </table>
            </div>
            <div class="view-all-link">
                <a href="${pageContext.request.contextPath}/view/ApplicationManagement.jsp">View All Applications</a>
            </div>
        </div>

        <!-- Recent Contact Messages -->
        <div class="section">
            <h2>Recent Contact Messages</h2>
            <div class="table-container">
                <table>
                    <thead>
                    <tr>
                        <th>Name</th>
                        <th>Email</th>
                        <th>Message</th>
                        <th>Date</th>
                        <th>Status</th>
                        <th>Actions</th>
                    </tr>
                    </thead>
                    <tbody>
                    <%
                        // Fetch recent contact messages
                        List<Contact> recentMessages = contactDAO.getAllContacts();
                        SimpleDateFormat msgDateFormat = new SimpleDateFormat("MMM dd, yyyy 'at' hh:mm a");

                        // Display messages with scrolling (limit to 5)
                        int messageCount = 0;
                        if (recentMessages != null && !recentMessages.isEmpty()) {
                            for (Contact msg : recentMessages) {
                                if (messageCount >= 5) break; // Limit to 5 messages
                                messageCount++;
                    %>
                    <tr class="<%= msg.isRead() ? "" : "unread-row" %>">
                        <td><%= msg.getName() %></td>
                        <td><%= msg.getEmail() %></td>
                        <td>
                            <%
                                // Truncate message if it's too long
                                String messageText = msg.getMessage();
                                if (messageText.length() > 50) {
                                    messageText = messageText.substring(0, 47) + "...";
                                }
                            %>
                            <%= messageText %>
                        </td>
                        <td><%= msgDateFormat.format(msg.getSubmittedAt()) %></td>
                        <td>
                            <% if (msg.isRead()) { %>
                                <span class="badge approved">Read</span>
                            <% } else { %>
                                <span class="badge pending">Unread</span>
                            <% } %>
                        </td>
                        <td>
                            <a href="mailto:<%= msg.getEmail() %>?subject=Re: Your message to InternConnect&body=Dear <%= msg.getName() %>,">
                                <i class="fa fa-reply" title="Reply"></i>
                            </a>
                            <% if (!msg.isRead()) { %>
                                <a href="${pageContext.request.contextPath}/MarkContactReadServlet?id=<%= msg.getContactId() %>">
                                    <i class="fa fa-check" title="Mark as Read"></i>
                                </a>
                            <% } %>
                        </td>
                    </tr>
                    <%
                            }
                        } else {
                    %>
                    <tr>
                        <td colspan="6" style="text-align: center;">No messages found</td>
                    </tr>
                    <%
                        }
                    %>
                    </tbody>
                </table>
            </div>
            <div class="view-all-link">
                <a href="${pageContext.request.contextPath}/view/AdminContactMessages.jsp">View All Messages</a>
            </div>
        </div>

        <!-- Active Users -->
        <div class="section">
            <h2>Registered Users</h2>
            
            <!-- Debug information - can be removed in production -->
            <div style="background: #f8f9fa; padding: 10px; margin-bottom: 15px; border-radius: 5px; font-family: monospace; font-size: 12px; display: none;">
                <strong>Debug Info:</strong> <br>
                <%
                    boolean dbConnected = false;
                    String dbErrorMessage = "";
                    
                    try (Connection debugConn = DatabaseConnection.getConnection()) {
                        dbConnected = true;
                        
                        // List all tables in the database
                        DatabaseMetaData metaData = debugConn.getMetaData();
                        ResultSet allTables = metaData.getTables(null, null, "%", new String[]{"TABLE"});
                %>
                        Available tables in database:<br>
                <%
                        boolean hasAnyTables = false;
                        
                        while (allTables.next()) {
                            hasAnyTables = true;
                            String tableName = allTables.getString("TABLE_NAME");
                            String tableType = allTables.getString("TABLE_TYPE");
                            String tableCat = allTables.getString("TABLE_CAT");
                            String tableSchem = allTables.getString("TABLE_SCHEM");
                %>
                            - <%= tableName %> (Type: <%= tableType %>, 
                              Catalog: <%= tableCat %>, 
                              Schema: <%= tableSchem %>)<br>
                <%          
                            // Count records in each table
                            try (Statement countStmt = debugConn.createStatement();
                                 ResultSet countRs = countStmt.executeQuery("SELECT COUNT(*) FROM " + tableName)) {
                                if (countRs.next()) {
                                    int recordCount = countRs.getInt(1);
                %>
                                    Records: <%= recordCount %><br>
                <%
                                }
                            } catch (Exception e) {
                %>
                                    Error counting records: <%= e.getMessage() %><br>
                <%
                            }
                        }
                        
                        if (!hasAnyTables) {
                %>
                            No tables found in database<br>
                <%
                        }
                %>
                        Database Connected: <%= dbConnected %><br>
                <% 
                        if (!dbErrorMessage.isEmpty()) { 
                %>
                        Error: <%= dbErrorMessage %><br>
                <%
                        }
                    } catch (Exception e) {
                        dbErrorMessage = "Database connection error: " + e.getMessage();
                %>
                        Database Connection Error: <%= dbErrorMessage %><br>
                <%
                    }
                %>
            </div>
            
            <div class="users-list">
                <%
                    // Approach to fetch and display users from the user table
                    int userCount = 0;
                    Connection conn = null;
                    PreparedStatement stmt = null;
                    ResultSet rs = null;
                    
                    try {
                        conn = DatabaseConnection.getConnection();
                        
                        // Query the user table directly - removed LIMIT to show all users
                        String query = "SELECT * FROM user ORDER BY user_id DESC";
                        stmt = conn.prepareStatement(query);
                        rs = stmt.executeQuery();
                        
                        while (rs.next()) {
                            userCount++;
                            
                            // Get user data
                            int userId = rs.getInt("user_id");
                            String userName = rs.getString("username");
                            String email = rs.getString("email");
                            
                            // Handle null username
                            if (userName == null || userName.isEmpty()) {
                                userName = "User #" + userId;
                            }
                            
                            // Default role
                            String userRole = "Job Seeker";
                            
                            // Try to get role if it exists
                            try {
                                String role = rs.getString("role");
                                if (role != null && !role.isEmpty()) {
                                    userRole = role;
                                }
                            } catch (Exception e) {
                                // Role column doesn't exist, use default
                            }
                %>
                <div class="user-card">
                    <i class="fa fa-user-circle"></i>
                    <div>
                        <h4><%= userName %></h4>
                        <p><%= email %></p>
                        <span class="status-badge status-active">Active</span>
                    </div>
                </div>
                <%
                        }
                        
                    } catch (Exception e) {
                        System.out.println("Error fetching users: " + e.getMessage());
                        e.printStackTrace();
                    } finally {
                        // Close resources
                        try { if (rs != null) rs.close(); } catch (Exception e) { }
                        try { if (stmt != null) stmt.close(); } catch (Exception e) { }
                        try { if (conn != null) conn.close(); } catch (Exception e) { }
                    }
                    
                    // If no users found, display message
                    if (userCount == 0) {
                %>
                <div class="user-card" style="width: 100%; text-align: center; justify-content: center;">
                    <div>
                        <h4>No registered users yet</h4>
                        <p>Users will appear here once they register</p>
                    </div>
                </div>
                <%
                    }
                %>
            </div>
        </div>

    </main>
</div>

</body>
</html>
