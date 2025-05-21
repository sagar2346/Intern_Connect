<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Login | InternConnect</title>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/login.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <style>
        .error-message {
            color: #e74c3c;
            background-color: #fdecea;
            border-left: 4px solid #e74c3c;
            padding: 10px 15px;
            margin-bottom: 20px;
            border-radius: 4px;
            font-size: 14px;
        }
        
        .success-message {
            color: #2ecc71;
            background-color: #eafaf1;
            border-left: 4px solid #2ecc71;
            padding: 10px 15px;
            margin-bottom: 20px;
            border-radius: 4px;
            font-size: 14px;
        }
        
        .error-message i, .success-message i {
            margin-right: 8px;
        }
        
        /* Password field styling */
        .password-input {
            position: relative;
            width: 100%;
        }
        
        .password-input input {
            width: 100%;
            padding-right: 40px; /* Make room for the eye icon */
        }
        
        .toggle-password {
            position: absolute;
            right: 10px;
            top: 50%;
            transform: translateY(-50%);
            cursor: pointer;
            color: #777;
            z-index: 10;
        }
        
        .toggle-password:hover {
            color: #2A2A2A;
        }
        
        /* Fix for duplicate labels */
        .input-group label {
            display: none;
        }
    </style>
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

<!-- Main Login Content -->
<main class="login-container">
    <div class="login-card">
        <div class="login-header">
            <h1>LOGIN</h1>
            <a href="${pageContext.request.contextPath}/view/Register.jsp" class="register-btn">Register</a>
        </div>

        <% 
            // Display error message if any
            String error = (String) request.getAttribute("error");
            if (error != null) {
        %>
        <div class="error-message">
            <i class="fas fa-exclamation-circle"></i> <%= error %>
        </div>
        <% } %>

        <% 
            // Display registration success message if any
            String registrationSuccess = (String) session.getAttribute("registrationSuccess");
            if (registrationSuccess != null) {
                // Remove the message from session to avoid displaying it again
                session.removeAttribute("registrationSuccess");
        %>
        <div class="success-message">
            <i class="fas fa-check-circle"></i> <%= registrationSuccess %>
        </div>
        <% } %>

        <% 
            // Display login success message if any
            String loginSuccess = (String) session.getAttribute("loginSuccess");
            if (loginSuccess != null) {
                // Remove the message from session to avoid displaying it again
                session.removeAttribute("loginSuccess");
        %>
        <div class="success-message">
            <i class="fas fa-check-circle"></i> <%= loginSuccess %>
        </div>
        <% } %>

        <!-- Get redirect parameters if any -->
        <% 
            String redirect = request.getParameter("redirect");
            String jobId = request.getParameter("jobId");
            String redirectParams = "";
            
            if (redirect != null && jobId != null) {
                redirectParams = "&redirect=" + redirect + "&jobId=" + jobId;
            }
        %>

        <form action="${pageContext.request.contextPath}/JobSeekerLoginServlet<%= redirectParams.isEmpty() ? "" : "?" + redirectParams.substring(1) %>" method="post">
            <label>Email</label>
            <div class="input-group">
                <label for="email">Email</label>
                <input type="email" id="email" name="email" required>
            </div>

            <label>Password</label>
            <div class="input-group">
                <label for="password">Password</label>
                <div class="password-input">
                    <input type="password" id="password" name="password" required>
                    <i class="fas fa-eye-slash toggle-password" id="togglePassword"></i>
                </div>
            </div>

            <div class="extras">
                <label><input type="checkbox"> Remember me</label>
                <a href="#">Forgot password?</a>
            </div>

            <button class="login-btn" type="submit">Login</button>

            <div class="register-link">
                Don't have an account? <a href="${pageContext.request.contextPath}/view/JobSeekerRegister.jsp<%= redirectParams.isEmpty() ? "" : "?" + redirectParams.substring(1) %>">Register</a>
            </div>
        </form>
    </div>
</main>

<!-- JS for Eye Toggle -->
<script>
    const togglePassword = document.getElementById("togglePassword");
    const password = document.getElementById("password");

    togglePassword.addEventListener("click", function () {
        const type = password.getAttribute("type") === "password" ? "text" : "password";
        password.setAttribute("type", type);
        this.classList.toggle("fa-eye");
        this.classList.toggle("fa-eye-slash");
    });
</script>

</body>
</html>
