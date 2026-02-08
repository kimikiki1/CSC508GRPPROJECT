<%@page import="java.sql.*"%>
<%@page import="com.petie.util.DBConnection"%>
<%@page import="com.petie.bean.UserBean"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Process Reports | Admin</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <style>
        /* Shared Styles (Copied from your request) */
        body { font-family: 'Segoe UI', sans-serif; background-color: #f4f6f9; margin: 0; }
        .container { max-width: 1200px; margin: 0 auto; padding: 20px; }
        
        /* Layout Wrapper to fix Sidebar overlap */
        .main-content {
            margin-left: 280px; 
            padding: 30px;
            min-height: 100vh;
        }

        /* Card Styles */
        .card { background: white; border-radius: 12px; box-shadow: 0 4px 15px rgba(0,0,0,0.1); overflow: hidden; }
        .card-header { background: linear-gradient(135deg, #4a90e2 0%, #3498db 100%); color: white; padding: 20px; }
        .card-header h1 { margin: 0; font-size: 1.5rem; display: flex; align-items: center; gap: 10px; }
        .card-body { padding: 20px; }

        /* Table Styles */
        .table-responsive { overflow-x: auto; }
        .styled-table { width: 100%; border-collapse: collapse; margin-top: 10px; }
        .styled-table thead tr { background-color: #f8f9fa; color: #34495e; text-align: left; }
        .styled-table th, .styled-table td { padding: 15px; border-bottom: 1px solid #eee; vertical-align: middle; }
        .styled-table tbody tr:hover { background-color: #fbfbfb; }

        /* Thumbnails */
        .pet-thumbnail { 
            width: 80px; height: 80px; object-fit: cover; border-radius: 8px; 
            border: 2px solid #eee; transition: transform 0.2s; 
        }
        .pet-thumbnail:hover { transform: scale(2.5); border-color: #4a90e2; z-index: 10; position: relative; box-shadow: 0 5px 15px rgba(0,0,0,0.2); }

        /* Status Badges */
        .status-badge { padding: 5px 12px; border-radius: 20px; font-size: 11px; font-weight: 700; text-transform: uppercase; }
        .status-pending { background-color: #fff3cd; color: #856404; }
        
        /* Buttons */
        .action-group { display: flex; gap: 5px; flex-wrap: wrap; }
        .btn-sm { 
            padding: 6px 10px; font-size: 12px; border: none; border-radius: 4px; 
            cursor: pointer; color: white; text-decoration: none; 
            display: inline-flex; align-items: center; gap: 4px; transition: opacity 0.2s; 
        }
        .btn-sm:hover { opacity: 0.9; transform: translateY(-1px); }
        
        .btn-foster { background-color: #2ecc71; } /* Green */
        .btn-center { background-color: #3498db; } /* Blue */
        .btn-reject { background-color: #e74c3c; } /* Red */

        @media (max-width: 992px) { .main-content { margin-left: 0; } }
    </style>
</head>
<body>

    <jsp:include page="navbar.jsp" />

    <div class="main-content">
        <div class="container">
            
            <div style="text-align: center; margin-bottom: 30px; color: #34495e;">
                <h1 style="font-weight: 700;">Process Reports</h1>
                <p style="opacity: 0.7;">Review new stray animal reports and decide the next step.</p>
            </div>

            <div class="card">
                <div class="card-header">
                    <h1><i class="fas fa-clipboard-list"></i> Pending Reports</h1>
                </div>
                
                <div class="card-body">
                    <div class="table-responsive">
                        <table class="styled-table">
                            <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>Photo</th>
                                    <th>Pet Details</th>
                                    <th>Location & Date</th>
                                    <th>Situation</th>
                                    <th>Reporter</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% 
                                    Connection con = null;
                                    try {
                                        con = DBConnection.createConnection();
                                        
                                        // JOIN Query to get Reporter Name + Stray Details
                                        // We only show 'PENDING' reports here
                                        String sql = "SELECT S.STRAY_ID, S.PET_TYPE, S.LOCATION_FOUND, S.DATE_FOUND, " +
                                                     "S.SITUATION, S.PET_PHOTO, U.FULL_NAME " +
                                                     "FROM STRAY_REPORT S " +
                                                     "JOIN USERS U ON S.USER_ID = U.USER_ID " +
                                                     "WHERE S.STATUS = 'PENDING' " +
                                                     "ORDER BY S.STRAY_ID DESC";
                                                     
                                        PreparedStatement ps = con.prepareStatement(sql);
                                        ResultSet rs = ps.executeQuery();
                                        
                                        boolean hasData = false;
                                        while(rs.next()) {
                                            hasData = true;
                                            int id = rs.getInt("STRAY_ID");
                                %>
                                <tr>
                                    <td>#<%= id %></td>
                                    
                                    <td>
                                        <img src="ImageServlet/<%= rs.getString("PET_PHOTO") %>" 
                                             class="pet-thumbnail" 
                                             onerror="this.src='https://via.placeholder.com/80?text=No+Img'">
                                    </td>

                                    <td>
                                        <strong style="color: #2c3e50; font-size: 1.1em;"><%= rs.getString("PET_TYPE") %></strong>
                                    </td>

                                    <td>
                                        <div style="font-size: 0.9em; line-height: 1.4;">
                                            <i class="fas fa-map-marker-alt" style="color:#e74c3c;"></i> <%= rs.getString("LOCATION_FOUND") %><br>
                                            <i class="far fa-calendar-alt" style="color:#666;"></i> <%= rs.getDate("DATE_FOUND") %>
                                        </div>
                                    </td>

                                    <td>
                                        <div style="max-width: 250px; font-size: 0.9em; color: #555;">
                                            <%= rs.getString("SITUATION") %>
                                        </div>
                                    </td>

                                    <td>
                                        <span style="font-weight: 500; color: #3498db;">
                                            <i class="fas fa-user-circle"></i> <%= rs.getString("FULL_NAME") %>
                                        </span>
                                    </td>

                                    <td>
                                        <div class="action-group">
                                            <a href="UpdateReportStatusServlet?id=<%= id %>&status=WAITING_ADMIN_FOSTER" 
                                               class="btn-sm btn-foster" title="Send to Foster Care">
                                                <i class="fas fa-home"></i> Foster
                                            </a>

                                            <a href="UpdateReportStatusServlet?id=<%= id %>&status=IN_CENTRE" 
                                               class="btn-sm btn-center" title="Send to Shelter">
                                                <i class="fas fa-clinic-medical"></i> Centre
                                            </a>

                                            <a href="UpdateReportStatusServlet?id=<%= id %>&status=REJECTED" 
                                               class="btn-sm btn-reject" 
                                               onclick="return confirm('Are you sure you want to reject this report?');">
                                                <i class="fas fa-times"></i> Reject
                                            </a>
                                        </div>
                                    </td>
                                </tr>
                                <% 
                                        }
                                        if(!hasData) {
                                %>
                                <tr>
                                    <td colspan="7" style="text-align:center; padding: 40px; color: #7f8c8d;">
                                        <i class="fas fa-check-circle" style="font-size: 40px; color: #2ecc71; margin-bottom: 10px;"></i><br>
                                        All caught up! No pending reports.
                                    </td>
                                </tr>
                                <% 
                                        }
                                    } catch(Exception e) {
                                        out.println("<tr><td colspan='7' style='color:red'>Error: " + e.getMessage() + "</td></tr>");
                                        e.printStackTrace();
                                    } finally {
                                        if(con != null) con.close();
                                    }
                                %>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>

</body>
</html>