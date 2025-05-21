package controller;

import dao.ContactDAO;

import jakarta.servlet.ServletException;
// Remove the WebServlet annotation to avoid conflicts with web.xml
// @WebServlet("/MarkContactReadServlet")
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

public class MarkContactReadServlet extends HttpServlet {
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        System.out.println("MarkContactReadServlet: Processing request");
        
        // Check if admin is logged in
        if (request.getSession().getAttribute("adminId") == null) {
            response.sendRedirect(request.getContextPath() + "/view/AdminLogin.jsp");
            return;
        }
        
        // Get contact ID from request
        String contactId = request.getParameter("id");
        
        if (contactId != null && !contactId.isEmpty()) {
            try {
                int id = Integer.parseInt(contactId);
                
                // Mark as read
                ContactDAO contactDAO = new ContactDAO();
                contactDAO.markAsRead(id);
                
                // Redirect back to messages page
                response.sendRedirect(request.getContextPath() + "/view/AdminContactMessages.jsp");
            } catch (NumberFormatException e) {
                response.sendRedirect(request.getContextPath() + "/view/AdminContactMessages.jsp");
            }
        } else {
            response.sendRedirect(request.getContextPath() + "/view/AdminContactMessages.jsp");
        }
    }
}