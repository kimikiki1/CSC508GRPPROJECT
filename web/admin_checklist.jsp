<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="com.petie.util.DBConnection"%>
<%@page import="java.sql.*"%>
<!DOCTYPE html>
<html>
<head>
    <title>Manage Reports</title>
    <style>
        body { font-family: Arial, sans-serif; background-color: #e0f7fa; margin: 0; }
        .content { padding: 40px; margin: auto; max-width: 1000px; }
        table { width: 100%; border-collapse: collapse; background: white; }
        th, td { padding: 12px; border: 1px solid #ddd; text-align: left; }
        th { background-color: #003366; color: white; }
        .btn-approve { background-color: #28a745; color: white; padding: 5px 10px; text-decoration: none; border-radius: 3px; }
        .btn-reject { background-color: #dc3545; color: white; padding: 5px 10px; text-decoration: none; border-radius: 3px; }
    </style>
</head>
<body>

    <jsp:include page="navbar.jsp" />

    <div class="content">
        <h1 style="color:#003366;">Stray Reports Checklist</h1>
        <table>
            <tr>
                <th>ID</th>
                <th>Type</th>
                <th>Location</th>
                <th>Date</th>
                <th>Status</th>
                <th>Action</th>
            </tr>
            <%
                Connection con = DBConnection.createConnection();
                PreparedStatement ps = con.prepareStatement("SELECT * FROM STRAY_REPORT");
                ResultSet rs = ps.executeQuery();
                while(rs.next()) {
            %>
            <tr>
                <td><%= rs.getInt("STRAY_ID") %></td>
                <td><%= rs.getString("PET_TYPE") %></td>
                <td><%= rs.getString("LOCATION_FOUND") %></td>
                <td><%= rs.getDate("DATE_FOUND") %></td>
                <td><%= rs.getString("STATUS") %></td>
                <td>
                    <a href="#" class="btn-approve">Approve</a>
                    <a href="#" class="btn-reject">Reject</a>
                </td>
            </tr>
            <% } con.close(); %>
        </table>
    </div>

</body>
</html>