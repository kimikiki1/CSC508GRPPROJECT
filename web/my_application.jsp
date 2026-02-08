<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="com.petie.bean.UserBean"%>
<%@page import="com.petie.util.DBConnection"%>
<%@page import="java.sql.*"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<%
    // Check if user is logged in
    UserBean user = (UserBean) session.getAttribute("userSession");
    if (user == null) { 
        response.sendRedirect("login.jsp"); 
        return; 
    }
    
    // Set user attributes for JSTL usage
    pageContext.setAttribute("user", user);
    pageContext.setAttribute("userRole", user.getRole());
    pageContext.setAttribute("userId", user.getUserId());
    
    // Clear session messages after displaying them
    String msg = (String) session.getAttribute("msg");
    String error = (String) session.getAttribute("error");
    
    if (msg != null) {
        session.removeAttribute("msg");
    }
    if (error != null) {
        session.removeAttribute("error");
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Applications - Petie Adoption System</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        /* CSS Variables - Consistent with other pages */
        :root {
            --pet-primary: #4a90e2;
            --pet-secondary: #2ecc71;
            --pet-danger: #e74c3c;
            --pet-warning: #f39c12;
            --pet-info: #3498db;
            --pet-dark: #2c3e50;
            --pet-gray: #7f8c8d;
            --light-gray: #ecf0f1;
            --border-radius: 10px;
            --box-shadow-sm: 0 2px 5px rgba(0,0,0,0.1);
            --box-shadow: 0 4px 10px rgba(0,0,0,0.1);
            --box-shadow-lg: 0 8px 20px rgba(0,0,0,0.15);
        }
        
        /* Reset and Base Styles */
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
            color: #333;
            min-height: 100vh;
        }
        
        /* Main Content Area */
        .main-content {
            margin-left: 280px;
            transition: margin-left 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            padding: 20px;
            min-height: 100vh;
            width: calc(100% - 280px);
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
        
        /* Applications Container */
        .applications-container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 0;
        }
        
        /* Page Header */
        .page-header {
            background: linear-gradient(135deg, var(--pet-info) 0%, #2980b9 100%);
            color: white;
            border-radius: var(--border-radius);
            padding: 25px 30px;
            margin-bottom: 30px;
            box-shadow: var(--box-shadow-lg);
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
        
        /* Stats Cards */
        .stats-cards {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }
        
        .stat-card {
            background: white;
            border-radius: var(--border-radius);
            padding: 20px;
            box-shadow: var(--box-shadow);
            display: flex;
            align-items: center;
            gap: 15px;
            transition: transform 0.3s ease;
            border-top: 4px solid;
        }
        
        .stat-card:hover {
            transform: translateY(-5px);
            box-shadow: var(--box-shadow-lg);
        }
        
        .stat-card.total { border-top-color: var(--pet-primary); }
        .stat-card.pending { border-top-color: var(--pet-warning); }
        .stat-card.approved { border-top-color: var(--pet-secondary); }
        .stat-card.rejected { border-top-color: var(--pet-danger); }
        
        .stat-icon {
            width: 50px;
            height: 50px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 24px;
            color: white;
        }
        
        .total .stat-icon { background: var(--pet-primary); }
        .pending .stat-icon { background: var(--pet-warning); }
        .approved .stat-icon { background: var(--pet-secondary); }
        .rejected .stat-icon { background: var(--pet-danger); }
        
        .stat-content {
            flex: 1;
        }
        
        .stat-number {
            font-size: 28px;
            font-weight: 700;
            color: var(--pet-dark);
            line-height: 1;
        }
        
        .stat-label {
            font-size: 14px;
            color: var(--pet-gray);
            margin-top: 5px;
        }
        
        /* Filter Tabs */
        .filter-tabs {
            display: flex;
            gap: 10px;
            margin-bottom: 25px;
            flex-wrap: wrap;
            background: white;
            padding: 15px;
            border-radius: var(--border-radius);
            box-shadow: var(--box-shadow);
        }
        
        .filter-tab {
            padding: 10px 20px;
            background: var(--light-gray);
            border: none;
            border-radius: 6px;
            cursor: pointer;
            font-weight: 600;
            color: var(--pet-dark);
            transition: all 0.3s;
            display: flex;
            align-items: center;
            gap: 8px;
        }
        
        .filter-tab:hover {
            background: #dee2e6;
        }
        
        .filter-tab.active {
            background: var(--pet-primary);
            color: white;
        }
        
        /* Applications Grid */
        .applications-grid {
            display: flex;
            flex-direction: column;
            gap: 20px;
        }
        
        .application-card {
            background: white;
            border-radius: var(--border-radius);
            overflow: hidden;
            box-shadow: var(--box-shadow);
            transition: all 0.3s ease;
            border-left: 5px solid;
        }
        
        .application-card:hover {
            transform: translateY(-5px);
            box-shadow: var(--box-shadow-lg);
        }
        
        .application-card.pending {
            border-left-color: var(--pet-warning);
            background: linear-gradient(to right, white 97%, #fff3cd 100%);
        }
        
        .application-card.approved {
            border-left-color: var(--pet-secondary);
            background: linear-gradient(to right, white 97%, #d4edda 100%);
        }
        
        .application-card.rejected {
            border-left-color: var(--pet-danger);
            background: linear-gradient(to right, white 97%, #f8d7da 100%);
        }
        
        .application-header {
            padding: 20px;
            border-bottom: 1px solid var(--light-gray);
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 15px;
        }
        
        .application-title {
            display: flex;
            align-items: center;
            gap: 12px;
        }
        
        .application-icon {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 18px;
            color: white;
        }
        
        .pending .application-icon { background: var(--pet-warning); }
        .approved .application-icon { background: var(--pet-secondary); }
        .rejected .application-icon { background: var(--pet-danger); }
        
        .application-title-text h3 {
            margin: 0;
            color: var(--pet-dark);
            font-size: 18px;
        }
        
        .application-meta {
            display: flex;
            gap: 15px;
            color: var(--pet-gray);
            font-size: 13px;
            margin-top: 5px;
        }
        
        .status-badge {
            padding: 6px 15px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
            display: inline-flex;
            align-items: center;
            gap: 6px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }
        
        .status-pending {
            background: #fff3cd;
            color: #856404;
        }
        
        .status-approved {
            background: #d4edda;
            color: #155724;
        }
        
        .status-rejected {
            background: #f8d7da;
            color: #721c24;
        }
        
        .application-body {
            padding: 20px;
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 20px;
        }
        
        .application-section {
            background: #f8f9fa;
            border-radius: 8px;
            padding: 15px;
        }
        
        .section-title {
            display: flex;
            align-items: center;
            gap: 10px;
            color: var(--pet-dark);
            margin-bottom: 12px;
            font-size: 16px;
            font-weight: 600;
        }
        
        .section-title i {
            color: var(--pet-primary);
        }
        
        .section-content {
            color: var(--pet-dark);
            line-height: 1.6;
            font-size: 14px;
        }
        
        .section-content p {
            margin: 8px 0;
        }
        
        .pet-info-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(150px, 1fr));
            gap: 10px;
        }
        
        .info-item {
            display: flex;
            flex-direction: column;
            gap: 5px;
        }
        
        .info-label {
            font-size: 12px;
            color: var(--pet-gray);
            font-weight: 600;
        }
        
        .info-value {
            font-size: 14px;
            color: var(--pet-dark);
            font-weight: 500;
        }
        
        .application-footer {
            padding: 15px 20px;
            border-top: 1px solid var(--light-gray);
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 15px;
            background: #f8f9fa;
        }
        
        .application-actions {
            display: flex;
            gap: 10px;
        }
        
        .btn {
            padding: 8px 20px;
            border-radius: 6px;
            font-weight: 600;
            cursor: pointer;
            border: none;
            font-size: 14px;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            text-decoration: none;
            transition: all 0.3s;
        }
        
        .btn-primary {
            background: var(--pet-primary);
            color: white;
        }
        
        .btn-primary:hover {
            background: #357ae8;
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(74, 144, 226, 0.3);
        }
        
        .btn-secondary {
            background: white;
            color: var(--pet-dark);
            border: 2px solid var(--light-gray);
        }
        
        .btn-secondary:hover {
            border-color: var(--pet-gray);
            background: #f8f9fa;
        }
        
        .btn-success {
            background: var(--pet-secondary);
            color: white;
        }
        
        .btn-success:hover {
            background: #27ae60;
            transform: translateY(-2px);
        }
        
        /* Empty State */
        .empty-state {
            text-align: center;
            padding: 60px 20px;
            background: white;
            border-radius: var(--border-radius);
            box-shadow: var(--box-shadow);
            margin: 20px 0;
        }
        
        .empty-icon {
            font-size: 80px;
            color: var(--light-gray);
            margin-bottom: 20px;
        }
        
        .empty-state h3 {
            color: var(--pet-dark);
            margin-bottom: 10px;
        }
        
        .empty-state p {
            color: var(--pet-gray);
            max-width: 400px;
            margin: 0 auto 20px;
        }
        
        /* Message Display */
        .message-container {
            margin-bottom: 25px;
        }
        
        .alert-success {
            background: linear-gradient(135deg, #d4edda 0%, #c3e6cb 100%);
            border: 1px solid #c3e6cb;
            color: #155724;
            padding: 15px 20px;
            border-radius: 8px;
            display: flex;
            align-items: center;
            gap: 10px;
            animation: slideDown 0.3s ease;
        }
        
        .alert-error {
            background: linear-gradient(135deg, #f8d7da 0%, #f5c6cb 100%);
            border: 1px solid #f5c6cb;
            color: #721c24;
            padding: 15px 20px;
            border-radius: 8px;
            display: flex;
            align-items: center;
            gap: 10px;
            animation: slideDown 0.3s ease;
        }
        
        @keyframes slideDown {
            from {
                opacity: 0;
                transform: translateY(-10px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }
        
        /* Responsive Design */
        @media (max-width: 768px) {
            .stats-cards {
                grid-template-columns: repeat(2, 1fr);
            }
            
            .application-header {
                flex-direction: column;
                align-items: flex-start;
            }
            
            .application-body {
                grid-template-columns: 1fr;
            }
            
            .pet-info-grid {
                grid-template-columns: repeat(2, 1fr);
            }
            
            .application-footer {
                flex-direction: column;
                align-items: flex-start;
            }
            
            .application-actions {
                width: 100%;
                justify-content: space-between;
            }
            
            .btn {
                flex: 1;
                justify-content: center;
            }
        }
        
        @media (max-width: 480px) {
            .stats-cards {
                grid-template-columns: 1fr;
            }
            
            .filter-tabs {
                justify-content: center;
            }
            
            .pet-info-grid {
                grid-template-columns: 1fr;
            }
        }
        
        /* Loading Animation */
        .loading-spinner {
            display: none;
            width: 20px;
            height: 20px;
            border: 2px solid rgba(255, 255, 255, 0.3);
            border-radius: 50%;
            border-top-color: white;
            animation: spin 1s ease-in-out infinite;
        }
        
        @keyframes spin {
            to { transform: rotate(360deg); }
        }
        
        /* Animation for application cards */
        @keyframes fadeInUp {
            from {
                opacity: 0;
                transform: translateY(20px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }
        
        .application-card {
            animation: fadeInUp 0.5s ease forwards;
        }
        
        .application-card:nth-child(1) { animation-delay: 0.1s; }
        .application-card:nth-child(2) { animation-delay: 0.2s; }
        .application-card:nth-child(3) { animation-delay: 0.3s; }
        .application-card:nth-child(4) { animation-delay: 0.4s; }
        .application-card:nth-child(5) { animation-delay: 0.5s; }
    </style>
</head>
<body>
    <!-- Include Navigation Sidebar -->
    <%@include file="navbar.jsp" %>
    
    <!-- Main Content Area -->
    <div class="main-content">
        <div class="applications-container">
            <!-- Page Header -->
            <div class="page-header">
                <h1>
                    <i class="fas fa-clipboard-list"></i> My Adoption Applications
                </h1>
                <p class="page-subtitle">
                    Track the status of your pet adoption applications
                </p>
            </div>
            
            <!-- Message Display -->
            <div class="message-container" id="messageContainer">
                <% if (msg != null) { %>
                    <div class="alert-success" id="successMessage">
                        <i class="fas fa-check-circle"></i> <%= msg %>
                    </div>
                <% } %>
                
                <% if (error != null) { %>
                    <div class="alert-error" id="errorMessage">
                        <i class="fas fa-exclamation-circle"></i> <%= error %>
                    </div>
                <% } %>
            </div>
            
            <!-- Stats Cards -->
            <div class="stats-cards" id="statsCards">
                <!-- Will be populated by JavaScript -->
            </div>
            
            <!-- Filter Tabs -->
            <div class="filter-tabs">
                <button class="filter-tab active" onclick="filterApplications('all')">
                    <i class="fas fa-layer-group"></i> All Applications
                </button>
                <button class="filter-tab" onclick="filterApplications('pending')">
                    <i class="fas fa-clock"></i> Pending
                </button>
                <button class="filter-tab" onclick="filterApplications('approved')">
                    <i class="fas fa-check-circle"></i> Approved
                </button>
                <button class="filter-tab" onclick="filterApplications('rejected')">
                    <i class="fas fa-times-circle"></i> Rejected
                </button>
            </div>
            
            <!-- Applications Grid -->
            <div class="applications-grid" id="applicationsGrid">
                <%
                    Connection con = null;
                    int totalCount = 0;
                    int pendingCount = 0;
                    int approvedCount = 0;
                    int rejectedCount = 0;
                    boolean hasApplications = false;

                    try {
                        con = DBConnection.createConnection();
                        String sql = "SELECT ar.*, sr.PET_TYPE, sr.LOCATION_FOUND, sr.DATE_FOUND, sr.PET_PHOTO, " +
                                    "sr.SITUATION, u.FULL_NAME, u.EMAIL, u.PHONE_NUMBER " +
                                    "FROM ADOPTION_REQUESTS ar " +
                                    "JOIN STRAY_REPORT sr ON ar.STRAY_ID = sr.STRAY_ID " +
                                    "JOIN USERS u ON ar.USER_ID = u.USER_ID " +
                                    "WHERE ar.USER_ID = ? " +
                                    "ORDER BY ar.REQUEST_DATE DESC";

                        // Create scrollable ResultSet for Derby
                        PreparedStatement ps = con.prepareStatement(
                            sql, 
                            ResultSet.TYPE_SCROLL_INSENSITIVE, 
                            ResultSet.CONCUR_READ_ONLY
                        );
                        ps.setInt(1, user.getUserId());
                        ResultSet rs = ps.executeQuery();

                        // Check if there are any results
                        hasApplications = rs.next(); // Move to first row
                        rs.beforeFirst(); // Move back to before first row

                        if (!hasApplications) {
                %>
                            <!-- Empty State -->
                            <div class="empty-state">
                                <div class="empty-icon">
                                    <i class="fas fa-clipboard"></i>
                                </div>
                                <h3>No Applications Yet</h3>
                                <p>You haven't submitted any adoption applications yet.</p>
                                <a href="adopt_me.jsp" class="btn btn-primary" style="margin-top: 20px;">
                                    <i class="fas fa-paw"></i> Browse Available Pets
                                </a>
                            </div>
                <%
                        } else {
                            while(rs.next()) {
                                totalCount++;
                                String requestId = rs.getString("REQUEST_ID");
                                String strayId = rs.getString("STRAY_ID");
                                String petType = rs.getString("PET_TYPE");
                                String location = rs.getString("LOCATION_FOUND");
                                String situation = rs.getString("SITUATION");
                                String status = rs.getString("STATUS");
                                Date requestDate = rs.getDate("REQUEST_DATE");
                                Date processedDate = rs.getDate("PROCESSED_DATE");
                                String reason = rs.getString("REASON");
                                String experience = rs.getString("EXPERIENCE");
                                String livingSituation = rs.getString("LIVING_SITUATION");
                                String contactPreference = rs.getString("CONTACT_PREFERENCE");
                                String photo = rs.getString("PET_PHOTO");
                                
                                // Format dates
                                String displayRequestDate = "";
                                String displayProcessedDate = "";
                                
                                if (requestDate != null) {
                                    java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("MMM dd, yyyy");
                                    displayRequestDate = sdf.format(requestDate);
                                }
                                
                                if (processedDate != null) {
                                    java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("MMM dd, yyyy");
                                    displayProcessedDate = sdf.format(processedDate);
                                }
                                
                                // Count by status
                                if ("PENDING".equals(status)) {
                                    pendingCount++;
                                } else if ("APPROVED".equals(status)) {
                                    approvedCount++;
                                } else if ("REJECTED".equals(status)) {
                                    rejectedCount++;
                                }
                                
                                // Determine status details
                                String statusClass = "pending";
                                String statusText = "Pending Review";
                                String statusIcon = "fa-clock";
                                String statusDescription = "Your application is under review by our team.";
                                
                                if ("APPROVED".equals(status)) {
                                    statusClass = "approved";
                                    statusText = "Approved";
                                    statusIcon = "fa-check-circle";
                                    statusDescription = "Congratulations! Your application has been approved.";
                                } else if ("REJECTED".equals(status)) {
                                    statusClass = "rejected";
                                    statusText = "Not Approved";
                                    statusIcon = "fa-times-circle";
                                    statusDescription = "Thank you for your interest. Unfortunately, this pet has been matched with another family.";
                                }
                %>
                                <div class="application-card <%= statusClass %>" data-status="<%= status.toLowerCase() %>">
                                    <!-- Application Header -->
                                    <div class="application-header">
                                        <div class="application-title">
                                            <div class="application-icon">
                                                <i class="fas <%= statusIcon %>"></i>
                                            </div>
                                            <div class="application-title-text">
                                                <h3><%= petType %> Adoption Application</h3>
                                                <div class="application-meta">
                                                    <span><i class="far fa-calendar"></i> Applied: <%= displayRequestDate %></span>
                                                    <% if (processedDate != null) { %>
                                                    <span><i class="far fa-calendar-check"></i> Processed: <%= displayProcessedDate %></span>
                                                    <% } %>
                                                    <span><i class="fas fa-hashtag"></i> Request ID: #<%= requestId %></span>
                                                </div>
                                            </div>
                                        </div>
                                        <span class="status-badge status-<%= statusClass %>">
                                            <i class="fas fa-circle" style="font-size: 8px;"></i> <%= statusText %>
                                        </span>
                                    </div>
                                    
                                    <!-- Application Body -->
                                    <div class="application-body">
                                        <!-- Pet Information -->
                                        <div class="application-section">
                                            <div class="section-title">
                                                <i class="fas fa-paw"></i> Pet Information
                                            </div>
                                            <div class="pet-info-grid">
                                                <div class="info-item">
                                                    <span class="info-label">Pet Type</span>
                                                    <span class="info-value"><%= petType %></span>
                                                </div>
                                                <div class="info-item">
                                                    <span class="info-label">Location Found</span>
                                                    <span class="info-value"><%= location %></span>
                                                </div>
                                                <div class="info-item">
                                                    <span class="info-label">Report ID</span>
                                                    <span class="info-value">#<%= strayId %></span>
                                                </div>
                                            </div>
                                            <div class="section-content" style="margin-top: 10px;">
                                                <strong>Condition:</strong>
                                                <p style="margin-top: 5px;"><%= situation %></p>
                                            </div>
                                        </div>
                                        
                                        <!-- Application Details -->
                                        <div class="application-section">
                                            <div class="section-title">
                                                <i class="fas fa-file-alt"></i> Application Details
                                            </div>
                                            <div class="section-content">
                                                <% if (reason != null && !reason.isEmpty()) { %>
                                                    <p><strong>Why you want to adopt:</strong><br><%= reason %></p>
                                                <% } %>
                                                
                                                <% if (experience != null && !experience.isEmpty()) { %>
                                                    <p><strong>Your experience with pets:</strong><br><%= experience %></p>
                                                <% } %>
                                                
                                                <% if (livingSituation != null && !livingSituation.isEmpty()) { %>
                                                    <p><strong>Your living situation:</strong><br><%= livingSituation %></p>
                                                <% } %>
                                            </div>
                                        </div>
                                        
                                        <!-- Status & Contact -->
                                        <div class="application-section">
                                            <div class="section-title">
                                                <i class="fas fa-info-circle"></i> Status Information
                                            </div>
                                            <div class="section-content">
                                                <p><%= statusDescription %></p>
                                                
                                                <% if (contactPreference != null && !contactPreference.isEmpty()) { %>
                                                    <p style="margin-top: 10px;">
                                                        <strong>Contact Preference:</strong> 
                                                        <%= contactPreference %>
                                                    </p>
                                                <% } %>
                                                
                                                <% if ("APPROVED".equals(status)) { %>
                                                    <div style="margin-top: 15px; padding: 10px; background: #d4edda; border-radius: 6px;">
                                                        <strong><i class="fas fa-check-circle"></i> Next Steps:</strong>
                                                        <p style="margin-top: 5px; color: #155724;">
                                                            Our team will contact you within 24-48 hours to arrange the adoption process.
                                                        </p>
                                                    </div>
                                                <% } else if ("REJECTED".equals(status)) { %>
                                                    <div style="margin-top: 15px;">
                                                        <a href="adopt_me.jsp" class="btn btn-primary">
                                                            <i class="fas fa-search"></i> Browse Other Pets
                                                        </a>
                                                    </div>
                                                <% } %>
                                            </div>
                                        </div>
                                    </div>
                                    
                                    <!-- Application Footer -->
                                    <div class="application-footer">
                                        <div>
                                            <% if ("PENDING".equals(status)) { %>
                                                <span style="color: var(--pet-warning); font-size: 14px;">
                                                    <i class="fas fa-clock"></i> Estimated review time: 2-3 business days
                                                </span>
                                            <% } else if ("APPROVED".equals(status)) { %>
                                                <span style="color: var(--pet-secondary); font-size: 14px;">
                                                    <i class="fas fa-check"></i> Ready for adoption process
                                                </span>
                                            <% } %>
                                        </div>
                                        <div class="application-actions">
                                            <% if ("PENDING".equals(status)) { %>
                                                <button class="btn btn-secondary" onclick="cancelApplication(<%= requestId %>)">
                                                    <i class="fas fa-times"></i> Cancel Request
                                                </button>
                                            <% } %>
                                            <a href="adopt_me.jsp" class="btn btn-primary">
                                                <i class="fas fa-search"></i> Browse More Pets
                                            </a>
                                        </div>
                                    </div>
                                </div>
                <%
                            }
                        }
                        con.close();
                    } catch (Exception e) {
                        out.println("<div class='alert alert-error'>Error loading applications: " + e.getMessage() + "</div>");
                        e.printStackTrace();
                    }
                %>
            </div>
        </div>
    </div>
    
    <!-- JavaScript for Interactive Features -->
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            console.log('My Applications page loaded');
            
            // Initialize stats cards with counts from JSP
            initializeStatsCards(<%= totalCount %>, <%= pendingCount %>, <%= approvedCount %>, <%= rejectedCount %>);
            
            // Auto-hide messages after 5 seconds
            setTimeout(function() {
                const successMsg = document.getElementById('successMessage');
                const errorMsg = document.getElementById('errorMessage');
                
                if (successMsg) {
                    successMsg.style.opacity = '0';
                    successMsg.style.transition = 'opacity 0.5s';
                    setTimeout(() => successMsg.remove(), 500);
                }
                
                if (errorMsg) {
                    errorMsg.style.opacity = '0';
                    errorMsg.style.transition = 'opacity 0.5s';
                    setTimeout(() => errorMsg.remove(), 500);
                }
            }, 5000);
            
            // Initialize filter functionality
            initializeFilters();
        });
        
        // Function to initialize stats cards
        function initializeStatsCards(total, pending, approved, rejected) {
            const statsCards = document.getElementById('statsCards');
            
            statsCards.innerHTML = `
                <div class="stat-card total">
                    <div class="stat-icon">
                        <i class="fas fa-layer-group"></i>
                    </div>
                    <div class="stat-content">
                        <div class="stat-number">${total}</div>
                        <div class="stat-label">Total Applications</div>
                    </div>
                </div>
                
                <div class="stat-card pending">
                    <div class="stat-icon">
                        <i class="fas fa-clock"></i>
                    </div>
                    <div class="stat-content">
                        <div class="stat-number">${pending}</div>
                        <div class="stat-label">Pending Review</div>
                    </div>
                </div>
                
                <div class="stat-card approved">
                    <div class="stat-icon">
                        <i class="fas fa-check-circle"></i>
                    </div>
                    <div class="stat-content">
                        <div class="stat-number">${approved}</div>
                        <div class="stat-label">Approved</div>
                    </div>
                </div>
                
                <div class="stat-card rejected">
                    <div class="stat-icon">
                        <i class="fas fa-times-circle"></i>
                    </div>
                    <div class="stat-content">
                        <div class="stat-number">${rejected}</div>
                        <div class="stat-label">Not Approved</div>
                    </div>
                </div>
            `;
        }
        
        // Function to initialize filters
        function initializeFilters() {
            const filterTabs = document.querySelectorAll('.filter-tab');
            
            filterTabs.forEach(tab => {
                tab.addEventListener('click', function() {
                    // Update active tab
                    filterTabs.forEach(t => t.classList.remove('active'));
                    this.classList.add('active');
                });
            });
        }
        
        // Function to filter applications by status
        function filterApplications(status) {
            const applications = document.querySelectorAll('.application-card');
            const emptyState = document.querySelector('.empty-state');
            
            let visibleCount = 0;
            
            applications.forEach(card => {
                if (status === 'all' || card.getAttribute('data-status') === status) {
                    card.style.display = 'flex';
                    visibleCount++;
                } else {
                    card.style.display = 'none';
                }
            });
            
            // Show/hide empty state based on filter results
            if (emptyState && visibleCount === 0) {
                emptyState.style.display = 'block';
            } else if (emptyState) {
                emptyState.style.display = 'none';
            }
            
            // Update active tab
            document.querySelectorAll('.filter-tab').forEach(tab => {
                tab.classList.remove('active');
            });
            
            // Set the clicked tab as active
            const tabMap = {
                'all': 0,
                'pending': 1,
                'approved': 2,
                'rejected': 3
            };
            
            document.querySelectorAll('.filter-tab')[tabMap[status]].classList.add('active');
        }
        
        // Function to cancel an application
        function cancelApplication(requestId) {
            if (!confirm('Are you sure you want to cancel this adoption application? This action cannot be undone.')) {
                return;
            }
            
            // Send AJAX request to cancel application
            fetch('CancelApplicationServlet?requestId=' + requestId, {
                method: 'GET'
            })
            .then(response => response.text())
            .then(data => {
                if (data.includes('success')) {
                    // Reload page to show updated list
                    location.reload();
                } else {
                    alert('Failed to cancel application. Please try again.');
                }
            })
            .catch(error => {
                console.error('Error:', error);
                alert('An error occurred. Please try again.');
            });
        }
        
        // Function to update stats on the fly (if needed)
        function updateStats() {
            // In a real app, you might want to update stats via AJAX
            console.log('Stats updated');
        }
    </script>
</body>
</html>