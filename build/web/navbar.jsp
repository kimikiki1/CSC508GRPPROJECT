<%@page import="com.petie.bean.UserBean"%>
<%
    UserBean navUser = (UserBean) session.getAttribute("userSession");
    String role = (navUser != null) ? navUser.getRole() : "";
%>
<div style="background-color: #003366; padding: 15px; overflow: hidden;">
    <span style="color: white; font-size: 20px; font-weight: bold; float: left; margin-left: 20px;">Petie Adoptie ?</span>
    
    <div style="float: right; margin-right: 20px;">
        <% if ("ADMIN".equals(role)) { %>
            <a href="admin_dashboard.jsp" style="color: white; text-decoration: none; margin: 0 15px;">Dashboard</a>
            <a href="admin_checklist.jsp" style="color: white; text-decoration: none; margin: 0 15px;">Manage Reports</a>
        
        <% } else if ("STAFF".equals(role)) { %>
            <a href="staff_dashboard.jsp" style="color: white; text-decoration: none; margin: 0 15px;">Dashboard</a>
            
            <a href="admin_checklist.jsp" style="color: white; text-decoration: none; margin: 0 15px;">Process Reports</a>
            
            <a href="manage_adoptions.jsp" style="color: white; text-decoration: none; margin: 0 15px;">Manage Adoptions</a>

        <% } else { %>
            <a href="home.jsp" style="color: white; text-decoration: none; margin: 0 15px;">Home</a>
            <a href="adopt_me.jsp" style="color: white; text-decoration: none; margin: 0 15px;">Adopt Me</a>
            <a href="report_stray.jsp" style="color: white; text-decoration: none; margin: 0 15px;">Report Stray</a>
            <a href="account_settings.jsp" style="color: white; text-decoration: none; margin: 0 15px;">My Account</a>
            <a href="my_reports.jsp" style="color: white; text-decoration: none; margin: 0 15px;">My Reports</a>
        <% } %>

        <span style="color: #ddd; margin-left: 20px;">Hello, <%= (navUser!=null)?navUser.getUsername():"Guest" %></span>
        <a href="LogoutServlet" style="background-color: #dc3545; color: white; padding: 5px 10px; border-radius: 3px; text-decoration: none; margin-left: 10px;">Log Out</a>
    </div>
</div>