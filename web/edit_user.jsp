<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="com.petie.bean.UserBean"%>
<%@page import="com.petie.util.DBConnection"%>
<%@page import="java.sql.*"%>

<%
    // Security Check
    UserBean admin = (UserBean) session.getAttribute("userSession");
    if (admin == null || !admin.getRole().equals("ADMIN")) {
        response.sendRedirect("login.jsp");
        return;
    }

    String editId = request.getParameter("id");
    String eName="", eUser="", eEmail="", ePhone="", eRole="";
    
    // Fetch current user data to pre-fill the form
    if(editId != null) {
        try {
            Connection con = DBConnection.createConnection();
            PreparedStatement ps = con.prepareStatement("SELECT * FROM USERS WHERE USER_ID = ?");
            ps.setInt(1, Integer.parseInt(editId));
            ResultSet rs = ps.executeQuery();
            if(rs.next()) {
                eName = rs.getString("FULL_NAME");
                eUser = rs.getString("USERNAME");
                eEmail = rs.getString("EMAIL");
                ePhone = rs.getString("PHONE_NUMBER");
                eRole = rs.getString("ROLE");
            }
            con.close();
        } catch(Exception e) { e.printStackTrace(); }
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>Edit User</title>
    <style>
        body { font-family: Arial, sans-serif; background-color: #f4f6f9; display: flex; justify-content: center; padding-top: 50px; }
        .edit-card { background: white; padding: 40px; border-radius: 8px; box-shadow: 0 4px 12px rgba(0,0,0,0.1); width: 400px; }
        h2 { text-align: center; color: #333; margin-bottom: 20px; }
        .form-group { margin-bottom: 15px; }
        label { display: block; margin-bottom: 5px; color: #666; font-size: 14px; }
        input, select { width: 100%; padding: 10px; border: 1px solid #ddd; border-radius: 4px; box-sizing: border-box; }
        .btn-save { width: 100%; background: #28a745; color: white; border: none; padding: 12px; border-radius: 4px; cursor: pointer; font-size: 16px; margin-top: 10px; }
        .btn-cancel { display: block; text-align: center; margin-top: 15px; text-decoration: none; color: #666; font-size: 14px; }
        .btn-save:hover { background: #218838; }
    </style>
</head>
<body>

    <div class="edit-card">
        <h2>Edit User #<%= editId %></h2>
        
        <form action="UpdateUserServlet" method="post">
            <input type="hidden" name="userId" value="<%= editId %>">
            
            <div class="form-group">
                <label>Full Name</label>
                <input type="text" name="fullName" value="<%= eName %>" required>
            </div>
            
            <div class="form-group">
                <label>Username</label>
                <input type="text" name="username" value="<%= eUser %>" required>
            </div>
            
            <div class="form-group">
                <label>Email</label>
                <input type="email" name="email" value="<%= eEmail %>" required>
            </div>

            <div class="form-group">
                <label>Phone Number</label>
                <input type="text" name="phone" value="<%= ePhone %>">
            </div>

            <div class="form-group">
                <label>Role</label>
                <select name="role">
                    <option value="USER" <%= "USER".equals(eRole) ? "selected" : "" %>>User</option>
                    <option value="STAFF" <%= "STAFF".equals(eRole) ? "selected" : "" %>>Staff</option>
                    <option value="ADMIN" <%= "ADMIN".equals(eRole) ? "selected" : "" %>>Admin</option>
                </select>
            </div>

            <button type="submit" class="btn-save">Save Changes</button>
            <a href="manage_users.jsp" class="btn-cancel">Cancel</a>
        </form>
    </div>

</body>
</html>