<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="util.ApplicationFetcher" %>
<%@ page import="model.JobApplication" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.SimpleDateFormat" %>
<!DOCTYPE html>
<html>
<head>
    <title>Application Management | InternConnect</title>

    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <style>
        /* CSS Reset */
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            margin: 0;
            padding: 0;
            width: 100%;
            min-height: 100vh;
            font-family: 'Segoe UI', sans-serif;
            background-color: #EFE6DD;
        }
        
        /* Dashboard Container */
        .dashboard-container {
            display: flex;
            min-height: 100vh;
            width: 100%;
            position: relative;
        }
        
        /* Sidebar */
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
            font-size: 24px;
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
        
        .sidebar-menu li a i {
            margin-right: 10px;
            width: 24px;
            text-align: center;
            font-size: 22px;
        }
        
        /* Main Content */
        .main-content {
            flex: 1;
            padding: 30px;
            margin-left: 250px;
            width: calc(100% - 250px);
        }
        
        /* Dashboard Header */
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
        
        .search-profile-wrapper {
            display: flex;
            align-items: center;
            gap: 20px;
        }
        
        .search-input-container {
            position: relative;
        }
        
        .search-input-container input {
            padding: 10px 15px 10px 40px;
            border-radius: 8px;
            border: 1px solid #D6C8BE;
            background-color: #FFFFFF;
            width: 250px;
        }
        
        .search-input-container i {
            position: absolute;
            left: 15px;
            top: 50%;
            transform: translateY(-50%);
            color: #B7AA9E;
        }
        
        .profile-icon {
            width: 40px;
            height: 40px;
            background-color: #D6C8BE;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        
        /* Applications Container */
        .applications-container {
            background-color: #D6C8BE;
            padding: 30px;
            border-radius: 20px;
            margin-bottom: 30px;
            width: 100%;
        }
        
        .applications-container h2 {
            font-size: 24px;
            margin-bottom: 20px;
        }
        
        /* Applications Table */
        .applications-table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
            background-color: #EFE6DD;
            border-radius: 8px;
            overflow: hidden;
        }
        
        .applications-table th, 
        .applications-table td {
            padding: 12px 15px;
            text-align: left;
            border-bottom: 1px solid #B7AA9E;
        }
        
        .applications-table th {
            background-color: #EFE6DD;
            font-weight: bold;
            position: sticky;
            top: 0;
            z-index: 10;
        }
        
        .applications-table tr:hover {
            background-color: #EFE6DD;
        }
        
        /* Status Colors */
        .status-pending {
            color: #f39c12;
            font-weight: bold;
        }
        
        .status-approved {
            color: #2ecc71;
            font-weight: bold;
        }
        
        .status-rejected {
            color: #e74c3c;
            font-weight: bold;
        }
        
        /* Action Buttons */
        .action-buttons {
            display: flex;
            gap: 10px;
        }
        
        .action-buttons a {
            padding: 6px 12px;
            border-radius: 4px;
            text-decoration: none;
            color: white;
            font-size: 14px;
            display: inline-flex;
            align-items: center;
            gap: 5px;
        }
        
        .view-btn {
            background-color: #3498db;
        }
        
        .approve-btn {
            background-color: #2ecc71;
        }
        
        .reject-btn {
            background-color: #e74c3c;
        }
        
        /* Filter Options */
        .filter-options {
            display: flex;
            gap: 15px;
            margin-bottom: 20px;
        }
        
        .filter-options select {
            padding: 8px 12px;
            border-radius: 4px;
            border: 1px solid #B7AA9E;
            background-color: #EFE6DD;
        }
        
        /* Messages */
        .success-message {
            background-color: #d4edda;
            color: #155724;
            padding: 10px 15px;
            margin-bottom: 15px;
            border-radius: 4px;
            border-left: 4px solid #28a745;
        }
        
        .error-message {
            background-color: #f8d7da;
            color: #721c24;
            padding: 10px 15px;
            margin-bottom: 15px;
            border-radius: 4px;
            border-left: 4px solid #dc3545;
        }
        
        /* Responsive Styles */
        @media (max-width: 1024px) {
            .main-content {
                padding: 20px;
            }
        }
        
        @media (max-width: 768px) {
            .dashboard-container {
                flex-direction: column;
            }
            
            .sidebar {
                width: 100%;
                position: relative;
                min-height: auto;
                padding: 20px;
            }
            
            .main-content {
                margin-left: 0;
                width: 100%;
            }
            
            .dashboard-header {
                flex-direction: column;
                align-items: flex-start;
                gap: 15px;
            }
            
            .search-profile-wrapper {
                width: 100%;
                justify-content: space-between;
            }
            
            .search-input-container input {
                width: 100%;
            }
            
            .applications-table {
                display: block;
                overflow-x: auto;
            }
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
    String jobIdFilter = request.getParameter("jobId");

    // Get all applications
    List<JobApplication> applications = ApplicationFetcher.getAllApplications();

    // Apply filters if needed
    if (statusFilter != null && !statusFilter.isEmpty() && !statusFilter.equals("all")) {
        applications.removeIf(app -> !app.getStatus().equalsIgnoreCase(statusFilter));
    }

    if (jobIdFilter != null && !jobIdFilter.isEmpty()) {
        try {
            int jobId = Integer.parseInt(jobIdFilter);
            applications.removeIf(app -> app.getJobId() != jobId);
        } catch (NumberFormatException e) {
            // Invalid job ID, ignore filter
        }
    }

    SimpleDateFormat dateFormat = new SimpleDateFormat("MMM dd, yyyy");
%>

<div class="dashboard-container">
    <!-- Sidebar -->
    <aside class="sidebar">
        <h2 class="sidebar-title"><i class="fa fa-chart-line"></i> Admin Portal</h2>
        <ul class="sidebar-menu">
            <li><a href="${pageContext.request.contextPath}/view/Admin_dashboard.jsp"><i class="fa fa-home"></i> Overview</a></li>
            <li><a href="${pageContext.request.contextPath}/view/AdminJobListing.jsp"><i class="fa fa-briefcase"></i> Jobs</a></li>
            <li><a href="${pageContext.request.contextPath}/view/postjob.jsp"><i class="fa fa-plus-circle"></i> Post Job</a></li>
            <li class="active"><a href="${pageContext.request.contextPath}/view/ApplicationManagement.jsp"><i class="fa fa-file-alt"></i> Applications</a></li>
            <li><a href="#"><i class="fa fa-users"></i> Users</a></li>
            <li><a href="${pageContext.request.contextPath}/LogoutServlet"><i class="fa fa-sign-out-alt"></i> Logout</a></li>
        </ul>
    </aside>

    <div class="main-content">
        <div class="dashboard-header">
            <div>
                <h1>Application Management</h1>
                <p>Manage all job applications</p>
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

        <div class="applications-container">
            <h2>Job Applications</h2>

            <%
                // Display success/error message if any
                String message = request.getParameter("message");
                String error = request.getParameter("error");

                if (message != null && !message.isEmpty()) {
            %>
            <div class="success-message">
                <%= message %>
            </div>
            <% } %>

            <% if (error != null && !error.isEmpty()) { %>
            <div class="error-message">
                <%= error %>
            </div>
            <% } %>

            <!-- Filter options -->
            <div class="filter-options">
                <form action="${pageContext.request.contextPath}/view/ApplicationManagement.jsp" method="get">
                    <select name="status" onchange="this.form.submit()">
                        <option value="all" <%= statusFilter == null || statusFilter.equals("all") ? "selected" : "" %>>All Statuses</option>
                        <option value="Pending" <%= "Pending".equals(statusFilter) ? "selected" : "" %>>Pending</option>
                        <option value="Approved" <%= "Approved".equals(statusFilter) ? "selected" : "" %>>Approved</option>
                        <option value="Rejected" <%= "Rejected".equals(statusFilter) ? "selected" : "" %>>Rejected</option>
                    </select>
                </form>
            </div>

            <% if (applications.isEmpty()) { %>
            <p>No applications found.</p>
            <% } else { %>
            <table class="applications-table">
                <thead>
                <tr>
                    <th>ID</th>
                    <th>Applicant</th>
                    <th>Position</th>
                    <th>Company</th>
                    <th>Date Applied</th>
                    <th>Status</th>
                    <th>Actions</th>
                </tr>
                </thead>
                <tbody>
                <% for (JobApplication app : applications) { %>
                <tr>
                    <td><%= app.getApplicationId() %></td>
                    <td><%= app.getUserName() != null ? app.getUserName() : "Unknown" %></td>
                    <td><%= app.getPosition() != null ? app.getPosition() : "Unknown" %></td>
                    <td><%= app.getCompanyName() != null ? app.getCompanyName() : "Unknown" %></td>
                    <td><%= app.getApplicationDate() != null ? dateFormat.format(app.getApplicationDate()) : "Unknown" %></td>
                    <td>
                        <%
                            String statusClass = "";
                            if (app.getStatus() == null || app.getStatus().equalsIgnoreCase("Pending")) {
                                statusClass = "status-pending";
                            } else if (app.getStatus().equalsIgnoreCase("Approved")) {
                                statusClass = "status-approved";
                            } else if (app.getStatus().equalsIgnoreCase("Rejected")) {
                                statusClass = "status-rejected";
                            }
                        %>
                        <span class="<%= statusClass %>"><%= app.getStatus() != null ? app.getStatus() : "Pending" %></span>
                    </td>
                    <td class="action-buttons">
                        <a href="${pageContext.request.contextPath}/view/ApplicationDetail.jsp?id=<%= app.getApplicationId() %>" class="view-btn">
                            <i class="fas fa-eye"></i> View
                        </a>
                        <% if (app.getStatus() == null || app.getStatus().equalsIgnoreCase("Pending")) { %>
                        <a href="${pageContext.request.contextPath}/ApproveApplicationServlet?id=<%= app.getApplicationId() %>" class="approve-btn">
                            <i class="fas fa-check"></i> Approve
                        </a>
                        <a href="${pageContext.request.contextPath}/RejectApplicationServlet?id=<%= app.getApplicationId() %>" class="reject-btn">
                            <i class="fas fa-times"></i> Reject
                        </a>
                        <% } %>
                    </td>
                </tr>
                <% } %>
                </tbody>
            </table>
            <% } %>
        </div>
    </div>
</div>

<script>
    // Check if the page is loaded inside an iframe
    if (window.self !== window.top) {
        document.body.classList.add('in-iframe');
    }
    
    // Log any layout issues
    window.addEventListener('load', function() {
        console.log('Page loaded. Dashboard container width: ' + 
            document.querySelector('.dashboard-container').offsetWidth + 'px');
        console.log('Main content width: ' + 
            document.querySelector('.main-content').offsetWidth + 'px');
    });
</script>

</body>
</html>
