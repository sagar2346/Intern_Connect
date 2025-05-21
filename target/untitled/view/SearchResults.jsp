xx<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="model.Job" %>
<%@ page import="jakarta.servlet.http.HttpSession" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Search Results | InternConnect</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/JobListing.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <style>
        /* Enhanced Search Results Styling */
        :root {
            --primary: #D6C8BE;
            --primary-hover: #C1B4AB;
            --secondary: #CBBBAF;
            --background: #EFE6DD;
            --text: #2A2A2A;
            --text-light: #555;
            --shadow: rgba(0,0,0,0.1);
            --radius: 10px;
            --transition: all 0.3s ease;
        }
        
        body {
            background-color: var(--background);
            font-family: 'Segoe UI', sans-serif;
            color: var(--text);
            line-height: 1.6;
            min-height: 100vh;
            display: flex;
            flex-direction: column;
        }
        
        /* Search Results Header */
        .search-results-header {
            background: linear-gradient(to right, #D6C8BE, #CBBBAF);
            padding: 40px 30px;
            text-align: center;
            margin-bottom: 40px;
            border-radius: 0 0 var(--radius) var(--radius);
            box-shadow: 0 4px 15px var(--shadow);
        }
        
        .search-results-header h1 {
            font-size: 36px;
            margin-bottom: 15px;
            color: var(--text);
            font-weight: 700;
        }
        
        .search-results-header p {
            font-size: 20px;
            color: var(--text-light);
            margin-bottom: 25px;
        }
        
        /* Enhanced Search Form - Matching Index Style */
        .search-form {
            background-color: #CBBBAF;
            padding: 30px 40px;
            border-radius: 20px;
            display: flex;
            gap: 25px;
            box-shadow: 0 8px 30px rgba(0, 0, 0, 0.1);
            justify-content: center;
            margin: 0 auto 30px;
            max-width: 900px;
            flex-wrap: nowrap;
        }
        
        .search-form input {
            padding: 22px 28px;
            border: none;
            border-radius: 10px;
            background-color: #DDD0C8;
            color: #323232;
            font-size: 20px;
            width: 300px;
        }
        
        .search-form input::placeholder {
            color: #999;
        }
        
        .search-form button {
            background-color: #DDD0C8;
            color: #323232;
            border: none;
            padding: 22px 34px;
            border-radius: 10px;
            font-size: 20px;
            font-weight: bold;
            cursor: pointer;
            transition: background-color 0.3s, transform 0.3s;
            display: flex;
            align-items: center;
            white-space: nowrap;
        }
        
        .search-form button:hover {
            background-color: #c2b3aa;
            transform: scale(1.05);
        }
        
        .search-form button i {
            margin-right: 10px;
        }
        
        /* Content Wrapper - To push footer down */
        .content-wrapper {
            flex: 1;
        }
        
        /* Enhanced Job Grid */
        .job-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
            gap: 25px;
            padding: 20px 100px 60px;
            max-width: 1400px;
            margin: 0 auto;
        }
        
        /* Enhanced Job Card */
        .job-card {
            position: relative;
            background: #FFFFFF;
            padding: 25px;
            border-radius: var(--radius);
            box-shadow: 0 5px 15px var(--shadow);
            transition: var(--transition);
            border-top: 5px solid var(--primary);
            display: flex;
            flex-direction: column;
            height: 100%;
        }
        
        .job-card:hover {
            transform: translateY(-8px);
            box-shadow: 0 12px 30px rgba(0,0,0,0.15);
        }
        
        .job-card h3 {
            margin-top: 0;
            margin-bottom: 15px;
            font-size: 22px;
            color: var(--text);
            padding-right: 80px; /* Space for badge */
        }
        
        .job-card p {
            margin: 8px 0;
            font-size: 15px;
            color: var(--text-light);
        }
        
        .job-card p strong {
            color: var(--text);
            font-weight: 600;
        }
        
        /* Badge */
        .job-card::before {
            content: attr(data-job-type);
            position: absolute;
            top: 15px;
            right: 15px;
            background: var(--primary);
            color: var(--text);
            font-size: 13px;
            font-weight: 600;
            padding: 5px 10px;
            border-radius: 20px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }
        
        /* Apply Button */
        .apply-btn {
            display: inline-block;
            background: var(--primary);
            color: var(--text);
            padding: 12px 25px;
            border-radius: var(--radius);
            text-decoration: none;
            font-weight: 600;
            transition: var(--transition);
            text-align: center;
            margin-top: auto;
            border: none;
            cursor: pointer;
            font-size: 15px;
        }
        
        .apply-btn:hover {
            background: var(--primary-hover);
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(0,0,0,0.1);
        }
        
        /* No Results */
        .no-results {
            text-align: center;
            padding: 60px 40px;
            background-color: #FFFFFF;
            border-radius: var(--radius);
            margin: 30px auto 60px;
            max-width: 800px;
            box-shadow: 0 5px 15px var(--shadow);
        }
        
        .no-results h3 {
            font-size: 28px;
            margin-bottom: 15px;
            color: var(--text);
        }
        
        .no-results p {
            font-size: 18px;
            color: var(--text-light);
            margin-bottom: 15px;
        }
        
        .no-results i {
            font-size: 60px;
            color: var(--primary);
            margin-bottom: 20px;
            opacity: 0.8;
        }
        
        .no-results a {
            display: inline-block;
            color: var(--primary);
            font-weight: 600;
            text-decoration: none;
            padding: 10px 20px;
            border: 2px solid var(--primary);
            border-radius: var(--radius);
            margin-top: 15px;
            transition: var(--transition);
        }
        
        .no-results a:hover {
            background-color: var(--primary);
            color: #FFFFFF;
        }
        
        /* Company Logo */
        .company-logo {
            width: 50px;
            height: 50px;
            background-color: var(--primary);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-bottom: 15px;
            color: #FFFFFF;
            font-size: 20px;
            font-weight: bold;
        }
        
        /* Job Details */
        .job-details {
            display: flex;
            flex-wrap: wrap;
            gap: 10px;
            margin: 15px 0;
        }
        
        .job-detail {
            display: flex;
            align-items: center;
            background-color: rgba(214,200,190,0.2);
            padding: 6px 12px;
            border-radius: 20px;
            font-size: 14px;
        }
        
        .job-detail i {
            margin-right: 6px;
            color: var(--primary);
        }
        
        /* Footer */
        .footer {
            background-color: var(--primary);
            color: var(--text);
            text-align: center;
            padding: 20px;
            margin-top: auto;
        }
        
        /* Responsive Adjustments */
        @media (max-width: 992px) {
            .job-grid {
                padding: 20px 50px;
            }
            
            .search-results-header {
                padding: 30px 20px;
            }
            
            .search-form {
                padding: 25px 30px;
            }
            
            .search-form input {
                width: 250px;
                padding: 18px 22px;
                font-size: 18px;
            }
            
            .search-form button {
                padding: 18px 25px;
                font-size: 18px;
            }
        }
        
        @media (max-width: 768px) {
            .search-form {
                gap: 15px;
                padding: 20px;
            }
            
            .search-form input {
                width: 200px;
                padding: 15px 20px;
                font-size: 16px;
            }
            
            .search-form button {
                padding: 15px 20px;
                font-size: 16px;
            }
            
            .job-grid {
                padding: 20px 30px;
            }
            
            .search-results-header h1 {
                font-size: 28px;
            }
            
            .search-results-header p {
                font-size: 16px;
            }
        }
        
        @media (max-width: 600px) {
            .search-form {
                flex-direction: column;
            }
            
            .search-form input {
                width: 100%;
            }
        }
    </style>
