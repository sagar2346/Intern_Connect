<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="dao.UserDAO" %>
<%@ page import="model.User" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Edit Profile | InternConnect</title>
    <!-- Internal CSS for navbar and profile container -->
    <style>
        /* Reset & Base */
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        html, body {
            height: 100%;
            font-family: 'Segoe UI', sans-serif;
            background-color: #EFE6DD; /* Beige */
            color: #323232; /* Dark Grey */
        }

        body {
            display: flex;
            flex-direction: column;
            min-height: 100vh;
            overflow-x: hidden;
        }

        /* Navbar */
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

        .logo span {
            font-weight: 500;
            font-size: 24px;
            opacity: 0.8;
        }

        .nav-links {
            display: flex;
            align-items: center;
            gap: 50px;
        }

        .nav-links a {
            color: #323232;
            text-decoration: none;
            margin-left: 0;
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

        /* Profile dropdown */
        .profile-dropdown {
            position: relative;
        }

        .profile-icon {
            font-size: 25px;
            color: #323232;
            cursor: pointer;
            transition: color 0.3s, transform 0.2s;
        }

        .profile-icon:hover {
            color: #8C7B6B;
            transform: scale(1.1);
        }

        .dropdown-content {
            display: none;
            position: absolute;
            right: 0;
            background-color: #FFFFFF;
            min-width: 200px;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
            border-radius: 8px;
            z-index: 1;
            overflow: hidden;
        }

        .dropdown-content a {
            color: #323232;
            padding: 12px 16px;
            text-decoration: none;
            display: block;
            font-size: 16px;
            margin-left: 0;
            transition: background-color 0.3s;
        }

        .dropdown-content a i {
            margin-right: 10px;
            width: 20px;
            text-align: center;
        }

        .dropdown-content a:hover {
            background-color: #EFE6DD;
            color: #323232;
        }

        .dropdown-content a.active {
            background-color: #EFE6DD;
            font-weight: 600;
        }

        .profile-dropdown:hover .dropdown-content {
            display: block;
            animation: fadeIn 0.2s ease;
        }

        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(-10px); }
            to { opacity: 1; transform: translateY(0); }
        }

        /* Edit Profile Container Styles */
        .edit-profile-container {
            width: 90%;
            max-width: 1200px;
            margin: 40px auto;
            padding: 0 20px;
        }

        .edit-profile-container h1 {
            font-size: 32px;
            margin-bottom: 30px;
            color: #2A2A2A;
            position: relative;
            padding-bottom: 10px;
        }

        .edit-profile-container h1::after {
            content: '';
            position: absolute;
            bottom: 0;
            left: 0;
            width: 60px;
            height: 4px;
            background-color: #D6C8BE;
            border-radius: 2px;
        }

        .edit-profile-card {
            background-color: #D6C8BE;
            border-radius: 12px;
            box-shadow: 0 8px 25px rgba(0, 0, 0, 0.12);
            overflow: hidden;
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }

        .edit-profile-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 12px 30px rgba(0, 0, 0, 0.15);
        }

        /* Form Styling */
        .edit-profile-form {
            padding: 35px;
        }

        .form-group {
            margin-bottom: 28px;
            position: relative;
        }

        .form-group label {
            display: block;
            margin-bottom: 10px;
            font-weight: 600;
            color: #2A2A2A;
            font-size: 16px;
            transition: color 0.3s ease;
        }

        .form-group:focus-within label {
            color: #8C7B6B;
        }

        .form-group label i {
            margin-right: 10px;
            color: #8C7B6B;
            width: 18px;
            text-align: center;
        }

        .form-group input {
            width: 100%;
            padding: 14px 18px;
            border: 2px solid #EFE6DD;
            border-radius: 8px;
            font-size: 16px;
            background-color: #EFE6DD;
            transition: border-color 0.3s ease, box-shadow 0.3s ease, transform 0.2s ease;
        }

        .form-group input:focus {
            outline: none;
            border-color: #8C7B6B;
            box-shadow: 0 0 0 4px rgba(140, 123, 107, 0.2);
            transform: translateY(-2px);
        }

        .form-group input::placeholder {
            color: #B7AA9E;
        }

        /* Password Section */
        .password-section {
            background-color: #EFE6DD;
            padding: 25px;
            border-radius: 10px;
            margin-top: 25px;
            margin-bottom: 25px;
            border-left: 4px solid #8C7B6B;
        }

        .password-section h3 {
            margin-bottom: 20px;
            color: #2A2A2A;
            font-size: 18px;
        }

        .password-strength {
            height: 6px;
            background-color: #EFE6DD;
            border-radius: 3px;
            margin-top: 10px;
            overflow: hidden;
        }

        .password-strength-meter {
            height: 100%;
            width: 0;
            border-radius: 3px;
            transition: width 0.3s ease, background-color 0.3s ease;
        }

        .password-strength-meter.weak {
            width: 33%;
            background-color: #F8B6B6;
        }

        .password-strength-meter.medium {
            width: 66%;
            background-color: #FFD700;
        }

        .password-strength-meter.strong {
            width: 100%;
            background-color: #C6F6C6;
        }

        .password-feedback {
            margin-top: 8px;
            font-size: 14px;
            color: #6C6C6C;
        }

        /* Form Buttons */
        .form-buttons {
            display: flex;
            justify-content: flex-end;
            gap: 18px;
            margin-top: 35px;
        }

        .save-button {
            background-color: #8C7B6B;
            color: white;
            border: none;
            padding: 14px 28px;
            border-radius: 8px;
            cursor: pointer;
            font-size: 16px;
            font-weight: 600;
            display: inline-flex;
            align-items: center;
            transition: background-color 0.3s ease, transform 0.2s ease, box-shadow 0.3s ease;
            box-shadow: 0 4px 10px rgba(140, 123, 107, 0.3);
        }

        .save-button i {
            margin-right: 10px;
            font-size: 18px;
        }

        .save-button:hover {
            background-color: #6A5D52;
            transform: translateY(-3px);
            box-shadow: 0 6px 15px rgba(140, 123, 107, 0.4);
        }

        .save-button:active {
            transform: translateY(-1px);
            box-shadow: 0 3px 8px rgba(140, 123, 107, 0.3);
        }

        .cancel-button {
            background-color: #EFE6DD;
            color: #2A2A2A;
            border: none;
            padding: 14px 28px;
            border-radius: 8px;
            cursor: pointer;
            text-decoration: none;
            font-size: 16px;
            font-weight: 600;
            display: inline-flex;
            align-items: center;
            transition: background-color 0.3s ease, transform 0.2s ease;
        }

        .cancel-button i {
            margin-right: 10px;
            font-size: 18px;
        }

        .cancel-button:hover {
            background-color: #D6C8BE;
            transform: translateY(-2px);
        }

        /* Messages */
        .success-message {
            background-color: rgba(198, 246, 198, 0.3);
            color: #155724;
            padding: 18px;
            border-radius: 8px;
            margin-bottom: 25px;
            display: flex;
            align-items: center;
            border-left: 4px solid #155724;
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.05);
        }

        .success-message i {
            margin-right: 12px;
            color: #155724;
            font-size: 20px;
        }

        .error-message {
            background-color: rgba(248, 182, 182, 0.3);
            color: #721c24;
            padding: 18px;
            border-radius: 8px;
            margin-bottom: 25px;
            display: flex;
            align-items: center;
            border-left: 4px solid #721c24;
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.05);
        }

        .error-message i {
            margin-right: 12px;
            color: #721c24;
            font-size: 20px;
        }

        /* Required field indicator */
        .required-field::after {
            content: "*";
            color: #F8B6B6;
            margin-left: 4px;
            font-size: 18px;
        }

        /* Form section dividers */
        .form-section {
            border-bottom: 1px solid rgba(140, 123, 107, 0.2);
            padding-bottom: 25px;
            margin-bottom: 25px;
        }

        .form-section:last-child {
            border-bottom: none;
            padding-bottom: 0;
            margin-bottom: 0;
        }

        .form-section-title {
            font-size: 18px;
            margin-bottom: 20px;
            color: #8C7B6B;
            font-weight: 600;
        }

        /* Responsive adjustments */
        @media (max-width: 992px) {
            .navbar {
                padding: 30px 50px;
            }
            
            .nav-links {
                gap: 30px;
            }
            
            .nav-links a {
                font-size: 20px;
            }
        }

        @media (max-width: 768px) {
            .navbar {
                padding: 20px 30px;
                flex-direction: column;
            }
            
            .logo {
                margin-bottom: 15px;
            }
            
            .nav-links {
                width: 100%;
                justify-content: space-between;
                gap: 10px;
            }
            
            .nav-links a {
                font-size: 16px;
            }
            
            .dropdown-content {
                right: -50px;
            }
            
            .edit-profile-container {
                padding: 0 15px;
            }
            
            .edit-profile-form {
                padding: 25px;
            }
            
            .form-buttons {
                flex-direction: column;
            }
            
            .save-button, .cancel-button {
                width: 100%;
                justify-content: center;
            }
            
            .save-button {
                order: 1;
            }
            
            .cancel-button {
                order: 2;
            }
        }
    </style>
    <!-- Font Awesome for icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
