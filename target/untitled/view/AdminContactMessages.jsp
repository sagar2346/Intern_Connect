<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="dao.ContactDAO, model.Contact, java.util.List, java.text.SimpleDateFormat" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Contact Messages | Admin Dashboard</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin-dashboard.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <style>
        /* Reset */
        *,
        *::before,
        *::after {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        /* Base */
        body {
            font-family: 'Segoe UI', sans-serif;
            background-color: #EFE6DD;
            color: #2A2A2A;
            line-height: 1.5;
        }

        /* Header/Nav */
        header nav {
            display: flex;
            justify-content: space-between;
            align-items: center;
            background-color: #DDD0C8;
            padding: 20px 100px;
            border-bottom: 1px solid #DDD0C8;
        }

        header .logo {
            font-size: 28px;
            font-weight: 700;
            color: #2A2A2A;
        }

        header .nav-links a {
            margin-left: 40px;
            font-size: 18px;
            font-weight: 600;
            color: #2A2A2A;
            text-decoration: none;
            position: relative;
            transition: color .3s;
        }

        header .nav-links a:hover,
        header .nav-links a.active {
            color: #ffffff;
        }

        header .nav-links a.active::after {
            content: '';
            position: absolute;
            bottom: -6px;
            left: 0;
            width: 100%;
            height: 3px;
            background: #DDD0C8;
            border-radius: 2px;
        }

        /* Container */
        .messages-container {
            max-width: 1000px;
            margin: 40px auto;
            padding: 0 20px;
        }

        /* Title */
        .messages-container h2 {
            font-size: 28px;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
        }

        .messages-container h2 i {
            margin-right: 10px;
            color: #2A2A2A;
        }

        /* Message Card */
        .message-card {
            background-color: #ffffff;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0,0,0,.1);
            padding: 20px;
            margin-bottom: 20px;
        }

        .message-card.unread {
            background-color: #f0f7ff;
        }

        .message-header {
            display: flex;
            justify-content: space-between;
            margin-bottom: 12px;
        }

        .sender-info {
            font-weight: 600;
            color: #2A2A2A;
        }

        .sender-info::before {
            content: '';
        }

        .message-card.unread .sender-info::before {
            content: '•';
            color: #0066cc;
            margin-right: 6px;
        }

        .message-date {
            font-size: 0.9em;
            color: #777;
        }

        /* Content */
        .message-content {
            background-color: #f9f9f9;
            padding: 15px;
            border-radius: 5px;
            margin-bottom: 15px;
            color: #2A2A2A;
        }

        /* Actions */
        .message-actions {
            text-align: right;
        }

        .message-actions a {
            margin-left: 15px;
            color: #555;
            text-decoration: none;
            font-size: 0.95em;
            transition: color .2s;
        }

        .message-actions a:hover {
            color: #000;
        }

        /* No Messages */
        .no-messages {
            text-align: center;
            padding: 60px 0;
            color: #777;
            font-size: 1.1em;
        }

        .no-messages i {
            font-size: 3em;
            margin-bottom: 15px;
        }

        /* Responsive */
        @media (max-width: 768px) {
            header nav {
                flex-direction: column;
                align-items: flex-start;
            }

            header .nav-links {
                margin-top: 10px;
            }

            .message-header {
                flex-direction: column;
                align-items: flex-start;
            }

            .message-actions {
                margin-top: 10px;
            }
        }

    </style>
</head>
<body>
    <%
        // Check if admin is logged in
        if (session.getAttribute("adminId") == null) {
            response.sendRedirect(request.getContextPath() + "/view/AdminLogin.jsp");
            return;
        }
    %>

    <!-- Header with navigation -->
    <header>
        <nav>
            <div class="logo">InternConnect | Admin</div>
            <div class="nav-links">
                <a href="${pageContext.request.contextPath}/view/Admin_dashboard.jsp">Dashboard</a>
                <a href="${pageContext.request.contextPath}/view/ApplicationManagement.jsp">Applications</a>
                <a href="${pageContext.request.contextPath}/view/AdminContactMessages.jsp" class="active">Messages</a>
                <a href="${pageContext.request.contextPath}/AdminLogoutServlet">Logout</a>
            </div>
        </nav>
    </header>

    <div class="messages-container">
        <h2><i class="fas fa-envelope"></i> Contact Messages</h2>
        
        <%
            ContactDAO contactDAO = new ContactDAO();
            List<Contact> contacts = contactDAO.getAllContacts();
            SimpleDateFormat dateFormat = new SimpleDateFormat("MMM dd, yyyy 'at' hh:mm a");
            
            if (contacts.isEmpty()) {
        %>
            <div class="no-messages">
                <i class="fas fa-inbox fa-3x"></i>
                <p>No messages yet</p>
            </div>
        <%
            } else {
                for (Contact contact : contacts) {
        %>
            <div class="message-card <%= contact.isRead() ? "" : "unread" %>">
                <div class="message-header">
                    <div class="sender-info">
                        <%= contact.getName() %> (<%= contact.getEmail() %>)
                    </div>
                    <div class="message-date">
                        <%= dateFormat.format(contact.getSubmittedAt()) %>
                    </div>
                </div>
                <div class="message-content">
                    <%= contact.getMessage() %>
                </div>
                <div class="message-actions">
                    <a href="mailto:<%= contact.getEmail() %>?subject=Re: Your message to InternConnect&body=Dear <%= contact.getName() %>,">
                        <i class="fas fa-reply"></i> Reply
                    </a>
                    <% if (!contact.isRead()) { %>
                    <a href="${pageContext.request.contextPath}/MarkContactReadServlet?id=<%= contact.getContactId() %>">
                        <i class="fas fa-check"></i> Mark as Read
                    </a>
                    <% } %>
                </div>
            </div>
        <%
                }
            }
        %>
    </div>
</body>
</html>