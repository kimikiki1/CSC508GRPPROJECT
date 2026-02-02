<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="com.petie.bean.UserBean"%>
<%@page import="com.petie.util.DBConnection"%>
<%@page import="java.sql.*"%>
<%
    UserBean admin = (UserBean) session.getAttribute("userSession");
    if (admin == null || !admin.getRole().equals("ADMIN")) {
        response.sendRedirect("login.jsp");
        return;
    }

    // Logic: Fetch Counts
    int totalUsers = 0, totalReports = 0, pendingReports = 0;
    try {
        Connection con = DBConnection.createConnection();
        PreparedStatement ps1 = con.prepareStatement("SELECT COUNT(*) FROM USERS WHERE ROLE != 'ADMIN'");
        ResultSet rs1 = ps1.executeQuery();
        if(rs1.next()) totalUsers = rs1.getInt(1);

        PreparedStatement ps2 = con.prepareStatement("SELECT COUNT(*) FROM STRAY_REPORT");
        ResultSet rs2 = ps2.executeQuery();
        if(rs2.next()) totalReports = rs2.getInt(1);
        
        PreparedStatement ps3 = con.prepareStatement("SELECT COUNT(*) FROM STRAY_REPORT WHERE STATUS = 'PENDING'");
        ResultSet rs3 = ps3.executeQuery();
        if(rs3.next()) pendingReports = rs3.getInt(1);
        con.close();
    } catch(Exception e) { e.printStackTrace(); }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Admin Dashboard</title>
    <style>
        body { font-family: Arial, sans-serif; background-color: #e0f7fa; margin: 0; }
        .main-content { padding: 40px; max-width: 1000px; margin: auto; }
        .stats-grid { display: flex; gap: 20px; justify-content: center; }
        .stat-card { 
            background: white; 
            padding: 20px; 
            border-radius: 8px; 
            box-shadow: 0 2px 5px rgba(0,0,0,0.1); 
            width: 30%; 
            text-align: center; 
        }
        .stat-number { font-size: 40px; font-weight: bold; color: #003366; margin: 10px 0; }
    </style>
</head>
<body>

    <jsp:include page="navbar.jsp" />

    <div class="main-content">
        <h1 style="text-align:center; color:#003366;">Admin Dashboard</h1>
        <p style="text-align:center;">Welcome, Admin <b><%= admin.getFullName() %></b>.</p>

        <div class="stats-grid">
            <div class="stat-card">
                <div class="stat-number"><%= totalUsers %></div>
                <div>Registered Users</div>
            </div>
            <div class="stat-card">
                <div class="stat-number"><%= totalReports %></div>
                <div>Total Stray Reports</div>
            </div>
            <div class="stat-card">
                <div class="stat-number" style="color:red;"><%= pendingReports %></div>
                <div>Pending Reviews</div>
            </div>
        </div>
        
        <div style="text-align:center; margin-top: 40px;">
             <a href="admin_checklist.jsp" style="background-color: #003366; color: white; padding: 15px 30px; text-decoration: none; border-radius: 5px; font-size: 18px;">Review Pending Reports</a>
        </div>
    </div>

</body>
</html>