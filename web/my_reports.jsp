<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="com.petie.bean.UserBean"%>
<%@page import="com.petie.util.DBConnection"%>
<%@page import="java.sql.*"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<%
    // ============================================
    // SECURITY CHECK & USER AUTHENTICATION
    // ============================================
    UserBean user = (UserBean) session.getAttribute("userSession");
    if (user == null) { 
        response.sendRedirect("login.jsp"); 
        return; 
    }
    
    // ============================================
    // PAGINATION PARAMETERS
    // ============================================
    int currentPage = 1;
    int recordsPerPage = 5; // Limit to 5 records per page
    int totalPages = 0;
    int totalRecords = 0;
    
    // Get current page from request parameter
    String pageParam = request.getParameter("page");
    if (pageParam != null && !pageParam.isEmpty()) {
        try {
            currentPage = Integer.parseInt(pageParam);
        } catch (NumberFormatException e) {
            currentPage = 1; // Default to page 1 if invalid
        }
    }
    
    // Calculate offset for SQL query
    int offset = (currentPage - 1) * recordsPerPage;
    
    // ============================================
    // DATABASE CONNECTION & VARIABLES
    // ============================================
    Connection con = null;
    PreparedStatement ps = null;
    ResultSet rs = null;
    
    // Store user info for JSTL
    pageContext.setAttribute("user", user);
    pageContext.setAttribute("currentPage", currentPage);
    pageContext.setAttribute("recordsPerPage", recordsPerPage);
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Reports & Applications - Petie Adoption System</title>
    <link rel="stylesheet" href="style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        /* All CSS remains exactly the same as before */
        /* ... (Your complete CSS from earlier) ... */
        
        /* Keep all your CSS styles - they are already perfect */
        
        /* ============================================
           CSS RESET & BASE STYLES
           ============================================ */
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body { 
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; 
            background-color: #f5f7fa; 
            color: #333;
        }
        
        /* ============================================
           MAIN CONTENT AREA - MATCHES report_stray.jsp
           ============================================ */
        .main-content {
            margin-left: 280px;
            transition: margin-left 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            padding: 20px;
            min-height: 100vh;
            width: calc(100% - 280px);
            box-sizing: border-box;
        }
        
        .sidebar-container.collapsed ~ .main-content {
            margin-left: 70px;
            width: calc(100% - 70px);
        }
        
        @media (max-width: 992px) {
            .main-content {
                margin-left: 0 !important;
                width: 100% !important;
                padding: 15px !important;
            }
        }
        
        /* ============================================
           PAGE CONTAINER
           ============================================ */
        .reports-container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 0;
        }
        
        /* ============================================
           PAGE HEADER - MATCHES report_stray.jsp
           ============================================ */
        .page-header {
            background: linear-gradient(135deg, #4a90e2 0%, #2c3e50 100%);
            color: white;
            border-radius: 12px;
            padding: 30px;
            margin-bottom: 30px;
            box-shadow: 0 10px 20px rgba(0, 0, 0, 0.15);
        }
        
        .page-header h1 {
            margin: 0;
            display: flex;
            align-items: center;
            gap: 15px;
            font-size: 28px;
        }
        
        .page-subtitle {
            color: rgba(255, 255, 255, 0.9);
            margin: 10px 0 0 0;
            font-size: 16px;
        }
        
        /* ============================================
           STATS CARDS GRID
           ============================================ */
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
            margin-bottom: 40px;
        }
        
        .stat-card {
            background: white;
            border-radius: 12px;
            padding: 25px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            transition: all 0.3s ease;
            border-top: 4px solid;
            text-align: center;
        }
        
        .stat-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 20px rgba(0, 0, 0, 0.15);
        }
        
        .stat-card:nth-child(1) { border-top-color: #4a90e2; }
        .stat-card:nth-child(2) { border-top-color: #2ecc71; }
        .stat-card:nth-child(3) { border-top-color: #f39c12; }
        .stat-card:nth-child(4) { border-top-color: #9b59b6; }
        
        .stat-icon {
            font-size: 40px;
            margin-bottom: 15px;
            padding: 15px;
            border-radius: 50%;
            display: inline-block;
        }
        
        .stat-card:nth-child(1) .stat-icon { 
            background: rgba(74, 144, 226, 0.1); 
            color: #4a90e2; 
        }
        .stat-card:nth-child(2) .stat-icon { 
            background: rgba(46, 204, 113, 0.1); 
            color: #2ecc71; 
        }
        .stat-card:nth-child(3) .stat-icon { 
            background: rgba(243, 156, 18, 0.1); 
            color: #f39c12; 
        }
        .stat-card:nth-child(4) .stat-icon { 
            background: rgba(155, 89, 182, 0.1); 
            color: #9b59b6; 
        }
        
        .stat-number {
            font-size: 32px;
            font-weight: 700;
            color: #34495e;
            margin: 10px 0;
        }
        
        .stat-label {
            color: #95a5a6;
            font-size: 14px;
            text-transform: uppercase;
            letter-spacing: 1px;
        }
        
        /* ============================================
           FOSTER BOX - ENHANCED
           ============================================ */
        .foster-box {
            background: linear-gradient(135deg, #e8f5e9 0%, #c8e6c9 100%);
            border-radius: 12px;
            padding: 30px;
            margin-bottom: 40px;
            text-align: center;
            border-left: 5px solid #4caf50;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        }
        
        .foster-number {
            font-size: 60px;
            font-weight: 700;
            color: #2e7d32;
            margin: 15px 0;
            text-shadow: 2px 2px 4px rgba(0, 0, 0, 0.1);
        }
        
        /* ============================================
           SECTION HEADERS
           ============================================ */
        .section-header {
            margin: 40px 0 20px 0;
            padding-bottom: 15px;
            border-bottom: 2px solid #eee;
            display: flex;
            align-items: center;
            justify-content: space-between;
            flex-wrap: wrap;
            gap: 15px;
        }
        
        .section-header h2 {
            color: #34495e;
            margin: 0;
            font-size: 22px;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        /* ============================================
           TABLE CONTAINER - MODERN DESIGN
           ============================================ */
        .table-container {
            background: white;
            border-radius: 12px;
            padding: 25px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            margin-bottom: 40px;
            overflow-x: auto;
        }
        
        .modern-table {
            width: 100%;
            border-collapse: separate;
            border-spacing: 0;
            margin-top: 10px;
        }
        
        .modern-table thead {
            background: linear-gradient(135deg, #34495e 0%, #2c3e50 100%);
            color: white;
        }
        
        .modern-table th {
            padding: 15px;
            text-align: left;
            font-weight: 600;
            border: none;
        }
        
        .modern-table th:first-child {
            border-top-left-radius: 8px;
        }
        
        .modern-table th:last-child {
            border-top-right-radius: 8px;
        }
        
        .modern-table tbody tr {
            transition: background-color 0.3s ease;
            border-bottom: 1px solid #eee;
        }
        
        .modern-table tbody tr:hover {
            background-color: #f8f9fa;
        }
        
        .modern-table td {
            padding: 15px;
            border: none;
            border-bottom: 1px solid #eee;
            vertical-align: top;
        }
        
        /* ============================================
           STATUS BADGES - ENHANCED
           ============================================ */
        .status-badge {
            padding: 6px 15px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            display: inline-block;
        }
        
        .status-pending { 
            background: linear-gradient(135deg, rgba(243, 156, 18, 0.1) 0%, rgba(243, 156, 18, 0.2) 100%); 
            color: #f39c12; 
            border: 1px solid rgba(243, 156, 18, 0.3);
        }
        
        .status-centre { 
            background: linear-gradient(135deg, rgba(46, 204, 113, 0.1) 0%, rgba(46, 204, 113, 0.2) 100%); 
            color: #27ae60; 
            border: 1px solid rgba(46, 204, 113, 0.3);
        }
        
        .status-foster { 
            background: linear-gradient(135deg, rgba(52, 152, 219, 0.1) 0%, rgba(52, 152, 219, 0.2) 100%); 
            color: #2980b9; 
            border: 1px solid rgba(52, 152, 219, 0.3);
        }
        
        .status-rejected { 
            background: linear-gradient(135deg, rgba(231, 76, 60, 0.1) 0%, rgba(231, 76, 60, 0.2) 100%); 
            color: #c0392b; 
            border: 1px solid rgba(231, 76, 60, 0.3);
        }
        
        /* ============================================
           PAGINATION CONTROLS
           ============================================ */
        .pagination-container {
            display: flex;
            justify-content: center;
            align-items: center;
            margin-top: 30px;
            gap: 10px;
            flex-wrap: wrap;
        }
        
        .pagination-info {
            color: #95a5a6;
            font-size: 14px;
            margin-right: 15px;
        }
        
        .page-btn {
            padding: 8px 16px;
            border: 1px solid #ddd;
            background: white;
            color: #34495e;
            border-radius: 6px;
            cursor: pointer;
            transition: all 0.3s ease;
            font-weight: 500;
            text-decoration: none;
            display: inline-block;
        }
        
        .page-btn:hover:not(.disabled) {
            background: #4a90e2;
            color: white;
            border-color: #4a90e2;
        }
        
        .page-btn.disabled {
            opacity: 0.5;
            cursor: not-allowed;
        }
        
        .page-btn.active {
            background: #4a90e2;
            color: white;
            border-color: #4a90e2;
            font-weight: 600;
        }
        
        /* ============================================
           EMPTY STATE
           ============================================ */
        .empty-state {
            text-align: center;
            padding: 50px 20px;
            background: white;
            border-radius: 12px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            margin: 40px 0;
        }
        
        .empty-icon {
            font-size: 60px;
            color: #95a5a6;
            margin-bottom: 20px;
        }
        
        /* ============================================
           ACTION BUTTONS
           ============================================ */
        .action-buttons {
            display: flex;
            gap: 15px;
            margin-top: 30px;
            flex-wrap: wrap;
        }
        
        .btn-primary {
            background: linear-gradient(135deg, #4a90e2 0%, #357ae8 100%);
            color: white;
            border: none;
            padding: 12px 25px;
            border-radius: 8px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            display: inline-flex;
            align-items: center;
            gap: 10px;
            transition: all 0.3s ease;
            text-decoration: none;
        }
        
        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(74, 144, 226, 0.3);
        }
        
        .btn-danger {
            background: linear-gradient(135deg, #e74c3c 0%, #c0392b 100%);
            color: white;
            border: none;
            padding: 12px 25px;
            border-radius: 8px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            display: inline-flex;
            align-items: center;
            gap: 10px;
            transition: all 0.3s ease;
            text-decoration: none;
        }
        
        .btn-danger:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(231, 76, 60, 0.3);
        }
        
        /* ============================================
           RESPONSIVE DESIGN
           ============================================ */
        @media (max-width: 768px) {
            .stats-grid {
                grid-template-columns: repeat(2, 1fr);
            }
            
            .action-buttons {
                flex-direction: column;
            }
            
            .btn-primary, .btn-danger {
                width: 100%;
                justify-content: center;
            }
            
            .modern-table {
                font-size: 14px;
            }
            
            .modern-table th,
            .modern-table td {
                padding: 10px;
            }
            
            .section-header {
                flex-direction: column;
                align-items: flex-start;
            }
            
            .pagination-container {
                flex-direction: column;
                gap: 15px;
            }
        }
        
        @media (max-width: 480px) {
            .stats-grid {
                grid-template-columns: 1fr;
            }
        }
        
        /* ============================================
           UTILITY CLASSES
           ============================================ */
        .situation-preview {
            max-width: 250px;
            overflow: hidden;
            text-overflow: ellipsis;
            white-space: nowrap;
            color: #95a5a6;
            font-size: 14px;
        }
        
        .view-details {
            color: #4a90e2;
            text-decoration: none;
            font-size: 14px;
            font-weight: 500;
        }
        
        .view-details:hover {
            text-decoration: underline;
        }
        
        .photo-thumbnail {
            width: 80px;
            height: 80px;
            object-fit: cover;
            border-radius: 8px;
            border: 1px solid #eee;
        }
    </style>
</head>
<body>
    <!-- ============================================
         INCLUDE NAVIGATION SIDEBAR
         ============================================ -->
    <jsp:include page="navbar.jsp" />
    
    <!-- ============================================
         MAIN CONTENT AREA
         ============================================ -->
    <div class="main-content">
        <div class="reports-container">
            <!-- ============================================
                 PAGE HEADER
                 ============================================ -->
            <div class="page-header">
                <h1>
                    <i class="fas fa-clipboard-list"></i> My Reports & Applications
                </h1>
                <p class="page-subtitle">
                    Track all your stray animal reports and adoption applications
                </p>
            </div>
            
            <!-- ============================================
                 QUICK STATS SECTION
                 ============================================ -->
            <%
                try {
                    con = DBConnection.createConnection();
                    
                    // ============================================
                    // SOLUTION 1: GET TOTAL REPORTS COUNT FIRST
                    // ============================================
                    String countSql = "SELECT COUNT(*) AS total FROM STRAY_REPORT WHERE USER_ID = ?";
                    ps = con.prepareStatement(countSql);
                    ps.setInt(1, user.getUserId());
                    rs = ps.executeQuery();
                    
                    int totalReports = 0;
                    if (rs.next()) {
                        totalReports = rs.getInt("total");
                    }
                    totalRecords = totalReports;
                    
                    // Close the first result set
                    if (rs != null) rs.close();
                    if (ps != null) ps.close();
                    
                    // ============================================
                    // GET FOSTERED PETS COUNT
                    // ============================================
                    countSql = "SELECT COUNT(*) AS fosterCount FROM STRAY_REPORT WHERE USER_ID = ? AND STATUS = 'FOSTERED'";
                    ps = con.prepareStatement(countSql);
                    ps.setInt(1, user.getUserId());
                    rs = ps.executeQuery();
                    int fosterCount = rs.next() ? rs.getInt("fosterCount") : 0;
                    
                    if (rs != null) rs.close();
                    if (ps != null) ps.close();
                    
                    // ============================================
                    // GET PENDING REPORTS COUNT
                    // ============================================
                    countSql = "SELECT COUNT(*) AS pendingCount FROM STRAY_REPORT WHERE USER_ID = ? AND STATUS = 'PENDING'";
                    ps = con.prepareStatement(countSql);
                    ps.setInt(1, user.getUserId());
                    rs = ps.executeQuery();
                    int pendingCount = rs.next() ? rs.getInt("pendingCount") : 0;
                    
                    if (rs != null) rs.close();
                    if (ps != null) ps.close();
                    
                    // ============================================
                    // GET IN_CENTRE REPORTS COUNT
                    // ============================================
                    countSql = "SELECT COUNT(*) AS inCentreCount FROM STRAY_REPORT WHERE USER_ID = ? AND STATUS = 'IN_CENTRE'";
                    ps = con.prepareStatement(countSql);
                    ps.setInt(1, user.getUserId());
                    rs = ps.executeQuery();
                    int inCentreCount = rs.next() ? rs.getInt("inCentreCount") : 0;
                    
                    if (rs != null) rs.close();
                    if (ps != null) ps.close();
                    
                    // Calculate total pages for pagination
                    totalPages = (int) Math.ceil((double) totalRecords / recordsPerPage);
            %>
            
            <div class="stats-grid">
                <!-- STAT CARD 1: TOTAL REPORTS -->
                <div class="stat-card">
                    <div class="stat-icon">
                        <i class="fas fa-file-alt"></i>
                    </div>
                    <div class="stat-number"><%= totalReports %></div>
                    <div class="stat-label">Total Reports</div>
                </div>
                
                <!-- STAT CARD 2: FOSTERED PETS -->
                <div class="stat-card">
                    <div class="stat-icon">
                        <i class="fas fa-heart"></i>
                    </div>
                    <div class="stat-number"><%= fosterCount %></div>
                    <div class="stat-label">Fostered Pets</div>
                </div>
                
                <!-- STAT CARD 3: PENDING REPORTS -->
                <div class="stat-card">
                    <div class="stat-icon">
                        <i class="fas fa-clock"></i>
                    </div>
                    <div class="stat-number"><%= pendingCount %></div>
                    <div class="stat-label">Pending</div>
                </div>
                
                <!-- STAT CARD 4: IN CENTRE -->
                <div class="stat-card">
                    <div class="stat-icon">
                        <i class="fas fa-home"></i>
                    </div>
                    <div class="stat-number"><%= inCentreCount %></div>
                    <div class="stat-label">In Centre</div>
                </div>
            </div>
            
            <!-- ============================================
                 FOSTER ACHIEVEMENT BOX
                 ============================================ -->
            <div class="foster-box">
                <h2><i class="fas fa-home"></i> Foster Care Achievement</h2>
                <div class="foster-number"><%= fosterCount %></div>
                <div>Pets in Your Care ❤️</div>
                <p style="color: #555; font-size: 16px; margin-top: 10px;">
                    Thank you for providing a temporary home for animals in need!
                </p>
            </div>
            
            <!-- ============================================
                 ACTION BUTTONS
                 ============================================ -->
            <div class="action-buttons">
                <a href="report_stray.jsp" class="btn-danger">
                    <i class="fas fa-exclamation-triangle"></i> Report New Stray
                </a>
                <a href="adopt_me.jsp" class="btn-primary">
                    <i class="fas fa-paw"></i> Browse Pets for Adoption
                </a>
            </div>
            
            <!-- ============================================
                 MY REPORTS SECTION
                 ============================================ -->
            <div class="section-header">
                <div>
                    <h2>
                        <i class="fas fa-exclamation-circle"></i> My Stray Reports
                    </h2>
                </div>
                <div style="color: #95a5a6; font-size: 14px;">
                    <% if (totalPages > 0) { %>
                        Page <%= currentPage %> of <%= totalPages %> | Showing <%= recordsPerPage %> records per page
                    <% } else { %>
                        No reports found
                    <% } %>
                </div>
            </div>
            
            <%
                // ============================================
                // SOLUTION 2: TWO-QUERY APPROACH FOR PAGINATION
                // ============================================
                // First, get all reports into a List to handle pagination
                java.util.List<Object[]> reportList = new java.util.ArrayList<>();
                
                String sql = "SELECT STRAY_ID, PET_TYPE, LOCATION_FOUND, PET_PHOTO, DATE_FOUND, SITUATION, STATUS " +
                            "FROM STRAY_REPORT WHERE USER_ID = ? ORDER BY DATE_FOUND DESC";
                
                // Create a scrollable ResultSet
                ps = con.prepareStatement(sql, 
                    ResultSet.TYPE_SCROLL_INSENSITIVE, 
                    ResultSet.CONCUR_READ_ONLY);
                ps.setInt(1, user.getUserId());
                rs = ps.executeQuery();
                
                // Collect all records
                while (rs.next()) {
                    Object[] report = new Object[7];
                    report[0] = rs.getInt("STRAY_ID");
                    report[1] = rs.getString("PET_TYPE");
                    report[2] = rs.getString("LOCATION_FOUND");
                    report[3] = rs.getString("PET_PHOTO");
                    report[4] = rs.getDate("DATE_FOUND");
                    report[5] = rs.getString("SITUATION");
                    report[6] = rs.getString("STATUS");
                    reportList.add(report);
                }
                
                int totalReportCount = reportList.size();
                boolean hasRecords = totalReportCount > 0;
                
                if (hasRecords) {
                    // Calculate pagination bounds
                    int startIndex = offset;
                    int endIndex = Math.min(offset + recordsPerPage, totalReportCount);
                    int displayedCount = endIndex - startIndex;
            %>
            
            <!-- ============================================
                 REPORTS TABLE
                 ============================================ -->
            <div class="table-container">
                <table class="modern-table">
                    <thead>
                        <tr>
                            <th>Report ID</th>
                            <th>Pet Photo</th>
                            <th>Pet Type</th>
                            <th>Location Found</th>
                            <th>Date Found</th>
                            <th>Situation</th>
                            <th>Status</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            // ============================================
                            // LOOP THROUGH PAGINATED RESULTS FROM LIST
                            // ============================================
                            for (int i = startIndex; i < endIndex; i++) {
                                Object[] report = reportList.get(i);
                                
                                int strayId = (Integer) report[0];
                                String petType = (String) report[1];
                                String location = (String) report[2];
                                String petPhoto = (String) report[3];
                                Date dateFound = (Date) report[4];
                                String situation = (String) report[5];
                                String status = (String) report[6];
                                
                                // Handle null values
                                if (petType == null) petType = "Unknown";
                                if (location == null) location = "Not specified";
                                if (situation == null) situation = "No description provided";
                                if (status == null) status = "PENDING";
                                if (dateFound == null) dateFound = new Date(System.currentTimeMillis());
                                
                                // Determine status badge class
                                String statusClass = "status-pending";
                                if ("IN_CENTRE".equalsIgnoreCase(status)) {
                                    statusClass = "status-centre";
                                } else if ("FOSTERED".equalsIgnoreCase(status)) {
                                    statusClass = "status-foster";
                                } else if ("REJECTED".equalsIgnoreCase(status)) {
                                    statusClass = "status-rejected";
                                }
                                
                                // Determine pet icon
                                String petIcon = "fa-paw";
                                if (petType.equalsIgnoreCase("dog")) {
                                    petIcon = "fa-dog";
                                } else if (petType.equalsIgnoreCase("cat")) {
                                    petIcon = "fa-cat";
                                } else if (petType.equalsIgnoreCase("bird")) {
                                    petIcon = "fa-dove";
                                }
                                
                                // Truncate situation for preview
                                String situationPreview = situation;
                                if (situation.length() > 50) {
                                    situationPreview = situation.substring(0, 47) + "...";
                                }
                                
                                // Handle photo path
                                String photoPath = "images/" + petPhoto;
                                if (petPhoto == null || petPhoto.isEmpty() || "no-image.jpg".equals(petPhoto)) {
                                    photoPath = "images/default-pet.jpg";
                                }
                        %>
                        <tr>
                            <!-- Report ID -->
                            <td><strong>#<%= strayId %></strong></td>
                            
                            <!-- Pet Photo -->
                            <td>
                                <img src="<%= photoPath %>" 
                                     alt="<%= petType %>" 
                                     class="photo-thumbnail"
                                     <img src="<%= photoPath %>" 
                                    alt="<%= petType %>" 
                                    class="photo-thumbnail"
                                    onerror="this.onerror=null; this.src='images/default-pet.jpg';">
                            </td>
                            
                            <!-- Pet Type with Icon -->
                            <td>
                                <i class="fas <%= petIcon %>" style="color: #4a90e2; margin-right: 8px;"></i>
                                <%= petType %>
                            </td>
                            
                            <!-- Location Found -->
                            <td>
                                <i class="fas fa-map-marker-alt" style="color: #95a5a6; margin-right: 8px;"></i>
                                <%= location %>
                            </td>
                            
                            <!-- Date Found -->
                            <td>
                                <i class="far fa-calendar" style="color: #95a5a6; margin-right: 8px;"></i>
                                <%= dateFound %>
                            </td>
                            
                            <!-- Situation Preview -->
                            <td>
                                <div class="situation-preview" title="<%= situation %>">
                                    <i class="fas fa-info-circle" style="color: #95a5a6; margin-right: 5px;"></i>
                                    <%= situationPreview %>
                                </div>
                            </td>
                            
                            <!-- Status Badge -->
                            <td>
                                <span class="status-badge <%= statusClass %>">
                                    <i class="fas fa-circle" style="font-size: 8px; margin-right: 5px;"></i>
                                    <%= status %>
                                </span>
                            </td>
                            
                            <!-- Action Links -->
                            <td>
                                <a href="view_report.jsp?id=<%= strayId %>" class="view-details">
                                    <i class="fas fa-eye"></i> View Details
                                </a>
                            </td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
                
                <!-- ============================================
                     PAGINATION CONTROLS
                     ============================================ -->
                <% if (totalPages > 0) { %>
                <div class="pagination-container">
                    <!-- Pagination Info -->
                    <div class="pagination-info">
                        Showing <%= offset + 1 %> to 
                        <%= offset + displayedCount %> 
                        of <%= totalReportCount %> records
                    </div>
                    
                    <!-- Previous Button -->
                    <% if (currentPage > 1) { %>
                        <a href="my_reports.jsp?page=<%= currentPage - 1 %>" class="page-btn">
                            <i class="fas fa-chevron-left"></i> Previous
                        </a>
                    <% } else { %>
                        <span class="page-btn disabled">
                            <i class="fas fa-chevron-left"></i> Previous
                        </span>
                    <% } %>
                    
                    <!-- Page Numbers -->
                    <%
                        // Show up to 5 page numbers around current page
                        int startPage = Math.max(1, currentPage - 2);
                        int endPage = Math.min(totalPages, startPage + 4);
                        
                        // Adjust start if we're near the end
                        if (endPage - startPage < 4) {
                            startPage = Math.max(1, endPage - 4);
                        }
                        
                        for (int i = startPage; i <= endPage; i++) {
                            if (i == currentPage) {
                    %>
                        <span class="page-btn active"><%= i %></span>
                    <% } else { %>
                        <a href="my_reports.jsp?page=<%= i %>" class="page-btn"><%= i %></a>
                    <% }
                        }
                    %>
                    
                    <!-- Next Button -->
                    <% if (currentPage < totalPages) { %>
                        <a href="my_reports.jsp?page=<%= currentPage + 1 %>" class="page-btn">
                            Next <i class="fas fa-chevron-right"></i>
                        </a>
                    <% } else { %>
                        <span class="page-btn disabled">
                            Next <i class="fas fa-chevron-right"></i>
                        </span>
                    <% } %>
                    
                    <!-- Go to Page Form -->
                    <% if (totalPages > 1) { %>
                    <div style="display: flex; gap: 5px; align-items: center;">
                        <form method="GET" action="my_reports.jsp" style="display: flex; gap: 5px;">
                            <input type="number" 
                                   name="page" 
                                   min="1" 
                                   max="<%= totalPages %>" 
                                   placeholder="Page"
                                   style="padding: 8px; border: 1px solid #ddd; border-radius: 6px; width: 70px;">
                            <button type="submit" class="page-btn" style="padding: 8px 12px;">
                                Go
                            </button>
                        </form>
                    </div>
                    <% } %>
                </div>
                <% } %>
            </div>
            
            <% } else { %>
            <!-- ============================================
                 EMPTY STATE - NO REPORTS
                 ============================================ -->
            <div class="empty-state">
                <div class="empty-icon">
                    <i class="fas fa-clipboard-list"></i>
                </div>
                <h3>No Reports Found</h3>
                <p>You haven't submitted any stray animal reports yet.</p>
                <a href="report_stray.jsp" class="btn-danger" style="margin-top: 15px;">
                    <i class="fas fa-exclamation-triangle"></i> Report Your First Stray
                </a>
            </div>
            <% } 
                
            } catch (Exception e) { 
                // ============================================
                // ERROR HANDLING
                // ============================================
                e.printStackTrace(); 
            %>
            <div class="empty-state">
                <div class="empty-icon">
                    <i class="fas fa-exclamation-triangle"></i>
                </div>
                <h3>Database Error</h3>
                <p>Unable to load your reports. Please try again later.</p>
                <p style="color: #e74c3c; font-size: 12px; margin-top: 10px;">
                    Error: <%= e.getMessage() %>
                </p>
                <p style="color: #95a5a6; font-size: 12px; margin-top: 5px;">
                    <strong>Debug Information:</strong><br>
                    User ID: <%= user != null ? user.getUserId() : "Not logged in" %><br>
                    Current Page: <%= currentPage %><br>
                    Records Per Page: <%= recordsPerPage %><br>
                    Offset: <%= offset %><br>
                    Error Type: ResultSet Scrollability Issue
                </p>
            </div>
            <% } finally {
                    // ============================================
                    // CLEANUP DATABASE CONNECTIONS
                    // ============================================
                    try { if (rs != null) rs.close(); } catch (SQLException e) { e.printStackTrace(); }
                    try { if (ps != null) ps.close(); } catch (SQLException e) { e.printStackTrace(); }
                    try { if (con != null) con.close(); } catch (SQLException e) { e.printStackTrace(); }
                }
            %>
            
            <!-- ============================================
                 TIPS SECTION
                 ============================================ -->
            <div class="tips-section" style="background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
                                            border-radius: 12px; padding: 25px; margin-top: 40px; border-left: 5px solid #f39c12;">
                <h3 style="color: #34495e; margin-bottom: 15px; display: flex; align-items: center; gap: 10px;">
                    <i class="fas fa-lightbulb"></i> Report Status Guide
                </h3>
                <ul style="list-style: none; padding: 0; margin: 0;">
                    <li style="padding: 8px 0; color: #95a5a6; display: flex; align-items: center; gap: 10px;">
                        <span class="status-badge status-pending" style="font-size: 10px; padding: 4px 8px;">PENDING</span>
                        <span>Your report is waiting for review by our team</span>
                    </li>
                    <li style="padding: 8px 0; color: #95a5a6; display: flex; align-items: center; gap: 10px;">
                        <span class="status-badge status-centre" style="font-size: 10px; padding: 4px 8px;">IN_CENTRE</span>
                        <span>The animal is now safe at our rescue center</span>
                    </li>
                    <li style="padding: 8px 0; color: #95a5a6; display: flex; align-items: center; gap: 10px;">
                        <span class="status-badge status-foster" style="font-size: 10px; padding: 4px 8px;">FOSTERED</span>
                        <span>The animal is in temporary foster care</span>
                    </li>
                    <li style="padding: 8px 0; color: #95a5a6; display: flex; align-items: center; gap: 10px;">
                        <span class="status-badge status-rejected" style="font-size: 10px; padding: 4px 8px;">REJECTED</span>
                        <span>Report was not accepted (usually due to incomplete information)</span>
                    </li>
                </ul>
            </div>
        </div>
    </div>

    <!-- ============================================
         JAVASCRIPT FOR SIDEBAR TOGGLE
         ============================================ -->
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            // Handle sidebar toggle events
            window.addEventListener('sidebarToggle', function(e) {
                const sidebarCollapsed = e.detail.collapsed;
                const mainContent = document.querySelector('.main-content');
                
                if (mainContent) {
                    if (sidebarCollapsed) {
                        mainContent.style.marginLeft = '70px';
                        mainContent.style.width = 'calc(100% - 70px)';
                    } else {
                        mainContent.style.marginLeft = '280px';
                        mainContent.style.width = 'calc(100% - 280px)';
                    }
                }
            });
            
            // Initial setup for responsive layout
            const sidebar = document.querySelector('.sidebar-container');
            const mainContent = document.querySelector('.main-content');
            
            if (sidebar && mainContent) {
                if (sidebar.classList.contains('collapsed')) {
                    mainContent.style.marginLeft = '70px';
                    mainContent.style.width = 'calc(100% - 70px)';
                } else {
                    mainContent.style.marginLeft = '280px';
                    mainContent.style.width = 'calc(100% - 280px)';
                }
            }
            
            // Mobile check
            if (window.innerWidth <= 992) {
                if (mainContent) {
                    mainContent.style.marginLeft = '0';
                    mainContent.style.width = '100%';
                }
            }
            
            // Handle window resize
            window.addEventListener('resize', function() {
                const mainContent = document.querySelector('.main-content');
                
                if (mainContent) {
                    if (window.innerWidth <= 992) {
                        mainContent.style.marginLeft = '0';
                        mainContent.style.width = '100%';
                    } else {
                        const sidebar = document.querySelector('.sidebar-container');
                        if (sidebar && sidebar.classList.contains('collapsed')) {
                            mainContent.style.marginLeft = '70px';
                            mainContent.style.width = 'calc(100% - 70px)';
                        } else if (sidebar) {
                            mainContent.style.marginLeft = '280px';
                            mainContent.style.width = 'calc(100% - 280px)';
                        }
                    }
                }
            });
        });
    </script>
</body>
</html>