<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="dao.UserDAO" %>
<%@ page import="dao.JobDAO" %>
<%@ page import="dao.JobApplicationDAO" %>
<%@ page import="model.User" %>
<%@ page import="model.Job" %>
<%@ page import="model.JobApplication" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.SimpleDateFormat" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Job Seeker Dashboard | InternConnect</title>

    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
</head>
<style>
    /* Reset & Base */
    *, *::before, *::after {
        margin: 0; padding: 0; box-sizing: border-box;
    }
    html, body {
        height: 100%;
        font-family: 'Segoe UI', sans-serif;
        background: #EFE6DD;
        color: #323232;
    }
    body {
        display: flex;
        flex-direction: column;
        min-height: 100vh;
        overflow-x: hidden;
    }

    /* Navbar */
    .navbar {
        display: flex;
        justify-content: space-between;
        align-items: center;
        padding: 40px 100px;
        background: #DDD0C8;
        border-bottom: 1px solid #DDD0C8;
    }
    .logo {
        font-size: 28px;
        font-weight: 700;
    }
    .nav-links {
        display: flex;
        align-items: center;
        gap: 32px;
    }
    .nav-links a {
        position: relative;
        font-size: 23px;
        font-weight: 600;
        color: #323232;
        text-decoration: none;
        transition: color 0.3s;
    }
    .nav-links a:hover {
        color: #ffffff;
    }
    .nav-links a.active::after {
        content: '';
        position: absolute;
        bottom: -8px; left: 0;
        width: 100%; height: 3px;
        background: #DDD0C8;
        border-radius: 4px;
    }

    /* Logout */
    .logout-link {
        display: inline-flex;
        align-items: center;
        padding: 8px 16px;
        border-radius: 8px;
        font-weight: 500;
        transition: background 0.3s;
    }
    .logout-link i {
        margin-right: 8px;
    }
    .logout-link:hover {
        background: #EFE6DD;
    }

    /* Profile dropdown */
    .profile-dropdown {
        position: relative;
    }
    .profile-icon {
        font-size: 25px;
        color: #323232;
        cursor: pointer;
        transition: color 0.3s, transform 0.2s;
    }
    .profile-icon:hover {
        color: #8C7B6B;
        transform: scale(1.1);
    }
    .dropdown-content {
        position: absolute;
        top: 40px; right: 0;
        min-width: 200px;
        background: #ffffff;
        box-shadow: 0 8px 18px rgba(0,0,0,0.1);
        border-radius: 8px;
        opacity: 0; visibility: hidden;
        transition: opacity 0.3s, visibility 0.3s;
    }
    .profile-dropdown:hover .dropdown-content {
        opacity: 1; visibility: visible;
    }
    .dropdown-content a {
        display: flex;
        align-items: center;
        padding: 12px 16px;
        color: #323232;
        font-size: 14px;
        text-decoration: none;
        border-radius: 4px;
        transition: background 0.2s;
    }
    .dropdown-content a i {
        margin-right: 10px;
        width: 16px;
        text-align: center;
    }
    .dropdown-content a:hover,
    .dropdown-content a.active {
        background: #EFE6DD;
        font-weight: 600;
    }

    /* Dashboard container */
    .dashboard-container {
        flex: 1;
        padding: 40px 60px;
    }
    .dashboard-container h1 {
        font-size: 28px;
        margin-bottom: 24px;
    }
    .highlight {
        font-weight: bold;
    }

    /* Cards */
    .card-grid {
        display: flex;
        gap: 20px;
        margin-bottom: 40px;
    }
    .card {
        flex: 1;
        background: #D6C8BE;
        padding: 30px;
        border-radius: 14px;
        text-align: center;
        box-shadow: 0 8px 18px rgba(0,0,0,0.1);
        min-height: 200px;
        display: flex;
        flex-direction: column;
        justify-content: center;
    }
    .card i {
        font-size: 26px;
        margin-bottom: 10px;
    }
    .card h3 {
        margin-bottom: 8px;
        font-size: 18px;
    }
    .card p {
        font-size: 22px;
        font-weight: bold;
    }

    /* Table */
    .table-section h2 {
        font-size: 22px;
        margin-bottom: 16px;
    }
    table {
        width: 100%;
        border-collapse: collapse;
        background: #ffffff;
        border-radius: 10px;
        overflow: hidden;
        box-shadow: 0 4px 10px rgba(0,0,0,0.08);
    }
    th, td {
        padding: 14px 20px;
        text-align: left;
        border-bottom: 1px solid #ddd;
    }
    th {
        background: #D6C8BE;
        font-weight: 600;
    }

    /* Responsive */
    @media (max-width: 768px) {
        .navbar {
            padding: 20px 30px;
        }
        .nav-links {
            gap: 16px;
        }
        .nav-links a {
            font-size: 16px;
        }
        .dashboard-container {
            padding: 30px 20px;
        }
        .card-grid {
            flex-direction: column;
        }
        table {
            display: block;
            overflow-x: auto;
        }
    }

    /* View All Button Styling */
    .view-all-link {
        text-align: right;
        margin: 20px 0 40px;
    }

    .view-all-button {
        display: inline-flex;
        align-items: center;
        background-color: #D6C8BE;
        color: #323232;
        padding: 10px 20px;
        border-radius: 8px;
        text-decoration: none;
        font-weight: 600;
        font-size: 16px;
        transition: all 0.3s ease;
        box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
    }

    .view-all-button i {
        margin-right: 10px;
        font-size: 18px;
    }

    .view-all-button:hover {
        background-color: #B7AA9E;
        transform: translateY(-2px);
        box-shadow: 0 6px 12px rgba(0, 0, 0, 0.15);
    }

    /* Status Badges (keep existing styles) */
    .status-badge {
        padding: 6px 12px;
        border-radius: 20px;
        font-size: 13px;
        font-weight: 600;
        display: inline-block;
        text-align: center;
        min-width: 100px;
    }

    .status-pending {
        background-color: rgba(255, 193, 7, 0.2);
        color: #856404;
    }

    .status-approved {
        background-color: rgba(40, 167, 69, 0.2);
        color: #155724;
    }

    .status-rejected {
        background-color: rgba(220, 53, 69, 0.2);
        color: #721c24;
    }

    .status-interview {
        background-color: rgba(13, 110, 253, 0.2);
        color: #0d6efd;
    }

    /* Action Button Styling */
    .action-btn {
        padding: 6px 12px;
        border-radius: 6px;
        font-size: 14px;
        font-weight: 500;
        text-decoration: none;
        display: inline-flex;
        align-items: center;
        justify-content: center;
        transition: all 0.3s ease;
        cursor: pointer;
    }

    .delete-btn {
        background-color: rgba(220, 53, 69, 0.1);
        color: #dc3545;
    }

    .delete-btn:hover {
        background-color: #dc3545;
        color: #ffffff;
    }

    .action-disabled {
        color: #6C6C6C;
        font-style: italic;
        font-size: 14px;
    }

    /* Table Container Styling */
    .applications-table-container {
        background-color: #ffffff;
        border-radius: 10px;
        box-shadow: 0 4px 10px rgba(0, 0, 0, 0.08);
        overflow: hidden;
        margin-bottom: 20px;
    }
