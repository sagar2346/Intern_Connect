<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Job Seeker Registration</title>
    <link rel="stylesheet" type="text/css" href="../assets/css/style.css">
    <!-- Font Awesome for icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
</head>
<body>

    <!-- NAVBAR -->
    <div class="navbar">
        <div class="logo">
            InternConnect <span class="logo-role">| Job Seeker</span>
        </div>
    </div>

    <!-- REGISTRATION FORM SECTION -->
    <div class="login-container">
        <div class="login-card">
            <div class="login-header">
                <h1 class="form-heading">Create your free Jobseeker Account</h1>
            </div>
            <p class="form-intro">Register with basic information, complete your profile and start applying for jobs for free!</p>

            <!-- Full Name -->
            <label>Full Name</label>
            <div class="input-group">
                <i class="fa fa-user"></i>
                <input type="text" placeholder="Full Name" name="fullname">
            </div>

            <!-- Mobile Number -->
            <label>Mobile Number</label>
            <div class="input-group">
                <i class="fa fa-phone"></i>
                <input type="text" placeholder="Mobile Number" name="phone">
            </div>

            <!-- Email -->
            <label>Email Address</label>
            <div class="input-group">
                <i class="fa fa-envelope"></i>
                <input type="email" placeholder="E-mail address" name="email">
            </div>

            <!-- Password -->
            <label>Password</label>
            <div class="input-group">
                <i class="fa fa-lock"></i>
                <input type="password" placeholder="Password" name="password">
            </div>

            <!-- Confirm Password -->
            <label>Confirm Password</label>
            <div class="input-group">
                <i class="fa fa-lock"></i>
                <input type="password" placeholder="Password (again)" name="confirmPassword">
            </div>

            <!-- Captcha Placeholder -->
            <div class="input-group captcha-group">
                <div class="captcha-center">
                    <input type="checkbox"> I'm not a robot
                </div>
            </div>

            <!-- Submit Button -->
            <button class="login-btn register-btn-spacing">Create Jobseeker Account</button>

            <!-- Terms -->
            <p class="terms-text">
                By clicking on 'Create Jobseeker Account' below you are agreeing to the 
                <a href="#">terms</a> and <a href="#">privacy</a> of InternConnect.
            </p>

            <!-- Already Have Account -->
            <div class="register-link register-link-spacing">
                Already have a jobseeker account? <a href="JobSeekerLogin.jsp">Log in</a>
            </div>

        </div>
    </div>
</body>
</html>