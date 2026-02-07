<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="com.petie.bean.UserBean"%>
<%@page import="com.petie.util.DBConnection"%>
<%@page import="java.sql.*"%>

<%
    // 2. SECURITY CHECK: Only allow STAFF
    UserBean user = (UserBean) session.getAttribute("userSession");
    if (user == null || !"STAFF".equals(user.getRole())) {
        response.sendRedirect("login.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>Manage Adoptions</title>
    <style>
        body { font-family: Arial, sans-serif; background-color: #f4f4f4; margin: 0; }
        .content { padding: 40px; margin: auto; max-width: 1000px; background: white; border-radius: 8px; box-shadow: 0 0 10px rgba(0,0,0,0.1); margin-top: 30px; }
        h1 { color: #003366; border-bottom: 2px solid #eee; padding-bottom: 10px; }
        
        table { width: 100%; border-collapse: collapse; margin-top: 20px; }
        th, td { padding: 12px; border: 1px solid #ddd; text-align: left; vertical-align: middle; }
        th { background-color: #003366; color: white; }
        tr:nth-child(even) { background-color: #f9f9f9; }
        
        /* Thumbnail Image */
        .pet-thumb { width: 60px; height: 60px; object-fit: cover; border-radius: 5px; border: 1px solid #ddd; }
        
        /* Buttons */
        .btn { padding: 8px 12px; text-decoration: none; color: white; border-radius: 4px; font-weight: bold; margin-right: 5px; font-size: 14px; }
        .btn-approve { background-color: #28a745; }
        .btn-reject { background-color: #dc3545; }
        .btn:hover { opacity: 0.8; }
    </style>
</head>
<body>

    <jsp:include page="navbar.jsp" />

    <div class="content">
        <h1>Adoption Requests</h1>
        <p>Review applications from users who want to adopt pets currently in the Centre.</p>

        <table>
            <tr>
                <th>Pet</th>
                <th>Type</th>
                <th>Applicant Name</th>
                <th>Contact</th>
                <th>Action</th>
            </tr>
            <%
                Connection con = null;
                try {
                    con = DBConnection.createConnection();
                    
                    // 3. COMPLEX QUERY: Join 3 tables to get all details
                    // We only want PENDING requests
                    String sql = "SELECT r.REQUEST_ID, s.STRAY_ID, s.PET_TYPE, s.PET_PHOTO, u.FULL_NAME, u.PHONE_NUMBER " +
                                 "FROM ADOPTION_REQUESTS r " +
                                 "JOIN USERS u ON r.USER_ID = u.USER_ID " +
                                 "JOIN STRAY_REPORT s ON r.STRAY_ID = s.STRAY_ID " +
                                 "WHERE r.STATUS = 'PENDING'";
                                 
                    PreparedStatement ps = con.prepareStatement(sql);
                    ResultSet rs = ps.executeQuery();
                    
                    boolean hasData = false;
                    while(rs.next()) {
                        hasData = true;
            %>
            <tr>
                <td>
                    <img src="ImageServlet/<%= rs.getString("PET_PHOTO") %>" class="pet-thumb" alt="Pet">
                </td>
                <td><%= rs.getString("PET_TYPE") %></td>
                <td>
                    <b><%= rs.getString("FULL_NAME") %></b>
                </td>
                <td><%= rs.getString("PHONE_NUMBER") %></td>
                <td>
                    <a href="ProcessAdoptionServlet?id=<%= rs.getInt("REQUEST_ID") %>&action=approve" 
                       class="btn btn-approve"
                       onclick="return confirm('Are you sure? This will remove the pet from the Adopt Me page.');">
                       Approve
                    </a>
                    
                    <a href="ProcessAdoptionServlet?id=<%= rs.getInt("REQUEST_ID") %>&action=reject" 
                       class="btn btn-reject"
                       onclick="return confirm('Reject this application?');">
                       Reject
                    </a>
                </td>
            </tr>
            <% 
                    } 
                    if(!hasData) { 
                        out.println("<tr><td colspan='5' style='text-align:center; padding:30px; color:#777;'>No pending adoption requests.</td></tr>"); 
                    }
                } catch(Exception e) {
                    e.printStackTrace();
                    out.println("<tr><td colspan='5' style='color:red;'>Error: " + e.getMessage() + "</td></tr>");
                } finally {
                    if(con != null) con.close();
                }
            %>
        </table>
    </div>

</body>
</html>