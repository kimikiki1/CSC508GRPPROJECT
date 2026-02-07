<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="com.petie.bean.UserBean"%>
<%@page import="com.petie.util.DBConnection"%>
<%@page import="java.sql.*"%>

<%
    // 2. SECURITY CHECK
    UserBean currentUser = (UserBean) session.getAttribute("userSession");
    if (currentUser == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    String role = currentUser.getRole();
    String sql = "";
    String title = "";

    // 3. LOGIC: WHO SEES WHAT?
    if ("STAFF".equals(role)) {
        sql = "SELECT * FROM STRAY_REPORT WHERE STATUS = 'PENDING'";
        title = "Staff Task List: Verify New Reports";
    } else if ("ADMIN".equals(role)) {
        sql = "SELECT * FROM STRAY_REPORT WHERE STATUS LIKE 'WAITING_%'";
        title = "Admin Task List: Finalize Proposals";
    } else {
        sql = "SELECT * FROM STRAY_REPORT WHERE 1=0"; 
        title = "No Access";
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>Manage Reports</title>
    <style>
        body { font-family: Arial, sans-serif; background-color: #f4f4f4; margin: 0; }
        .content { padding: 40px; margin: auto; max-width: 1000px; background: white; border-radius: 8px; box-shadow: 0 0 10px rgba(0,0,0,0.1); margin-top: 30px; }
        h1 { color: #003366; border-bottom: 2px solid #eee; padding-bottom: 10px; }
        table { width: 100%; border-collapse: collapse; margin-top: 20px; }
        th, td { padding: 12px; border: 1px solid #ddd; text-align: left; }
        th { background-color: #003366; color: white; }
        tr:nth-child(even) { background-color: #f9f9f9; }
        .btn { padding: 6px 12px; text-decoration: none; color: white; border-radius: 4px; font-size: 14px; margin-right: 5px; display: inline-block; margin-bottom: 3px; }
        .btn-blue { background-color: #007bff; }
        .btn-green { background-color: #28a745; }
        .btn-cyan { background-color: #17a2b8; }
        .btn-red { background-color: #dc3545; }
    </style>
</head>
<body>

    <jsp:include page="navbar.jsp" />

    <div class="content">
        <h1><%= title %></h1>

        <table>
            <tr>
                <th>ID</th>
                <th>Pet Type</th>
                <th>Location</th>
                <th>Date Found</th>
                <th>Current Status</th>
                <th style="width: 250px;">Action</th>
            </tr>
            <%
                Connection con = null;
                try {
                    con = DBConnection.createConnection();
                    PreparedStatement ps = con.prepareStatement(sql);
                    ResultSet rs = ps.executeQuery();
                    
                    boolean hasData = false;
                    while(rs.next()) {
                        hasData = true;
                        String status = rs.getString("STATUS");
            %>
            <tr>
                <td><%= rs.getInt("STRAY_ID") %></td>
                <td><%= rs.getString("PET_TYPE") %></td>
                <td><%= rs.getString("LOCATION_FOUND") %></td>
                <td><%= rs.getDate("DATE_FOUND") %></td>
                <td><b style="color:orange;"><%= status %></b></td>
                <td>
                    <% if ("STAFF".equals(role)) { %>
                        <a href="ProcessReportServlet?id=<%= rs.getInt("STRAY_ID") %>&action=centre" class="btn btn-blue">Propose Centre</a>
                        <a href="ProcessReportServlet?id=<%= rs.getInt("STRAY_ID") %>&action=foster" class="btn btn-cyan">Propose Foster</a>
                        <a href="ProcessReportServlet?id=<%= rs.getInt("STRAY_ID") %>&action=reject" class="btn btn-red">Reject</a>
                    <% } else if ("ADMIN".equals(role)) { %>
                        <a href="ProcessReportServlet?id=<%= rs.getInt("STRAY_ID") %>&action=approve&currentStatus=<%= status %>" class="btn btn-green">Confirm Decision</a>
                        <a href="ProcessReportServlet?id=<%= rs.getInt("STRAY_ID") %>&action=reject" class="btn btn-red">Override & Reject</a>
                    <% } %>
                </td>
            </tr>
            <% 
                    } 
                    if(!hasData) { 
                        out.println("<tr><td colspan='6' style='text-align:center; padding:30px; color:#777;'>No pending tasks found.</td></tr>"); 
                    }
                } catch(Exception e) {
                    e.printStackTrace();
                    out.println("<tr><td colspan='6' style='color:red;'>Error loading data: " + e.getMessage() + "</td></tr>");
                } finally {
                    if(con != null) con.close();
                }
            %>
        </table>
    </div>
</body>
</html>