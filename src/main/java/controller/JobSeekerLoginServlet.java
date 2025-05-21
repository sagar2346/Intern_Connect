package controller;

import dao.UserDAO;
import model.User;
import util.PasswordUtil;

import java.io.IOException;
import java.security.NoSuchAlgorithmException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Cookie;

public class JobSeekerLoginServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // For debugging
        System.out.println("JobSeekerLoginServlet doPost method called");
        
        // Retrieve form data
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String rememberMe = request.getParameter("remember");
        
        System.out.println("Login attempt - Email: " + email);

        try {
            // Use UserDAO to authenticate
            UserDAO userDAO = new UserDAO();
            User user = userDAO.getUserByEmail(email);
            
            boolean passwordMatch = false;
            if (user != null) {
                try {
                    // Hash the input password for comparison
                    String hashedInputPassword = PasswordUtil.hashPassword(password);
                    // Check if password matches (either hashed or plain text for backward compatibility)
                    passwordMatch = user.getPassword().equals(hashedInputPassword) || 
                                   user.getPassword().equals(password);
                } catch (NoSuchAlgorithmException e) {
                    // If hashing fails, fall back to direct comparison
                    passwordMatch = user.getPassword().equals(password);
                }
            }
            
            if (user != null && passwordMatch) {
                System.out.println("User found in database");
                
                // Create a session and store user information
                HttpSession session = request.getSession();
                session.setAttribute("userId", user.getUserId());
                session.setAttribute("username", user.getUsername());
                session.setAttribute("email", email);
                session.setAttribute("loggedIn", true);
                
                // Set success message
                session.setAttribute("loginSuccess", "Welcome back, " + user.getUsername() + "!");
                
                // Set remember me cookie if checkbox is checked
                if (rememberMe != null && rememberMe.equals("on")) {
                    // Create a unique token (you can use UUID or other methods)
                    String token = user.getUserId() + "-" + System.currentTimeMillis();
                    
                    // Create cookie that lasts for 30 days
                    Cookie rememberMeCookie = new Cookie("jobSeekerRememberMe", token);
                    rememberMeCookie.setMaxAge(60*60*24*30); // 30 days in seconds
                    rememberMeCookie.setPath("/");
                    response.addCookie(rememberMeCookie);
                    
                    System.out.println("Remember me cookie set for user");
                }
                
                System.out.println("Session attributes set");
                
                // Check if there's a redirect parameter
                String redirect = request.getParameter("redirect");
                String jobId = request.getParameter("jobId");
                
                if (redirect != null && redirect.equals("job") && jobId != null) {
                    // Redirect to job application page
                    System.out.println("Redirecting to job application page for job ID: " + jobId);
                    response.sendRedirect(request.getContextPath() + "/view/JobApplication.jsp?jobId=" + jobId);
                } else {
                    // Redirect to the dashboard page
                    System.out.println("Redirecting to dashboard");
                    response.sendRedirect(request.getContextPath() + "/view/UserDashboard.jsp");
                }
            } else {
                // Invalid credentials
                System.out.println("Invalid credentials");
                
                // Check if user exists but password is wrong
                if (user != null) {
                    request.setAttribute("error", "Invalid password. Please try again.");
                } else {
                    // Check if email exists in database
                    boolean emailExists = userDAO.checkEmailExists(email);
                    if (emailExists) {
                        request.setAttribute("error", "Invalid password. Please try again.");
                    } else {
                        request.setAttribute("error", "Email not registered. Please create an account first.");
                    }
                }
                
                request.getRequestDispatcher("/view/JobSeekerLogin.jsp").forward(request, response);
            }
        } catch (Exception e) {
            System.out.println("Unexpected Exception: " + e.getMessage());
            e.printStackTrace();
            
            request.setAttribute("error", "Unexpected error: " + e.getMessage());
            request.getRequestDispatcher("/view/JobSeekerLogin.jsp").forward(request, response);
        }
    }
}