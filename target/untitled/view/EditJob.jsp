<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="dao.JobDAO" %>
<%@ page import="model.Job" %>
<%@ page import="java.sql.*" %>
<%@ page import="util.DatabaseConnection" %>
<!DOCTYPE html>
<html>
<head>
    <title>Edit Job | InternConnect</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin_dashboard.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/postjob.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <style>
        .edit-job-container {
            background-color: #D6C8BE;
            padding: 30px;
            border-radius: 20px;
            margin-bottom: 30px;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
        }
        
        .form-group {
            margin-bottom: 20px;
        }
        
        .form-group label {
            display: block;
            margin-bottom: 5px;
            font-weight: bold;
            color: #2A2A2A;
        }
        
        .form-group input, 
        .form-group select, 
        .form-group textarea {
            width: 100%;
            padding: 10px;
            border: 1px solid #ccc;
            border-radius: 5px;
            font-size: 16px;
            background-color: #EFE6DD;
        }
        
        .form-group textarea {
            min-height: 150px;
            resize: vertical;
        }
        
        .action-buttons {
            display: flex;
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
        
        .save-button {
            background-color: #C6F6C6;
            color: #2A2A2A;
        }
        
        .cancel-button {
            background-color: #EFE6DD;
            color: #2A2A2A;
        }
        
        /* Updated sidebar styles to match JobDetail.jsp */
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

    if (job == null) {
        response.sendRedirect(request.getContextPath() + "/view/Admin_dashboard.jsp?error=Job not found");
        return;
    }
%>

<div class="dashboard-container">

    <!-- Sidebar -->
    <aside class="sidebar">
        <h2 class="sidebar-title"><i class="fa fa-chart-line"></i> Admin Portal</h2>
        <ul class="sidebar-menu">
            <li><a href="${pageContext.request.contextPath}/view/Admin_dashboard.jsp"><i class="fa fa-home"></i> Overview</a></li>
            <li class="active"><a href="${pageContext.request.contextPath}/view/AdminJobListing.jsp"><i class="fa fa-briefcase"></i> Jobs</a></li>
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
                <h1>Edit Job</h1>
                <p><a href="${pageContext.request.contextPath}/view/Admin_dashboard.jsp">Dashboard</a> > <a href="${pageContext.request.contextPath}/view/JobDetail.jsp?id=<%= job.getJobId() %>">Job Details</a> > Edit Job</p>
            </div>
        </div>

        <!-- Edit Job Form -->
        <div class="edit-job-container">
            <form action="${pageContext.request.contextPath}/UpdateJobServlet" method="post">
                <input type="hidden" name="jobId" value="<%= job.getJobId() %>">
                
                <div class="form-group">
                    <label for="title">Job Title*</label>
                    <input type="text" id="title" name="title" value="<%= job.getTitle() %>" required>
                </div>
                
                <div class="form-group">
                    <label for="companyName">Company Name*</label>
                    <input type="text" id="companyName" name="companyName" value="<%= job.getCompanyName() %>" required>
                </div>
                
                <div class="form-group">
                    <label for="jobType">Job Type*</label>
                    <select id="jobType" name="jobType" required>
                        <option value="Full-time" <%= job.getJobType().equals("Full-time") ? "selected" : "" %>>Full-time</option>
                        <option value="Part-time" <%= job.getJobType().equals("Part-time") ? "selected" : "" %>>Part-time</option>
                        <option value="Internship" <%= job.getJobType().equals("Internship") ? "selected" : "" %>>Internship</option>
                        <option value="Contract" <%= job.getJobType().equals("Contract") ? "selected" : "" %>>Contract</option>
                        <option value="Freelance" <%= job.getJobType().equals("Freelance") ? "selected" : "" %>>Freelance</option>
                    </select>
                </div>
                
                <div class="form-group">
                    <label for="location">Location*</label>
                    <input type="text" id="location" name="location" value="<%= job.getLocation() %>" required>
                </div>
                
                <div class="form-group">
                    <label for="salary">Salary Range</label>
                    <input type="text" id="salary" name="salary" value="<%= job.getSalary() != null ? job.getSalary() : "" %>">
                </div>
                
                <div class="form-group">
                    <label for="description">Job Description*</label>
                    <textarea id="description" name="description" rows="5" required><%= job.getDescription() %></textarea>
                </div>
                
                <div class="form-group">
                    <label for="requirements">Requirements*</label>
                    <textarea id="requirements" name="requirements" rows="5" required><%= job.getRequirements() %></textarea>
                </div>
                
                <div class="form-group">
                    <label for="deadline">Application Deadline</label>
                    <input type="date" id="deadline" name="deadline" value="<%= job.getApplicationDeadline() != null ? job.getApplicationDeadline() : "" %>">
                </div>
                
                <div class="form-group">
                    <label for="status">Status</label>
                    <select id="status" name="status">
                        <option value="Pending" <%= job.getJobStatus().equals("Pending") ? "selected" : "" %>>Pending</option>
                        <option value="Approved" <%= job.getJobStatus().equals("Approved") ? "selected" : "" %>>Approved</option>
                    </select>
                </div>
                
                <div class="action-buttons">
                    <button type="submit" class="action-button save-button">Save Changes</button>
                    <a href="${pageContext.request.contextPath}/view/JobDetail.jsp?id=<%= job.getJobId() %>" class="action-button cancel-button">Cancel</a>
                </div>
            </form>
        </div>

    </main>
</div>

</body>
</html>