<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="dao.JobDAO" %>
<%@ page import="dao.AdminDAO" %>
<%@ page import="model.Job" %>
<%@ page import="model.Admin" %>
<%@ page import="java.sql.*" %>
<%@ page import="util.DatabaseConnection" %>
<!DOCTYPE html>
<html>
<head>
    <title>Job Details | InternConnect</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin_dashboard.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <style>
        /* Basic reset and layout */
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #EFE6DD;
            color: #2A2A2A;
            line-height: 1.6;
        }
        
        /* Dashboard container layout */
        .dashboard-container {
            display: flex;
            min-height: 100vh;
            width: 100%;
        }
        
        /* Main content area */
        .main-content {
            flex: 1;
            padding: 30px;
            margin-left: 250px; /* Match sidebar width */
            width: calc(100% - 250px);
        }
        
        /* Dashboard header */
        .dashboard-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
        }
        
        .dashboard-header h1 {
            font-size: 28px;
            margin-bottom: 5px;
        }
        
        .dashboard-header p {
            color: #8C7B6B;
        }
        
        .dashboard-header p a {
            color: #8C7B6B;
            text-decoration: none;
        }
        
        .dashboard-header p a:hover {
            text-decoration: underline;
        }
        
        /* Job detail container */
        .job-detail-container {
            background-color: #D6C8BE;
            padding: 30px;
            border-radius: 20px;
            margin-bottom: 30px;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
        }
        
        .job-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
        }
        
        .job-title {
            font-size: 24px;
            margin: 0;
        }
        
        .job-company {
            font-size: 18px;
            margin: 5px 0;
        }
        
        .job-meta {
            display: flex;
            flex-wrap: wrap;
            gap: 20px;
            margin-bottom: 20px;
        }
        
        .job-meta-item {
            display: flex;
            align-items: center;
            gap: 5px;
        }
        
        .job-description {
            margin-bottom: 20px;
            line-height: 1.6;
        }
        
        .job-requirements {
            margin-bottom: 20px;
        }
        
        .job-requirements h3 {
            margin-bottom: 10px;
        }
        
        .action-buttons {
            display: flex;
            flex-wrap: wrap;
            gap: 10px;
            margin-top: 20px;
        }
        
        .action-button {
            padding: 10px 20px;
            border-radius: 5px;
            border: none;
            cursor: pointer;
            font-weight: bold;
            text-decoration: none;
            display: inline-block;
        }
        
        .approve-button {
            background-color: #C6F6C6;
            color: #2A2A2A;
        }
        
        .reject-button {
            background-color: #F8B6B6;
            color: #2A2A2A;
        }
        
        .edit-button {
            background-color: #B6D7F8;
            color: #2A2A2A;
        }
        
        .back-button {
            background-color: #EFE6DD;
            color: #2A2A2A;
        }
        
        .badge {
            padding: 5px 10px;
            border-radius: 20px;
            font-size: 14px;
            font-weight: bold;
        }
        
        .badge.pending {
            background-color: #FFF3CD;
            color: #856404;
        }
        
        .badge.approved {
            background-color: #C6F6C6;
            color: #155724;
        }
        
        .badge.rejected {
            background-color: #F8B6B6;
            color: #721C24;
        }
        
        /* Sidebar styles */
        .sidebar {
            width: 250px;
            background-color: #D6C8BE;
            padding: 30px 20px;
            min-height: 100vh;
            position: fixed;
            left: 0;
            top: 0;
            bottom: 0;
            z-index: 100;
        }
        
        .sidebar-title {
            font-size: 28px;
            font-weight: bold;
            margin-bottom: 30px;
            color: #2A2A2A;
            display: flex;
            align-items: center;
        }
        
        .sidebar-title i {
            margin-right: 10px;
        }
        
        .sidebar-menu {
            list-style: none;
            padding: 0;
            margin: 0;
        }
        
        .sidebar-menu li {
            margin-bottom: 15px;
        }
        
        .sidebar-menu li a {
            display: flex;
            align-items: center;
            padding: 12px 10px;
            color: #2A2A2A;
            text-decoration: none;
            font-size: 22px;
            border-radius: 8px;
            transition: background-color 0.3s;
        }
        
        .sidebar-menu li a:hover {
            background-color: #CBBBAF;
        }
        
        .sidebar-menu li a.active {
            background-color: #B7AA9E;
            color: #fff;
        }
        
        .sidebar-menu li.active {
            display: flex;
            align-items: center;
            padding: 12px 10px;
            color: #fff;
            font-size: 22px;
            border-radius: 8px;
            background-color: #B7AA9E;
        }
        
        .sidebar-menu li i,
        .sidebar-menu li a i {
            margin-right: 10px;
            width: 24px;
            text-align: center;
            font-size: 22px;
        }
        
        /* Responsive adjustments */
        @media (max-width: 768px) {
            .sidebar {
                width: 100%;
                position: relative;
                min-height: auto;
            }
            
            .main-content {
                margin-left: 0;
                width: 100%;
                padding: 20px;
            }
            
            .dashboard-container {
                flex-direction: column;
            }
            
            .job-meta {
                flex-direction: column;
                gap: 10px;
            }
            
            .action-buttons {
                flex-direction: column;
            }
            
            .action-button {
                width: 100%;
                text-align: center;
            }
        }
    </style>
