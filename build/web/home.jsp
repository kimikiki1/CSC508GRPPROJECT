<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="com.petie.bean.UserBean"%>
<%@page import="com.petie.util.DBConnection"%>
<%@page import="java.sql.*"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<%
    // 1. Security Check
    UserBean user = (UserBean) session.getAttribute("userSession");
    if (user == null) { 
        response.sendRedirect("login.jsp"); 
        return; 
    }
    
    // Set attributes for JSTL
    pageContext.setAttribute("user", user);
    pageContext.setAttribute("userRole", user.getRole());
    pageContext.setAttribute("userName", user.getFullName());

    // 2. FETCH LIVE STATS FROM DATABASE
    int countAvailable = 0;
    int countAdopted = 0;
    int countReports = 0;

    Connection con = null;
    try {
        con = DBConnection.createConnection();

        // A. Count Available Pets (Status = 'IN_CENTRE')
        String sql1 = "SELECT COUNT(*) FROM STRAY_REPORT WHERE STATUS = 'IN_CENTRE'";
        PreparedStatement ps1 = con.prepareStatement(sql1);
        ResultSet rs1 = ps1.executeQuery();
        if(rs1.next()) countAvailable = rs1.getInt(1);

        // B. Count Adopted Pets (Status = 'ADOPTED')
        String sql2 = "SELECT COUNT(*) FROM STRAY_REPORT WHERE STATUS = 'ADOPTED'";
        PreparedStatement ps2 = con.prepareStatement(sql2);
        ResultSet rs2 = ps2.executeQuery();
        if(rs2.next()) countAdopted = rs2.getInt(1);

        // C. Count Total Reports Submitted (All Statuses)
        String sql3 = "SELECT COUNT(*) FROM STRAY_REPORT";
        PreparedStatement ps3 = con.prepareStatement(sql3);
        ResultSet rs3 = ps3.executeQuery();
        if(rs3.next()) countReports = rs3.getInt(1);

    } catch(Exception e) {
        e.printStackTrace();
    } finally {
        if(con != null) try { con.close(); } catch(Exception e) {}
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard - Petie Adoptie</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        /* --- THEME VARIABLES --- */
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

        /* --- LAYOUT --- */
        .main-content {
            margin-left: 280px;
            transition: margin-left 0.3s ease;
            padding: 30px;
            min-height: 100vh;
        }
        
        .dashboard-container { max-width: 1200px; margin: 0 auto; }

        /* --- WELCOME BANNER --- */
        .welcome-banner {
            background: linear-gradient(135deg, #8E44AD 0%, #3498DB 100%);
            color: white;
            border-radius: var(--border-radius);
            padding: 30px;
            margin-bottom: 40px;
            box-shadow: var(--box-shadow-lg);
            display: flex;
            align-items: center;
            justify-content: space-between;
            position: relative;
            overflow: hidden;
        }
        
        .welcome-banner::before {
            content: ""; position: absolute; top: -50%; right: -50%; width: 300%; height: 200%;
            background: radial-gradient(circle, rgba(255,255,255,0.1) 1px, transparent 1px);
            background-size: 20px 20px; opacity: 0.2;
        }
        
        .welcome-text h1 { margin: 0; font-size: 1.8rem; position: relative; z-index: 1; }
        .welcome-text p { margin: 5px 0 0; opacity: 0.9; position: relative; z-index: 1; }
        
        /* --- STATS CARDS --- */
        .stats-container {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 25px;
            margin-bottom: 40px;
        }
        
        .stat-card {
            background: white;
            border-radius: var(--border-radius);
            padding: 25px;
            box-shadow: var(--box-shadow);
            text-align: center;
            border-top: 4px solid #ddd;
            transition: transform 0.2s;
        }
        .stat-card:hover { transform: translateY(-5px); }
        
        .stat-icon { font-size: 30px; margin-bottom: 10px; display: inline-block; padding: 15px; border-radius: 50%; }
        .stat-number { font-size: 32px; font-weight: 700; color: var(--pet-dark); margin: 5px 0; }
        .stat-label { color: var(--pet-gray); font-size: 14px; text-transform: uppercase; letter-spacing: 1px; }

        /* Colors */
        .sc-orange { border-color: var(--pet-secondary); }
        .sc-orange .stat-icon { background: rgba(243, 156, 18, 0.1); color: var(--pet-secondary); }
        
        .sc-green { border-color: var(--pet-success); }
        .sc-green .stat-icon { background: rgba(46, 204, 113, 0.1); color: var(--pet-success); }
        
        .sc-purple { border-color: var(--pet-purple); }
        .sc-purple .stat-icon { background: rgba(155, 89, 182, 0.1); color: var(--pet-purple); }

        /* --- FEATURES GRID (NAVIGATION LINKS) --- */
        .features-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
            gap: 25px;
            margin-bottom: 40px;
        }
        
        .feature-card {
            background: white;
            border-radius: var(--border-radius);
            padding: 30px;
            box-shadow: var(--box-shadow);
            display: flex; flex-direction: column; align-items: center; text-align: center;
            border-top: 4px solid #eee;
            transition: all 0.3s;
        }
        .feature-card:hover { transform: translateY(-5px); box-shadow: var(--box-shadow-lg); }
        
        .fc-icon { font-size: 40px; margin-bottom: 20px; }
        .fc-title { font-size: 1.2rem; color: var(--pet-dark); margin-bottom: 10px; font-weight: 600; }
        .fc-desc { color: #777; font-size: 0.9rem; margin-bottom: 20px; flex-grow: 1; }
        
        .btn-card {
            padding: 10px 20px; border-radius: 20px; text-decoration: none;
            color: white; font-weight: 600; font-size: 0.9rem; display: inline-block;
        }

        /* Specific Card Styles */
        .fc-report { border-color: var(--pet-danger); }
        .fc-report .fc-icon { color: var(--pet-danger); }
        .btn-report { background: var(--pet-danger); }

        .fc-adopt { border-color: var(--pet-success); }
        .fc-adopt .fc-icon { color: var(--pet-success); }
        .btn-adopt { background: var(--pet-success); }

        .fc-admin { border-color: var(--pet-dark); }
        .fc-admin .fc-icon { color: var(--pet-dark); }
        .btn-admin { background: var(--pet-dark); }

        .fc-staff { border-color: var(--pet-warm); }
        .fc-staff .fc-icon { color: var(--pet-warm); }
        .btn-staff { background: var(--pet-warm); }
        
        .fc-blue { border-color: var(--pet-primary); }
        .fc-blue .fc-icon { color: var(--pet-primary); }
        .btn-blue { background: var(--pet-primary); }

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
            
            <div class="welcome-banner">
                <div class="welcome-text">
                    <h1>Welcome, ${userName}!</h1>
                    <p>
                        <i class="far fa-calendar-alt"></i> 
                        <jsp:useBean id="now" class="java.util.Date" />
                        <fmt:formatDate value="${now}" pattern="EEEE, MMMM dd, yyyy" />
                    </p>
                </div>
                <div>
                    <a href="account_settings.jsp" style="color: white; text-decoration: none; border: 1px solid white; padding: 8px 15px; border-radius: 5px; font-size: 0.9rem;">
                        <i class="fas fa-cog"></i> Settings
                    </a>
                </div>
            </div>
            
            <div class="stats-container">
                <div class="stat-card sc-orange">
                    <div class="stat-icon"><i class="fas fa-paw"></i></div>
                    <div class="stat-number"><%= countAvailable %></div>
                    <div class="stat-label">Available Pets</div>
                </div>
                
                <div class="stat-card sc-green">
                    <div class="stat-icon"><i class="fas fa-home"></i></div>
                    <div class="stat-number"><%= countAdopted %></div>
                    <div class="stat-label">Total Adoptions</div>
                </div>
                
                <div class="stat-card sc-purple">
                    <div class="stat-icon"><i class="fas fa-file-alt"></i></div>
                    <div class="stat-number"><%= countReports %></div>
                    <div class="stat-label">Reports Submitted</div>
                </div>
            </div>
            
            <h3 style="color: var(--pet-dark); margin-bottom: 20px;">Quick Actions</h3>

            <div class="features-grid">

                <c:if test="${userRole == 'ADMIN'}">
                    <div class="feature-card fc-admin">
                        <i class="fas fa-users-cog fc-icon"></i>
                        <div class="fc-title">Manage Users</div>
                        <div class="fc-desc">View, edit, or remove user accounts and staff members.</div>
                        <a href="manage_users.jsp" class="btn-card btn-admin">Go to Users</a>
                    </div>

                    <div class="feature-card fc-staff">
                        <i class="fas fa-clipboard-check fc-icon"></i>
                        <div class="fc-title">Process Reports</div>
                        <div class="fc-desc">Review stray reports and finalize decisions (Centre/Foster).</div>
                        <a href="admin_checklist.jsp" class="btn-card btn-staff">View Checklist</a>
                    </div>
                </c:if>

                <c:if test="${userRole == 'STAFF'}">
                    <div class="feature-card fc-staff">
                        <i class="fas fa-clipboard-list fc-icon"></i>
                        <div class="fc-title">Process Reports</div>
                        <div class="fc-desc">Verify new stray reports and propose actions to Admin.</div>
                        <a href="admin_checklist.jsp" class="btn-card btn-staff">Start Processing</a>
                    </div>

                    <div class="feature-card fc-green">
                        <i class="fas fa-heart fc-icon" style="color:var(--pet-success)"></i>
                        <div class="fc-title">Manage Adoptions</div>
                        <div class="fc-desc">Review adoption applications and approve pet matches.</div>
                        <a href="manage_adoptions.jsp" class="btn-card btn-adopt">View Requests</a>
                    </div>
                </c:if>

                <c:if test="${userRole == 'USER'}">
                    <div class="feature-card fc-adopt">
                        <i class="fas fa-paw fc-icon"></i>
                        <div class="fc-title">Adopt a Pet</div>
                        <div class="fc-desc">Browse our gallery of pets looking for a forever home.</div>
                        <a href="adopt_me.jsp" class="btn-card btn-adopt">Browse Pets</a>
                    </div>

                    <div class="feature-card fc-report">
                        <i class="fas fa-exclamation-triangle fc-icon"></i>
                        <div class="fc-title">Report a Stray</div>
                        <div class="fc-desc">Found an animal in need? Let us know the location and details.</div>
                        <a href="report_stray.jsp" class="btn-card btn-report">Submit Report</a>
                    </div>

                    <div class="feature-card fc-blue">
                        <i class="fas fa-file-invoice fc-icon"></i>
                        <div class="fc-title">My Activity</div>
                        <div class="fc-desc">Check status of your stray reports and adoption applications.</div>
                        <a href="my_reports.jsp" class="btn-card btn-blue">View Activity</a>
                    </div>
                </c:if>

                <div class="feature-card fc-purple" style="border-color: var(--pet-purple);">
                    <i class="fas fa-user-circle fc-icon" style="color: var(--pet-purple);"></i>
                    <div class="fc-title">My Profile</div>
                    <div class="fc-desc">Update your personal details and account settings.</div>
                    <a href="account_settings.jsp" class="btn-card" style="background: var(--pet-purple);">Manage Profile</a>
                </div>

            </div>
            
        </div>
    </div>

</body>
</html>