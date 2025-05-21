<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Admin Login | InternConnect</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/Admin_login.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
</head>
<body>

<!-- NAVIGATION -->
<div class="employer-navbar">
    <div class="navbar-left">
        <div class="logo">InternConnect <span class="zone-label">| Admin Zone</span></div>
    </div>
    <div class="nav-links">
        <a href="${pageContext.request.contextPath}/index.jsp">Home</a>
        <a href="${pageContext.request.contextPath}/view/AdminLogin.jsp" class="active">Login</a>
        <a href="${pageContext.request.contextPath}/view/AdminRegister.jsp">Register</a>
    </div>
</div>

<!-- MAIN CONTAINER -->
<div class="employer-login-wrapper">
    <!-- LEFT: Info -->
    <div class="employer-info">
        <h1>Welcome, Admin</h1>
        <p>Manage your portal settings, view reports, and oversee all platform activity from here.</p>
    </div>

    <!-- RIGHT: Login Form -->
    <div class="login-box">
        <h2>Admin Login</h2>
        <p class="subtitle">Enter your administrator credentials</p>

        <%-- show error or success messages --%>
        <% if (request.getAttribute("error") != null) { %>
        <div class="error-message">
            <i class="fas fa-exclamation-circle"></i>
            <%= request.getAttribute("error") %>
        </div>
        <% } %>
        <% if (session.getAttribute("registrationSuccess") != null) { %>
        <div class="success-message">
            <i class="fas fa-check-circle"></i>
            <%= session.getAttribute("registrationSuccess") %>
            <% session.removeAttribute("registrationSuccess"); %>
        </div>
        <% } %>

        <form action="${pageContext.request.contextPath}/AdminLoginServlet" method="post">
            <label>Admin Email</label>
            <div class="input-icon-group">
                <i class="fa fa-envelope"></i>
                <input type="email" name="email" placeholder="admin@yourcompany.com" required>
            </div>

            <label>Password</label>
            <div class="input-icon-group">
                <i class="fa fa-lock"></i>
                <input type="password" name="password" placeholder="••••••••" required>
            </div>

            <div class="extra-options">
                <label><input type="checkbox" name="remember"> Remember Me</label>
                <a href="#">Forgot Password?</a>
            </div>

            <button type="submit" class="login-btn">
                <i class="fa fa-sign-in-alt"></i> Login
            </button>

            <p class="register-text">
                Don't have an admin account?
                <a href="${pageContext.request.contextPath}/view/AdminRegister.jsp">
                    Register Here
                </a>
            </p>
        </form>
    </div>
</div>

</body>
</html>