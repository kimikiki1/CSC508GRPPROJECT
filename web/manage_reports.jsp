<%@page import="java.util.List"%>
<%@page import="com.petie.bean.StraysBean"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Manage Stray Reports | Staff Dashboard</title>
    <link rel="stylesheet" type="text/css" href="style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <style>
        /* Table Styles */
        .table-responsive { overflow-x: auto; }
        .styled-table { width: 100%; border-collapse: collapse; margin: 25px 0; background-color: white; border-radius: 8px; overflow: hidden; box-shadow: 0 0 20px rgba(0,0,0,0.1); }
        .styled-table thead tr { background-color: var(--primary, #4a90e2); color: white; text-align: left; }
        .styled-table th, .styled-table td { padding: 12px 15px; border-bottom: 1px solid #ddd; vertical-align: middle; }
        .styled-table tbody tr:hover { background-color: #f3f3f3; }

        /* Thumbnails */
        .pet-thumbnail { width: 80px; height: 80px; object-fit: cover; border-radius: 8px; border: 2px solid #eee; transition: transform 0.2s; }
        .pet-thumbnail:hover { transform: scale(1.5); border-color: var(--primary, #4a90e2); z-index: 10; position: relative; }

        /* Text truncation */
        .situation-text { font-size: 0.9em; color: #555; max-width: 250px; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; cursor: help; }

        /* Status Badges */
        .status-badge { padding: 5px 10px; border-radius: 20px; font-size: 12px; font-weight: bold; text-transform: uppercase; }
        .status-pending { background-color: #ffeeba; color: #856404; }
        .status-foster { background-color: #d4edda; color: #155724; }
        .status-center { background-color: #cce5ff; color: #004085; }
        .status-rejected { background-color: #f8d7da; color: #721c24; }

        /* Buttons */
        .action-group { display: flex; gap: 5px; }
        .btn-sm { padding: 6px 10px; font-size: 12px; border: none; border-radius: 4px; cursor: pointer; color: white; text-decoration: none; display: inline-flex; align-items: center; gap: 4px; transition: opacity 0.2s; }
        .btn-sm:hover { opacity: 0.9; transform: translateY(-1px); }
        
        .btn-foster { background-color: #2ecc71; }
        .btn-center { background-color: #3498db; }
        .btn-reject { background-color: #e74c3c; }
    </style>
</head>
<body>

    <jsp:include page="navbar.jsp" />

    <div class="container mt-4">
        
        <div style="text-align: center; margin-bottom: 30px; color: white;">
            <h1 style="font-weight: 700;">Stray Reports Management</h1>
            <p style="opacity: 0.9;">Review incoming reports and assign actions.</p>
        </div>

        <div class="card">
            <div class="card-header">
                <h1><i class="fas fa-clipboard-list"></i> Active Reports</h1>
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
                                <th>Status</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% 
                                List<StraysBean> list = (List<StraysBean>) request.getAttribute("reportList");
                                if(list != null && !list.isEmpty()) {
                                    for(StraysBean r : list) {
                                        // Determine badge color
                                        String badgeClass = "status-pending";
                                        String status = r.getStatus();
                                        if("FOSTER".equals(status)) badgeClass = "status-foster";
                                        else if("CENTER".equals(status)) badgeClass = "status-center";
                                        else if("REJECTED".equals(status)) badgeClass = "status-rejected";
                            %>
                            <tr>
                                <td>#<%= r.getStrayId() %></td>
                                
                                <td>
                                    <img src="uploads/<%= r.getPetPhoto() %>" alt="Pet" class="pet-thumbnail" 
                                         onerror="this.src='https://via.placeholder.com/80?text=No+Img'">
                                </td>

                                <td>
                                    <strong><%= r.getPetType() %></strong>
                                </td>

                                <td>
                                    <div style="font-size: 0.9em;">
                                        <i class="fas fa-map-marker-alt" style="color:#e74c3c;"></i> <%= r.getLocationFound() %><br>
                                        <i class="far fa-calendar-alt" style="color:#666;"></i> <%= r.getDateFound() %>
                                    </div>
                                </td>

                                <td>
                                    <div class="situation-text" title="<%= r.getSituation() %>">
                                        <%= r.getSituation() %>
                                    </div>
                                </td>

                                <td><%= r.getReporterName() %></td>

                                <td><span class="status-badge <%= badgeClass %>"><%= status == null ? "PENDING" : status %></span></td>

                                <td>
                                    <div class="action-group">
                                        <a href="UpdateReportStatusServlet?id=<%= r.getStrayId() %>&status=FOSTER" 
                                           class="btn-sm btn-foster" title="Approve for Foster">
                                            <i class="fas fa-home"></i> Foster
                                        </a>

                                        <a href="UpdateReportStatusServlet?id=<%= r.getStrayId() %>&status=CENTER" 
                                           class="btn-sm btn-center" title="Send to Center">
                                            <i class="fas fa-clinic-medical"></i> Center
                                        </a>

                                        <a href="UpdateReportStatusServlet?id=<%= r.getStrayId() %>&status=REJECTED" 
                                           class="btn-sm btn-reject" title="Reject Report"
                                           onclick="return confirm('Reject this report?');">
                                            <i class="fas fa-times"></i> Reject
                                        </a>
                                    </div>
                                </td>
                            </tr>
                            <% 
                                    } 
                                } else {
                            %>
                            <tr><td colspan="8" style="text-align:center; padding: 30px; color: #777;">No reports found in database.</td></tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>

</body>
</html>