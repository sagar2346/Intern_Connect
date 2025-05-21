<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Admin Registration | InternConnect</title>

  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
  <style>
    /* AdminRegister.css */

    /* Reset & Base */
    body {
      margin: 0;
      font-family: 'Segoe UI', sans-serif;
      background-color: #EFE6DD;
    }

    /* Navbar - matching AdminLogin.css */
    .navbar {
      display: flex;
      justify-content: space-between;
      align-items: center;
      padding: 40px 100px;
      background-color: #DDD0C8;
      border-bottom: 1px solid #DDD0C8;
    }

    .logo {
      font-size: 28px;
      font-weight: 700;
      color: #323232;
    }

    .nav-links a {
      color: #323232;
      text-decoration: none;
      margin-left: 50px;
      font-size: 24px;
      font-weight: 600;
      position: relative;
      transition: color 0.3s ease;
    }

    .nav-links a:hover {
      color: #ffffff;
    }

    .nav-links a.active::after {
      content: '';
      position: absolute;
      width: 100%;
      height: 3px;
      background: #DDD0C8;
      bottom: -8px;
      left: 0;
      border-radius: 2px;
    }

    /* Employer Navbar - matching AdminLogin.css */
    .employer-navbar {
      display: flex;
      justify-content: space-between;
      align-items: center;
      background-color: #D6C8BE;
      padding: 25px 60px;
      border-bottom: 2px solid #CBBBAF;
    }

    .navbar-left {
      display: flex;
      align-items: center;
    }

    .logo {
      font-size: 28px;
      font-weight: bold;
      color: #2A2A2A;
    }

    .zone-label {
      font-weight: 400;
      font-size: 16px;
      margin-left: 8px;
    }

    /* Container */
    .login-container {
      display: flex;
      justify-content: center;
      align-items: center;
      padding: 0 20px;
      min-height: calc(100vh - 80px);
    }

    /* Registration Card */
    .login-card {
      background-color: #D6C8BE;
      border-radius: 20px;
      box-shadow: 0 12px 30px rgba(0, 0, 0, 0.1);
      width: 600px;
      max-width: 90%;
      padding: 40px;
    }

    .login-card h2 {
      font-size: 24px;
      margin-bottom: 10px;
      color: #2A2A2A;
    }

    .form-intro {
      font-size: 14px;
      color: #2A2A2A;
      margin-bottom: 25px;
    }

    /* Input Fields */
    .input-group {
      display: flex;
      align-items: center;
      background-color: #EFE6DD;
      padding: 14px 16px;
      border-radius: 12px;
      margin-bottom: 20px;
    }

    .input-group i {
      color: #2A2A2A;
      margin-right: 12px;
      font-size: 18px;
    }

    .input-group input {
      background: transparent;
      border: none;
      outline: none;
      font-size: 16px;
      color: #2A2A2A;
      flex: 1;
    }

    /* Error & Success Messages */
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

    /* Button */
    .login-btn {
      width: 100%;
      padding: 14px;
      background-color: #2A2A2A;
      color: #EFE6DD;
      font-size: 16px;
      font-weight: bold;
      border: none;
      border-radius: 10px;
      cursor: pointer;
      transition: background-color 0.3s ease, opacity 0.3s ease;
    }

    .login-btn:hover {
      opacity: 0.85;
    }

    /* Text Links */
    .terms-text {
      font-size: 13px;
      color: #2A2A2A;
      margin-top: 15px;
      text-align: center;
    }

    .terms-text a {
      color: #2A2A2A;
      text-decoration: underline;
    }

    .terms-text a:hover {
      color: #444;
    }
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
  </style>
</head>
<body>

<header class="navbar">
  <div class="navbar-left">
    <div class="logo">InternConnect <span class="zone-label">| Admin Zone</span></div>
  </div>
  <nav class="nav-links">
    <a href="${pageContext.request.contextPath}/index.jsp">Home</a>
    <a href="${pageContext.request.contextPath}/view/AdminLogin.jsp">Login</a>
    <a href="${pageContext.request.contextPath}/view/AdminRegister.jsp" class="active">Register</a>
  </nav>
</header>

<section class="login-container">
  <div class="login-card">
    <h2>Admin Registration</h2>
    <p class="form-intro">Create an admin account to manage the portal.</p>

    <% if (request.getAttribute("error") != null) { %>
    <div class="error-message">
      <i class="fas fa-exclamation-circle"></i>
      <%= request.getAttribute("error") %>
    </div>
    <% } %>

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

      <p class="terms-text">Already have an account? <a href="${pageContext.request.contextPath}/view/AdminLogin.jsp">Login Here</a></p>
    </form>
  </div>
</section>

</body>
</html>
