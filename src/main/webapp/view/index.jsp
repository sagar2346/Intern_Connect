<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Internship & Job Placement Portal</title>
    <link rel="stylesheet" type="text/css" href="../assets/css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
</head>
<body>

<!-- Navbar -->
<header class="navbar">
    <div class="logo">InternConnect</div>
    <nav class="nav-links">
        <a href="index.jsp" class="active">Home</a>
        <a href="login.jsp">Login</a>
        <a href="register.jsp">Register</a>
        <a href="job_listings.jsp">Job Listings</a>

        <!-- Zone Dropdown -->
        <div class="dropdown">
            <span class="dropbtn">Zone</span>
            <div class="dropdown-content">
                <a href="employee_zone.jsp">Employee Zone</a>
                <a href="admin_zone.jsp">Admin Zone</a>
            </div>
        </div>
    </nav>
</header>

<!-- Page Content Wrapper -->
<div class="page-content">

    <!-- Hero Section -->
    <section class="hero">
        <h1>Find Internships & Job Placement Portal</h1>
        <p>Discover your path to success by exploring the latest internships and job opportunities.</p>
        <div class="search-bar">
            <input type="text" placeholder="Job title">
            <input type="text" placeholder="Location">
            <button>Search</button>
        </div>
    </section>

    <!-- Features -->
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
