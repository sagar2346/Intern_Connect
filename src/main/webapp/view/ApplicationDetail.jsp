<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="dao.JobApplicationDAO" %>
<%@ page import="model.JobApplication" %>
<%@ page import="java.text.SimpleDateFormat" %>
<!DOCTYPE html>
<html>
<head>
    <title>Application Details | InternConnect</title>

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
        }
        
        /* Complete Sidebar Styling */
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
        
        .sidebar-menu li.active a {
            background-color: #B7AA9E;
            color: #fff;
        }
        
        .sidebar-menu li a i {
            margin-right: 10px;
            width: 24px;
            text-align: center;
            font-size: 22px;
        }
        
        /* Main Content Adjustment */
        .main-content {
            flex: 1;
            padding: 30px;
            margin-left: 250px;
            width: calc(100% - 250px);
        }
        
        .application-detail-container {
            background-color: #D6C8BE;
            padding: 35px;
            border-radius: 20px;
            margin-bottom: 30px;
            width: 100%;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
        }
        
        .application-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
        }
        
        .application-title {
            font-size: 24px;
            margin: 0;
        }
        
        .application-status {
            padding: 6px 12px;
            border-radius: 4px;
            font-weight: bold;
        }
        
        .status-pending {
            background-color: #f39c12;
            color: white;
        }
        
        .status-approved {
            background-color: #2ecc71;
            color: white;
        }
        
        .status-rejected {
            background-color: #e74c3c;
            color: white;
        }
        
        .application-info {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
            margin-bottom: 30px;
        }
        
        .info-group {
            margin-bottom: 15px;
        }
        
        .info-label {
            font-weight: bold;
            margin-bottom: 5px;
            color: #555;
        }
        
        .info-value {
            font-size: 16px;
        }
        
        .additional-info {
            background-color: #EFE6DD;
            padding: 15px;
            border-radius: 8px;
            margin-bottom: 20px;
        }
        
        .document-links {
            margin-top: 20px;
        }
        
        .document-link {
            display: inline-block;
            padding: 8px 15px;
            background-color: #3498db;
            color: white;
            text-decoration: none;
            border-radius: 4px;
            margin-right: 10px;
        }
        
        .action-buttons {
            display: flex;
            gap: 15px;
            margin-top: 40px;
            flex-wrap: wrap;
            justify-content: flex-start;
        }
        
        .action-buttons a {
            padding: 12px 24px;
            border-radius: 8px;
            text-decoration: none;
            color: white;
            font-weight: bold;
            font-size: 16px;
            display: flex;
            align-items: center;
            transition: all 0.3s ease;
        }
        
        .action-buttons a i {
            margin-right: 8px;
        }
        
        .approve-btn {
            background-color: #2ecc71;
        }
        
        .approve-btn:hover {
            background-color: #27ae60;
            transform: translateY(-2px);
        }
        
        .reject-btn {
            background-color: #e74c3c;
        }
        
        .reject-btn:hover {
            background-color: #c0392b;
            transform: translateY(-2px);
        }
        
        .back-btn {
            background-color: #7f8c8d;
        }
        
        .back-btn:hover {
            background-color: #6c7a7d;
            transform: translateY(-2px);
        }
        
        /* Header and Container Spacing */
        .header {
            margin-bottom: 25px;
        }
        
        .header h1 {
            font-size: 32px;
            color: #2A2A2A;
            margin-bottom: 10px;
        }
        
        /* Improved Action Buttons */
        .action-buttons {
            display: flex;
            gap: 15px;
            margin-top: 40px;
            flex-wrap: wrap;
            justify-content: flex-start;
        }
        
        .action-buttons a {
            padding: 12px 24px;
            border-radius: 8px;
            text-decoration: none;
            color: white;
            font-weight: bold;
            font-size: 16px;
            display: flex;
            align-items: center;
            transition: all 0.3s ease;
        }
        
        .action-buttons a i {
            margin-right: 8px;
        }
        
        .approve-btn {
            background-color: #2ecc71;
        }
        
        .approve-btn:hover {
            background-color: #27ae60;
            transform: translateY(-2px);
        }
        
        .reject-btn {
            background-color: #e74c3c;
        }
        
        .reject-btn:hover {
            background-color: #c0392b;
            transform: translateY(-2px);
        }
        
        .back-btn {
            background-color: #7f8c8d;
        }
        
        .back-btn:hover {
            background-color: #6c7a7d;
            transform: translateY(-2px);
        }
        
        /* Responsive styles */
        @media (max-width: 768px) {
            .application-info {
                grid-template-columns: 1fr;
            }
            
            .application-header {
                flex-direction: column;
                align-items: flex-start;
                gap: 10px;
            }
            
            .action-buttons {
                flex-direction: column;
                width: 100%;
            }
            
            .action-buttons a {
                width: 100%;
                text-align: center;
            }
        }
    </style>
</head>
<body>

<%
    // Get application ID from request parameter
    String applicationIdStr = request.getParameter("id");
    int applicationId = 0;
    
    try {
        applicationId = Integer.parseInt(applicationIdStr);
    } catch (Exception e) {
        // Invalid application ID
    }
    
    // Fetch application details using JobApplicationDAO
    JobApplicationDAO applicationDAO = new JobApplicationDAO();
    JobApplication jobApplication = applicationDAO.getApplicationById(applicationId);
    
    if (jobApplication == null) {
        response.sendRedirect(request.getContextPath() + "/view/ApplicationManagement.jsp?error=Application not found");
        return;
    }
    
    SimpleDateFormat dateFormat = new SimpleDateFormat("MMM dd, yyyy");