</head>
<body>

<%
    // Check if user is logged in
    Integer userId = (Integer) session.getAttribute("userId");
    String username = (String) session.getAttribute("username");
    
    if (userId == null || username == null) {
        response.sendRedirect(request.getContextPath() + "/view/JobSeekerLogin.jsp");
        return;
    }
    
    // Get user details using UserDAO
    UserDAO userDAO = new UserDAO();
    User user = userDAO.getUserById(userId);
    
    // Check for success message
    String successMessage = request.getParameter("success");
%>

<!-- Navbar matching UserProfile.jsp -->
<header class="navbar">
    <div class="logo">InternConnect <span>| Job Seeker</span></div>
    <nav class="nav-links">
        <a href="UserDashboard.jsp">Home</a>
        <a href="JobListing.jsp">Browse Jobs</a>
        <a href="MyApplications.jsp">My Applications</a>
        <div class="profile-dropdown">
            <a href="UserProfile.jsp" class="profile-icon"><i class="fas fa-user-circle"></i></a>
            <div class="dropdown-content">
                <a href="UserProfile.jsp"><i class="fas fa-id-card"></i> View Profile</a>
                <a href="EditProfile.jsp" class="active"><i class="fas fa-user-edit"></i> Edit Profile</a>
                <a href="LogoutServlet"><i class="fas fa-sign-out-alt"></i> Logout</a>
            </div>
        </div>
    </nav>
