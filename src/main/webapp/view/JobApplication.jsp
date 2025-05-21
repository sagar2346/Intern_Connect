<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, util.DatabaseConnection, model.Job" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Job Application Form</title>
    <!-- Link to CSS with dynamic context path -->
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/JobApplication.css">
</head>
<body>

<%
    // Check if user is logged in
    HttpSession userSession = request.getSession(false);
    boolean isLoggedIn = userSession != null && userSession.getAttribute("loggedIn") != null && (Boolean)userSession.getAttribute("loggedIn");
    
    if (!isLoggedIn) {
        // Redirect to login page with redirect parameters
        String jobId = request.getParameter("jobId");
        response.sendRedirect(request.getContextPath() + "/view/JobSeekerLogin.jsp?redirect=job&jobId=" + jobId);
        return;
    }
    
    // Get job details
    String jobId = request.getParameter("jobId");
    String jobTitle = "";
    String companyName = "";
    
    if (jobId != null && !jobId.isEmpty()) {
        try (Connection conn = DatabaseConnection.getConnection()) {
            String query = "SELECT title, company_name FROM jobs WHERE job_id = ?";
            PreparedStatement stmt = conn.prepareStatement(query);
            stmt.setInt(1, Integer.parseInt(jobId));
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                jobTitle = rs.getString("title");
                companyName = rs.getString("company_name");
            } else {
                response.sendRedirect(request.getContextPath() + "/view/JobListing.jsp?error=Job not found");
                return;
            }
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/view/JobListing.jsp?error=Database error");
            return;
        }
    } else {
        response.sendRedirect(request.getContextPath() + "/view/JobListing.jsp?error=Invalid job ID");
        return;
    }
    
    // Get user details from session
    Integer userId = (Integer) userSession.getAttribute("userId");
    String email = (String) userSession.getAttribute("email");
    String username = (String) userSession.getAttribute("username");
%>

<div class="navbar">
    <div class="logo">InternConnect <span>| Job Application</span></div>
    <nav class="nav-links">
        <a href="${pageContext.request.contextPath}UserDashboard.jsp">Home</a>
        <a href="${pageContext.request.contextPath}/view/JobListing.jsp">Job Listings</a>
        <a href="${pageContext.request.contextPath}/view/UserDashboard.jsp">Dashboard</a>
    </nav>
</div>

<div class="form-container">
    <h2 class="form-title">Job Application</h2>
    <p class="form-intro">Applying for: <strong><%= jobTitle %></strong> at <strong><%= companyName %></strong></p>
    
    <% 
        // Display error message if any
        String error = request.getParameter("error");
        if (error != null && !error.isEmpty()) {
    %>
    <div class="error-message">
        <%= error %>
    </div>
    <% } %>

    <form action="${pageContext.request.contextPath}/JobApplicationServlet" method="post" enctype="multipart/form-data">
        <!-- Hidden field for job ID -->
        <input type="hidden" name="jobId" value="<%= jobId %>">
        <input type="hidden" name="position" value="<%= jobTitle %>">

        <!-- Name -->
        <div class="form-row two-cols">
            <div>
                <label>First Name*</label>
                <input type="text" name="firstName" required value="<%= username.split(" ").length > 0 ? username.split(" ")[0] : "" %>">
            </div>
            <div>
                <label>Last Name*</label>
                <input type="text" name="lastName" required value="<%= username.split(" ").length > 1 ? username.split(" ")[1] : "" %>">
            </div>
        </div>

        <!-- Email -->
        <div class="form-row">
            <label>Email*</label>
            <input type="email" name="email" required value="<%= email %>">
        </div>

        <!-- Phone -->
        <div class="form-row">
            <label>Phone Number*</label>
            <input type="tel" name="phone" required>
        </div>

        <!-- Address -->
        <div class="form-row">
            <label>Address</label>
            <input type="text" name="address" placeholder="Street address">
        </div>

        <!-- City -->
        <div class="form-row">
            <label>City</label>
            <input type="text" name="city" placeholder="City">
        </div>

        <!-- Extra Info -->
        <div class="form-row">
            <label>Additional Info (Optional)</label>
            <textarea name="additionalInfo" rows="5" placeholder="Mention any relevant experience or notes..."></textarea>
        </div>

        <!-- File Uploads -->
        <div class="form-row two-cols">
            <div>
                <label>Upload your resume* (PDF, DOC, DOCX)</label>
                <input type="file" name="resume" accept=".pdf,.doc,.docx" required>
            </div>
            <div>
                <label>Upload cover letter (optional)</label>
                <input type="file" name="coverLetter" accept=".pdf,.doc,.docx">
            </div>
        </div>

        <div class="form-row">
            <button type="submit" class="submit-btn">Submit Application</button>
        </div>
    </form>
</div>

</body>
</html>
