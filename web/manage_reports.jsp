<%@page import="java.sql.*"%>
<%@page import="com.petie.util.DBConnection"%>
<%@page import="com.petie.bean.UserBean"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    // 1. Security Check
    UserBean currentUser = (UserBean) session.getAttribute("userSession");
    if (currentUser == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    String role = currentUser.getRole();
    String sql = "";
    String title = "";

    // 2. Determine View based on Role
    if ("STAFF".equals(role)) {
        sql = "SELECT S.STRAY_ID, S.PET_TYPE, S.LOCATION_FOUND, S.DATE_FOUND, S.SITUATION, S.PET_PHOTO, S.STATUS, U.FULL_NAME " +
              "FROM STRAY_REPORT S JOIN USERS U ON S.USER_ID = U.USER_ID " +
              "WHERE S.STATUS = 'PENDING' ORDER BY S.STRAY_ID DESC";
        title = "Staff Checklist: Verify New Reports";
    } else if ("ADMIN".equals(role)) {
        sql = "SELECT S.STRAY_ID, S.PET_TYPE, S.LOCATION_FOUND, S.DATE_FOUND, S.SITUATION, S.PET_PHOTO, S.STATUS, U.FULL_NAME " +
              "FROM STRAY_REPORT S JOIN USERS U ON S.USER_ID = U.USER_ID " +
              "WHERE S.STATUS LIKE 'WAITING_%' ORDER BY S.STRAY_ID DESC";
        title = "Admin Checklist: Finalize Proposals";
    } else {
        response.sendRedirect("home.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>Manage Reports</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <style>
        /* Shared Styles */
        body { font-family: 'Segoe UI', sans-serif; background-color: #f4f6f9; margin: 0; }
        .main-content { margin-left: 280px; padding: 30px; min-height: 100vh; }
        .container { max-width: 1200px; margin: 0 auto; }

        /* Card */
        .card { background: white; border-radius: 12px; box-shadow: 0 4px 15px rgba(0,0,0,0.1); overflow: hidden; }
        .card-header { background: linear-gradient(135deg, #4a90e2 0%, #3498db 100%); color: white; padding: 20px; }
        .card-body { padding: 0; }

        /* Table */
        .styled-table { width: 100%; border-collapse: collapse; }
        .styled-table th { background-color: #f8f9fa; color: #34495e; padding: 15px; text-align: left; font-weight: 600; border-bottom: 2px solid #eee; }
        .styled-table td { padding: 15px; border-bottom: 1px solid #eee; vertical-align: middle; color: #555; }
        .styled-table tr:hover { background-color: #fbfbfb; }

        /* Thumbnails */
        .pet-thumbnail { 
            width: 80px; height: 80px; object-fit: cover; border-radius: 8px; 
            border: 1px solid #ddd; box-shadow: 0 2px 5px rgba(0,0,0,0.05);
            transition: transform 0.2s ease; cursor: pointer;
        }
        .pet-thumbnail:hover { transform: scale(2.5); z-index: 100; position: relative; border-color: #3498db; }

        /* Buttons */
        .btn-action { padding: 6px 12px; border-radius: 4px; text-decoration: none; color: white; font-size: 12px; margin-right: 5px; display: inline-block; font-weight: 600; }
        .btn-blue { background-color: #3498db; }
        .btn-green { background-color: #2ecc71; }
        .btn-red { background-color: #e74c3c; }
        .btn-cyan { background-color: #17a2b8; }

        @media (max-width: 992px) { .main-content { margin-left: 0; } }
    </style>
</head>
<body>

    <jsp:include page="navbar.jsp" />

    <div class="main-content">
        <div class="container">
            
            <div class="card">
                <div class="card-header">
                    <h2 style="margin:0;"><i class="fas fa-clipboard-check"></i> <%= title %></h2>
                </div>
                
                <div class="card-body">
                    <table class="styled-table">
                        <thead>
                            <tr>
                                <th>Photo</th>
                                <th>Details</th>
                                <th>Status</th>
                                <th>Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                Connection con = null;
                                try {
                                    con = DBConnection.createConnection();
                                    PreparedStatement ps = con.prepareStatement(sql);
                                    ResultSet rs = ps.executeQuery();
                                    boolean hasData = false;
                                    
                                    while(rs.next()) {
                                        hasData = true;
                                        int id = rs.getInt("STRAY_ID");
                                        String status = rs.getString("STATUS");
                                        String photo = rs.getString("PET_PHOTO");
                            %>
                            <tr>
                                <td>
                                    <img src="ImageServlet/<%= photo %>" 
                                         class="pet-thumbnail" 
                                         alt="Pet Photo"
                                         onerror="this.src='https://via.placeholder.com/80?text=No+Img'">
                                </td>
                                
                                <td>
                                    <strong><%= rs.getString("PET_TYPE") %></strong> <span style="color:#999; font-size:12px;">(#<%= id %>)</span><br>
                                    <span style="font-size:13px; color:#666;">
                                        <i class="fas fa-map-marker-alt" style="color:#e74c3c;"></i> <%= rs.getString("LOCATION_FOUND") %>
                                    </span><br>
                                    <span style="font-size:13px; color:#666;">
                                        <i class="fas fa-user"></i> <%= rs.getString("FULL_NAME") %>
                                    </span>
                                </td>
                                
                                <td>
                                    <span style="background:#fff3cd; color:#856404; padding:4px 8px; border-radius:10px; font-size:11px; font-weight:bold;">
                                        <%= status %>
                                    </span>
                                </td>
                                
                                <td>
                                    <% if ("STAFF".equals(role)) { %>
                                        <a href="UpdateReportStatusServlet?id=<%= id %>&status=WAITING_ADMIN_CENTRE" class="btn-action btn-blue">Propose Centre</a>
                                        <a href="UpdateReportStatusServlet?id=<%= id %>&status=WAITING_ADMIN_FOSTER" class="btn-action btn-cyan">Propose Foster</a>
                                        <a href="UpdateReportStatusServlet?id=<%= id %>&status=REJECTED" class="btn-action btn-red">Reject</a>
                                    
                                    <% } else if ("ADMIN".equals(role)) { %>
                                        <a href="UpdateReportStatusServlet?id=<%= id %>&status=IN_CENTRE" class="btn-action btn-green">Confirm Centre</a>
                                        <a href="UpdateReportStatusServlet?id=<%= id %>&status=FOSTERED" class="btn-action btn-green">Confirm Foster</a>
                                        <a href="UpdateReportStatusServlet?id=<%= id %>&status=REJECTED" class="btn-action btn-red">Reject</a>
                                    <% } %>
                                </td>
                            </tr>
                            <% 
                                    }
                                    if(!hasData) { out.println("<tr><td colspan='4' style='text-align:center; padding:30px;'>No pending reports.</td></tr>"); }
                                } catch(Exception e) { e.printStackTrace(); } 
                                finally { if(con!=null) try { con.close(); } catch(Exception e){} }
                            %>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</body>
</html>