</header>

<!-- Edit Profile Content -->
<section class="edit-profile-container">
    <h1>Edit Profile</h1>
    
    <% if (request.getParameter("success") != null && request.getParameter("success").equals("true")) { %>
        <div class="success-message">
            <i class="fas fa-check-circle"></i> Your profile has been updated successfully!
        </div>
    <% } %>
    
    <% if (request.getAttribute("error") != null) { %>
        <div class="error-message">
            <i class="fas fa-exclamation-circle"></i> <%= request.getAttribute("error") %>
        </div>
    <% } %>
    
    <div class="edit-profile-card">
        <form action="${pageContext.request.contextPath}/UpdateProfileServlet" method="post" class="edit-profile-form">
            <div class="form-section">
                <div class="form-section-title"><i class="fas fa-user-circle"></i> Personal Information</div>
                <div class="form-group">
                    <label for="username" class="required-field"><i class="fas fa-user"></i> Full Name</label>
                    <input type="text" id="username" name="username" value="<%= user.getUsername() %>" required>
                </div>
                
                <div class="form-group">
                    <label for="email" class="required-field"><i class="fas fa-envelope"></i> Email</label>
                    <input type="email" id="email" name="email" value="<%= user.getEmail() %>" required>
                </div>
                
                <div class="form-group">
                    <label for="phone"><i class="fas fa-phone"></i> Phone</label>
                    <input type="text" id="phone" name="phone" value="<%= user.getPhone() != null ? user.getPhone() : "" %>" placeholder="Enter your phone number">
                </div>
                
                <div class="form-group">
                    <label for="address"><i class="fas fa-home"></i> Address</label>
                    <input type="text" id="address" name="address" value="<%= user.getAddress() != null ? user.getAddress() : "" %>" placeholder="Enter your address">
                </div>
            </div>
            
            <div class="form-section">
                <div class="form-section-title"><i class="fas fa-lock"></i> Security</div>
                <div class="form-group">
                    <label for="currentPassword" class="required-field"><i class="fas fa-lock"></i> Current Password</label>
                    <input type="password" id="currentPassword" name="currentPassword" required placeholder="Enter your current password">
                    <div class="password-feedback">Required to save any changes</div>
                </div>
                
                <div class="password-section">
                    <h3><i class="fas fa-key"></i> Change Password</h3>
                    <div class="form-group">
                        <label for="newPassword"><i class="fas fa-key"></i> New Password</label>
                        <input type="password" id="newPassword" name="newPassword" placeholder="Leave blank to keep current password">
                        <div class="password-strength">
                            <div class="password-strength-meter" id="passwordStrength"></div>
                        </div>
                        <div class="password-feedback" id="passwordFeedback">Password strength will be shown here</div>
                    </div>
                    
                    <div class="form-group">
                        <label for="confirmPassword"><i class="fas fa-check-circle"></i> Confirm New Password</label>
                        <input type="password" id="confirmPassword" name="confirmPassword" placeholder="Confirm your new password">
                    </div>
                </div>
            </div>
            
            <div class="form-buttons">
                <button type="submit" class="save-button"><i class="fas fa-save"></i> Save Changes</button>
                <a href="UserProfile.jsp" class="cancel-button"><i class="fas fa-times"></i> Cancel</a>
            </div>
        </form>
    </div>
