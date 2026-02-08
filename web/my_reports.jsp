<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="com.petie.bean.UserBean"%>
<%@page import="com.petie.util.DBConnection"%>
<%@page import="java.sql.*"%>

<%
    // 1. Security Check
    UserBean user = (UserBean) session.getAttribute("userSession");
    if (user == null) { response.sendRedirect("login.jsp"); return; }
    
    // Initialize variables
    int fosterCount = 0;
    Connection con = null;
    PreparedStatement ps = null;
    ResultSet rs = null;
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Reports & Activity - Petie Adoptie</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <style>
        /* --- 1. DASHBOARD THEME VARIABLES --- */
        :root {
            --pet-primary: #4a90e2;       
            --pet-secondary: #f39c12;    
            --pet-success: #2ecc71;      
            --pet-danger: #e74c3c;       
            --pet-purple: #9b59b6;
            --pet-dark: #34495e;         
            --pet-gray: #95a5a6;         
            --border-radius: 12px;
            --box-shadow: 0 4px 6px rgba(0,0,0,0.05);
            --box-shadow-lg: 0 10px 15px rgba(0,0,0,0.1);
        }

        body { font-family: 'Segoe UI', sans-serif; background-color: #f4f6f9; margin: 0; }

        /* --- 2. MAIN LAYOUT WRAPPER (Critical for Sidebar) --- */
        .main-content {
            margin-left: 280px;
            padding: 30px;
            transition: margin-left 0.3s ease;
            min-height: 100vh;
        }

        .dashboard-container { max-width: 1200px; margin: 0 auto; }

        /* --- 3. PAGE HEADER --- */
        .page-header {
            background: linear-gradient(135deg, #4a90e2 0%, #3498DB 100%);
            color: white;
            padding: 30px;
            border-radius: var(--border-radius);
            margin-bottom: 30px;
            box-shadow: var(--box-shadow-lg);
            display: flex;
            align-items: center;
            justify-content: space-between;
            position: relative;
            overflow: hidden;
        }
        
        .page-header::before {
            content: ""; position: absolute; top: -50%; right: -50%; width: 300%; height: 200%;
            background: radial-gradient(circle, rgba(255,255,255,0.1) 1px, transparent 1px);
            background-size: 20px 20px; opacity: 0.2;
        }

        .header-content { position: relative; z-index: 1; }
        .header-content h1 { margin: 0; font-size: 1.8rem; }
        .header-content p { margin: 5px 0 0; opacity: 0.9; }

        /* --- 4. FOSTER STAT CARD --- */
        .stat-card {
            background: white;
            border-radius: var(--border-radius);
            padding: 25px;
            box-shadow: var(--box-shadow);
            border-left: 5px solid var(--pet-success);
            display: flex;
            align-items: center;
            margin-bottom: 30px;
            max-width: 350px;
        }

        .stat-icon {
            width: 60px; height: 60px;
            background: rgba(46, 204, 113, 0.1);
            color: var(--pet-success);
            border-radius: 50%;
            display: flex; align-items: center; justify-content: center;
            font-size: 24px;
            margin-right: 20px;
        }

        .stat-info h3 { margin: 0; font-size: 32px; color: var(--pet-dark); }
        .stat-info p { margin: 0; color: var(--pet-gray); font-size: 14px; text-transform: uppercase; letter-spacing: 0.5px; }

        /* --- 5. DATA TABLES --- */
        .table-card {
            background: white;
            border-radius: var(--border-radius);
            padding: 25px;
            box-shadow: var(--box-shadow);
            margin-bottom: 30px;
            border-top: 4px solid var(--pet-primary);
        }

        .card-title {
            margin: 0 0 20px 0;
            color: var(--pet-dark);
            font-size: 1.2rem;
            display: flex; align-items: center; gap: 10px;
            padding-bottom: 15px; border-bottom: 1px solid #eee;
        }

        .table-responsive { overflow-x: auto; }

        table { width: 100%; border-collapse: collapse; }
        
        th { 
            text-align: left; padding: 15px; 
            background-color: #f8f9fa; color: var(--pet-dark);
            font-weight: 700; border-bottom: 2px solid #eee;
            font-size: 0.9rem;
        }
        
        td { 
            padding: 15px; border-bottom: 1px solid #eee; 
            vertical-align: middle; color: #555;
        }
        
        tr:hover { background-color: #fbfbfb; }

        /* Status Badges */
        .status-badge {
            padding: 5px 10px; border-radius: 20px; font-size: 12px; font-weight: 700;
        }
        .st-pending { background: #fff3cd; color: #856404; }
        .st-centre  { background: #d1ecf1; color: #0c5460; }
        .st-foster  { background: #cce5ff; color: #004085; }
        .st-adopted { background: #d4edda; color: #155724; }
        .st-rejected{ background: #f8d7da; color: #721c24; }

        /* Mobile */
        @media (max-width: 992px) {
            .main-content { margin-left: 0; }
        }
    </style>
</head>
<body>

    <jsp:include page="navbar.jsp" />

    <div class="main-content">
        <div class="dashboard-container">
            
            <div class="page-header">
                <div class="header-content">
                    <h1>My Activity Log</h1>
                    <p>Track your submitted reports and adoption applications.</p>
                </div>
                <div style="font-size: 40px; opacity: 0.3;">
                    <i class="fas fa-file-alt"></i>
                </div>
            </div>

            <%
                try {
                    con = DBConnection.createConnection();
                    
                    // --- FOSTER COUNT QUERY ---
                    String countSql = "SELECT COUNT(*) FROM STRAY_REPORT WHERE USER_ID = ? AND STATUS = 'FOSTERED'";
                    ps = con.prepareStatement(countSql);
                    ps.setInt(1, user.getUserId());
                    rs = ps.executeQuery();
                    if(rs.next()) { fosterCount = rs.getInt(1); }
            %>

            <div class="stat-card">
                <div class="stat-icon"><i class="fas fa-heart"></i></div>
                <div class="stat-info">
                    <h3><%= fosterCount %></h3>
                    <p>Pets Fostered</p>
                </div>
            </div>

            <div class="table-card">
                <h3 class="card-title">
                    <i class="fas fa-history" style="color: var(--pet-primary);"></i> 
                    Report History
                </h3>
                
                <div class="table-responsive">
                    <table>
                        <thead>
                            <tr>
                                <th>Pet Type</th>
                                <th>Date Found</th>
                                <th>Situation</th>
                                <th>Status</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                // Reset Resources
                                if(rs!=null) rs.close();
                                if(ps!=null) ps.close();

                                String reportSql = "SELECT * FROM STRAY_REPORT WHERE USER_ID = ? ORDER BY STRAY_ID DESC";
                                ps = con.prepareStatement(reportSql);
                                ps.setInt(1, user.getUserId());
                                rs = ps.executeQuery();
                                
                                boolean hasReports = false;
                                while(rs.next()) {
                                    hasReports = true;
                                    String status = rs.getString("STATUS");
                                    String badgeClass = "st-pending"; // Default
                                    
                                    if("IN_CENTRE".equals(status)) badgeClass = "st-centre";
                                    if("FOSTERED".equals(status)) badgeClass = "st-foster";
                                    if("ADOPTED".equals(status)) badgeClass = "st-adopted";
                                    if("REJECTED".equals(status)) badgeClass = "st-rejected";
                            %>
                            <tr>
                                <td><b style="color: #555;"><%= rs.getString("PET_TYPE") %></b></td>
                                <td><%= rs.getDate("DATE_FOUND") %></td>
                                <td><%= rs.getString("SITUATION") %></td>
                                <td><span class="status-badge <%= badgeClass %>"><%= status %></span></td>
                            </tr>
                            <% 
                                } 
                                if(!hasReports) { 
                                    out.println("<tr><td colspan='4' style='text-align:center; padding:30px; color:#aaa;'>You haven't reported any strays yet.</td></tr>"); 
                                }
                            %>
                        </tbody>
                    </table>
                </div>
            </div>

            <div class="table-card" style="border-top-color: var(--pet-purple);">
                <h3 class="card-title">
                    <i class="fas fa-paw" style="color: var(--pet-purple);"></i> 
                    Adoption Applications
                </h3>
                
                <div class="table-responsive">
                    <table>
                        <thead>
                            <tr>
                                <th>Pet Photo</th>
                                <th>Pet Type</th>
                                <th>Application Status</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                // Reset Resources
                                if(rs!=null) rs.close();
                                if(ps!=null) ps.close();

                                String adoptSql = "SELECT s.PET_TYPE, s.PET_PHOTO, r.STATUS " +
                                                  "FROM ADOPTION_REQUESTS r " +
                                                  "JOIN STRAY_REPORT s ON r.STRAY_ID = s.STRAY_ID " +
                                                  "WHERE r.USER_ID = ? ORDER BY r.REQUEST_ID DESC";
                                
                                ps = con.prepareStatement(adoptSql);
                                ps.setInt(1, user.getUserId());
                                rs = ps.executeQuery();
                                
                                boolean hasApps = false;
                                while(rs.next()) {
                                    hasApps = true;
                                    String aStatus = rs.getString("STATUS");
                                    String aBadge = "st-pending";
                                    if("APPROVED".equals(aStatus)) aBadge = "st-adopted"; // Green
                                    if("REJECTED".equals(aStatus)) aBadge = "st-rejected"; // Red
                            %>
                            <tr>
                                <td>
                                    <img src="ImageServlet/<%= rs.getString("PET_PHOTO") %>" 
                                         width="60" height="60" 
                                         style="object-fit:cover; border-radius:8px; border:1px solid #eee;">
                                </td>
                                <td><b><%= rs.getString("PET_TYPE") %></b></td>
                                <td><span class="status-badge <%= aBadge %>"><%= aStatus %></span></td>
                            </tr>
                            <% 
                                }
                                if(!hasApps) { 
                                    out.println("<tr><td colspan='3' style='text-align:center; padding:30px; color:#aaa;'>No active adoption applications.</td></tr>"); 
                                }
                            %>
                        </tbody>
                    </table>
                </div>
            </div>

            <%
                } catch (Exception e) {
                    out.println("<p style='color:red'>Error loading data: " + e.getMessage() + "</p>");
                } finally {
                    if(rs != null) try { rs.close(); } catch(Exception e){}
                    if(ps != null) try { ps.close(); } catch(Exception e){}
                    if(con != null) try { con.close(); } catch(Exception e){}
                }
            %>

        </div>
    </div>

</body>
</html>