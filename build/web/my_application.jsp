<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="com.petie.bean.UserBean"%>
<%
    UserBean user = (UserBean) session.getAttribute("userSession");
    if (user == null) { 
        response.sendRedirect("login.jsp"); 
        return; 
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
        /* CSS Variables */
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
            --box-shadow-md: 0 4px 10px rgba(0,0,0,0.1);
            --box-shadow-lg: 0 8px 20px rgba(0,0,0,0.15);
        }
        
        /* Basic Styles */
        * { margin: 0; padding: 0; box-sizing: border-box; }
        
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #f5f7fa;
            color: #333;
            min-height: 100vh;
        }
        
        /* Navigation */
        .top-nav {
            background: linear-gradient(to right, #4a90e2, #2c3e50);
            color: white;
            padding: 15px 20px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        
        .logo {
            display: flex;
            align-items: center;
            gap: 10px;
            font-size: 20px;
            font-weight: bold;
        }
        
        .nav-links a {
            color: white;
            text-decoration: none;
            margin-left: 20px;
            padding: 8px 15px;
            border-radius: 4px;
        }
        
        .nav-links a:hover {
            background: rgba(255,255,255,0.1);
        }
        
        /* Main Content */
        .main-content {
            padding: 40px 20px;
            max-width: 1200px;
            margin: 0 auto;
        }
        
        /* Page Header */
        .page-header {
            background: linear-gradient(to right, #4a90e2, #3498db);
            color: white;
            border-radius: 10px;
            padding: 25px 30px;
            margin-bottom: 30px;
            box-shadow: 0 8px 20px rgba(0,0,0,0.15);
        }
        
        .page-header h1 {
            font-size: 28px;
            display: flex;
            align-items: center;
            gap: 15px;
        }
        
        .page-subtitle {
            opacity: 0.9;
            margin-top: 10px;
        }
        
        /* Card */
        .card {
            background: white;
            border-radius: 10px;
            box-shadow: 0 5px 20px rgba(0,0,0,0.08);
            padding: 30px;
            margin-top: 20px;
        }
        
        /* Empty State */
        .empty-state {
            text-align: center;
            padding: 60px 20px;
        }
        
        .empty-icon {
            font-size: 80px;
            color: #ddd;
            margin-bottom: 20px;
        }
        
        .empty-state h3 {
            color: #2c3e50;
            margin-bottom: 10px;
        }
        
        .empty-state p {
            color: #666;
            margin-bottom: 20px;
        }
        
        .btn {
            padding: 12px 25px;
            border-radius: 8px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            text-decoration: none;
            border: none;
        }
        
        .btn-primary {
            background: #4a90e2;
            color: white;
        }
        
        .btn-primary:hover {
            background: #357ae8;
        }
    </style>
</head>
<body>
    <!-- Navigation -->
    <nav class="top-nav">
        <div class="logo">
            <i class="fas fa-paw"></i>
            <span>Petie Adoption System</span>
        </div>
        <div class="nav-links">
            <a href="home.jsp"><i class="fas fa-home"></i> Home</a>
            <a href="my_application.jsp" style="background: rgba(255,255,255,0.2);">
                <i class="fas fa-file-alt"></i> My Applications
            </a>
            <a href="logout.jsp"><i class="fas fa-sign-out-alt"></i> Logout</a>
        </div>
    </nav>
    
    <!-- Main Content -->
    <main class="main-content">
        <!-- Page Header -->
        <div class="page-header">
            <h1><i class="fas fa-file-alt"></i> My Applications</h1>
            <p class="page-subtitle">Track and manage all your pet adoption applications</p>
        </div>
        
        <!-- Main Card -->
        <div class="card">
            <div class="empty-state">
                <div class="empty-icon">
                    <i class="fas fa-file-alt"></i>
                </div>
                <h3>Coming Soon!</h3>
                <p>The My Applications feature is currently being developed.</p>
                <p>You'll be able to track all your adoption applications here soon.</p>
                <br>
                <a href="adopt_me.jsp" class="btn btn-primary">
                    <i class="fas fa-paw"></i> Browse Available Pets
                </a>
            </div>
        </div>
    </main>
    
    <script>
        // Simple JavaScript for future functionality
        console.log("My Applications page loaded");
    </script>
</body>
</html>