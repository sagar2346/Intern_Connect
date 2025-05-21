<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="dao.JobDAO" %>
<%@ page import="model.Job" %>
<%@ page import="java.util.List" %>
<%@ page import="java.sql.*" %>
<%@ page import="util.DatabaseConnection" %>
<!DOCTYPE html>
<html>
<head>
    <title>Debug Jobs | InternConnect</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 20px;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }
        th, td {
            border: 1px solid #ddd;
            padding: 8px;
            text-align: left;
        }
        th {
            background-color: #f2f2f2;
        }
        tr:nth-child(even) {
            background-color: #f9f9f9;
        }
        h2 {
            color: #333;
        }
    </style>
</head>
<body>
    <h1>Debug Jobs Database</h1>
    
    <h2>All Jobs in Database</h2>
    <table>
        <tr>
            <th>ID</th>
            <th>Title</th>
            <th>Company</th>
            <th>Type</th>
            <th>Status</th>
            <th>Posted Date</th>
        </tr>
        <%
            // Get all jobs using JobDAO
            JobDAO jobDAO = new JobDAO();
            List<Job> allJobs = jobDAO.getAllJobs();
            
            for (Job job : allJobs) {
        %>
        <tr>
            <td><%= job.getJobId() %></td>
            <td><%= job.getTitle() %></td>
            <td><%= job.getCompanyName() %></td>
            <td><%= job.getJobType() %></td>
            <td><%= job.getJobStatus() != null ? job.getJobStatus() : "Pending" %></td>
            <td><%= job.getPostedDate() %></td>
        </tr>
        <%
            }
            
            if (allJobs.isEmpty()) {
        %>
        <tr>
            <td colspan="6" style="text-align: center;">No jobs found in database</td>
        </tr>
        <%
            }
        %>
    </table>
    
    <h2>Database Structure</h2>
    <table>
        <tr>
            <th>Table</th>
            <th>Column</th>
            <th>Type</th>
        </tr>
        <%
            try (Connection conn = DatabaseConnection.getConnection()) {
                DatabaseMetaData metaData = conn.getMetaData();
                ResultSet tables = metaData.getTables(null, null, "%", new String[]{"TABLE"});
                
                while (tables.next()) {
                    String tableName = tables.getString("TABLE_NAME");
                    ResultSet columns = metaData.getColumns(null, null, tableName, null);
                    
                    boolean firstColumn = true;
                    while (columns.next()) {
                        String columnName = columns.getString("COLUMN_NAME");
                        String columnType = columns.getString("TYPE_NAME");
        %>
        <tr>
            <% if (firstColumn) { %>
            <td rowspan="<%= getColumnCount(conn, tableName) %>"><%= tableName %></td>
            <% firstColumn = false; } %>
            <td><%= columnName %></td>
            <td><%= columnType %></td>
        </tr>
        <%
                    }
                }
            } catch (SQLException e) {
                out.println("<tr><td colspan='3'>Error: " + e.getMessage() + "</td></tr>");
                e.printStackTrace();
            }
        %>
    </table>
    
    <p><a href="${pageContext.request.contextPath}/view/Admin_dashboard.jsp">Back to Admin Dashboard</a></p>
</body>
</html>

<%!
    // Helper method to get column count for a table
    private int getColumnCount(Connection conn, String tableName) throws SQLException {
        int count = 0;
        ResultSet columns = conn.getMetaData().getColumns(null, null, tableName, null);
        while (columns.next()) {
            count++;
        }
        return count > 0 ? count : 1; // Minimum 1 to avoid rowspan="0"
    }
%>