</head>
<body>

<%
    // Get job ID from request parameter
    String jobIdStr = request.getParameter("id");
    int jobId = 0;
    
    try {
        jobId = Integer.parseInt(jobIdStr);
    } catch (Exception e) {
        // Invalid job ID
    }
    
    // Fetch job details using JobDAO
    JobDAO jobDAO = new JobDAO();
    Job job = jobDAO.getJobById(jobId);
    
    // Get admin name who posted the job
    String postedByName = "Admin";
    if (job != null && job.getPostedBy() != null) {
        try {
            AdminDAO adminDAO = new AdminDAO();
            Admin admin = adminDAO.getAdminById(job.getPostedBy());
            if (admin != null) {
                postedByName = admin.getName();
            }
        } catch (Exception e) {
            // Use default name if query fails
        }
    }
%>

<div class="dashboard-container">

    <!-- Updated Sidebar -->
    <aside class="sidebar">
        <h2 class="sidebar-title"><i class="fa fa-chart-line"></i> Admin Portal</h2>
        <ul class="sidebar-menu">
            <li><a href="${pageContext.request.contextPath}/view/Admin_dashboard.jsp"><i class="fa fa-home"></i> Overview</a></li>
            <li class="active"><a href="${pageContext.request.contextPath}/view/AdminJobListing.jsp"><i class="fa fa-briefcase"></i> Jobs</a></li>
            <li><a href="${pageContext.request.contextPath}/view/postjob.jsp"><i class="fa fa-plus-circle"></i> Post Job</a></li>
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
                <h1>Job Details</h1>
                <p><a href="${pageContext.request.contextPath}/view/Admin_dashboard.jsp">Dashboard</a> > Job Details</p>
            </div>
            
            <!-- Display success or error messages if any -->
            <% if (request.getParameter("message") != null) { %>
                <div class="alert alert-success">
                    <i class="fa fa-check-circle"></i> <%= request.getParameter("message") %>
                </div>
            <% } %>
            
            <% if (request.getParameter("error") != null) { %>
                <div class="alert alert-danger">
                    <i class="fa fa-exclamation-circle"></i> <%= request.getParameter("error") %>
                </div>
            <% } %>
        </div>

        <!-- Job Details -->
        <% if (job != null) { %>
        <div class="job-detail-container">
            <div class="job-header">
                <div>
                    <h2 class="job-title"><%= job.getTitle() %></h2>
                    <p class="job-company"><%= job.getCompanyName() %></p>
                </div>
                <%
                    String status = job.getJobStatus();
                    if (status == null || status.isEmpty()) status = "Pending";
                    String badgeClass = "pending";
                    
                    if (status.equalsIgnoreCase("Approved")) {
                        badgeClass = "approved";
                    } else if (status.equalsIgnoreCase("Rejected")) {
                        badgeClass = "rejected";
                    }
                %>
                <span class="badge <%= badgeClass %>"><%= status %></span>
            </div>
            
            <div class="job-meta">
                <div class="job-meta-item">
                    <i class="fa fa-map-marker-alt"></i>
                    <span><%= job.getLocation() %></span>
                </div>
                <div class="job-meta-item">
                    <i class="fa fa-briefcase"></i>
                    <span><%= job.getJobType() %></span>
                </div>
                <div class="job-meta-item">
                    <i class="fa fa-money-bill-wave"></i>
                    <span><%= job.getSalary() != null && !job.getSalary().isEmpty() ? job.getSalary() : "Not specified" %></span>
                </div>
                <div class="job-meta-item">
                    <i class="fa fa-calendar"></i>
                    <span>Posted: <%= job.getPostedDate() %></span>
                </div>
                <div class="job-meta-item">
                    <i class="fa fa-user"></i>
                    <span>Posted by: <%= postedByName %></span>
                </div>
            </div>
            
            <div class="job-section">
                <h3><i class="fa fa-info-circle"></i> Job Description</h3>
                <div class="job-description">
                    <p><%= job.getDescription() %></p>
                </div>
            </div>
            
            <div class="job-section">
                <h3><i class="fa fa-list-check"></i> Requirements</h3>
                <div class="job-requirements">
                    <p><%= job.getRequirements() %></p>
                </div>
            </div>
            
            <div class="job-meta-item deadline-item">
                <i class="fa fa-calendar-times"></i>
                <span>Application Deadline: <%= job.getApplicationDeadline() != null && !job.getApplicationDeadline().isEmpty() ? job.getApplicationDeadline() : "Not specified" %></span>
            </div>
            
            <div class="action-buttons">
                <a href="${pageContext.request.contextPath}/ApproveJobServlet?id=<%= job.getJobId() %>" class="action-button approve-button">
                    <i class="fa fa-check"></i> Approve Job
                </a>
                
                <a href="${pageContext.request.contextPath}/RejectJobServlet?id=<%= job.getJobId() %>" class="action-button reject-button">
                    <i class="fa fa-trash"></i> Delete Job
                </a>
                
                <a href="${pageContext.request.contextPath}/view/EditJob.jsp?id=<%= job.getJobId() %>" class="action-button edit-button">
                    <i class="fa fa-edit"></i> Edit Job
                </a>
                
                <a href="${pageContext.request.contextPath}/view/Admin_dashboard.jsp" class="action-button back-button">
                    <i class="fa fa-arrow-left"></i> Back to Dashboard
                </a>
            </div>
        </div>
        <% } else { %>
        <div class="job-detail-container">
            <h2>Job Not Found</h2>
            <p>The requested job could not be found.</p>
            <div class="action-buttons">
                <a href="${pageContext.request.contextPath}/view/Admin_dashboard.jsp" class="action-button back-button">
                    <i class="fa fa-arrow-left"></i> Back to Dashboard
                </a>
            </div>
        </div>
        <% } %>

    </main>
