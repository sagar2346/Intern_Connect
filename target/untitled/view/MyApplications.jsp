<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="model.JobApplication" %>
<%@ page import="util.ApplicationFetcher" %>
<%@ page import="java.text.SimpleDateFormat" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Applications | InternConnect</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/applications.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
</head>
<body>

<%
    // Check if user is logged in
    HttpSession userSession = request.getSession(false);
    if (userSession == null || userSession.getAttribute("userId") == null) {
        response.sendRedirect(request.getContextPath() + "/view/JobSeekerLogin.jsp");
        return;
    }
    
    int userId = (Integer) userSession.getAttribute("userId");
    String username = (String) userSession.getAttribute("username");
    
    // Get all applications for this user
    List<JobApplication> applications = ApplicationFetcher.getApplicationsByUserId(userId);
    SimpleDateFormat dateFormat = new SimpleDateFormat("dd MMM yyyy");
%>

<!-- Navbar -->
<header class="navbar">
    <div class="logo">InternConnect <span>| Job Seeker</span></div>
    <nav class="nav-links">
        <a href="UserDashboard.jsp">Home</a>
        <a href="JobListing.jsp">Browse Jobs</a>
        <a href="MyApplications.jsp" class="active">My Applications</a>
        <a href="LogoutServlet" class="logout-link"><i class="fas fa-sign-out-alt"></i> Logout</a>
        <div class="profile-dropdown">
            <a href="UserProfile.jsp" class="profile-icon"><i class="fas fa-user-circle"></i></a>
            <div class="dropdown-content">
                <a href="UserProfile.jsp"><i class="fas fa-id-card"></i> View Profile</a>
                <a href="EditProfile.jsp"><i class="fas fa-user-edit"></i> Edit Profile</a>
            </div>
        </div>
    </nav>
</header>

<div class="container">
    <h1>My Applications</h1>
    
    <%-- Display success or error messages --%>
    <% String message = request.getParameter("message"); %>
    <% String error = request.getParameter("error"); %>
    
    <% if (message != null) { %>
    <div class="alert alert-success">
        <i class="fas fa-check-circle"></i> <%= message %>
    </div>
    <% } %>
    
    <% if (error != null) { %>
    <div class="alert alert-danger">
        <i class="fas fa-exclamation-circle"></i> <%= error %>
    </div>
    <% } %>
    
    <% if (applications != null && !applications.isEmpty()) { %>
    <div class="applications-table-container">
        <table class="applications-table">
            <thead>
                <tr>
                    <th>Job Title</th>
                    <th>Company</th>
                    <th>Date Applied</th>
                    <th>Status</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
                <% for (JobApplication app : applications) { 
                    // Determine status class for styling
                    String statusClass = "";
                    if ("Approved".equalsIgnoreCase(app.getStatus())) {
                        statusClass = "status-approved";
                    } else if ("Rejected".equalsIgnoreCase(app.getStatus())) {
                        statusClass = "status-rejected";
                    } else if ("Interview Scheduled".equalsIgnoreCase(app.getStatus())) {
                        statusClass = "status-interview";
                    } else {
                        statusClass = "status-pending";
                    }
                %>
                <tr>
                    <td><strong><%= app.getJobTitle() %></strong></td>
                    <td><%= app.getCompanyName() %></td>
                    <td><%= app.getApplicationDate() != null ? dateFormat.format(app.getApplicationDate()) : "N/A" %></td>
                    <td><span class="status-badge <%= statusClass %>"><%= app.getStatus() != null ? app.getStatus() : "Pending" %></span></td>
                    <td>
                        <% if ("Pending".equalsIgnoreCase(app.getStatus()) || app.getStatus() == null) { %>
                            <a href="${pageContext.request.contextPath}/DeleteApplicationServlet?id=<%= app.getApplicationId() %>" 
                               class="action-btn delete-btn" 
                               onclick="return confirm('Are you sure you want to delete this application? This action cannot be undone.');">
                                <i class="fas fa-trash-alt"></i> Delete
                            </a>
                        <% } else { %>
                            <span class="action-disabled">No actions available</span>
                        <% } %>
                    </td>
                </tr>
                <% } %>
            </tbody>
        </table>
    </div>
    <% } else { %>
    <div class="no-applications">
        <i class="fas fa-clipboard-list"></i>
        <h3>No Applications Found</h3>
        <p>You haven't submitted any job applications yet. Start exploring job opportunities and apply to positions that match your skills and interests.</p>
        <a href="${pageContext.request.contextPath}/view/JobListing.jsp" class="browse-link">
            <i class="fas fa-search"></i> Browse Job Listings
        </a>
    </div>
    <% } %>
    
    <a href="${pageContext.request.contextPath}/view/UserDashboard.jsp" class="back-link">
        <i class="fas fa-arrow-left"></i> Back to Dashboard
    </a>
</div>

</body>
</html>