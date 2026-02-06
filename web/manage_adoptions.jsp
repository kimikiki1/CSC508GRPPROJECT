<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="com.petie.util.DBConnection"%>
<%@page import="java.sql.*"%>
<!DOCTYPE html>
<html>
<head><title>Manage Adoptions</title></head>
<body>
    <jsp:include page="navbar.jsp" />
    <h1>Adoption Requests</h1>
    <table border="1" style="width: 80%; margin: auto;">
        <tr>
            <th>Pet ID</th>
            <th>Applicant Name</th>
            <th>Phone</th>
            <th>Action</th>
        </tr>
        <%
            Connection con = DBConnection.createConnection();
            // Join 3 tables to get Pet Name, User Name, and Request Info
            String sql = "SELECT r.REQUEST_ID, s.STRAY_ID, u.FULL_NAME, u.PHONE_NUMBER " +
                         "FROM ADOPTION_REQUESTS r " +
                         "JOIN USERS u ON r.USER_ID = u.USER_ID " +
                         "JOIN STRAY_REPORT s ON r.STRAY_ID = s.STRAY_ID " +
                         "WHERE r.STATUS = 'PENDING'";
            PreparedStatement ps = con.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while(rs.next()) {
        %>
        <tr>
            <td><%= rs.getInt("STRAY_ID") %></td>
            <td><%= rs.getString("FULL_NAME") %></td>
            <td><%= rs.getString("PHONE_NUMBER") %></td>
            <td>
                <a href="ProcessAdoptionServlet?id=<%= rs.getInt("REQUEST_ID") %>&action=approve">Approve</a>
                <a href="ProcessAdoptionServlet?id=<%= rs.getInt("REQUEST_ID") %>&action=reject">Reject</a>
            </td>
        </tr>
        <% } con.close(); %>
    </table>
</body>
</html>