</div>

<style>
    /* Additional styles for improved job details container */
    .job-detail-container {
        background-color: #D6C8BE;
        padding: 30px;
        border-radius: 20px;
        margin-bottom: 30px;
        box-shadow: 0 8px 15px rgba(0, 0, 0, 0.1);
    }
    
    .job-header {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-bottom: 25px;
        padding-bottom: 15px;
        border-bottom: 1px solid rgba(0, 0, 0, 0.1);
    }
    
    .job-title {
        font-size: 28px;
        margin: 0;
        color: #2A2A2A;
    }
    
    .job-company {
        font-size: 20px;
        margin: 8px 0 0;
        color: #555;
    }
    
    .job-meta {
        display: flex;
        flex-wrap: wrap;
        gap: 20px;
        margin-bottom: 25px;
        padding-bottom: 15px;
        border-bottom: 1px solid rgba(0, 0, 0, 0.1);
    }
    
    .job-meta-item {
        display: flex;
        align-items: center;
        gap: 8px;
        font-size: 16px;
    }
    
    .job-meta-item i {
        color: #8C7B6B;
        font-size: 18px;
        width: 20px;
        text-align: center;
    }
    
    .job-section {
        margin-bottom: 25px;
        padding-bottom: 15px;
        border-bottom: 1px solid rgba(0, 0, 0, 0.1);
    }
    
    .job-section h3 {
        font-size: 20px;
        margin-bottom: 15px;
        color: #2A2A2A;
        display: flex;
        align-items: center;
        gap: 8px;
    }
    
    .job-section h3 i {
        color: #8C7B6B;
    }
    
    .job-description, .job-requirements {
        line-height: 1.7;
        color: #333;
        font-size: 16px;
        padding-left: 10px;
    }
    
    .deadline-item {
        margin: 20px 0;
        padding: 12px 15px;
        background-color: #EFE6DD;
        border-radius: 8px;
        font-weight: bold;
    }
    
    .action-buttons {
        display: flex;
        flex-wrap: wrap;
        gap: 15px;
        margin-top: 25px;
        padding-top: 15px;
        border-top: 1px solid rgba(0, 0, 0, 0.1);
    }
    
    .action-button {
        padding: 12px 20px;
        border-radius: 8px;
        border: none;
        cursor: pointer;
        font-weight: bold;
        text-decoration: none;
        display: inline-flex;
        align-items: center;
        gap: 8px;
        transition: transform 0.2s, box-shadow 0.2s;
    }
    
    .action-button:hover {
        transform: translateY(-3px);
        box-shadow: 0 5px 10px rgba(0, 0, 0, 0.1);
    }
    
    .approve-button {
        background-color: #C6F6C6;
        color: #155724;
    }
    
    .reject-button {
        background-color: #F8B6B6;
        color: #721C24;
    }
    
    .edit-button {
        background-color: #B6D7F8;
        color: #0C5460;
    }
    
    .back-button {
        background-color: #EFE6DD;
        color: #2A2A2A;
    }
    
    .badge {
        padding: 8px 15px;
        border-radius: 20px;
        font-size: 16px;
        font-weight: bold;
        display: inline-flex;
        align-items: center;
        gap: 5px;
    }
    
    .badge.pending {
        background-color: #FFF3CD;
        color: #856404;
    }
    
    .badge.pending::before {
        content: "⏳";
    }
    
    .badge.approved {
        background-color: #C6F6C6;
        color: #155724;
    }
    
    .badge.approved::before {
        content: "✓";
    }
    
    .badge.rejected {
        background-color: #F8B6B6;
        color: #721C24;
    }
    
    .badge.rejected::before {
        content: "✗";
    }
    
    /* Alert messages */
    .alert {
        padding: 15px;
        border-radius: 8px;
        margin-bottom: 20px;
        display: flex;
        align-items: center;
        gap: 10px;
    }
    
    .alert-success {
        background-color: rgba(198, 246, 198, 0.3);
        color: #155724;
        border-left: 4px solid #155724;
    }
    
    .alert-danger {
        background-color: rgba(248, 182, 182, 0.3);
        color: #721C24;
        border-left: 4px solid #721C24;
    }
    
    /* Responsive adjustments */
    @media (max-width: 768px) {
        .job-meta {
            flex-direction: column;
            gap: 10px;
        }
        
        .action-buttons {
            flex-direction: column;
        }
        
        .action-button {
            width: 100%;
            justify-content: center;
        }
    }
</style>

</body>
</html>
