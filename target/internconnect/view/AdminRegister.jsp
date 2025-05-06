<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Admin Registration | InternConnect</title>
  <link rel="stylesheet" href="../assets/css/AdminRegister.css">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>

<header class="navbar">
  <div class="logo">InternConnect <span>| Admin Registration</span></div>
</header>

<section class="login-container">
  <div class="login-card">
    <h2>Admin Registration</h2>
    <p class="form-intro">Create an admin account to manage the portal.</p>

    <form action="${pageContext.request.contextPath}/AdminRegisterServlet" method="post">
      <div class="input-group">
        <i class="fas fa-user-shield"></i>
        <input type="text" name="adminName" placeholder="Full Name" required>
      </div>

      <div class="input-group">
        <i class="fas fa-envelope"></i>
        <input type="email" name="email" placeholder="Official Email" required>
      </div>

      <div class="input-group">
        <i class="fas fa-lock"></i>
        <input type="password" name="password" placeholder="Password" required>
      </div>

      <div class="input-group">
        <i class="fas fa-lock"></i>
        <input type="password" name="confirmPassword" placeholder="Confirm Password" required>
      </div>

      <button type="submit" class="login-btn">Register</button>

      <p class="terms-text">Already have an account? <a href="AdminLogin.jsp">Login Here</a></p>
    </form>
  </div>
</section>

</body>
</html>
