<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Admin Login | InternConnect</title>
    <link rel="stylesheet" href="../assets/css/Adminlogin.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>

<header class="navbar">
    <div class="logo">InternConnect <span>| Admin Login</span></div>
</header>

<section class="login-container">
    <div class="login-card">
        <h2>Admin Login</h2>
        <p class="form-intro">Only authorized admin can access this portal.</p>

        <form action="${pageContext.request.contextPath}/AdminLoginServlet" method="post">
            <div class="input-group">
                <i class="fas fa-envelope"></i>
                <input type="email" name="email" placeholder="Admin Email" required>
            </div>

            <div class="input-group">
                <i class="fas fa-lock"></i>
                <input type="password" name="password" placeholder="Password" required>
            </div>

            <button class="login-btn" type="submit">
                Login
            </button>


            <p class="terms-text">Don't have an account? <a href="AdminRegister.jsp">Register Here</a></p>
        </form>
    </div>
</section>

</body>
</html>
