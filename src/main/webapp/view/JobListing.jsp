<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="dao.JobDAO, model.Job, filter.JobFilter" %>
<%@ page import="java.util.List" %>
<%@ page import="jakarta.servlet.http.HttpSession" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Job Listings | InternConnect</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/JobListing.css">
    <link rel="stylesheet"
          href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <style>
        :root {
            --primary: #796858;
            --primary-hover: #C1B4AB; /* ~10% darker */
            --background: #EFE6DD;
            --text: #2A2A2A;
            --shadow: rgba(0,0,0,0.1);
        }

        /* Reset */
        *, *::before, *::after {
            margin: 0; padding: 0; box-sizing: border-box;
        }
        body {
            background: var(--background);
            font-family: 'Segoe UI', sans-serif;
            color: var(--text);
        }

        /* Navbar */
        .navbar {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 40px 100px;
            background-color: #DDD0C8;
            border-bottom: 1px solid #DDD0C8;
        }
        .logo {
            font-size: 28px; font-weight: 700; color: #323232;
        }
        .nav-links a {
            margin-left: 50px;
            font-size: 24px; font-weight: 600;
            color: #323232; text-decoration: none;
            position: relative; transition: color .3s;
        }
        .nav-links a:hover { color: #fff; }
        .nav-links a.active::after {
            content: '';
            position: absolute; bottom: -8px; left: 0;
            width: 100%; height: 3px;
            background: #DDD0C8;
            border-radius: 2px;
        }

        /* Hero */
        .hero {
            padding: 80px 100px;
            background: #a68d7c;
            color: var(--background);
            text-align: center;
        }
        .hero h1 { font-size: 42px; margin-bottom: 20px; }
        .hero p { font-size: 20px; }

        /* Job Grid: 4 columns */
        .job-grid {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 20px;
            padding: 20px 100px;
        }
        @media (max-width:1200px) { .job-grid { grid-template-columns: repeat(3,1fr); } }
        @media (max-width:900px)  { .job-grid { grid-template-columns: repeat(2,1fr); } }
        @media (max-width:600px)  { .job-grid { grid-template-columns: 1fr; } }

        /* Job Card */
        .job-card {
            position: relative;
            background: var(--background);
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 2px 5px var(--shadow);
            transition: transform .3s, box-shadow .3s;
        }
        .job-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 6px 15px var(--shadow);
        }
        /* badge */
        .job-card::before {
            content: attr(data-job-type);
            position: absolute;
            top: 12px; right: 12px;
            background: var(--primary);
            color: var(--background);
            font-size: 12px; font-weight: 600;
            padding: 4px 8px; border-radius: 4px;
        }
        .job-card h3 { margin-top:0; margin-bottom:8px; font-size:20px; }
        .job-card p { margin:4px 0; font-size:14px; color:#444; }

        /* Apply Button */
        .apply-btn {
            display: inline-block;
            background: #d1b59f;
            color: var(--background);
            padding: 10px 20px;
            border-radius: 4px;
            text-decoration: none;
            font-weight: 600;
            transition: background .3s;
        }
        .apply-btn:hover {
            background: var(--primary-hover);
        }

        /* Success message */
        .success-message {
            background: #d4edda; color: #155724;
            padding: 10px; margin: 10px 100px;
            border-radius:4px; text-align:center;
        }
    </style>
</head>
<body>

<!-- Navbar -->
<nav class="navbar">
    <div class="logo">InternConnect</div>
    <div class="nav-links">
        <a href="${pageContext.request.contextPath}/index.jsp">Home</a>
        <a href="${pageContext.request.contextPath}/view/JobSeekerLogin.jsp">Login</a>
        <a href="${pageContext.request.contextPath}/view/JobListing.jsp" class="active">Job Listings</a>
    </div>
</nav>

<!-- Success Message -->
<%
    String msg = request.getParameter("message");
    if (msg != null && !msg.isEmpty()) {
%>
<div class="success-message"><%= msg %></div>
<% } %>

<!-- Hero -->
<section class="hero">
    <h1>Find Your Dream Job</h1>
    <p>Browse through our latest job listings and find the perfect opportunity for your career</p>
</section>

<!-- Job Listings -->
<div class="job-grid">
    <%
        JobDAO dao = new JobDAO();
        List<Job> jobs = JobFilter.getApprovedJobs(dao.getAllJobs());
        HttpSession sess = request.getSession(false);
        boolean loggedIn = sess != null && sess.getAttribute("userId") != null;

        if (jobs.isEmpty()) {
    %>
    <div style="grid-column:1/-1; text-align:center; padding:50px;">
        <h3>No jobs available at the moment</h3>
        <p>Please check back later for new opportunities.</p>
    </div>
    <%
    } else {
        for (Job job : jobs) {
    %>
    <div class="job-card" data-job-type="<%= job.getJobType() %>">
        <h3><%= job.getTitle() %></h3>
        <p><strong>Company:</strong> <%= job.getCompanyName() %></p>
        <p><strong>Location:</strong> <%= job.getLocation() %></p>
        <% if (job.getSalary()!=null && !job.getSalary().isEmpty()) { %>
        <p><strong>Salary:</strong> <%= job.getSalary() %></p>
        <% } %>
        <% if (loggedIn) { %>
        <a href="${pageContext.request.contextPath}/view/JobApplication.jsp?jobId=<%=job.getJobId()%>"
           class="apply-btn">Apply Now</a>
        <% } else { %>
        <a href="${pageContext.request.contextPath}/view/JobSeekerLogin.jsp?redirect=job&jobId=<%=job.getJobId()%>"
           class="apply-btn">Login to Apply</a>
        <% } %>
    </div>
    <%   }
    }
    %>
</div>

</body>
</html>
