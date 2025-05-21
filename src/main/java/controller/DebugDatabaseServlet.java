package controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DatabaseMetaData;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.sql.Statement;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import util.DatabaseConnection;

//@WebServlet("/DebugDatabaseServlet")
public class DebugDatabaseServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/html");
        PrintWriter out = response.getWriter();
        
        out.println("<html><head><title>Database Debug</title>");
        out.println("<style>");
        out.println("body { font-family: Arial, sans-serif; margin: 20px; }");
        out.println("table { border-collapse: collapse; width: 100%; margin-bottom: 20px; }");
        out.println("th, td { border: 1px solid #ddd; padding: 8px; text-align: left; }");
        out.println("th { background-color: #f2f2f2; }");
        out.println("h2 { margin-top: 30px; }");
        out.println("</style>");
        out.println("</head><body>");
        
        out.println("<h1>Database Debug</h1>");
        
        try (Connection conn = DatabaseConnection.getConnection()) {
            // Get database metadata
            DatabaseMetaData metaData = conn.getMetaData();
            
            // List all tables
            out.println("<h2>Database Tables</h2>");
            out.println("<table>");
            out.println("<tr><th>Table Name</th></tr>");
            
            ResultSet tables = metaData.getTables(null, null, "%", new String[]{"TABLE"});
            while (tables.next()) {
                String tableName = tables.getString("TABLE_NAME");
                out.println("<tr><td>" + tableName + "</td></tr>");
            }
            out.println("</table>");
            
            // Show jobs table structure
            out.println("<h2>Jobs Table Structure</h2>");
            out.println("<table>");
            out.println("<tr><th>Column Name</th><th>Type</th><th>Nullable</th></tr>");
            
            ResultSet columns = metaData.getColumns(null, null, "jobs", null);
            while (columns.next()) {
                String columnName = columns.getString("COLUMN_NAME");
                String columnType = columns.getString("TYPE_NAME");
                String nullable = columns.getString("IS_NULLABLE");
                
                out.println("<tr>");
                out.println("<td>" + columnName + "</td>");
                out.println("<td>" + columnType + "</td>");
                out.println("<td>" + nullable + "</td>");
                out.println("</tr>");
            }
            out.println("</table>");
            
            // Show jobs data
            out.println("<h2>Jobs Data</h2>");
            out.println("<table>");
            
            Statement stmt = conn.createStatement();
            ResultSet rs = stmt.executeQuery("SELECT * FROM jobs");
            ResultSetMetaData rsmd = rs.getMetaData();
            
            // Print column headers
            out.println("<tr>");
            for (int i = 1; i <= rsmd.getColumnCount(); i++) {
                out.println("<th>" + rsmd.getColumnName(i) + "</th>");
            }
            out.println("</tr>");
            
            // Print data rows
            while (rs.next()) {
                out.println("<tr>");
                for (int i = 1; i <= rsmd.getColumnCount(); i++) {
                    String value = rs.getString(i);
                    out.println("<td>" + (value != null ? value : "NULL") + "</td>");
                }
                out.println("</tr>");
            }
            out.println("</table>");
            
            // Add a form to approve a job
            out.println("<h2>Approve a Job</h2>");
            out.println("<form action='" + request.getContextPath() + "/ApproveJobServlet' method='get'>");
            out.println("Job ID: <input type='text' name='id'>");
            out.println("<input type='submit' value='Approve'>");
            out.println("</form>");
            
            out.println("<p><a href='" + request.getContextPath() + "/view/JobListing.jsp'>Go to Job Listing Page</a></p>");
            out.println("<p><a href='" + request.getContextPath() + "/view/Admin_dashboard.jsp'>Go to Admin Dashboard</a></p>");
            
        } catch (SQLException e) {
            out.println("<h2>Error</h2>");
            out.println("<p>Error: " + e.getMessage() + "</p>");
            e.printStackTrace(new PrintWriter(out));
        }
        
        out.println("</body></html>");
    }
}