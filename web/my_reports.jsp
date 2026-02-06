<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="com.petie.bean.UserBean"%>
<%@page import="com.petie.util.DBConnection"%>
<%@page import="java.sql.*"%>
<%
    // 1. Security Check
    UserBean user = (UserBean) session.getAttribute("userSession");
    if (user == null) { response.sendRedirect("login.jsp"); return; }
    
    int fosterCount = 0;
    Connection con = null;
    PreparedStatement ps = null;
    ResultSet rs = null;
%>
<!DOCTYPE html>
<html>
<head>
    <title>My Reports & Fosters</title>
    <style>
        body { font-family: Arial, sans-serif; background-color: #f4f4f4; margin: 0; }
        .container { max-width: 900px; margin: 40px auto; background: white; padding: 30px; border-radius: 10px; box-shadow: 0 4px 10px rgba(0,0,0,0.1); }
        h2 { color: #003366; }
        
        /* Foster Badge */
        .foster-box { background-color: #e8f5e9; padding: 20px; border-radius: 8px; text-align: center; margin-bottom: 30px; border: 2px solid #4caf50; }
        .foster-number { font-size: 40px; font-weight: bold; color: #2e7d32; }
        
        table { width: 100%; border-collapse: collapse; margin-top: 10px; }
        th, td { padding: 12px; border: 1px solid #ddd; text-align: left; }
        th { background-color: #003366; color: white; }
        
        /* Status Colors */
        .status-pending { color: orange; font-weight: bold; }
        .status-centre { color: green; font-weight: bold; }
        .status-foster { color: #2196f3; font-weight: bold; } /* Blue for Foster */
        .status-rejected { color: red; font-weight: bold; }
    </style>
</head>
<body>

    <jsp:include page="navbar.jsp" />

    <div class="container">
        
        <%
            try {
                con = DBConnection.createConnection();
                
                // 2. Count Fostered Pets
                String countSql = "SELECT COUNT(*) FROM STRAY_REPORT WHERE USER_ID = ? AND STATUS = 'FOSTERED'";
                ps = con.prepareStatement(countSql);
                ps.setInt(1, user.getUserId());
                rs = ps.executeQuery();
                if(rs.next()) { fosterCount = rs.getInt(1); }
        %>

        <div class="foster-box">
            <div>You are currently fostering</div>
            <div class="foster-number"><%= fosterCount %></div>
            <div>Pets ❤️</div>
        </div>

        <hr>

        <h2>My Report History</h2>
        <table>
            <tr>
                <th>Pet Type</th>
                <th>Date Reported</th>
                <th>Situation</th>
                <th>Status</th>
            </tr>
            <%
                // 3. Get All Reports for this User
                String sql = "SELECT * FROM STRAY_REPORT WHERE USER_ID = ? ORDER BY STRAY_ID DESC";
                ps = con.prepareStatement(sql);
                ps.setInt(1, user.getUserId());
                rs = ps.executeQuery();
                
                while(rs.next()) {
                    String status = rs.getString("STATUS");
                    String cssClass = "status-pending"; // Default
                    
                    if("IN_CENTRE".equals(status)) cssClass = "status-centre";
                    if("FOSTERED".equals(status)) cssClass = "status-foster";
                    if("REJECTED".equals(status)) cssClass = "status-rejected";
            %>
            <tr>
                <td><%= rs.getString("PET_TYPE") %></td>
                <td><%= rs.getDate("DATE_FOUND") %></td>
                <td><%= rs.getString("SITUATION") %></td>
                <td class="<%= cssClass %>"><%= status %></td>
            </tr>
            <% 
                }
            } catch (Exception e) { e.printStackTrace(); } 
            %>
        </table>
    </div>
        <hr style="margin: 40px 0;">

        <h2>My Adoption Applications</h2>
        <table>
            <tr>
                <th>Pet Photo</th>
                <th>Pet Type</th>
                <th>Application Status</th>
            </tr>
            <%
                try {
                    // Re-open connection if needed, or use existing 'con' if strictly managed
                    if(con.isClosed()) con = DBConnection.createConnection();

                    // Join tables to get Pet Details for the Request
                    String adoptSql = "SELECT s.PET_TYPE, s.PET_PHOTO, r.STATUS " +
                                      "FROM ADOPTION_REQUESTS r " +
                                      "JOIN STRAY_REPORT s ON r.STRAY_ID = s.STRAY_ID " +
                                      "WHERE r.USER_ID = ? ORDER BY r.REQUEST_ID DESC";
                    
                    PreparedStatement psAdopt = con.prepareStatement(adoptSql);
                    psAdopt.setInt(1, user.getUserId());
                    ResultSet rsAdopt = psAdopt.executeQuery();
                    
                    while(rsAdopt.next()) {
                        String aStatus = rsAdopt.getString("STATUS");
                        String color = "orange";
                        if("APPROVED".equals(aStatus)) color = "green";
                        if("REJECTED".equals(aStatus)) color = "red";
            %>
            <tr>
                <td>
                    <img src="ImageServlet/<%= rsAdopt.getString("PET_PHOTO") %>" width="80" height="80" style="object-fit:cover; border-radius:5px;">
                </td>
                <td><%= rsAdopt.getString("PET_TYPE") %></td>
                <td><b style="color: <%= color %>;"><%= aStatus %></b></td>
            </tr>
            <% 
                    }
                    con.close(); // Close finally
                } catch (Exception e) { e.printStackTrace(); }
            %>
        </table>
        
        <br><br>
</body>
</html>