</head>
<body>

<!-- Navbar -->
<nav class="navbar">
    <div class="logo">InternConnect</div>
    <div class="nav-links">
        <a href="${pageContext.request.contextPath}/index.jsp">Home</a>
        <a href="${pageContext.request.contextPath}/view/login.jsp">Login</a>
        <a href="${pageContext.request.contextPath}/view/Register.jsp">Register</a>
        <a href="${pageContext.request.contextPath}/view/JobListing.jsp" class="active">Job Listings</a>
    </div>
</nav>

<!-- Content Wrapper -->
<div class="content-wrapper">
    <!-- Search Results Header -->
    <section class="search-results-header">
        <h1>Search Results</h1>
        <p>Found ${totalResults} jobs matching your search criteria</p>
        
        <!-- Search Form -->
        <form action="${pageContext.request.contextPath}/SearchServlet" method="get" class="search-form">
            <input type="text" name="keyword" placeholder="Job title or keyword" value="${keyword}">
            <input type="text" name="location" placeholder="Location" value="${location}">
            <button type="submit"><i class="fas fa-search"></i> Search</button>
        </form>
    </section>

    <!-- Job Listings -->
    <div class="job-grid">
        <%
            List<Job> jobs = (List<Job>) request.getAttribute("jobs");
            HttpSession sess = request.getSession(false);
            boolean loggedIn = sess != null && sess.getAttribute("userId") != null;

            if (jobs == null || jobs.isEmpty()) {
        %>
        <div class="no-results" style="grid-column: 1 / -1;">
            <i class="fas fa-search"></i>
            <h3>No jobs found matching your search criteria</h3>
            <p>Try adjusting your search terms or browse all available jobs.</p>
            <a href="${pageContext.request.contextPath}/view/JobListing.jsp">View all job listings</a>
        </div>
        <%
            } else {
                for (Job job : jobs) {
                    // Get first letter of company name for logo
                    String companyInitial = job.getCompanyName() != null && !job.getCompanyName().isEmpty() ? 
                                           job.getCompanyName().substring(0, 1).toUpperCase() : "C";
        %>
        <div class="job-card" data-job-type="<%= job.getJobType() %>">
            <div class="company-logo"><%= companyInitial %></div>
            <h3><%= job.getTitle() %></h3>
            
            <div class="job-details">
                <div class="job-detail"><i class="fas fa-building"></i> <%= job.getCompanyName() %></div>
                <div class="job-detail"><i class="fas fa-map-marker-alt"></i> <%= job.getLocation() %></div>
                <% if (job.getSalary()!=null && !job.getSalary().isEmpty()) { %>
                <div class="job-detail"><i class="fas fa-money-bill-wave"></i> <%= job.getSalary() %></div>
                <% } %>
            </div>
            
            <p><%= job.getDescription() != null ? 
                   (job.getDescription().length() > 100 ? 
                    job.getDescription().substring(0, 100) + "..." : 
                    job.getDescription()) : 
                   "No description available" %></p>
            
            <% if (loggedIn) { %>
            <a href="${pageContext.request.contextPath}/view/JobApplication.jsp?jobId=<%=job.getJobId()%>"
               class="apply-btn"><i class="fas fa-paper-plane"></i> Apply Now</a>
            <% } else { %>
            <a href="${pageContext.request.contextPath}/view/JobSeekerLogin.jsp?redirect=JobApplication.jsp?jobId=<%=job.getJobId()%>"
               class="apply-btn"><i class="fas fa-sign-in-alt"></i> Login to Apply</a>
            <% } %>
        </div>
        <%
                }
            }
        %>
    </div>
</div>

<!-- Footer -->
<footer class="footer">
    <p>&copy; 2025 InternConnect | All Rights Reserved</p>
</footer>

</body>
</html>