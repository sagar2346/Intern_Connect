<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Job Application Form</title>
    <link rel="stylesheet" type="text/css" href="../assets/css/JobApplication.css">

</head>
<body>

<div class="navbar">
    <div class="logo">InternConnect <span>| Job Application</span></div>
    <nav class="nav-links">
        <a href="index.jsp" class="active">Home</a>
    </nav>
</div>

<div class="form-container">
    <h2 class="form-title">Job Application</h2>
    <p class="form-intro">Please fill out all required fields and attach your resume below.</p>

    <form action="submitApplication.jsp" method="post" enctype="multipart/form-data">

        <!-- Name -->
        <div class="form-row two-cols">
            <div>
                <label>First Name*</label>
                <input type="text" name="firstName" required>
            </div>
            <div>
                <label>Last Name*</label>
                <input type="text" name="lastName" required>
            </div>
        </div>

        <!-- Address -->
        <div class="form-row">
            <label>Address*</label>
            <input type="text" name="address" required>
        </div>
        <div class="form-row two-cols-three">
            <div><input type="text" name="city" placeholder="City" required></div>
            <div><input type="text" name="state" placeholder="State" required></div>
            <div><input type="text" name="zip" placeholder="ZIP Code" required></div>
        </div>

        <!-- Contact -->
        <div class="form-row">
            <label>Phone Number*</label>
            <input type="tel" name="phone" required>
        </div>

        <div class="form-row">
            <label>Email*</label>
            <input type="email" name="email" required>
        </div>

        <!-- Extra Info -->
        <div class="form-row">
            <label>Additional Info (Optional)</label>
            <textarea name="additionalInfo" rows="5" placeholder="Mention any relevant experience or notes..."></textarea>
        </div>

        <!-- File Uploads -->
        <div class="form-row two-cols">
            <div>
                <label>Upload your resume*</label>
                <input type="file" name="resume" accept=".pdf,.doc,.docx" required>
            </div>
            <div>
                <label>Upload cover letter (optional)</label>
                <input type="file" name="coverLetter" accept=".pdf,.doc,.docx">
            </div>
        </div>

        <!-- Position -->
        <div class="form-row">
            <label>Position Applying For*</label>
            <input type="text" name="position" required>
        </div>

        <div class="form-row">
            <button type="submit" class="login-btn">Submit Application</button>
        </div>
    </form>
</div>

</body>
</html>