</section>

<script>
    // Form validation and password strength meter
    document.addEventListener('DOMContentLoaded', function() {
        const form = document.querySelector('.edit-profile-form');
        const newPassword = document.getElementById('newPassword');
        const confirmPassword = document.getElementById('confirmPassword');
        const passwordStrength = document.getElementById('passwordStrength');
        const passwordFeedback = document.getElementById('passwordFeedback');
        
        // Form validation
        form.addEventListener('submit', function(e) {
            if (newPassword.value !== confirmPassword.value && newPassword.value !== '') {
                e.preventDefault();
                alert('New passwords do not match!');
            }
        });
        
        // Password strength meter
        newPassword.addEventListener('input', function() {
            const value = newPassword.value;
            
            if (value === '') {
                passwordStrength.className = 'password-strength-meter';
                passwordStrength.style.width = '0';
                passwordFeedback.textContent = 'Password strength will be shown here';
                return;
            }
            
            // Simple password strength check
            let strength = 0;
            
            // Length check
            if (value.length >= 8) strength += 1;
            
            // Contains number
            if (/\d/.test(value)) strength += 1;
            
            // Contains special character
            if (/[!@#$%^&*(),.?":{}|<>]/.test(value)) strength += 1;
            
            // Contains uppercase and lowercase
            if (/[a-z]/.test(value) && /[A-Z]/.test(value)) strength += 1;
            
            // Update UI based on strength
            if (strength <= 1) {
                passwordStrength.className = 'password-strength-meter weak';
                passwordFeedback.textContent = 'Weak password - try adding numbers, symbols, and mixed case';
            } else if (strength <= 3) {
                passwordStrength.className = 'password-strength-meter medium';
                passwordFeedback.textContent = 'Medium strength - add more variety for a stronger password';
            } else {
                passwordStrength.className = 'password-strength-meter strong';
                passwordFeedback.textContent = 'Strong password - good job!';
            }
        });
    });
</script>

</body>
</html>
