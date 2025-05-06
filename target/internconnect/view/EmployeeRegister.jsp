<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Employer Registration | InternConnect</title>
    <link rel="stylesheet" href="../assets/css/EmployeeRegister.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>

<!-- Navbar -->
<header class="navbar">
    <div class="logo">InternConnect <span>| Employer Zone</span></div>
    <nav class="nav-links">
        <a href="../index.jsp">Home</a>
        <a href="EmployeeZoneLogin.jsp">Login</a>
        <a href="EmployeeRegister.jsp" class="active">Register</a>
    </nav>
</header>

<!-- Main Section -->
<section class="container">
    <div class="form-card">
        <h2>Create your free Employer Account</h2>
        <p class="subtext">Register with InternConnect and find the perfect candidate.</p>

        <form action="${pageContext.request.contextPath}/EmployerRegisterServlet" method="post">

            <div class="input-group">
                <i class="fas fa-building"></i>
                <input type="text" name="companyName" placeholder="Company Name" required>
            </div>

            <div class="input-group">
                <i class="fas fa-industry"></i>
                <select name="companyIndustry" required>
                    <option value="">Select Company Industry Type</option>
                    <option value="IT">Information Technology</option>
                    <option value="Finance">Finance</option>
                    <option value="Healthcare">Healthcare</option>
                    <option value="Education">Education</option>
                </select>
            </div>

            <div class="input-group">
                <i class="fas fa-phone-alt"></i>
                <input type="text" name="companyContact" placeholder="Company Contact Number" required>
            </div>

            <div class="input-group">
                <i class="fas fa-envelope"></i>
                <input type="email" name="email" placeholder="Official Email Address" required>
            </div>

            <div class="input-group">
                <i class="fas fa-lock"></i>
                <input type="password" name="password" placeholder="Password" required>
            </div>

            <div class="input-group">
                <i class="fas fa-lock"></i>
                <input type="password" name="confirmPassword" placeholder="Confirm Password" required>
            </div>

            <div class="checkbox-group">
                <input type="checkbox" required> I'm not a robot
            </div>

            <button type="submit" class="submit-btn">Register Now</button>

            <p class="terms">By clicking on 'Register Now' you agree to our
                <a href="#">Terms & Conditions</a> and
                <a href="#">Privacy Policy</a>.
            </p>

            <p class="login-link">Already have an account? <a href="EmployeeZoneLogin.jsp">Login Here</a></p>
        </form>
    </div>
</section>

</body>
</html>
