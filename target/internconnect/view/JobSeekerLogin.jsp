<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Login | InternConnect</title>
    <!-- Link to your CSS with dynamic context path -->
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/login.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
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
            <a href="${pageContext.request.contextPath}/view/register.jsp" class="register-btn">Register</a>
        </div>

        <form action="${pageContext.request.contextPath}/jobSeekerLogin" method="post">
            <% if (request.getAttribute("error") != null) { %>
            <p style="color: red;"><%= request.getAttribute("error") %></p>
            <% } %>

            <label>Email</label>
            <div class="input-group">
                <i class="fas fa-envelope"></i>
                <input type="email" name="email" placeholder="Enter your email" required>
            </div>

            <div class="divider"><span></span></div>

            <label>Password</label>
            <div class="input-group">
                <i class="fas fa-lock"></i>
                <input type="password" id="password" name="password" placeholder="Enter your password" required>
                <i class="fas fa-eye-slash toggle-password" id="togglePassword"></i>
            </div>



            <div class="extras">
                <label><input type="checkbox"> Remember me</label>
                <a href="#">Forgot password?</a>
            </div>

            <button class="login-btn" type="submit">Login</button>

            <div class="register-link">
                Don't have an account? <a href="${pageContext.request.contextPath}/view/Register.jsp">Register</a>
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
