package controller;

import dao.ContactDAO;
import model.Contact;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

//@WebServlet("/ContactServlet")
public class ContactServlet extends HttpServlet {
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Get form data
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String message = request.getParameter("message");
        
        // Validate input
        if (name == null || name.trim().isEmpty() ||
            email == null || email.trim().isEmpty() ||
            message == null || message.trim().isEmpty()) {
            
            request.setAttribute("error", "All fields are required!");
            request.getRequestDispatcher("/view/contact.jsp").forward(request, response);
            return;
        }
        
        // Check if user is logged in
        HttpSession session = request.getSession(false);
        Integer userId = null;
        if (session != null && session.getAttribute("userId") != null) {
            userId = (Integer) session.getAttribute("userId");
        }
        
        // Create Contact object with userId if available
        Contact contact;
        if (userId != null) {
            contact = new Contact(name, email, message, userId);
        } else {
            contact = new Contact(name, email, message);
        }
        
        // Save to database
        ContactDAO contactDAO = new ContactDAO();
        boolean success = contactDAO.insertContact(contact);
        
        if (success) {
            // Set success message in session to survive redirect
            request.getSession().setAttribute("contactSuccess", "Your message has been sent successfully! We'll get back to you soon.");
            response.sendRedirect(request.getContextPath() + "/view/contact.jsp");
        } else {
            request.setAttribute("error", "Failed to send your message. Please try again later.");
            request.getRequestDispatcher("/view/contact.jsp").forward(request, response);
        }
    }
}