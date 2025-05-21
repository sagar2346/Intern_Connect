package controller;

import dao.AdminDAO;
import model.Admin;
import util.PasswordUtil;

import java.io.IOException;
import java.io.PrintWriter;
import java.security.NoSuchAlgorithmException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class AdminRegisterServlet extends HttpServlet {

    // Do POST to register a new Admin
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/html");
        PrintWriter out = response.getWriter();
        
        System.out.println("AdminRegisterServlet doPost method called");

        // Getting form data
        String adminName = request.getParameter("adminName");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        
        System.out.println("Form data received - Name: " + adminName + ", Email: " + email);

        // Simple validation for empty fields
        if (adminName == null || adminName.trim().isEmpty() ||
                email == null || email.trim().isEmpty() ||
                password == null || password.trim().isEmpty() ||
                confirmPassword == null || confirmPassword.trim().isEmpty()) {

            System.out.println("Validation error: Empty fields");
            request.setAttribute("error", "All fields are required!");
            request.getRequestDispatcher("/view/AdminRegister.jsp").forward(request, response);
            return;
        }
        
        // Check if passwords match
        if (!password.equals(confirmPassword)) {
            System.out.println("Validation error: Passwords don't match");
            request.setAttribute("error", "Passwords do not match!");
            request.getRequestDispatcher("/view/AdminRegister.jsp").forward(request, response);
            return;
        }

        try {
            // Hash the password
            String hashedPassword = password;
            try {
                hashedPassword = PasswordUtil.hashPassword(password);
            } catch (NoSuchAlgorithmException e) {
                System.out.println("Error hashing password: " + e.getMessage());
                // Continue with unhashed password if hashing fails
            }
            
            // Check if email already exists
            AdminDAO adminDAO = new AdminDAO();
            boolean emailExists = adminDAO.checkEmailExists(email);
            
            if (emailExists) {
                System.out.println("Email already exists: " + email);
                request.setAttribute("error", "This email is already registered. Please use a different email or login to your existing account.");
                request.getRequestDispatcher("/view/AdminRegister.jsp").forward(request, response);
                return;
            }
            
            // Create Admin object
            Admin admin = new Admin();
            admin.setName(adminName);
            admin.setEmail(email);
            admin.setPassword(hashedPassword);
            
            // Use AdminDAO to insert the admin
            boolean success = adminDAO.insertAdmin(admin);

            // Redirect on successful registration
            if (success) {
                System.out.println("Admin registered successfully");
                // Set success message in session
                request.getSession().setAttribute("registrationSuccess", "Registration successful! Please login with your credentials.");
                response.sendRedirect(request.getContextPath() + "/view/AdminLogin.jsp");
            } else {
                System.out.println("Registration failed, no rows affected");
                request.setAttribute("error", "Registration Failed! Please try again later.");
                request.getRequestDispatcher("/view/AdminRegister.jsp").forward(request, response);
            }
        } catch (Exception e) {
            System.out.println("Error during registration: " + e.getMessage());
            e.printStackTrace();
            
            // Handle specific errors
            if (e.getMessage() != null && e.getMessage().contains("Duplicate entry")) {
                request.setAttribute("error", "Email already exists. Please use a different email.");
                System.out.println("Set error attribute: Email already exists");
            } else {
                request.setAttribute("error", "Registration error: " + e.getMessage());
                System.out.println("Set error attribute: Registration error: " + e.getMessage());
            }
            
            // Debug the request attributes
            System.out.println("Request attributes before forwarding:");
            java.util.Enumeration<String> attributeNames = request.getAttributeNames();
            while (attributeNames.hasMoreElements()) {
                String name = attributeNames.nextElement();
                System.out.println("  " + name + " = " + request.getAttribute(name));
            }
            
            request.getRequestDispatcher("/view/AdminRegister.jsp").forward(request, response);
        }
    }
}
