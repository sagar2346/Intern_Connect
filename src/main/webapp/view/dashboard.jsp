<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page session="true" %>
<%
    String email = (String) session.getAttribute("email");
    String role = (String) session.getAttribute("role");

    if (email == null || role == null) {
        response.sendRedirect("JobSeekerRegister.jsp?error=Please+login+first");
        return;
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Job Seeker Dashboard</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background: #EFE6DD;
            padding: 40px;
        }
        .dashboard {
            background-color: #D6C8BE;
            padding: 40px;
            border-radius: 12px;
            max-width: 600px;
            margin: 0 auto;
            box-shadow: 0 4px 16px rgba(0,0,0,0.1);
            text-align: center;
        }
        h1 {
            color: #2A2A2A;
        }
        .email {
            font-size: 20px;
            margin-top: 10px;
        }
        a {
            margin-top: 20px;
            display: inline-block;
            padding: 10px 20px;
            background: #2A2A2A;
            color: white;
            text-decoration: none;
            border-radius: 8px;
        }
        a:hover {
            background: #444;
        }
    </style>
</head>
<body>

<div class="dashboard">
    <h1>Welcome, Job Seeker!</h1>
    <div class="email">Logged in as: <strong><%= email %></strong></div>
    <div class="email">Your role: <strong><%= role %></strong></div>
    <a href="logout.jsp">Logout</a>
</div>

</body>
</html>



