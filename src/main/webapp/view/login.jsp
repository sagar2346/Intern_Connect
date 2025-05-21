<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Login | InternConnect</title>
    <!-- Link to your CSS with dynamic context path -->
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/style.css">
    <link rel="stylesheet"
          href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
</head>
<body>

<!-- Navbar -->
<header class="navbar">
    <div class="logo">InternConnect</div>
    <nav class="nav-links">
        <a href="${pageContext.request.contextPath}/index.jsp">Home</a>
        <a href="${pageContext.request.contextPath}/view/login.jsp" class="active">Login</a>
        <a href="${pageContext.request.contextPath}/view/Register.jsp">Register</a>
        <a href="${pageContext.request.contextPath}/view/JobListing.jsp">Job Listings</a>
    </nav>
</header>

<!-- Split Login -->
<main class="register-section">
    <!-- Job Seeker -->
    <div class="register-card">
        <i class="fas fa-user-friends"></i>
        <h2>Job Seeker</h2>
        <p>Log in to apply for internships and jobs!</p>
        <a href="${pageContext.request.contextPath}/view/JobSeekerLogin.jsp">Login</a>
    </div>

    <!-- Divider -->
    <div class="divider-vertical"></div>

    <!-- Admin -->
    <div class="register-card">
        <i class="fas fa-user-shield"></i>
        <h2>Admin</h2>
        <p>Log in to manage the platform and settings.</p>
        <a href="${pageContext.request.contextPath}/view/AdminLogin.jsp">Login</a>
    </div>
</main>

<!-- Bottom Link -->
<div class="bottom-login-link">
    Don’t have an account? <a href="${pageContext.request.contextPath}/view/Register.jsp">Register</a>
</div>

</body>
</html>
