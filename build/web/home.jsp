<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="com.petie.bean.UserBean"%>
<%
    // Security Check: Ensure user is logged in
    UserBean user = (UserBean) session.getAttribute("userSession");
    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Home - Petie Adoptie</title>
    <style>
        body { font-family: Arial, sans-serif; background-color: #87ceeb; margin: 0; }
        .navbar { background-color: #003366; padding: 15px; color: white; display: flex; justify-content: space-between; align-items: center; }
        .navbar a { color: white; text-decoration: none; margin: 0 15px; font-weight: bold; }
        .navbar a:hover { text-decoration: underline; }
        .container { text-align: center; padding: 50px; }
        .card { 
            background-color: white; 
            width: 250px; 
            display: inline-block; 
            margin: 20px; 
            padding: 20px; 
            border-radius: 10px; 
            box-shadow: 0 4px 8px rgba(0,0,0,0.2); 
            vertical-align: top;
        }
        .btn { 
            background-color: #28a745; 
            color: white; 
            padding: 10px 20px; 
            text-decoration: none; 
            border-radius: 5px; 
            display: inline-block; 
            margin-top: 10px; 
        }
        .welcome-banner { background-color: white; padding: 20px; border-radius: 10px; width: 80%; margin: auto; }
    </style>
</head>
<body>

    <div class="navbar">
        <div class="logo">Petie Adoptie</div>
        <div>
            <a href="home.jsp">Home</a>
            <a href="adopt_me.jsp">Adopt Me</a>
            <a href="report_stray.jsp">Report Stray Pet</a>
            <a href="account_settings.jsp">My Account</a> 
        </div>
        <div>
            <span>Welcome, <%= user.getUsername() %>!</span>
            <a href="LogoutServlet" style="background-color: #dc3545; padding: 5px 10px; border-radius: 5px;">Log Out</a>
        </div>
    </div>

    <div class="container">
        <div class="welcome-banner">
            <h1>Welcome back, <%= user.getFullName() %>!</h1>
            <p>What would you like to do today?</p>
        </div>

        <br><br>

        <div class="card">
            <h3>Report a Stray</h3>
            <p>Found a stray animal? Report it here so our team can rescue it.</p>
            <a href="report_stray.jsp" class="btn">Report Now</a>
        </div>

        <div class="card">
            <h3>Adopt a Pet</h3>
            <p>Browse our list of lovable pets waiting for a forever home.</p>
            <a href="adopt_me.jsp" class="btn">Find a Pet</a>
        </div>

        <div class="card">
            <h3>My Profile</h3>
            <p>Update your contact info or view your adoption history.</p>
            <a href="account_settings.jsp" class="btn" style="background-color: #007bff;">Manage Profile</a>
        </div>
    </div>
 
</body>
</html>