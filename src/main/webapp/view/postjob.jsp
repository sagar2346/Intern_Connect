<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Post Job | InternConnect</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/postjob.css?v=1.3">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
</head>
<body>

<div class="dashboard-container">
    <!-- Sidebar -->
    <aside class="sidebar">
        <h2 class="sidebar-title"><i class="fa fa-chart-line"></i> Admin Portal</h2>
        <ul class="sidebar-menu">
            <li><a href="${pageContext.request.contextPath}/view/Admin_dashboard.jsp"><i class="fa fa-home"></i> Overview</a></li>
            <li><a href="${pageContext.request.contextPath}/view/AdminJobListing.jsp"><i class="fa fa-briefcase"></i> Jobs</a></li>
            <li class="active"><a href="${pageContext.request.contextPath}/view/postjob.jsp"><i class="fa fa-plus-circle"></i> Post Job</a></li>
            <li><a href="${pageContext.request.contextPath}/view/ApplicationManagement.jsp"><i class="fa fa-file-alt"></i> Applications</a></li>
            <li><a href="#"><i class="fa fa-users"></i> Users</a></li>
            <li><a href="${pageContext.request.contextPath}/LogoutServlet"><i class="fa fa-sign-out-alt"></i> Logout</a></li>
        </ul>
    </aside>

    <!-- Main Content -->
    <div class="main-content">
        <%-- Display success or error messages --%>
        <%
            String message = request.getParameter("message");
            String error = request.getParameter("error");
        %>
        <% if (message != null) { %>
        <div class="success-msg"><%= message %></div>
        <% } %>
        <% if (error != null) { %>
        <div class="error-msg"><%= error %></div>
        <% } %>

        <!-- Post Job Form -->
        <div class="post-job-container">
            <h2>Post a New Job</h2>
            <form action="${pageContext.request.contextPath}/PostJobServlet" method="post">
                <div class="form-group">
                    <label for="title">Job Title*</label>
                    <input type="text" id="title" name="title" required>
                </div>
                
                <div class="form-group">
                    <label for="company">Company Name*</label>
                    <input type="text" id="company" name="company" required>
                </div>
                
                <div class="form-group">
                    <label for="type">Job Type*</label>
                    <select id="type" name="type" required>
                        <option value="">Select Job Type</option>
                        <option value="Full-time">Full-time</option>
                        <option value="Part-time">Part-time</option>
                        <option value="Internship">Internship</option>
                        <option value="Contract">Contract</option>
                        <option value="Freelance">Freelance</option>
                    </select>
                </div>
                
                <div class="form-group">
                    <label for="category">Category</label>
                    <select id="category" name="category">
                        <option value="">Select Category</option>
                        <option value="IT">Information Technology</option>
                        <option value="Finance">Finance</option>
                        <option value="Marketing">Marketing</option>
                        <option value="Engineering">Engineering</option>
                        <option value="Healthcare">Healthcare</option>
                        <option value="Education">Education</option>
                        <option value="Other">Other</option>
                    </select>
                </div>
                
                <div class="form-group">
                    <label for="location">Location*</label>
                    <input type="text" id="location" name="location" required>
                </div>
                
                <div class="form-group">
                    <label for="salary">Salary Range</label>
                    <input type="text" id="salary" name="salary" placeholder="e.g. $50,000 - $70,000">
                </div>
                
                <div class="form-group">
                    <label for="description">Job Description*</label>
                    <textarea id="description" name="description" rows="5" required></textarea>
                </div>
                
                <div class="form-group">
                    <label for="requirements">Requirements*</label>
                    <textarea id="requirements" name="requirements" rows="5" required></textarea>
                </div>
                
                <div class="form-group">
                    <label for="deadline">Application Deadline</label>
                    <input type="date" id="deadline" name="deadline">
                </div>
                
                <div class="form-actions">
                    <button type="submit" class="submit-btn"><i class="fas fa-paper-plane"></i> Post Job</button>
                    <button type="reset" class="reset-btn"><i class="fas fa-undo"></i> Reset Form</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script>
document.addEventListener('DOMContentLoaded', function() {
    const form = document.querySelector('form');
    
    form.addEventListener('submit', function(event) {
        // Get required fields
        const title = document.getElementById('title').value.trim();
        const company = document.getElementById('company').value.trim();
        const description = document.getElementById('description').value.trim();
        
        // Check if required fields are filled
        if (!title || !company || !description) {
            event.preventDefault();
            alert('Please fill in all required fields: Title, Company, and Description');
        }
    });
});
</script>

</body>
</html>
