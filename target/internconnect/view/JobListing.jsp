<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Job Listings | InternConnect</title>
    <!-- Link to CSS with dynamic context path -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/JobListing.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
</head>
<body>

<!-- Navbar -->
<nav class="navbar">
    <div class="logo">InternConnect</div>
    <div class="nav-links">
        <a href="${pageContext.request.contextPath}/index.jsp" class="active">Home</a>
        <a href="${pageContext.request.contextPath}/view/JobSeekerLogin.jsp">Login</a>
        <a href="${pageContext.request.contextPath}/view/JobListing.jsp" class="active">Job Listings</a>
    </div>
</nav>

<!-- 💼 Hero Section -->
<section class="hero">
    <div class="hero-text">
        <h1>1000+ Jobs For You</h1>
        <p>Find suitable jobs for you according to your requirements and your skills</p>
        <a href="#" class="explore-btn">Explore now</a>
    </div>
    <div class="hero-graphic">
        <div class="job-card job1">
            <p>Java Developer</p>
            <span>$120K - $130K</span>
        </div>
        <div class="job-card job2">
            <p>UI / UX Designer</p>
            <span>$100K - $110K</span>
        </div>
    </div>
</section>

<!-- 📋 Job Listing Section -->
<section class="job-section">
    <div class="job-header">
        <h2>All Jobs</h2>
        <select>
            <option>Filter</option>
        </select>
    </div>

    <div class="job-grid">
        <!-- Job Cards with images -->
        <div class="job-box">
            <img src="${pageContext.request.contextPath}/assets/img/java.png" alt="Java Developer" class="job-img">
            <p class="job-type">Onsite</p>
            <h3>Junior Java Developer</h3>
            <p class="job-date">Dec 22, 2024</p>
            <a href="#" class="apply-btn">Apply</a>
        </div>

        <div class="job-box">
            <img src="${pageContext.request.contextPath}/assets/img/python.png" alt="Python Developer" class="job-img">
            <p class="job-type">Onsite</p>
            <h3>Python Developer</h3>
            <p class="job-date">Nov 20, 2024</p>
            <a href="#" class="apply-btn">Apply</a>
        </div>

        <div class="job-box">
            <img src="${pageContext.request.contextPath}/assets/img/marketing.png" alt="Marketing Manager" class="job-img">
            <p class="job-type">Onsite</p>
            <h3>Sales Marketing Manager</h3>
            <p class="job-date">Nov 12, 2024</p>
            <a href="#" class="apply-btn">Apply</a>
        </div>

        <div class="job-box">
            <img src="${pageContext.request.contextPath}/assets/img/hiring.png" alt="Hiring Manager" class="job-img">
            <p class="job-type">Onsite</p>
            <h3>Hiring Manager</h3>
            <p class="job-date">Oct 17, 2024</p>
            <a href="#" class="apply-btn">Apply</a>
        </div>

        <div class="job-box">
            <img src="${pageContext.request.contextPath}/assets/img/security.png" alt="Security Analyst" class="job-img">
            <p class="job-type">Remote</p>
            <h3>Security Analyst</h3>
            <p class="job-date">Oct 10, 2024</p>
            <a href="#" class="apply-btn">Apply</a>
        </div>

        <div class="job-box">
            <img src="${pageContext.request.contextPath}/assets/img/soc.png" alt="Soc Analyst" class="job-img">
            <p class="job-type">Remote</p>
            <h3>Soc Analyst</h3>
            <p class="job-date">Sep 19, 2024</p>
            <a href="#" class="apply-btn">Apply</a>
        </div>
    </div>

    <div class="see-more-container">
        <a href="#" class="see-more-btn">See more Jobs</a>
    </div>
</section>

</body>
</html>
