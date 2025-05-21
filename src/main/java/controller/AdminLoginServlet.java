package controller;

import dao.AdminDAO;
import model.Admin;
import util.PasswordUtil;

import java.io.IOException;
import java.security.NoSuchAlgorithmException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Cookie;

public class AdminLoginServlet extends HttpServlet {
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        System.out.println("AdminLoginServlet doPost method called");
        
        // Get form data
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String rememberMe = request.getParameter("remember");
        
        System.out.println("Login attempt - Email: " + email);

        // Validate input
        if (email == null || email.trim().isEmpty() || password == null || password.trim().isEmpty()) {
            System.out.println("Validation error: Empty fields");
            request.setAttribute("error", "Please enter both email and password.");
            request.getRequestDispatcher("/view/AdminLogin.jsp").forward(request, response);
            return;
        }

        try {
            // Hash the password for comparison
            String hashedPassword = password;
            try {
                hashedPassword = PasswordUtil.hashPassword(password);
            } catch (NoSuchAlgorithmException e) {
                System.out.println("Error hashing password: " + e.getMessage());
                // Continue with unhashed password if hashing fails
            }
            
            // Use AdminDAO to authenticate
            AdminDAO adminDAO = new AdminDAO();
            Admin admin = adminDAO.getAdminByEmail(email);
            
            boolean passwordMatch = false;
            if (admin != null) {
                // Check if password matches (either hashed or unhashed)
                passwordMatch = admin.getPassword().equals(hashedPassword) || admin.getPassword().equals(password);
            }
            
            if (admin != null && passwordMatch) {
                System.out.println("Password verified successfully");
                
                // Create session
                HttpSession session = request.getSession();
                session.setAttribute("adminId", admin.getAdminId());
                session.setAttribute("adminName", admin.getName());
                session.setAttribute("adminEmail", email);
                session.setAttribute("adminLoggedIn", true);
                
                // Set remember me cookie if checkbox is checked
                if (rememberMe != null && rememberMe.equals("on")) {
                    // Create a unique token
                    String token = admin.getAdminId() + "-" + System.currentTimeMillis();
                    
                    // Create cookie that lasts for 30 days
                    Cookie rememberMeCookie = new Cookie("adminRememberMe", token);
                    rememberMeCookie.setMaxAge(60*60*24*30); // 30 days in seconds
                    rememberMeCookie.setPath("/");
                    response.addCookie(rememberMeCookie);
                    
                    System.out.println("Remember me cookie set for admin");
                }
                
                System.out.println("Session created, redirecting to dashboard");
                
                // Redirect to admin dashboard
                response.sendRedirect(request.getContextPath() + "/view/Admin_dashboard.jsp");
            } else {
                System.out.println("Authentication failed");
                request.setAttribute("error", "Invalid email or password.");
                request.getRequestDispatcher("/view/AdminLogin.jsp").forward(request, response);
            }
        } catch (Exception e) {
            System.out.println("Error during login: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "Login error: " + e.getMessage());
            request.getRequestDispatcher("/view/AdminLogin.jsp").forward(request, response);
        }
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Simply forward to the login page
        request.getRequestDispatcher("/view/AdminLogin.jsp").forward(request, response);
    }
}