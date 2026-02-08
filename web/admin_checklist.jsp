<%@page import="java.sql.*"%>
<%@page import="com.petie.util.DBConnection"%>
<%@page import="com.petie.bean.UserBean"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    // 1. SECURITY CHECK
    UserBean currentUser = (UserBean) session.getAttribute("userSession");
    if (currentUser == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    String role = currentUser.getRole();
    String sql = "";
    String pageTitle = "";
    String pageDesc = "";

    // 2. WORKFLOW LOGIC
    if ("STAFF".equals(role)) {
        sql = "SELECT S.STRAY_ID, S.PET_TYPE, S.LOCATION_FOUND, S.DATE_FOUND, S.SITUATION, S.PET_PHOTO, S.STATUS, U.FULL_NAME " +
              "FROM STRAY_REPORT S JOIN USERS U ON S.USER_ID = U.USER_ID " +
              "WHERE S.STATUS = 'PENDING' ORDER BY S.STRAY_ID DESC";
        pageTitle = "Verify New Reports";
        pageDesc = "Review incoming stray reports and propose actions.";
    } else if ("ADMIN".equals(role)) {
        sql = "SELECT S.STRAY_ID, S.PET_TYPE, S.LOCATION_FOUND, S.DATE_FOUND, S.SITUATION, S.PET_PHOTO, S.STATUS, U.FULL_NAME " +
              "FROM STRAY_REPORT S JOIN USERS U ON S.USER_ID = U.USER_ID " +
              "WHERE S.STATUS LIKE 'WAITING_%' ORDER BY S.STRAY_ID DESC";
        pageTitle = "Finalize Proposals";
        pageDesc = "Approve or reject proposals submitted by staff.";
    } else {
        response.sendRedirect("home.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Process Reports - Petie Adoptie</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <style>
        /* --- 1. THEME VARIABLES (Matches Dashboard) --- */
        :root {
            --pet-primary: #4a90e2;       
            --pet-secondary: #f39c12;    
            --pet-success: #2ecc71;      
            --pet-danger: #e74c3c;       
            --pet-purple: #9b59b6;
            --pet-teal: #1abc9c;
            --pet-dark: #34495e;         
            --pet-gray: #95a5a6;         
            --border-radius: 12px;
            --box-shadow: 0 4px 6px rgba(0,0,0,0.05);
            --box-shadow-lg: 0 10px 15px rgba(0,0,0,0.1);
        }

        body { font-family: 'Segoe UI', sans-serif; background-color: #f4f6f9; margin: 0; }

        /* --- 2. MAIN LAYOUT WRAPPER --- */
        .main-content {
            margin-left: 280px; /* Matches Sidebar Width */
            padding: 30px;
            transition: margin-left 0.3s ease;
            min-height: 100vh;
        }

        .dashboard-container { max-width: 1400px; margin: 0 auto; }

        /* --- 3. PAGE HEADER (Banner Style) --- */
        .page-header {
            background: linear-gradient(135deg, var(--pet-teal) 0%, #16a085 100%);
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

        .header-text h1 { margin: 0; font-size: 1.8rem; position: relative; z-index: 1; }
        .header-text p { margin: 5px 0 0; opacity: 0.9; position: relative; z-index: 1; }

        /* --- 4. TABLE CARD --- */
        .table-card {
            background: white;
            border-radius: var(--border-radius);
            padding: 25px;
            box-shadow: var(--box-shadow);
            border-top: 4px solid var(--pet-teal);
        }

        .table-responsive { overflow-x: auto; }

        table { width: 100%; border-collapse: collapse; margin-top: 10px; }
        
        th { 
            text-align: left; padding: 15px; 
            background-color: #f8f9fa; color: var(--pet-dark);
            font-weight: 700; border-bottom: 2px solid #eee;
            font-size: 0.9rem; text-transform: uppercase; letter-spacing: 0.5px;
        }
        
        td { 
            padding: 15px; border-bottom: 1px solid #eee; 
            vertical-align: middle; color: #555; font-size: 0.95rem;
        }
        
        tr:hover { background-color: #fbfbfb; }

        /* Thumbnail */
        .pet-thumb {
            width: 60px; height: 60px; object-fit: cover; 
            border-radius: 8px; border: 1px solid #eee;
            transition: transform 0.2s;
        }
        .pet-thumb:hover { transform: scale(1.5); border-color: var(--pet-teal); z-index: 5; position: relative; }

        /* Status Badge */
        .status-badge {
            padding: 5px 10px; border-radius: 20px; font-size: 11px; font-weight: 700; text-transform: uppercase;
        }
        .badge-pending { background: #fff3cd; color: #856404; }
        .badge-waiting { background: #d1ecf1; color: #0c5460; }

        /* Buttons */
        .btn-action {
            padding: 8px 12px; border-radius: 6px; text-decoration: none;
            font-size: 12px; font-weight: 600; display: inline-flex; align-items: center; gap: 5px;
            margin-right: 5px; margin-bottom: 5px; border: none; cursor: pointer; color: white;
            transition: transform 0.2s;
        }
        
        .btn-blue { background: #3498db; }
        .btn-cyan { background: #17a2b8; }
        .btn-green { background: #2ecc71; }
        .btn-red { background: #e74c3c; }
        
        .btn-action:hover { transform: translateY(-2px); box-shadow: 0 4px 8px rgba(0,0,0,0.15); opacity: 0.95; }

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
                <div class="header-text">
                    <h1><%= pageTitle %></h1>
                    <p><%= pageDesc %></p>
                </div>
                <div style="font-size: 40px; opacity: 0.3;">
                    <i class="fas fa-clipboard-check"></i>
                </div>
            </div>

            <div class="table-card">
                <div style="margin-bottom: 20px; display: flex; justify-content: space-between; align-items: center;">
                    <h3 style="margin: 0; color: var(--pet-dark);">Pending Tasks</h3>
                    <span style="font-size: 13px; color: var(--pet-gray);"><i class="fas fa-sync"></i> Live Data</span>
                </div>

                <div class="table-responsive">
                    <table>
                        <thead>
                            <tr>
                                <th>Photo</th>
                                <th>Pet Info</th>
                                <th>Location & Situation</th>
                                <th>Reporter</th>
                                <th>Status</th>
                                <th style="width: 280px;">Actions</th>
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
                                        String badgeClass = "badge-pending";
                                        if(status.startsWith("WAITING")) badgeClass = "badge-waiting";
                            %>
                            <tr>
                                <td>
                                    <img src="ImageServlet/<%= rs.getString("PET_PHOTO") %>" 
                                         class="pet-thumb" 
                                         onerror="this.src='https://via.placeholder.com/60?text=No+Img'">
                                </td>
                                
                                <td>
                                    <div style="font-weight: 700; color: var(--pet-dark); font-size: 1.1em;">
                                        <%= rs.getString("PET_TYPE") %>
                                    </div>
                                    <div style="color: var(--pet-gray); font-size: 0.85em;">ID: #<%= id %></div>
                                </td>

                                <td>
                                    <div style="max-width: 250px;">
                                        <div style="font-size: 0.9em; margin-bottom: 4px;">
                                            <i class="fas fa-map-marker-alt" style="color:var(--pet-danger);"></i> 
                                            <%= rs.getString("LOCATION_FOUND") %>
                                        </div>
                                        <div style="font-size: 0.85em; color: #777; white-space: nowrap; overflow: hidden; text-overflow: ellipsis;">
                                            <%= rs.getString("SITUATION") %>
                                        </div>
                                    </div>
                                </td>

                                <td>
                                    <div style="display: flex; align-items: center; gap: 8px;">
                                        <div style="width: 25px; height: 25px; background: #eee; border-radius: 50%; display: flex; align-items: center; justify-content: center; color: #999;">
                                            <i class="fas fa-user"></i>
                                        </div>
                                        <span style="font-size: 0.9em;"><%= rs.getString("FULL_NAME") %></span>
                                    </div>
                                </td>

                                <td><span class="status-badge <%= badgeClass %>"><%= status %></span></td>

                                <td>
                                    <% if ("STAFF".equals(role)) { %>
                                        <a href="ProcessReportServlet?id=<%= id %>&action=propose_centre" class="btn-action btn-blue">
                                            <i class="fas fa-clinic-medical"></i> Propose Centre
                                        </a>
                                        <a href="ProcessReportServlet?id=<%= id %>&action=propose_foster" class="btn-action btn-cyan">
                                            <i class="fas fa-home"></i> Propose Foster
                                        </a>
                                        <a href="ProcessReportServlet?id=<%= id %>&action=reject" class="btn-action btn-red" onclick="return confirm('Reject this report?');">
                                            <i class="fas fa-times"></i> Reject
                                        </a>
                                    
                                    <% } else if ("ADMIN".equals(role)) { %>
                                        <% if(status.equals("WAITING_ADMIN_CENTRE")) { %>
                                            <div style="font-size: 11px; color: var(--pet-primary); margin-bottom: 5px;">
                                                <i class="fas fa-info-circle"></i> Staff proposed: Centre
                                            </div>
                                            <a href="ProcessReportServlet?id=<%= id %>&action=confirm_centre" class="btn-action btn-green">
                                                <i class="fas fa-check"></i> Approve
                                            </a>
                                        <% } else if(status.equals("WAITING_ADMIN_FOSTER")) { %>
                                            <div style="font-size: 11px; color: var(--pet-teal); margin-bottom: 5px;">
                                                <i class="fas fa-info-circle"></i> Staff proposed: Foster
                                            </div>
                                            <a href="ProcessReportServlet?id=<%= id %>&action=confirm_foster" class="btn-action btn-green">
                                                <i class="fas fa-check"></i> Approve
                                            </a>
                                        <% } %>

                                        <a href="ProcessReportServlet?id=<%= id %>&action=reject" class="btn-action btn-red" onclick="return confirm('Override and reject?');">
                                            <i class="fas fa-times"></i> Reject
                                        </a>
                                    <% } %>
                                </td>
                            </tr>
                            <% 
                                    } 
                                    if(!hasData) { 
                            %>
                            <tr>
                                <td colspan="6" style="text-align:center; padding: 50px; color: var(--pet-gray);">
                                    <div style="font-size: 40px; margin-bottom: 10px; opacity: 0.3;"><i class="fas fa-check-circle"></i></div>
                                    <p>All caught up! No pending reports found.</p>
                                </td>
                            </tr>
                            <% 
                                    }
                                } catch(Exception e) {
                                    e.printStackTrace();
                                    out.println("<tr><td colspan='6' style='color:red; padding:20px;'>Error: " + e.getMessage() + "</td></tr>");
                                } finally {
                                    if(con != null) try { con.close(); } catch(Exception e){}
                                }
                            %>
                        </tbody>
                    </table>
                </div>
            </div>

        </div>
    </div>

</body>
</html>