</style>
<body>

<%
    // Check if user is logged in
    Integer userId = (Integer) session.getAttribute("userId");
    String username = (String) session.getAttribute("username");

    if (userId == null || username == null) {
        response.sendRedirect(request.getContextPath() + "/view/JobSeekerLogin.jsp");
        return;
    }

    // Get user details using UserDAO
    UserDAO userDAO = new UserDAO();
    User user = userDAO.getUserById(userId);

    // Get user's applications using JobApplicationDAO
    JobApplicationDAO applicationDAO = new JobApplicationDAO();
    List<JobApplication> userApplications = applicationDAO.getApplicationsByUserId(userId);

    // Get recommended jobs using JobDAO
    JobDAO jobDAO = new JobDAO();
    List<Job> recommendedJobs = jobDAO.getJobsByStatus("Approved");
    // Limit to 5 jobs
    if (recommendedJobs.size() > 5) {
        recommendedJobs = recommendedJobs.subList(0, 5);
    }

    SimpleDateFormat dateFormat = new SimpleDateFormat("MMM dd, yyyy");
%>

<!-- Navbar -->
<header class="navbar">
    <div class="logo">InternConnect <span>| Job Seeker</span></div>
    <nav class="nav-links">
        <a href="../index.jsp">Home</a>
        <a href="JobListing.jsp">Browse Jobs</a>
        <a href="MyApplications.jsp">My Applications</a>
        <a href="${pageContext.request.contextPath}/LogoutServlet" class="logout-link"><i class="fas fa-sign-out-alt"></i> Logout</a>
        <div class="profile-dropdown">
            <a href="UserProfile.jsp" class="profile-icon"><i class="fas fa-user-circle"></i></a>
            <div class="dropdown-content">
                <a href="UserProfile.jsp"><i class="fas fa-id-card"></i> View Profile</a>
                <a href="EditProfile.jsp"><i class="fas fa-user-edit"></i> Edit Profile</a>
            </div>
        </div>
    </nav>
</header>

