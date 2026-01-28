<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="com.petie.bean.UserBean"%>
<%@page import="com.petie.util.DBConnection"%>
<%@page import="java.sql.*"%>
<%
    // Security Check: Ensure user is logged in AND is ADMIN
    UserBean admin = (UserBean) session.getAttribute("userSession");
    if (admin == null || !admin.getRole().equals("ADMIN")) {
        response.sendRedirect("login.jsp");
        return;
    }

    // --- DASHBOARD LOGIC: Fetch Counts from Database ---
    int totalUsers = 0;
    int totalReports = 0;
    int pendingReports = 0;

    try {
        Connection con = DBConnection.createConnection();
        
        // Count Users
        PreparedStatement ps1 = con.prepareStatement("SELECT COUNT(*) FROM USERS WHERE ROLE != 'ADMIN'");
        ResultSet rs1 = ps1.executeQuery();
        if(rs1.next()) totalUsers = rs1.getInt(1);

        // Count Total Reports
        PreparedStatement ps2 = con.prepareStatement("SELECT COUNT(*) FROM STRAY_REPORT");
        ResultSet rs2 = ps2.executeQuery();
        if(rs2.next()) totalReports = rs2.getInt(1);
        
        // Count Pending Reports
        PreparedStatement ps3 = con.prepareStatement("SELECT COUNT(*) FROM STRAY_REPORT WHERE STATUS = 'PENDING'");
        ResultSet rs3 = ps3.executeQuery();
        if(rs3.next()) pendingReports = rs3.getInt(1);
        
        con.close();
    } catch(Exception e) {
        e.printStackTrace();
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Admin Dashboard - Petie Adoptie</title>
    <style>
        body { font-family: Arial, sans-serif; background-color: #e0f7fa; margin: 0; }
        .sidebar { height: 100vh; width: 250px; position: fixed; background-color: #003366; color: white; padding-top: 20px; }
        .sidebar a { display: block; padding: 15px; color: white; text-decoration: none; font-size: 18px; }
        .sidebar a:hover { background-color: #00509e; }
        .sidebar .active { background-color: #28a745; }
        
        .main-content { margin-left: 250px; padding: 40px; }
        .stats-grid { display: flex; gap: 20px; }
        .stat-card { 
            background: white; 
            padding: 20px; 
            border-radius: 8px; 
            box-shadow: 0 2px 5px rgba(0,0,0,0.1); 
            width: 30%; 
            text-align: center; 
        }
        .stat-number { font-size: 40px; font-weight: bold; color: #003366; margin: 10px 0; }
        .stat-label { color: #666; font-size: 14px; text-transform: uppercase; }
        
        table { width: 100%; border-collapse: collapse; margin-top: 20px; background: white; }
        th, td { padding: 12px; border-bottom: 1px solid #ddd; text-align: left; }
        th { background-color: #003366; color: white; }
    </style>
</head>
<body>

    <div class="sidebar">
        <h2 style="text-align:center; margin-bottom: 30px;">Admin Panel</h2>
        <a href="admin_dashboard.jsp" class="active">Dashboard</a>
        <a href="admin_checklist.jsp">Stray Reports</a>
        <a href="manage_users.jsp">Manage Users</a>
        <a href="LogoutServlet" style="margin-top: 50px; background-color: #b71c1c;">Log Out</a>
    </div>

    <div class="main-content">
        <h1>Dashboard Overview</h1>
        <p>Welcome, Admin <b><%= admin.getFullName() %></b>.</p>

        <div class="stats-grid">
            <div class="stat-card">
                <div class="stat-number"><%= totalUsers %></div>
                <div class="stat-label">Registered Users</div>
            </div>
            <div class="stat-card">
                <div class="stat-number"><%= totalReports %></div>
                <div class="stat-label">Total Stray Reports</div>
            </div>
            <div class="stat-card">
                <div class="stat-number" style="color:red;"><%= pendingReports %></div>
                <div class="stat-label">Pending Reviews</div>
            </div>
        </div>

        <br><br>
        
        <h2>Quick Actions</h2>
        <div style="background-color: white; padding: 20px; border-radius: 8px;">
            <p>You have <b><%= pendingReports %></b> new stray reports waiting for approval.</p>
            <a href="admin_checklist.jsp" style="background-color: #003366; color: white; padding: 10px 20px; text-decoration: none; border-radius: 5px;">View Reports</a>
        </div>
    </div>

</body>
</html>