package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.User;
import dao.UserDAO;
import util.PasswordUtil;

import java.io.IOException;
import java.security.NoSuchAlgorithmException;

//@WebServlet("/UpdateProfileServlet")
public class UpdateProfileServlet extends HttpServlet {
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/view/JobSeekerLogin.jsp");
            return;
        }
        
        Integer userId = (Integer) session.getAttribute("userId");
        
        try {
            // Get form data
            String username = request.getParameter("username");
            String email = request.getParameter("email");
            String phone = request.getParameter("phone");
            String address = request.getParameter("address");
            String currentPassword = request.getParameter("currentPassword");
            String newPassword = request.getParameter("newPassword");
            String confirmPassword = request.getParameter("confirmPassword");
            
            // Debug log
            System.out.println("UpdateProfileServlet: Received form data - User ID: " + userId + 
                              ", Name: " + username + ", Email: " + email);
            
            // Validate required fields
            if (username == null || username.trim().isEmpty() || 
                email == null || email.trim().isEmpty() || 
                currentPassword == null || currentPassword.trim().isEmpty()) {
                
                request.setAttribute("error", "Name, email, and current password are required");
                request.getRequestDispatcher("/view/EditProfile.jsp").forward(request, response);
                return;
            }
            
            // Get current user data
            UserDAO userDAO = new UserDAO();
            User user = userDAO.getUserById(userId);
            
            if (user == null) {
                request.setAttribute("error", "User not found");
                request.getRequestDispatcher("/view/EditProfile.jsp").forward(request, response);
                return;
            }
            
            // Verify current password
            boolean passwordVerified = false;
            try {
                // Check if the password is stored as a hash
                if (user.getPassword().length() > 20) {
                    // Password is hashed, verify using hash
                    String hashedInputPassword = PasswordUtil.hashPassword(currentPassword);
                    passwordVerified = user.getPassword().equals(hashedInputPassword);
                } else {
                    // Password is stored in plain text (not recommended)
                    passwordVerified = user.getPassword().equals(currentPassword);
                }
            } catch (NoSuchAlgorithmException e) {
                // If hashing fails, fall back to direct comparison (not secure)
                passwordVerified = user.getPassword().equals(currentPassword);
            }
            
            if (!passwordVerified) {
                System.out.println("UpdateProfileServlet: Password verification failed");
                request.setAttribute("error", "Current password is incorrect");
                request.getRequestDispatcher("/view/EditProfile.jsp").forward(request, response);
                return;
            }
            
            // Update user object
            user.setUsername(username);
            user.setEmail(email);
            user.setPhone(phone);
            user.setAddress(address);
            
            // Update password if provided
            if (newPassword != null && !newPassword.trim().isEmpty()) {
                if (!newPassword.equals(confirmPassword)) {
                    request.setAttribute("error", "New passwords do not match");
                    request.getRequestDispatcher("/view/EditProfile.jsp").forward(request, response);
                    return;
                }
                
                try {
                    // Hash the new password
                    String hashedPassword = PasswordUtil.hashPassword(newPassword);
                    user.setPassword(hashedPassword);
                } catch (NoSuchAlgorithmException e) {
                    // If hashing fails, store plain text (not recommended)
                    user.setPassword(newPassword);
                }
            }
            
            // Update user in database
            boolean success = userDAO.updateUser(user);
            
            if (success) {
                System.out.println("UpdateProfileServlet: Profile updated successfully");
                // Update session attributes if username changed
                session.setAttribute("username", username);
                
                // Redirect to profile page with success message
                response.sendRedirect(request.getContextPath() + "/view/EditProfile.jsp?success=true");
            } else {
                System.out.println("UpdateProfileServlet: Failed to update profile");
                request.setAttribute("error", "Failed to update profile");
                request.getRequestDispatcher("/view/EditProfile.jsp").forward(request, response);
            }
            
        } catch (Exception e) {
            System.out.println("UpdateProfileServlet: Error - " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "Error updating profile: " + e.getMessage());
            request.getRequestDispatcher("/view/EditProfile.jsp").forward(request, response);
        }
    }
}