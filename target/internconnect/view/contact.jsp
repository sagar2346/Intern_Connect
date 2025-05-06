<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Contact Us | InternConnect</title>
    <!-- Link to CSS with dynamic context path -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/contact.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
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
    <form class="contact-card">
        <h2>Get in touch</h2>

        <label for="name">Your name</label>
        <input type="text" id="name" placeholder="Full name" required>

        <label for="email">Your email</label>
        <input type="email" id="email" placeholder="yourmail@emaily.com" required>

        <label for="message">How can we help?</label>
        <textarea id="message" placeholder="Enter your message here" required></textarea>

        <button type="submit">Send my message</button>
    </form>

    <div class="image-card">
        <img src="${pageContext.request.contextPath}/assets/img/contact.jpg" alt="Contact Illustration" />
    </div>
</div>

</body>
</html>