%>

<div class="dashboard-container">
    <!-- Sidebar -->
    <aside class="sidebar">
        <h2 class="sidebar-title"><i class="fa fa-chart-line"></i> Admin Portal</h2>
        <ul class="sidebar-menu">
            <li><a href="${pageContext.request.contextPath}/view/Admin_dashboard.jsp"><i class="fa fa-home"></i> Overview</a></li>
            <li><a href="${pageContext.request.contextPath}/view/JobListing.jsp"><i class="fa fa-briefcase"></i> Jobs</a></li>
            <li><a href="${pageContext.request.contextPath}/view/postjob.jsp" class="post-job-link"><i class="fa fa-plus-circle"></i> Post Job</a></li>
            <li class="active"><a href="${pageContext.request.contextPath}/view/ApplicationManagement.jsp"><i class="fa fa-file-alt"></i> Applications</a></li>
            <li><i class="fa fa-users"></i> Users</li>
            <li><a href="${pageContext.request.contextPath}/index.jsp"><i class="fa fa-sign-out-alt"></i> Logout</a></li>
        </ul>
    </aside>

    <div class="main-content">
        <div class="header">
            <h1>Application Details</h1>
            <p>Review and manage the application information below</p>
        </div>

        <div class="application-detail-container">
            <div class="application-header">
                <h2 class="application-title">Application for <%= jobApplication.getJobTitle() != null ? jobApplication.getJobTitle() : jobApplication.getPosition() %></h2>
                <% 
                    String statusClass = "";
                    if (jobApplication.getStatus().equalsIgnoreCase("Pending")) {
                        statusClass = "status-pending";
                    } else if (jobApplication.getStatus().equalsIgnoreCase("Approved")) {
                        statusClass = "status-approved";
                    } else if (jobApplication.getStatus().equalsIgnoreCase("Rejected")) {
                        statusClass = "status-rejected";
                    }
                %>
                <span class="application-status <%= statusClass %>"><%= jobApplication.getStatus() %></span>
            </div>
            
            <div class="application-info">
                <div>
                    <div class="info-group">
                        <div class="info-label">Applicant Name</div>
                        <div class="info-value"><%= jobApplication.getUserName() %></div>
                    </div>
                    
                    <div class="info-group">
                        <div class="info-label">Email</div>
                        <div class="info-value"><%= jobApplication.getEmail() %></div>
                    </div>
                    
                    <div class="info-group">
                        <div class="info-label">Phone</div>
                        <div class="info-value"><%= jobApplication.getPhone() %></div>
                    </div>
                    
                    <div class="info-group">
                        <div class="info-label">Address</div>
                        <div class="info-value"><%= jobApplication.getAddress() %>, <%= jobApplication.getCity() %></div>
                    </div>
                </div>
                
                <div>
                    <div class="info-group">
                        <div class="info-label">Position</div>
                        <div class="info-value"><%= jobApplication.getPosition() %></div>
                    </div>
                    
                    <div class="info-group">
                        <div class="info-label">Company</div>
                        <div class="info-value"><%= jobApplication.getCompanyName() %></div>
                    </div>
                    
                    <div class="info-group">
                        <div class="info-label">Application Date</div>
                        <div class="info-value"><%= dateFormat.format(jobApplication.getApplicationDate()) %></div>
                    </div>
                    
                    <div class="info-group">
                        <div class="info-label">Application ID</div>
                        <div class="info-value">#<%= jobApplication.getApplicationId() %></div>
                    </div>
                </div>
            </div>
            
            <% if (jobApplication.getAdditionalInfo() != null && !jobApplication.getAdditionalInfo().isEmpty()) { %>
            <div class="info-group">
                <div class="info-label">Additional Information</div>
                <div class="additional-info">
                    <%= jobApplication.getAdditionalInfo() %>
                </div>
            </div>
            <% } %>

            <div class="document-links">
                <% if (jobApplication.getResumePath() != null && !jobApplication.getResumePath().isEmpty()) { %>
                <a href="${pageContext.request.contextPath}/<%= jobApplication.getResumePath() %>" class="document-link" target="_blank">
                    <i class="fas fa-file-pdf"></i> View Resume
                </a>
                <% } %>
                
                <% if (jobApplication.getCoverLetterPath() != null && !jobApplication.getCoverLetterPath().isEmpty()) { %>
                <a href="${pageContext.request.contextPath}/<%= jobApplication.getCoverLetterPath() %>" class="document-link" target="_blank">
                    <i class="fas fa-file-alt"></i> View Cover Letter
                </a>
                <% } %>
            </div>

            <div class="action-buttons">
                <a href="${pageContext.request.contextPath}/ApproveApplicationServlet?id=<%= jobApplication.getApplicationId() %>" class="approve-btn">
                    <i class="fas fa-check"></i> Approve Application
                </a>
                <a href="${pageContext.request.contextPath}/RejectApplicationServlet?id=<%= jobApplication.getApplicationId() %>" class="reject-btn">
                    <i class="fas fa-times"></i> Reject Application
                </a>
                <a href="${pageContext.request.contextPath}/view/ApplicationManagement.jsp" class="back-btn">
                    <i class="fas fa-arrow-left"></i> Back to Applications
                </a>
            </div>
        </div>
    </div>
</div>

</body>
</html>
