package filter;

import dao.AdminDAO;
import dao.UserDAO;
import model.Admin;
import model.User;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.WebFilter;
import java.io.IOException;

@WebFilter("/*")
public class AuthenticationFilter implements Filter {
    
    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) 
            throws IOException, ServletException {
        
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        HttpSession session = httpRequest.getSession(false);
        
        // Check if user is already logged in
        boolean isUserLoggedIn = (session != null && session.getAttribute("userId") != null);
        boolean isAdminLoggedIn = (session != null && session.getAttribute("adminId") != null);
        
        // If not logged in, check for remember me cookies
        if (!isUserLoggedIn && !isAdminLoggedIn) {
            Cookie[] cookies = httpRequest.getCookies();
            if (cookies != null) {
                for (Cookie cookie : cookies) {
                    // Check for job seeker remember me cookie
                    if (cookie.getName().equals("jobSeekerRememberMe") && !isUserLoggedIn) {
                        String token = cookie.getValue();
                        try {
                            // Extract user ID from token (assuming format: "userId-timestamp")
                            String[] parts = token.split("-");
                            if (parts.length == 2) {
                                int userId = Integer.parseInt(parts[0]);
                                
                                UserDAO userDAO = new UserDAO();
                                User user = userDAO.getUserById(userId);
                                
                                if (user != null) {
                                    // Create a new session
                                    session = httpRequest.getSession(true);
                                    session.setAttribute("userId", user.getUserId());
                                    session.setAttribute("username", user.getUsername());
                                    session.setAttribute("email", user.getEmail());
                                    session.setAttribute("loggedIn", true);
                                    
                                    System.out.println("User auto-logged in via remember me cookie");
                                }
                            }
                        } catch (Exception e) {
                            System.out.println("Error auto-logging in user: " + e.getMessage());
                        }
                    }
                    
                    // Check for admin remember me cookie
                    if (cookie.getName().equals("adminRememberMe") && !isAdminLoggedIn) {
                        String token = cookie.getValue();
                        try {
                            // Extract admin ID from token (assuming format: "adminId-timestamp")
                            String[] parts = token.split("-");
                            if (parts.length == 2) {
                                int adminId = Integer.parseInt(parts[0]);
                                
                                AdminDAO adminDAO = new AdminDAO();
                                Admin admin = adminDAO.getAdminById(adminId);
                                
                                if (admin != null) {
                                    // Create a new session
                                    session = httpRequest.getSession(true);
                                    session.setAttribute("adminId", admin.getAdminId());
                                    session.setAttribute("adminName", admin.getName());
                                    session.setAttribute("adminEmail", admin.getEmail());
                                    session.setAttribute("adminLoggedIn", true);
                                    
                                    System.out.println("Admin auto-logged in via remember me cookie");
                                }
                            }
                        } catch (Exception e) {
                            System.out.println("Error auto-logging in admin: " + e.getMessage());
                        }
                    }
                }
            }
        }
        
        // Continue with the request
        chain.doFilter(request, response);
    }
    
    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
    }
    
    @Override
    public void destroy() {
    }
}