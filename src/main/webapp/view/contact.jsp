<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Contact Us | InternConnect</title>
    <!-- Link to CSS with dynamic context path -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/contact.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <style>
        .success-message {
            background-color: #d4edda;
            color: #155724;
            padding: 15px;
            margin-bottom: 20px;
            border-radius: 8px;
            text-align: center;
            font-weight: 500;
        }
        
        .error-message {
            background-color: #f8d7da;
            color: #721c24;
            padding: 15px;
            margin-bottom: 20px;
            border-radius: 8px;
            text-align: center;
            font-weight: 500;
        }
    </style>
</head>
<body>

<!-- 🔗 Navbar -->
<nav class="navbar">
    <div class="logo">InternConnect</div>
    <div class="nav-links">
        <a href="${pageContext.request.contextPath}/index.jsp">Home</a>
        <a href="${pageContext.request.contextPath}/view/About_us.jsp">About Us</a>
        <a href="${pageContext.request.contextPath}/view/contact.jsp" class="active">Contact Us</a>
    </div>
</nav>

<!-- 💬 Contact Section with Image -->
<div class="contact-wrapper">
    <form class="contact-card" action="${pageContext.request.contextPath}/ContactServlet" method="post">
        <h2>Get in touch</h2>
        
        <!-- Display success message from session -->
        <% if (session.getAttribute("contactSuccess") != null) { %>
            <div class="success-message">
                <i class="fas fa-check-circle"></i> 
                <%= session.getAttribute("contactSuccess") %>
            </div>
            <% session.removeAttribute("contactSuccess"); %>
        <% } %>
        
        <!-- Display error message from request -->
        <% if (request.getAttribute("error") != null) { %>
            <div class="error-message">
                <i class="fas fa-exclamation-circle"></i>
                <%= request.getAttribute("error") %>
            </div>
        <% } %>

        <label for="name">Your name</label>
        <input type="text" id="name" name="name" placeholder="Full name" required>

        <label for="email">Your email</label>
        <input type="email" id="email" name="email" placeholder="yourmail@emaily.com" required>

        <label for="message">How can we help?</label>
        <textarea id="message" name="message" placeholder="Enter your message here" required></textarea>

        <button type="submit">Send my message</button>
    </form>

    <div class="image-card">
        <img src="${pageContext.request.contextPath}/assets/img/contact.jpg" alt="Contact Illustration" />
    </div>
</div>

</body>
</html>
