<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="com.petie.bean.UserBean"%>
<%@page import="com.petie.util.DBConnection"%>
<%@page import="java.sql.*"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<%
    // 1. Security Check
    UserBean user = (UserBean) session.getAttribute("userSession");
    if (user == null || !user.getRole().equals("ADMIN")) { 
        response.sendRedirect("login.jsp"); 
        return; 
    }
    
    // Set attributes for display
    pageContext.setAttribute("userName", user.getFullName());
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Users - Petie Adoptie</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <style>
        /* --- 1. THEME VARIABLES (Copied from Dashboard) --- */
        :root {
            --pet-primary: #4a90e2;       
            --pet-secondary: #f39c12;    
            --pet-success: #2ecc71;      
            --pet-danger: #e74c3c;       
            --pet-purple: #9b59b6;       
            --pet-teal: #1abc9c;         
            --pet-warm: #e67e22;         
            --pet-light: #f8f9fa;        
            --pet-dark: #34495e;         
            --pet-gray: #95a5a6;         
            --border-radius: 12px;
            --box-shadow: 0 4px 6px rgba(0,0,0,0.05);
            --box-shadow-lg: 0 10px 15px rgba(0,0,0,0.1);
        }

        body { font-family: 'Segoe UI', sans-serif; background-color: #f4f6f9; margin: 0; }

        /* --- 2. LAYOUT WRAPPER (This fixes the sidebar overlap) --- */
        .main-content {
            margin-left: 280px; /* Matches Sidebar Width */
            padding: 30px;
            transition: margin-left 0.3s ease;
            min-height: 100vh;
        }

        .dashboard-container { max-width: 1400px; margin: 0 auto; }

        /* --- 3. PAGE BANNER (Matches Dashboard Welcome Banner) --- */
        .page-banner {
            background: linear-gradient(135deg, #8E44AD 0%, #3498DB 100%);
            color: white;
            border-radius: var(--border-radius);
            padding: 30px;
            margin-bottom: 30px;
            box-shadow: var(--box-shadow-lg);
            display: flex;
            align-items: center;
            justify-content: space-between;
            position: relative;
            overflow: hidden;
        }
        
        /* Subtle background animation effect */
        .page-banner::before {
            content: ""; position: absolute; top: -50%; right: -50%; width: 300%; height: 200%;
            background: radial-gradient(circle, rgba(255,255,255,0.1) 1px, transparent 1px);
            background-size: 20px 20px; opacity: 0.2;
        }

        .banner-text h1 { margin: 0; font-size: 1.8rem; position: relative; z-index: 1; }
        .banner-text p { margin: 5px 0 0; opacity: 0.9; position: relative; z-index: 1; }

        /* --- 4. DATA TABLE CARD --- */
        .table-card {
            background: white;
            border-radius: var(--border-radius);
            padding: 25px;
            box-shadow: var(--box-shadow);
            border-top: 4px solid var(--pet-primary);
        }

        .table-responsive { overflow-x: auto; }

        table { width: 100%; border-collapse: collapse; margin-top: 10px; }
        
        th { 
            text-align: left; padding: 15px; 
            background-color: #f8f9fa; color: var(--pet-dark);
            font-weight: 700; border-bottom: 2px solid #eee;
            text-transform: uppercase; font-size: 0.85rem; letter-spacing: 0.5px;
        }
        
        td { 
            padding: 15px; border-bottom: 1px solid #eee; 
            vertical-align: middle; color: #555; font-size: 0.95rem;
        }
        
        tr:hover { background-color: #fbfbfb; }

        /* --- 5. BADGES & BUTTONS --- */
        .role-badge {
            padding: 5px 12px; border-radius: 20px; 
            font-size: 11px; font-weight: 700; text-transform: uppercase; letter-spacing: 0.5px;
        }
        .badge-admin { background: rgba(44, 62, 80, 0.1); color: var(--pet-dark); }
        .badge-staff { background: rgba(230, 126, 34, 0.1); color: var(--pet-warm); }
        .badge-user  { background: rgba(46, 204, 113, 0.1); color: var(--pet-success); }

        .btn-action {
            padding: 8px 12px; border-radius: 6px; text-decoration: none;
            font-size: 13px; font-weight: 600; display: inline-flex; align-items: center; gap: 5px;
            margin-right: 5px; transition: transform 0.2s, box-shadow 0.2s; border: none; cursor: pointer;
            color: white;
        }
        
        .btn-edit { background: linear-gradient(135deg, var(--pet-secondary) 0%, #e67e22 100%); }
        .btn-delete { background: linear-gradient(135deg, var(--pet-danger) 0%, #c0392b 100%); }
        
        .btn-action:hover { transform: translateY(-2px); box-shadow: 0 4px 8px rgba(0,0,0,0.15); opacity: 0.95; }

        /* Mobile Responsive */
        @media (max-width: 992px) {
            .main-content { margin-left: 0; }
        }
    </style>
</head>
<body>

    <jsp:include page="navbar.jsp" />

    <div class="main-content">
        <div class="dashboard-container">
            
            <div class="page-banner">
                <div class="banner-text">
                    <h1>User Management</h1>
                    <p>View, edit, or remove registered accounts.</p>
                </div>
                <div style="font-size: 40px; opacity: 0.3;">
                    <i class="fas fa-users-cog"></i>
                </div>
            </div>

            <div class="table-card">
                <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px;">
                    <h3 style="margin: 0; color: var(--pet-dark);">Registered Accounts</h3>
                    <span style="font-size: 13px; color: var(--pet-gray);">
                        <i class="fas fa-database"></i> Live Data
                    </span>
                </div>

                <%
                    Connection conn = null;
                    try {
                        conn = DBConnection.createConnection();
                        String sql = "SELECT * FROM USERS ORDER BY USER_ID ASC";
                        PreparedStatement ps = conn.prepareStatement(sql);
                        ResultSet rs = ps.executeQuery();
                %>

                <div class="table-responsive">
                    <table>
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>User Profile</th>
                                <th>Contact Info</th>
                                <th>Role</th>
                                <th style="text-align:center;">Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% while(rs.next()) { 
                                String r = rs.getString("ROLE");
                                String badgeClass = "badge-user"; // Default
                                if("ADMIN".equals(r)) badgeClass = "badge-admin";
                                if("STAFF".equals(r)) badgeClass = "badge-staff";
                            %>
                            <tr>
                                <td style="color: var(--pet-gray);">#<%= rs.getInt("USER_ID") %></td>
                                
                                <td>
                                    <div style="display:flex; align-items:center;">
                                        <div style="width:35px; height:35px; background: #f0f2f5; border-radius:50%; display:flex; align-items:center; justify-content:center; margin-right:12px; color: var(--pet-primary);">
                                            <i class="fas fa-user"></i>
                                        </div>
                                        <div>
                                            <div style="font-weight: 600; color: var(--pet-dark);"><%= rs.getString("FULL_NAME") %></div>
                                            <div style="font-size: 12px; color: var(--pet-gray);">@<%= rs.getString("USERNAME") %></div>
                                        </div>
                                    </div>
                                </td>
                                
                                <td>
                                    <div style="font-size: 13px;">
                                        <i class="fas fa-envelope" style="color: var(--pet-gray); width: 20px;"></i> <%= rs.getString("EMAIL") %><br>
                                        <i class="fas fa-phone" style="color: var(--pet-gray); width: 20px;"></i> <%= rs.getString("PHONE_NUMBER") %>
                                    </div>
                                </td>
                                
                                <td><span class="role-badge <%= badgeClass %>"><%= r %></span></td>
                                
                                <td style="text-align:center;">
                                    <a href="edit_user.jsp?id=<%= rs.getInt("USER_ID") %>" class="btn-action btn-edit">
                                        <i class="fas fa-pen"></i> Edit
                                    </a>
                                    
                                    <a href="DeleteUserServlet?id=<%= rs.getInt("USER_ID") %>" 
                                       class="btn-action btn-delete"
                                       onclick="return confirm('Are you sure you want to delete user: <%= rs.getString("USERNAME") %>?');">
                                       <i class="fas fa-trash"></i> Delete
                                    </a>
                                </td>
                            </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>

                <%
                    conn.close();
                    } catch (Exception e) {
                        out.println("<p style='color:var(--pet-danger); padding: 20px;'>Error loading data: " + e.getMessage() + "</p>");
                    }
                %>
            </div>

        </div>
    </div>

</body>
</html>