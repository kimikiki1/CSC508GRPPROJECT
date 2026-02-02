<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="com.petie.bean.UserBean"%>
<%@page import="com.petie.util.DBConnection"%>
<%@page import="java.sql.*"%>
<%
    // SECURITY CHECK: Only allow STAFF
    UserBean user = (UserBean) session.getAttribute("userSession");
    if (user == null || !user.getRole().equals("STAFF")) {
        response.sendRedirect("login.jsp");
        return;
    }

    // Count Pending Reports
    int pendingCount = 0;
    try {
        Connection con = DBConnection.createConnection();
        PreparedStatement ps = con.prepareStatement("SELECT COUNT(*) FROM STRAY_REPORT WHERE STATUS = 'PENDING'");
        ResultSet rs = ps.executeQuery();
        if(rs.next()) pendingCount = rs.getInt(1);
        con.close();
    } catch(Exception e) { e.printStackTrace(); }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Staff Dashboard</title>
    <style>
        body { font-family: Arial, sans-serif; background-color: #fff3e0; margin: 0; } /* Orange tint for Staff */
        .container { padding: 50px; text-align: center; }
        .card { 
            background: white; width: 300px; padding: 30px; margin: auto; 
            border-radius: 10px; box-shadow: 0 4px 8px rgba(0,0,0,0.1); 
        }
        .btn { 
            background-color: #e65100; color: white; padding: 15px 30px; 
            text-decoration: none; border-radius: 5px; font-weight: bold; display: inline-block; 
        }
    </style>
</head>
<body>
    <jsp:include page="navbar.jsp" />

    <div class="container">
        <h1 style="color: #e65100;">Staff Work Area</h1>
        <p>Welcome, <%= user.getFullName() %>.</p>
        <br>
        <div class="card">
            <h1 style="font-size: 50px; margin: 10px;"><%= pendingCount %></h1>
            <p>Reports Waiting for Review</p>
            <br>
            <a href="admin_checklist.jsp" class="btn">Start Processing</a>
        </div>
    </div>
</body>
</html>