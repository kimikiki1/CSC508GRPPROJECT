<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="com.petie.bean.UserBean"%>
<%
    UserBean user = (UserBean) session.getAttribute("userSession");
    if (user == null) { response.sendRedirect("login.jsp"); return; }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Account Settings</title>
    <style>
        body { font-family: Arial, sans-serif; background-color: #e0f7fa; margin: 0; }
        .settings-container { width: 50%; margin: 50px auto; background: white; padding: 30px; border-radius: 10px; box-shadow: 0 0 10px rgba(0,0,0,0.1); }
        input[type=text], input[type=email], input[type=password] { width: 100%; padding: 10px; margin: 10px 0; border: 1px solid #ccc; border-radius: 5px; }
        .save-btn { background-color: #003366; color: white; padding: 10px 20px; border: none; border-radius: 5px; cursor: pointer; width: 100%; font-size: 16px; }
        .save-btn:hover { background-color: #002244; }
    </style>
</head>
<body>

    <jsp:include page="navbar.jsp" />

    <div class="settings-container">
        <h2 style="text-align:center; color: #003366;">Account Settings</h2>
        
        <form action="UpdateProfileServlet" method="post">
            <label>Full Name</label>
            <input type="text" name="fullname" value="<%= user.getFullName() %>" required>

            <label>Username</label>
            <input type="text" name="username" value="<%= user.getUsername() %>" required>

            <label>Email Address</label>
            <input type="email" name="email" value="<%= user.getEmail() %>" readonly style="background-color: #eee;">

            <label>Phone Number</label>
            <input type="text" name="phone" value="<%= user.getPhoneNumber() %>">

            <label>Change Password</label>
            <input type="password" name="password" value="<%= user.getPassword() %>">

            <button type="submit" class="save-btn">Save Changes</button>
        </form>
    </div>

</body>
</html>