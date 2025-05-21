package controller;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;

public class LogoutServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        
        if (session != null) {
            // Invalidate session
            session.invalidate();
            System.out.println("Session invalidated");
            
            // Delete cookies if they exist
            Cookie[] cookies = request.getCookies();
            if (cookies != null) {
                for (Cookie cookie : cookies) {
                    if (cookie.getName().equals("jobSeekerRememberMe") || 
                        cookie.getName().equals("adminRememberMe")) {
                        cookie.setValue("");
                        cookie.setMaxAge(0);
                        cookie.setPath("/");
                        response.addCookie(cookie);
                    }
                }
            }
        }
        
        // Redirect to home page
        response.sendRedirect(request.getContextPath() + "/index.jsp");
    }
}