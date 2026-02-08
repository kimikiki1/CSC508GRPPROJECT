<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="com.petie.bean.UserBean"%>
<%@page import="com.petie.bean.StatsBean"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<%
    // Check if user is logged in, redirect to login if not
    UserBean user = (UserBean) session.getAttribute("userSession");
    if (user == null) { 
        response.sendRedirect("login.jsp"); 
        return; 
    }
    
    // Fetch statistics from database
    StatsBean stats = new StatsBean(user.getUserId(), user.getRole());
    
    // Set attributes for JSTL
    pageContext.setAttribute("user", user);
    pageContext.setAttribute("userRole", user.getRole());
    pageContext.setAttribute("userName", user.getFullName());
    pageContext.setAttribute("stats", stats);
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard - Petie Adoptie System</title>
    <link rel="stylesheet" href="style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        /* Updated Color Variables for better balance */
        :root {
            --pet-primary: #4a90e2;      /* Keep blue but use sparingly */
            --pet-secondary: #f39c12;    /* Orange accent */
            --pet-success: #2ecc71;      /* Green */
            --pet-danger: #e74c3c;       /* Red */
            --pet-purple: #9b59b6;       /* Purple */
            --pet-teal: #1abc9c;         /* Teal */
            --pet-warm: #e67e22;         /* Warm orange */
            --pet-light: #f8f9fa;        /* Light background */
            --pet-dark: #34495e;         /* Dark slate */
            --pet-gray: #95a5a6;         /* Gray */
        }
        
        /* Fix for main content centering */
        .main-content {
            margin-left: 280px;
            transition: margin-left 0.3s ease;
            padding: 20px;
            min-height: 100vh;
        }
        
        /* When sidebar is collapsed */
        .sidebar-container.collapsed ~ .main-content {
            margin-left: 70px;
        }
        
        /* On mobile, no margin */
        @media (max-width: 992px) {
            .main-content {
                margin-left: 0 !important;
            }
        }
        
        /* Page-specific styles for dashboard */
        .dashboard-container {
            padding: 40px 0;
            max-width: 1400px;
            margin: 0 auto;
        }
        
        /* Welcome Banner - Updated with balanced colors */
        .welcome-banner {
            background: linear-gradient(135deg, #8E44AD 0%, #3498DB 100%);
            color: white;
            border-radius: var(--border-radius);
            padding: 30px;
            margin-bottom: 40px;
            box-shadow: var(--box-shadow-lg);
            position: relative;
            overflow: hidden;
        }
        
        .welcome-banner::before {
            content: "";
            position: absolute;
            top: -50%;
            right: -50%;
            width: 300%;
            height: 200%;
            background: radial-gradient(circle, rgba(255,255,255,0.1) 1px, transparent 1px);
            background-size: 20px 20px;
            opacity: 0.2;
            animation: float 20s linear infinite;
        }
        
        @keyframes float {
            from { transform: rotate(0deg); }
            to { transform: rotate(360deg); }
        }
        
        .welcome-content {
            position: relative;
            z-index: 1;
        }
        
        .user-avatar {
            width: 80px;
            height: 80px;
            background: linear-gradient(135deg, rgba(255,255,255,0.3) 0%, rgba(255,255,255,0.1) 100%);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-right: 20px;
            font-size: 36px;
            border: 3px solid rgba(255,255,255,0.3);
        }
        
        /* Quick Stats Cards - Color variety */
        .stats-container {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
            margin-bottom: 40px;
        }
        
        .stat-card {
            background: white;
            border-radius: var(--border-radius);
            padding: 20px;
            box-shadow: var(--box-shadow);
            text-align: center;
            transition: transform 0.3s ease;
            border-top: 4px solid;
        }
        
        .stat-card:hover {
            transform: translateY(-5px);
            box-shadow: var(--box-shadow-lg);
        }
        
        .stat-card:nth-child(1) { border-top-color: var(--pet-secondary); }
        .stat-card:nth-child(2) { border-top-color: var(--pet-success); }
        .stat-card:nth-child(3) { border-top-color: var(--pet-purple); }
        .stat-card:nth-child(4) { border-top-color: var(--pet-warm); }
        
        .stat-icon {
            font-size: 40px;
            margin-bottom: 15px;
            padding: 15px;
            border-radius: 50%;
            display: inline-block;
        }
        
        .stat-card:nth-child(1) .stat-icon { 
            background: rgba(243, 156, 18, 0.1); 
            color: var(--pet-secondary); 
        }
        .stat-card:nth-child(2) .stat-icon { 
            background: rgba(46, 204, 113, 0.1); 
            color: var(--pet-success); 
        }
        .stat-card:nth-child(3) .stat-icon { 
            background: rgba(155, 89, 182, 0.1); 
            color: var(--pet-purple); 
        }
        .stat-card:nth-child(4) .stat-icon { 
            background: rgba(230, 126, 34, 0.1); 
            color: var(--pet-warm); 
        }
        
        .stat-number {
            font-size: 32px;
            font-weight: 700;
            color: var(--pet-dark);
            margin: 10px 0;
        }
        
        .stat-label {
            color: var(--pet-gray);
            font-size: 14px;
        }
        
        /* Feature Cards Grid - More color variety */
        .features-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 25px;
            margin-bottom: 40px;
        }
        
        .feature-card {
            background: white;
            border-radius: var(--border-radius);
            padding: 25px;
            box-shadow: var(--box-shadow);
            transition: all 0.3s ease;
            border-top: 4px solid;
            height: 100%;
            display: flex;
            flex-direction: column;
        }
        
        .feature-card:hover {
            transform: translateY(-10px);
            box-shadow: var(--box-shadow-lg);
        }
        
        .feature-icon {
            font-size: 48px;
            margin-bottom: 20px;
            text-align: center;
            padding: 20px;
            border-radius: 15px;
            display: inline-block;
            width: fit-content;
            margin-left: auto;
            margin-right: auto;
        }
        
        .feature-card h3 {
            color: var(--pet-dark);
            margin-bottom: 15px;
            font-size: 20px;
        }
        
        .feature-card p {
            color: var(--pet-gray);
            margin-bottom: 20px;
            flex-grow: 1;
            line-height: 1.6;
        }
        
        /* Different colors for different features */
        .card-report { 
            border-top-color: var(--pet-danger);
            background: linear-gradient(to bottom right, white, #fef5f5);
        }
        .card-report .feature-icon {
            background: rgba(231, 76, 60, 0.1);
            color: var(--pet-danger);
        }
        
        .card-adopt { 
            border-top-color: var(--pet-success);
            background: linear-gradient(to bottom right, white, #f5fef8);
        }
        .card-adopt .feature-icon {
            background: rgba(46, 204, 113, 0.1);
            color: var(--pet-success);
        }
        
        .card-profile { 
            border-top-color: var(--pet-purple);
            background: linear-gradient(to bottom right, white, #f9f5ff);
        }
        .card-profile .feature-icon {
            background: rgba(155, 89, 182, 0.1);
            color: var(--pet-purple);
        }
        
        .card-admin { 
            border-top-color: var(--pet-dark);
            background: linear-gradient(to bottom right, white, #f5f7fa);
        }
        .card-admin .feature-icon {
            background: rgba(52, 73, 94, 0.1);
            color: var(--pet-dark);
        }
        
        .card-staff { 
            border-top-color: var(--pet-warm);
            background: linear-gradient(to bottom right, white, #fef9f5);
        }
        .card-staff .feature-icon {
            background: rgba(230, 126, 34, 0.1);
            color: var(--pet-warm);
        }
        
        /* Button colors to match cards */
        .btn-card-primary {
            background: linear-gradient(135deg, var(--pet-primary) 0%, #357ae8 100%);
            color: white;
            border: none;
        }
        
        .btn-card-danger {
            background: linear-gradient(135deg, var(--pet-danger) 0%, #c0392b 100%);
            color: white;
            border: none;
        }
        
        .btn-card-success {
            background: linear-gradient(135deg, var(--pet-success) 0%, #27ae60 100%);
            color: white;
            border: none;
        }
        
        .btn-card-purple {
            background: linear-gradient(135deg, var(--pet-purple) 0%, #8e44ad 100%);
            color: white;
            border: none;
        }
        
        .btn-card-dark {
            background: linear-gradient(135deg, var(--pet-dark) 0%, #2c3e50 100%);
            color: white;
            border: none;
        }
        
        .btn-card-warm {
            background: linear-gradient(135deg, var(--pet-warm) 0%, #d35400 100%);
            color: white;
            border: none;
        }
        
        /* Recent Activity */
        .activity-container {
            background: white;
            border-radius: var(--border-radius);
            padding: 25px;
            box-shadow: var(--box-shadow);
            margin-bottom: 40px;
            border-left: 5px solid var(--pet-teal);
        }
        
        .activity-list {
            margin-top: 20px;
        }
        
        .activity-item {
            display: flex;
            align-items: center;
            padding: 15px;
            border-bottom: 1px solid #eee;
            transition: background-color 0.2s;
            border-radius: 8px;
            margin-bottom: 8px;
        }
        
        .activity-item:hover {
            background-color: #f8f9fa;
        }
        
        .activity-item:last-child {
            border-bottom: none;
            margin-bottom: 0;
        }
        
        .activity-icon {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-right: 15px;
            font-size: 18px;
        }
        
        .activity-login .activity-icon { background: rgba(52, 152, 219, 0.1); color: #3498db; }
        .activity-view .activity-icon { background: rgba(155, 89, 182, 0.1); color: var(--pet-purple); }
        .activity-report .activity-icon { background: rgba(231, 76, 60, 0.1); color: var(--pet-danger); }
        .activity-application .activity-icon { background: rgba(46, 204, 113, 0.1); color: var(--pet-success); }
        
        /* Role Badge - More variety */
        .role-badge {
            display: inline-block;
            padding: 6px 15px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
            margin-left: 10px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }
        
        .badge-admin { 
            background: linear-gradient(135deg, var(--pet-dark) 0%, #2c3e50 100%); 
            color: white; 
        }
        .badge-staff { 
            background: linear-gradient(135deg, var(--pet-warm) 0%, #d35400 100%); 
            color: white; 
        }
        .badge-user { 
            background: linear-gradient(135deg, var(--pet-success) 0%, #27ae60 100%); 
            color: white; 
        }
        
        /* Quick Tips Section */
        .quick-tips {
            background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
            border-radius: var(--border-radius);
            padding: 25px;
            text-align: center;
            margin-bottom: 40px;
            border-left: 5px solid var(--pet-secondary);
        }
        
        .tip-items {
            display: flex;
            flex-wrap: wrap;
            justify-content: center;
            gap: 15px;
            margin-top: 20px;
        }
        
        .tip-item {
            background: white;
            padding: 12px 20px;
            border-radius: 20px;
            font-size: 14px;
            box-shadow: var(--box-shadow);
            display: flex;
            align-items: center;
            gap: 10px;
            transition: transform 0.3s ease;
        }
        
        .tip-item:hover {
            transform: translateY(-3px);
            box-shadow: var(--box-shadow-lg);
        }
        
        .tip-item:nth-child(1) { border-left: 3px solid var(--pet-primary); }
        .tip-item:nth-child(2) { border-left: 3px solid var(--pet-success); }
        .tip-item:nth-child(3) { border-left: 3px solid var(--pet-danger); }
        
        .tip-icon {
            font-size: 16px;
        }
        
        /* Responsive adjustments */
        @media (max-width: 768px) {
            .welcome-banner {
                text-align: center;
                padding: 20px;
            }
            
            .user-avatar {
                margin: 0 auto 15px;
            }
            
            .features-grid {
                grid-template-columns: 1fr;
            }
            
            .tip-items {
                flex-direction: column;
                align-items: center;
            }
            
            .tip-item {
                width: 100%;
                max-width: 300px;
                justify-content: center;
            }
        }
        
        /* Add subtle animations */
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
        
        .animate-fade-in-up {
            animation: fadeInUp 0.5s ease forwards;
        }
        
        .delay-1 { animation-delay: 0.1s; opacity: 0; }
        .delay-2 { animation-delay: 0.2s; opacity: 0; }
        .delay-3 { animation-delay: 0.3s; opacity: 0; }
        .delay-4 { animation-delay: 0.4s; opacity: 0; }
        .delay-5 { animation-delay: 0.5s; opacity: 0; }
    </style>
</head>
<body>
    <!-- Include Navigation Sidebar -->
    <%@include file="navbar.jsp" %>
    
    <!-- Main Content Area -->
    <div class="main-content">
        <div class="dashboard-container">
            <!-- Welcome Banner -->
            <div class="welcome-banner animate-fade-in-up">
                <div class="welcome-content" style="display: flex; align-items: center; flex-wrap: wrap;">
                    <div class="user-avatar">
                        <i class="fas fa-user"></i>
                    </div>
                    <div style="flex: 1;">
                        <h1 style="margin: 0 0 10px 0; color: white;">
                            Welcome back, <span style="font-weight: 700;">${userName}</span>!
                            <span class="role-badge badge-${userRole.toLowerCase()}">${userRole}</span>
                        </h1>
                        <p style="margin: 0; color: rgba(255,255,255,0.9);">
                            <i class="far fa-calendar-alt"></i> 
                            <jsp:useBean id="now" class="java.util.Date" />
                            <fmt:formatDate value="${now}" pattern="EEEE, MMMM dd, yyyy" />
                        </p>
                        <p style="margin: 10px 0 0 0; color: rgba(255,255,255,0.8); font-size: 14px;">
                            <i class="fas fa-heart"></i> Thank you for helping animals find loving homes
                        </p>
                    </div>
                    <div style="text-align: right;">
                        <a href="account_settings.jsp" class="btn" style="background: rgba(255,255,255,0.2); color: white; border: 2px solid white; backdrop-filter: blur(5px);">
                            <i class="fas fa-cog"></i> Account Settings
                        </a>
                    </div>
                </div>
            </div>
            
            <!-- Quick Stats Section -->
            <div class="stats-container">
                <div class="stat-card animate-fade-in-up delay-1">
                    <div class="stat-icon">
                        <i class="fas fa-paw"></i>
                    </div>
                    <div class="stat-number">${stats.availablePets}</div>
                    <div class="stat-label">Available Pets</div>
                </div>
                
                <div class="stat-card animate-fade-in-up delay-2">
                    <div class="stat-icon">
                        <i class="fas fa-home"></i>
                    </div>
                    <div class="stat-number">${stats.adoptedThisMonth}</div>
                    <div class="stat-label">Adopted This Month</div>
                </div>
                
                <div class="stat-card animate-fade-in-up delay-3">
                    <div class="stat-icon">
                        <i class="fas fa-exclamation-circle"></i>
                    </div>
                    <div class="stat-number">${stats.reportsSubmitted}</div>
                    <div class="stat-label">Reports Submitted</div>
                </div>
                
                <div class="stat-card animate-fade-in-up delay-4">
                    <div class="stat-icon">
                        <i class="fas fa-heart"></i>
                    </div>
                    <div class="stat-number">${stats.happyFamilies}</div>
                    <div class="stat-label">Happy Families</div>
                </div>
            </div>
            
            <!-- Features Grid -->
            <div class="features-grid">
                <!-- Common Features for All Users -->
                <div class="feature-card card-report animate-fade-in-up delay-1">
                    <div class="feature-icon">
                        <i class="fas fa-exclamation-triangle"></i>
                    </div>
                    <h3>Report a Stray</h3>
                    <p>Found a stray animal in need? Report it with location, photos, and details so our rescue team can help.</p>
                    <a href="report_stray.jsp" class="btn btn-card-danger">
                        <i class="fas fa-plus-circle"></i> Submit Report
                    </a>
                </div>
                
                <div class="feature-card card-adopt animate-fade-in-up delay-2">
                    <div class="feature-icon">
                        <i class="fas fa-paw"></i>
                    </div>
                    <h3>Adopt a Pet</h3>
                    <p>Browse our gallery of adorable pets waiting for their forever homes. Filter by type, age, or location.</p>
                    <a href="adopt_me.jsp" class="btn btn-card-success">
                        <i class="fas fa-search"></i> Browse Pets
                    </a>
                </div>
                
                <div class="feature-card card-profile animate-fade-in-up delay-3">
                    <div class="feature-icon">
                        <i class="fas fa-user-circle"></i>
                    </div>
                    <h3>My Profile</h3>
                    <p>Update your contact information, view your adoption history, and manage your account settings.</p>
                    <a href="account_settings.jsp" class="btn btn-card-purple">
                        <i class="fas fa-cog"></i> Manage Profile
                    </a>
                </div>
                
                <!-- ADMIN-ONLY Features -->
                <c:if test="${userRole == 'ADMIN'}">
                    <div class="feature-card card-admin animate-fade-in-up delay-4">
                        <div class="feature-icon">
                            <i class="fas fa-user-shield"></i>
                        </div>
                        <h3>Admin Dashboard</h3>
                        <p>Manage users, view system reports, configure settings, and oversee all platform activities.</p>
                        <a href="admin_dashboard.jsp" class="btn btn-card-dark">
                            <i class="fas fa-tachometer-alt"></i> Admin Panel
                        </a>
                    </div>
                </c:if>
                
                <!-- STAFF-ONLY Features -->
                <c:if test="${userRole == 'STAFF' || userRole == 'ADMIN'}">
                    <div class="feature-card card-staff animate-fade-in-up delay-4">
                        <div class="feature-icon">
                            <i class="fas fa-clipboard-check"></i>
                        </div>
                        <h3>Manage Reports</h3>
                        <p>Review and process stray reports, update status, and coordinate with rescue teams.</p>
                        <a href="manage_reports.jsp" class="btn btn-card-warm">
                            <i class="fas fa-tasks"></i> View Reports
                        </a>
                    </div>
                    
                    <div class="feature-card animate-fade-in-up delay-5">
                        <div class="feature-icon" style="background: rgba(26, 188, 156, 0.1); color: var(--pet-teal);">
                            <i class="fas fa-dog"></i>
                        </div>
                        <h3>Pet Management</h3>
                        <p>Add new pets for adoption, update medical records, and manage adoption applications.</p>
                        <a href="manage_pets.jsp" class="btn btn-card-primary">
                            <i class="fas fa-plus"></i> Add New Pet
                        </a>
                    </div>
                </c:if>
                
                <!-- Additional User Features -->
                <div class="feature-card animate-fade-in-up delay-5">
                    <div class="feature-icon" style="background: rgba(46, 204, 113, 0.1); color: var(--pet-success);">
                        <i class="fas fa-heart"></i>
                    </div>
                    <h3>My Applications</h3>
                    <p>Track the status of your adoption applications and see scheduled meet-and-greets.</p>
                    <a href="my_applications.jsp" class="btn btn-card-success">
                        <i class="fas fa-file-alt"></i> View Applications
                    </a>
                </div>
                
                <div class="feature-card animate-fade-in-up delay-5">
                    <div class="feature-icon" style="background: rgba(52, 152, 219, 0.1); color: #3498db;">
                        <i class="fas fa-comments"></i>
                    </div>
                    <h3>Help & Support</h3>
                    <p>Get help with the adoption process, report issues, or contact our support team.</p>
                    <a href="help.jsp" class="btn btn-card-primary">
                        <i class="fas fa-question-circle"></i> Get Help
                    </a>
                </div>
            </div>
            
            <!-- Recent Activity Section -->
            <div class="activity-container animate-fade-in-up">
                <h2 style="color: var(--pet-dark); margin-bottom: 10px;">
                    <i class="fas fa-history"></i> Recent Activity
                </h2>
                <p style="color: var(--pet-gray);">Your recent actions on the platform</p>
                
                <div class="activity-list">
                    <div class="activity-item activity-login">
                        <div class="activity-icon">
                            <i class="fas fa-sign-in-alt"></i>
                        </div>
                        <div style="flex: 1;">
                            <strong>Logged in</strong>
                            <div style="color: var(--pet-gray); font-size: 13px;">
                                <fmt:formatDate value="${now}" pattern="hh:mm a" />
                                • Just now
                            </div>
                        </div>
                    </div>
                    
                    <div class="activity-item activity-view">
                        <div class="activity-icon">
                            <i class="fas fa-paw"></i>
                        </div>
                        <div style="flex: 1;">
                            <strong>Viewed pet profile: "Max"</strong>
                            <div style="color: var(--pet-gray); font-size: 13px;">
                                Yesterday • 3:45 PM
                            </div>
                        </div>
                    </div>
                    
                    <div class="activity-item activity-report">
                        <div class="activity-icon">
                            <i class="fas fa-exclamation-circle"></i>
                        </div>
                        <div style="flex: 1;">
                            <strong>Submitted stray report #R-024</strong>
                            <div style="color: var(--pet-gray); font-size: 13px;">
                                March 15, 2024 • Status: Under Review
                            </div>
                        </div>
                    </div>
                    
                    <div class="activity-item activity-application">
                        <div class="activity-icon">
                            <i class="fas fa-file-alt"></i>
                        </div>
                        <div style="flex: 1;">
                            <strong>Adoption application submitted</strong>
                            <div style="color: var(--pet-gray); font-size: 13px;">
                                March 10, 2024 • For: Luna (Cat)
                            </div>
                        </div>
                    </div>
                </div>
                
                <div style="text-align: center; margin-top: 20px;">
                    <a href="activity_log.jsp" class="link" style="color: var(--pet-teal);">
                        <i class="fas fa-list"></i> View All Activity
                    </a>
                </div>
            </div>
            
            <!-- Quick Tips Section -->
            <div class="quick-tips animate-fade-in-up">
                <h3 style="color: var(--pet-dark); margin-bottom: 15px;">
                    <i class="fas fa-lightbulb"></i> Quick Tips
                </h3>
                <div class="tip-items">
                    <div class="tip-item">
                        <i class="fas fa-camera tip-icon" style="color: var(--pet-primary);"></i>
                        Add clear photos when reporting strays
                    </div>
                    <div class="tip-item">
                        <i class="fas fa-home tip-icon" style="color: var(--pet-success);"></i>
                        Prepare your home before adopting
                    </div>
                    <div class="tip-item">
                        <i class="fas fa-phone tip-icon" style="color: var(--pet-danger);"></i>
                        Keep your contact info updated
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <!-- JavaScript for Interactive Elements -->
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            // Update greeting based on time of day
            updateGreeting();
            
            function updateGreeting() {
                const hour = new Date().getHours();
                let greeting = "Good ";
                
                if (hour < 12) greeting += "morning";
                else if (hour < 18) greeting += "afternoon";
                else greeting += "evening";
                
                // Optional: Update the welcome message
                // const welcomeHeader = document.querySelector('.welcome-banner h1');
                // if (welcomeHeader) {
                //     welcomeHeader.innerHTML = `${greeting}, <span style="font-weight: 700;">${"<%= user.getFullName() %>"}</span>!`;
                // }
            }
            
            // Add hover effects to cards
            const cards = document.querySelectorAll('.stat-card, .feature-card');
            cards.forEach(card => {
                card.addEventListener('mouseenter', function() {
                    this.style.zIndex = '10';
                });
                
                card.addEventListener('mouseleave', function() {
                    this.style.zIndex = '';
                });
            });
            
            // Animate elements on scroll
            const observerOptions = {
                threshold: 0.1,
                rootMargin: '0px 0px -50px 0px'
            };
            
            const observer = new IntersectionObserver(function(entries) {
                entries.forEach(entry => {
                    if (entry.isIntersecting) {
                        entry.target.style.opacity = '1';
                        entry.target.style.transform = 'translateY(0)';
                    }
                });
            }, observerOptions);
            
            // Observe all animated elements
            document.querySelectorAll('.animate-fade-in-up').forEach(el => {
                observer.observe(el);
            });
            
            // Sync sidebar state with main content margin
            const sidebar = document.querySelector('.sidebar-container');
            const mainContent = document.querySelector('.main-content');
            
            function updateContentMargin() {
                if (sidebar && mainContent) {
                    if (window.innerWidth > 992) {
                        if (sidebar.classList.contains('collapsed')) {
                            mainContent.style.marginLeft = '70px';
                        } else {
                            mainContent.style.marginLeft = '280px';
                        }
                    } else {
                        mainContent.style.marginLeft = '0';
                    }
                }
            }
            
            // Listen for sidebar toggle events
            const originalToggle = document.querySelector('.toggle-btn');
            if (originalToggle) {
                originalToggle.addEventListener('click', function() {
                    setTimeout(updateContentMargin, 300); // Wait for transition
                });
            }
            
            // Initial margin setup
            updateContentMargin();
            
            // Update on window resize
            window.addEventListener('resize', updateContentMargin);
        });
    </script>
</body>
</html>