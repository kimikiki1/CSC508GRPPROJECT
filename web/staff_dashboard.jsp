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

    int pendingReports = 0;
    int pendingAdoptions = 0;

    try {
        Connection con = DBConnection.createConnection();
        
        // 1. Count Pending Reports
        PreparedStatement ps1 = con.prepareStatement("SELECT COUNT(*) FROM STRAY_REPORT WHERE STATUS = 'PENDING'");
        ResultSet rs1 = ps1.executeQuery();
        if(rs1.next()) pendingReports = rs1.getInt(1);

        // 2. Count Pending Adoptions (NEW)
        PreparedStatement ps2 = con.prepareStatement("SELECT COUNT(*) FROM ADOPTION_REQUESTS WHERE STATUS = 'PENDING'");
        ResultSet rs2 = ps2.executeQuery();
        if(rs2.next()) pendingAdoptions = rs2.getInt(1);
        
        con.close();
    } catch(Exception e) { e.printStackTrace(); }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Staff Dashboard</title>
    <style>
        body { font-family: Arial, sans-serif; background-color: #fff3e0; margin: 0; }
        .container { padding: 50px; text-align: center; }
        
        /* Flexbox for side-by-side cards */
        .dashboard-grid { display: flex; justify-content: center; gap: 30px; margin-top: 30px; }
        
        .card { 
            background: white; width: 300px; padding: 30px; 
            border-radius: 10px; box-shadow: 0 4px 8px rgba(0,0,0,0.1); 
            text-align: center;
        }
        .count { font-size: 50px; margin: 10px; font-weight: bold; color: #e65100; }
        .btn { 
            background-color: #e65100; color: white; padding: 10px 20px; 
            text-decoration: none; border-radius: 5px; font-weight: bold; display: inline-block; margin-top: 10px;
        }
        .btn:hover { background-color: #ef6c00; }
    </style>
</head>
<body>
    <jsp:include page="navbar.jsp" />

    <div class="container">
        <h1 style="color: #e65100;">Staff Command Center</h1>
        <p>Welcome, <%= user.getFullName() %>.</p>
        
        <div class="dashboard-grid">
            
            <div class="card">
                <div class="count"><%= pendingReports %></div>
                <h3>New Stray Reports</h3>
                <p>Waiting for verification</p>
                <a href="admin_checklist.jsp" class="btn">Process Reports</a>
            </div>

            <div class="card">
                <div class="count"><%= pendingAdoptions %></div>
                <h3>Adoption Requests</h3>
                <p>Waiting for approval</p>
                <a href="manage_adoptions.jsp" class="btn">Manage Adoptions</a>
            </div>

        </div>
    </div>
</body>
</html>