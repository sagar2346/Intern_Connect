package controller;
import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.FilterConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;


@WebFilter("/dashboard.jsp")  // You can add more URLs here if needed
public class AuthFilter implements Filter {

    public void init(FilterConfig filterConfig) throws ServletException {
        // Optional: log or config load
    }

    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;
        HttpSession session = req.getSession(false);

        // If user not logged in, redirect to login page
        if (session == null || session.getAttribute("email") == null) {
            res.sendRedirect(req.getContextPath() + "/JobSeekerLogin.jsp?error=Please+login+first");
            return;
        }

        // Allow access
        chain.doFilter(request, response);
    }

    public void destroy() {
        // Optional: cleanup
    }
}
