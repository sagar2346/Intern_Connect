<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="dao.UserDAO" %>
<%@ page import="model.User" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>My Profile | InternConnect</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/UserDashboard.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/profile.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
</head>
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
%>

<!-- Navbar -->
<header class="navbar">
    <div class="logo">InternConnect <span>| Job Seeker</span></div>
    <nav class="nav-links">
        <a href="UserDashboard.jsp">Home</a>
        <a href="JobListing.jsp">Browse Jobs</a>
        <a href="MyApplications.jsp">My Applications</a>
        <div class="profile-dropdown">
            <a href="UserProfile.jsp" class="profile-icon"><i class="fas fa-user-circle"></i></a>
            <div class="dropdown-content">
                <a href="UserProfile.jsp" class="active"><i class="fas fa-id-card"></i> View Profile</a>
                <a href="EditProfile.jsp"><i class="fas fa-user-edit"></i> Edit Profile</a>
                <a href="LogoutServlet"><i class="fas fa-sign-out-alt"></i> Logout</a>
            </div>
        </div>
    </nav>
</header>

<!-- Profile Content -->
<section class="profile-container">
    <h1>My Profile</h1>
    
    <div class="profile-card">
        <div class="profile-header">
            <div class="profile-avatar">
                <i class="fas fa-user-circle"></i>
            </div>
            <div class="profile-info">
                <h2><%= user.getUsername() %></h2>
                <p><i class="fas fa-envelope"></i> <%= user.getEmail() %></p>
            </div>
            <a href="EditProfile.jsp" class="edit-button">
                <i class="fas fa-edit"></i> Edit Profile
            </a>
        </div>
        
        <div class="profile-details">
            <div class="detail-row">
                <div class="detail-label">Full Name</div>
                <div class="detail-value"><%= user.getUsername() %></div>
            </div>
            <div class="detail-row">
                <div class="detail-label">Email</div>
                <div class="detail-value"><%= user.getEmail() %></div>
            </div>
            <div class="detail-row">
                <div class="detail-label">Phone</div>
                <div class="detail-value"><%= user.getPhone() != null ? user.getPhone() : "Not provided" %></div>
            </div>
            <div class="detail-row">
                <div class="detail-label">Address</div>
                <div class="detail-value"><%= user.getAddress() != null ? user.getAddress() : "Not provided" %></div>
            </div>
            <!-- Removed the Member Since row that was causing the error -->
        </div>
        
        <!-- Add a more prominent edit button at the bottom -->
        <div class="profile-actions">
            <a href="EditProfile.jsp" class="edit-profile-button">
                <i class="fas fa-user-edit"></i> Edit Your Profile
            </a>
        </div>
    </div>
</section>

</body>
</html>
