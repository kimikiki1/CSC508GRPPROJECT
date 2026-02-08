<%@page import="java.sql.*"%>
<%@page import="com.petie.util.DBConnection"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Manage Users | Admin</title>
    <link rel="stylesheet" type="text/css" href="style.css">
    
    <style>
        /* Specific Styles for the User Table matching your theme */
        .table-responsive {
            overflow-x: auto;
        }
        
        .styled-table {
            width: 100%;
            border-collapse: collapse;
            margin: 25px 0;
            font-size: 0.95em;
            background-color: white;
            box-shadow: 0 0 20px rgba(0, 0, 0, 0.05);
            border-radius: var(--border-radius);
            overflow: hidden;
        }

        .styled-table thead tr {
            background-color: var(--primary);
            color: #ffffff;
            text-align: left;
        }

        .styled-table th, .styled-table td {
            padding: 12px 15px;
            border-bottom: 1px solid var(--light-gray);
        }

        .styled-table tbody tr {
            transition: background-color 0.2s;
        }

        .styled-table tbody tr:hover {
            background-color: var(--light);
        }

        /* Action Buttons */
        .action-btn {
            padding: 6px 12px;
            font-size: 14px;
            margin-right: 5px;
            text-decoration: none;
            border-radius: 4px;
            display: inline-block;
            color: white;
            transition: opacity 0.2s;
        }
        
        .btn-edit { background-color: var(--secondary); }
        .btn-delete { background-color: var(--danger); }
        
        .action-btn:hover { opacity: 0.8; color: white; }

        .role-badge {
            padding: 4px 8px;
            border-radius: 12px;
            font-size: 12px;
            font-weight: bold;
            background-color: var(--light-gray);
            color: var(--dark);
        }
    </style>
</head>
<body>

    <jsp:include page="navbar.jsp" />

    <div class="container mt-4">
        
        <div style="text-align: center; margin-bottom: 30px; color: white;">
            <h1 style="font-weight: 700;">User Management</h1>
            <p style="opacity: 0.9;">View, Edit, or Delete system users</p>
        </div>

        <div class="card">
            <div class="card-header">
                <h1>Registered Accounts</h1>
                <p>List of all users currently in the database</p>
            </div>
            
            <div class="card-body">
                
                <%-- Database Logic Starts Here --%>
                <%
                    Connection conn = null;
                    Statement stmt = null;
                    ResultSet rs = null;
                    
                    try {
                        // 1. USE YOUR UTILITY CLASS HERE
                        conn = DBConnection.createConnection();
                        
                        if (conn != null) {
                            // 2. Create Query
                            String sql = "SELECT USER_ID, USERNAME, EMAIL, FULL_NAME, PHONE_NUMBER, ROLE FROM users";
                            stmt = conn.createStatement();
                            rs = stmt.executeQuery(sql);
                %>

                <div class="table-responsive">
                    <table class="styled-table">
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Full Name</th>
                                <th>Username</th>
                                <th>Email</th>
                                <th>Phone</th>
                                <th>Role</th>
                                <th>Password</th>
                                <th style="text-align: center;">Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                while(rs.next()) {
                                    int userId = rs.getInt("USER_ID");
                                    String role = rs.getString("ROLE");
                            %>
                            <tr>
                                <td>#<%= userId %></td>
                                <td style="font-weight: 600;"><%= rs.getString("FULL_NAME") %></td>
                                <td><%= rs.getString("USERNAME") %></td>
                                <td><%= rs.getString("EMAIL") %></td>
                                <td><%= rs.getString("PHONE_NUMBER") %></td>
                                <td><span class="role-badge"><%= role %></span></td>
                                
                                <td style="color: var(--gray); letter-spacing: 2px;">••••••••</td>
                                
                                <td style="text-align: center;">
                                    <a href="edit_user.jsp?id=<%= userId %>" class="action-btn btn-edit">Edit</a>
                                    <a href="delete_user_action.jsp?id=<%= userId %>" 
                                       class="action-btn btn-delete"
                                       onclick="return confirm('Delete user <%= rs.getString("USERNAME") %>?');">
                                        Delete
                                    </a>
                                </td>
                            </tr>
                            <%
                                } // End While Loop
                            %>
                        </tbody>
                    </table>
                </div>

                <%
                        } else {
                %>
                    <div class="alert alert-danger">
                        <strong>Error:</strong> Could not connect to the database. Please check your DBConnection class.
                    </div>
                <%
                        }
                    } catch (Exception e) {
                %>
                    <div class="alert alert-danger">
                        <strong>Error:</strong> <%= e.getMessage() %>
                    </div>
                <%
                    } finally {
                        // Clean up resources
                        if(rs != null) rs.close();
                        if(stmt != null) stmt.close();
                        if(conn != null) conn.close();
                    }
                %>
                
            </div>
        </div>
    </div>

</body>
</html>