<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Job Seeker Dashboard | InternConnect</title>
    <link rel="stylesheet" href="../assets/css/UserDashboard.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>

<!-- Navbar -->
<header class="navbar">
    <div class="logo">InternConnect <span>| Job Seeker</span></div>
    <nav class="nav-links">
        <a href="../index.jsp">Home</a>
        <a href="JobListing.jsp">Browse Jobs</a>
        <a href="MyApplications.jsp">My Applications</a>
        <a href="LogoutServlet">Logout</a>
    </nav>
</header>

<!-- Dashboard Content -->
<section class="dashboard-container">
    <h1>Welcome, <span class="highlight">[Job Seeker Name]</span></h1>

    <!-- Cards -->
    <div class="card-grid">
        <div class="card">
            <i class="fas fa-briefcase"></i>
            <h3>Jobs Applied</h3>
            <p>5</p>
        </div>
        <div class="card">
            <i class="fas fa-clock"></i>
            <h3>Pending Applications</h3>
            <p>2</p>
        </div>
        <div class="card">
            <i class="fas fa-calendar-check"></i>
            <h3>Interviews Scheduled</h3>
            <p>1</p>
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
            </tr>
            </thead>
            <tbody>
            <tr>
                <td>UI/UX Designer</td>
                <td>DesignLabs</td>
                <td>30 Apr 2025</td>
                <td>Pending</td>
            </tr>
            <tr>
                <td>Data Analyst Intern</td>
                <td>DataHive</td>
                <td>28 Apr 2025</td>
                <td>Interview Scheduled</td>
            </tr>
            </tbody>
        </table>
    </div>
</section>

</body>
</html>
