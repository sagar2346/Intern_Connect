<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Employer Login | InternConnect</title>
    <link rel="stylesheet" href="../assets/css/employee_zone.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
</head>
<body>

<!-- NAVIGATION -->

<div class="employer-navbar">
    <div class="navbar-left">
        <div class="logo">InternConnect <span class="zone-label">| Employer Zone</span></div>
    </div>
    <div class="nav-links">
        <a href="index.jsp">Home</a>
        <a href="employee_zone.jsp">Login</a>
        <a href="register.jsp">Register</a>
    </div>
</div>


<!-- MAIN CONTAINER -->
<div class="employer-login-wrapper">
    <!-- LEFT: Info -->
    <div class="employer-info">
        <h1>Welcome to Your Hiring Dashboard</h1>
        <p>Efficiently manage applicants, post new openings, and find the ideal candidate — all in one place.</p>
    </div>

    <!-- RIGHT: Login Form -->
    <div class="login-box">
        <h2>Employer Login</h2>
        <p class="subtitle">Sign in with your official credentials</p>

        <form action="EmployerLoginServlet" method="post">
            <!-- Email -->
            <label>Email Address</label>
            <div class="input-icon-group">
                <i class="fa fa-envelope"></i>
                <input type="email" name="email" placeholder="E-mail address" required>
            </div>

            <!-- Password -->
            <label>Password</label>
            <div class="input-icon-group">
                <i class="fa fa-lock"></i>
                <input type="password" name="password" placeholder="Password" required>
            </div>

            <!-- Extras -->
            <div class="extra-options">
                <label><input type="checkbox" name="remember"> Remember Me</label>
                <a href="#">Forgot Password?</a>
            </div>

            <!-- Login Button -->
            <button type="submit" class="login-btn"><i class="fa fa-sign-in-alt"></i> Login</button>

            <!-- Register Link -->
            <p class="register-text">Don’t have an account? <a href="employer_register.jsp">Register Now</a></p>
        </form>
    </div>
</div>

</body>
</html>
