 <%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>InternConnect</title>
    <!-- Linking to your external CSS file -->
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
</head>
<body>

<!-- Navbar -->
<header class="navbar">
    <div class="logo">InternConnect</div>
    <nav class="nav-links">
        <a href="${pageContext.request.contextPath}/index.jsp" class="active">Home</a>
        <a href="${pageContext.request.contextPath}/view/login.jsp">Login</a>
        <a href="${pageContext.request.contextPath}/view/Register.jsp">Register</a>
        <a href="${pageContext.request.contextPath}/view/JobListing.jsp">Job Listings</a>
        <a href="${pageContext.request.contextPath}/view/About_us.jsp">About Us</a>
        <a href="${pageContext.request.contextPath}/view/contact.jsp">Contact Us</a>
    </nav>
</header>

<!-- Page Content Wrapper -->
<div class="page-content">

    <!-- Hero Section -->
    <section class="hero">
        <h1>Find Internships & Job Placement Portal</h1>
        <p>Discover your path to success by exploring the latest internships and job opportunities.</p>
        <form action="${pageContext.request.contextPath}/SearchServlet" method="get" class="search-bar">
            <input type="text" name="keyword" placeholder="Job title or keyword">
            <input type="text" name="location" placeholder="Location">
            <button type="submit">Search</button>
        </form>
    </section>

    <!-- Features Section -->
    <section class="features">
        <div class="feature-card">
            <h3>Build Your Resume</h3>
            <p>Create a professional resume quickly and easily.</p>
        </div>
        <div class="feature-card">
            <h3>Explore Job Listings</h3>
            <p>Browse through available internships and job opportunities.</p>
        </div>
    </section>

</div>

<!-- Footer -->
<footer class="footer">
    <p>&copy; 2025 InternConnect | Group 1 | All Rights Reserved</p>
</footer>

</body>
</html>