<!-- Dashboard Content -->
<section class="dashboard-container">
    <h1>Welcome, <span class="highlight"><%= username %></span></h1>

    <!-- Cards -->
    <div class="card-grid">
        <div class="card">
            <i class="fas fa-briefcase"></i>
            <h3>Jobs Applied</h3>
            <p><%= userApplications.size() %></p>
        </div>
        <div class="card">
            <i class="fas fa-clock"></i>
            <h3>Pending Applications</h3>
            <p><%= userApplications.stream().filter(app -> app.getStatus().equalsIgnoreCase("Pending")).count() %></p>
        </div>
        <div class="card">
            <i class="fas fa-calendar-check"></i>
            <h3>Interviews Scheduled</h3>
            <p><%= userApplications.stream().filter(app -> app.getStatus().equalsIgnoreCase("Interview Scheduled")).count() %></p>
        </div>
    </div>

    <!-- Table -->
    <div class="table-section">
        <h2>Recent Applications</h2>
        <table>
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
            <%
                // Display recent applications
                java.util.List<model.JobApplication> recentApps = util.ApplicationFetcher.getApplicationsByUserId(userId);
                // Use a different variable name to avoid duplication
                java.text.SimpleDateFormat appDateFormat = new java.text.SimpleDateFormat("dd MMM yyyy");

                if (recentApps != null && !recentApps.isEmpty()) {
                    // Display up to 5 most recent applications
                    int count = 0;
                    for (model.JobApplication app : recentApps) {
                        if (count >= 5) break;

                        // Determine status class for styling
                        String statusClass = "";
                        if ("Approved".equalsIgnoreCase(app.getStatus())) {
                            statusClass = "status-approved";
                        } else if ("Rejected".equalsIgnoreCase(app.getStatus())) {
                            statusClass = "status-rejected";
                        } else {
                            statusClass = "status-pending";
                        }
            %>
            <tr>
                <td><%= app.getJobTitle() %></td>
                <td><%= app.getCompanyName() %></td>
                <td><%= app.getApplicationDate() != null ? appDateFormat.format(app.getApplicationDate()) : "N/A" %></td>
                <td><span class="<%= statusClass %>"><%= app.getStatus() != null ? app.getStatus() : "Pending" %></span></td>
                <td>
                    <% if ("Pending".equalsIgnoreCase(app.getStatus()) || app.getStatus() == null) { %>
                        <a href="${pageContext.request.contextPath}/DeleteApplicationServlet?id=<%= app.getApplicationId() %>"
                           class="delete-btn"
                           onclick="return confirm('Are you sure you want to delete this application? This action cannot be undone.');">
                            <i class="fas fa-trash-alt"></i> Delete
                        </a>
                    <% } else { %>
                        <span class="action-disabled">No actions available</span>
                    <% } %>
                </td>
            </tr>
            <%
                        count++;
                    }
                } else {
            %>
            <tr>
                <td colspan="5" style="text-align: center;">No applications found</td>
            </tr>
            <%
                }
            %>
            </tbody>
        </table>
    </div>

    <!-- View All My Applications Link -->
    <div class="view-all-link">
        <a href="${pageContext.request.contextPath}/view/MyApplications.jsp" class="view-all-button">
            <i class="fas fa-list-alt"></i> View All My Applications
        </a>
    </div>

    <!-- My Contact Messages Section -->
    <div class="table-section">
        <h2>My Contact Messages</h2>
        <table>
            <thead>
            <tr>
                <th>Date</th>
                <th>Message</th>
                <th>Status</th>
            </tr>
            </thead>
            <tbody>
            <%
                // Get user's contact messages
                dao.ContactDAO contactDAO = new dao.ContactDAO();
                java.util.List<model.Contact> userMessages = contactDAO.getContactsByUserId(userId);
                java.text.SimpleDateFormat msgDateFormat = new java.text.SimpleDateFormat("dd MMM yyyy");
                
                if (userMessages != null && !userMessages.isEmpty()) {
                    // Display up to 5 most recent messages
                    int msgCount = 0;
                    for (model.Contact msg : userMessages) {
                        if (msgCount >= 5) break;
            %>
            <tr>
                <td><%= msg.getSubmittedAt() != null ? msgDateFormat.format(msg.getSubmittedAt()) : "N/A" %></td>
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
                <td>
                    <% if (msg.isRead()) { %>
                        <span class="status-badge read">Read</span>
                    <% } else { %>
                        <span class="status-badge unread">Unread</span>
                    <% } %>
                </td>
            </tr>
            <%
                        msgCount++;
                    }
                } else {
            %>
            <tr>
                <td colspan="3" style="text-align: center;">No messages found</td>
            </tr>
            <%
                }
            %>
            </tbody>
        </table>
    </div>
</section>

</body>
</html>