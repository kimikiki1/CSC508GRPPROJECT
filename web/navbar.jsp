<%@page import="com.petie.bean.UserBean"%>
<%
    // This will now have the USERNAME and USER_ID because we fixed the DAO
    com.petie.bean.UserBean navUser = (com.petie.bean.UserBean) session.getAttribute("userSession");
    String role = (navUser != null) ? navUser.getRole() : "";
%>
<style>
    /* Global Navbar Styles */
    .navbar { background-color: #003366; padding: 15px; color: white; display: flex; justify-content: space-between; align-items: center; }
    .navbar a { color: white; text-decoration: none; margin: 0 15px; font-weight: bold; font-family: Arial, sans-serif; }
    .navbar a:hover { text-decoration: underline; color: #ffcc00; }
    .nav-right { display: flex; align-items: center; }
    .logout-btn { background-color: #dc3545; padding: 8px 15px; border-radius: 5px; }
</style>

<div class="navbar">
    <div class="logo" style="font-size: 24px; font-weight: bold;">Petie Adoptie ?</div>
    
    <div class="nav-links">
        <% if ("ADMIN".equals(role)) { %>
            <a href="admin_dashboard.jsp">Dashboard</a>
            <a href="admin_checklist.jsp">Manage Reports</a>
            <a href="manage_users.jsp">Users</a>
        <% } else { %>
            <a href="home.jsp">Home</a>
            <a href="adopt_me.jsp">Adopt Me</a>
            <a href="report_stray.jsp">Report Stray</a>
            <a href="account_settings.jsp">My Account</a>
        <% } %>
    </div>

    <div class="nav-right">
        <% if (navUser != null) { %>
            <span style="margin-right: 15px;">Hello, <%= navUser.getUsername() %></span>
            <a href="LogoutServlet" class="logout-btn">Log Out</a>
        <% } else { %>
            <a href="login.jsp">Log In</a>
        <% } %>
    </div>
</div>