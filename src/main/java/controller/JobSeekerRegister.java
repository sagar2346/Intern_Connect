package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.sql.*;

import utils.PasswordHashUtil;

@WebServlet("/JobSeekerRegisterServlet")
public class JobSeekerRegister extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private static final String JDBC_URL = "jdbc:mysql://localhost:3306/job_portal";
    private static final String DB_USER = "root";
    private static final String DB_PASSWORD = "your_password_here";


    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String fullname = request.getParameter("fullname");
        String phone = request.getParameter("phone");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        String remember = request.getParameter("remember");

        if (!password.equals(confirmPassword)) {
            response.sendRedirect("JobSeekerRegister.jsp?error=Passwords+do+not+match");
            return;
        }

        try {
            String hashedPassword = PasswordHashUtil.hashPassword(password);

            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection(JDBC_URL, DB_USER, DB_PASSWORD);

            PreparedStatement check = con.prepareStatement("SELECT id FROM job_seekers WHERE email=?");
            check.setString(1, email);
            ResultSet rs = check.executeQuery();
            if (rs.next()) {
                response.sendRedirect("JobSeekerRegister.jsp?error=Email+exists");
                return;
            }

            PreparedStatement insert = con.prepareStatement(
                "INSERT INTO job_seekers(fullname, phone, email, password, role) VALUES (?, ?, ?, ?, ?)");
            insert.setString(1, fullname);
            insert.setString(2, phone);
            insert.setString(3, email);
            insert.setString(4, hashedPassword);
            insert.setString(5, "job_seeker");

            if (insert.executeUpdate() > 0) {
                HttpSession session = request.getSession();
                session.setAttribute("email", email);
                session.setAttribute("role", "job_seeker");

                if ("on".equals(remember)) {
                    Cookie cookie = new Cookie("email", email);
                    cookie.setMaxAge(7 * 24 * 60 * 60);
                    response.addCookie(cookie);
                }

                response.sendRedirect("dashboard.jsp");
            } else {
                response.sendRedirect("JobSeekerRegister.jsp?error=Something+went+wrong");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("JobSeekerRegister.jsp?error=Server+error");
        }
    }
}
