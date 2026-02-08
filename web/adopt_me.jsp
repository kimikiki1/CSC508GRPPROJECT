<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="com.petie.util.DBConnection"%>
<%@page import="java.sql.*"%>
<%@page import="com.petie.bean.UserBean"%>

<%
    // Security Check
    UserBean user = (UserBean) session.getAttribute("userSession");
    if (user == null) { response.sendRedirect("login.jsp"); return; }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Adopt a Pet - Petie Adoptie</title>
    <link rel="stylesheet" href="style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <style>
        /* --- LAYOUT & THEME --- */
        .adopt-container { max-width: 1200px; margin: 0 auto; }
        .main-content { margin-left: 280px; padding: 30px; min-height: 100vh; }
        
        /* Banner */
        .page-header { background: linear-gradient(135deg, #f39c12 0%, #e67e22 100%); color: white; border-radius: 12px; padding: 30px; margin-bottom: 30px; box-shadow: 0 4px 10px rgba(0,0,0,0.1); }
        .page-header h1 { margin: 0; font-size: 2rem; display: flex; align-items: center; gap: 10px; }

        /* Grid Layout */
        .pets-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(300px, 1fr)); gap: 30px; }
        
        /* Pet Card */
        .pet-card { background: white; border-radius: 15px; overflow: hidden; box-shadow: 0 5px 15px rgba(0,0,0,0.05); transition: transform 0.3s; display: flex; flex-direction: column; }
        .pet-card:hover { transform: translateY(-8px); box-shadow: 0 15px 30px rgba(0,0,0,0.1); }
        
        /* Image Area */
        .pet-image-container { position: relative; height: 220px; overflow: hidden; background: #eee; }
        .pet-image { width: 100%; height: 100%; object-fit: cover; transition: transform 0.5s; }
        .pet-card:hover .pet-image { transform: scale(1.05); }
        
        /* Status Badge */
        .pet-status { position: absolute; top: 15px; right: 15px; padding: 6px 14px; border-radius: 20px; font-size: 11px; font-weight: 800; color: white; text-transform: uppercase; box-shadow: 0 2px 5px rgba(0,0,0,0.2); }
        .st-center { background: #3498db; }
        .st-foster { background: #2ecc71; }

        /* Card Info */
        .pet-info { padding: 25px; flex-grow: 1; display: flex; flex-direction: column; }
        .pet-name { font-size: 1.4rem; font-weight: 800; color: #2c3e50; margin-bottom: 5px; }
        .pet-meta { color: #7f8c8d; font-size: 0.9rem; margin-bottom: 15px; display: flex; align-items: center; gap: 6px; }
        
        /* View Button */
        .view-btn { width: 100%; padding: 12px; background: white; color: #333; border: 2px solid #eee; border-radius: 8px; font-weight: 600; cursor: pointer; transition: all 0.2s; margin-top: auto; }
        .view-btn:hover { background: #f39c12; color: white; border-color: #f39c12; }

        /* --- MODAL (POPUP) STYLES --- */
        .modal { display: none; position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(0,0,0,0.8); z-index: 2000; align-items: center; justify-content: center; backdrop-filter: blur(5px); }
        .modal-content { background: white; width: 90%; max-width: 800px; border-radius: 15px; overflow: hidden; display: flex; animation: zoomIn 0.3s ease; box-shadow: 0 20px 50px rgba(0,0,0,0.3); }
        @keyframes zoomIn { from { transform: scale(0.9); opacity: 0; } to { transform: scale(1); opacity: 1; } }

        /* Modal Layout */
        .modal-image-col { width: 50%; background: #000; display: flex; align-items: center; justify-content: center; }
        .modal-img { width: 100%; height: 100%; object-fit: cover; max-height: 500px; }
        
        .modal-info-col { width: 50%; padding: 40px; display: flex; flex-direction: column; position: relative; }
        .close-btn { position: absolute; top: 15px; right: 20px; font-size: 28px; cursor: pointer; color: #aaa; transition: color 0.2s; }
        .close-btn:hover { color: #333; }

        .modal-title { font-size: 2rem; font-weight: 800; color: #2c3e50; margin: 0 0 10px 0; }
        .modal-badge { display: inline-block; padding: 5px 12px; border-radius: 4px; font-size: 12px; font-weight: bold; color: white; margin-bottom: 20px; }
        .modal-desc { font-size: 1rem; color: #555; line-height: 1.6; margin-bottom: 30px; }
        
        .contact-box { background: #f8f9fa; padding: 15px; border-radius: 8px; border-left: 4px solid #f39c12; }
        .contact-box h4 { margin: 0 0 5px 0; color: #333; }
        .contact-box p { margin: 0; font-size: 0.9rem; color: #666; }

        /* Mobile Responsive */
        @media (max-width: 768px) {
            .modal-content { flex-direction: column; max-height: 90vh; overflow-y: auto; }
            .modal-image-col, .modal-info-col { width: 100%; }
            .modal-img { height: 250px; }
            .main-content { margin-left: 0; }
        }
    </style>
</head>
<body>

    <jsp:include page="navbar.jsp" />

    <div class="main-content">
        <div class="adopt-container">
            
            <div class="page-header">
                <h1><i class="fas fa-paw"></i> Adopt a Pet</h1>
                <p>Browse our gallery of pets looking for a forever home.</p>
            </div>

            <div class="pets-grid">
                <% 
                    Connection con = null;
                    try {
                        con = DBConnection.createConnection();
                        // Query: Only show pets that are APPROVED by Admin (IN_CENTRE or FOSTERED)
                        String sql = "SELECT * FROM STRAY_REPORT WHERE STATUS IN ('IN_CENTRE', 'FOSTERED') ORDER BY DATE_FOUND DESC";
                        PreparedStatement ps = con.prepareStatement(sql);
                        ResultSet rs = ps.executeQuery();
                        
                        boolean hasPets = false;
                        while(rs.next()) {
                            hasPets = true;
                            String type = rs.getString("PET_TYPE");
                            String location = rs.getString("LOCATION_FOUND");
                            String photo = rs.getString("PET_PHOTO"); // Filename from DB
                            String situation = rs.getString("SITUATION");
                            String status = rs.getString("STATUS");
                            
                            // Determine Badge Color & Text
                            String badgeClass = "st-center";
                            String badgeText = "At Centre";
                            if("FOSTERED".equals(status)) {
                                badgeClass = "st-foster";
                                badgeText = "In Foster Care";
                            }
                            
                            // Escape special characters for JavaScript
                            String safeDesc = situation.replace("'", "\\'").replace("\"", "&quot;").replace("\n", " ");
                %>
                
                <div class="pet-card">
                    <div class="pet-image-container">
                        <img src="ImageServlet/<%= photo %>" class="pet-image" onerror="this.src='https://via.placeholder.com/300x200?text=No+Image'">
                        <span class="pet-status <%= badgeClass %>"><%= badgeText %></span>
                    </div>
                    
                    <div class="pet-info">
                        <div class="pet-name"><%= type %></div>
                        <div class="pet-meta">
                            <i class="fas fa-map-marker-alt" style="color:#e74c3c;"></i> <%= location %>
                        </div>
                        
                        <button class="view-btn" onclick="openModal(
                            '<%= type %>', 
                            '<%= badgeText %>', 
                            '<%= badgeClass %>', 
                            '<%= safeDesc %>', 
                            'ImageServlet/<%= photo %>'
                        )">
                            View Details <i class="fas fa-arrow-right"></i>
                        </button>
                    </div>
                </div>

                <% 
                        } // End while
                        if(!hasPets) {
                %>
                    <div style="grid-column: 1/-1; text-align: center; padding: 50px; color: #777;">
                        <i class="fas fa-search" style="font-size: 40px; opacity: 0.3; margin-bottom: 15px;"></i>
                        <h3>No pets available right now.</h3>
                        <p>Check back later or report a stray!</p>
                    </div>
                <% 
                        }
                    } catch(Exception e) { 
                        e.printStackTrace(); 
                        out.println("<p style='color:red'>Error: " + e.getMessage() + "</p>");
                    } finally { 
                        if(con!=null) con.close(); 
                    }
                %>
            </div>
        </div>
    </div>

    <div id="petModal" class="modal" onclick="closeModal(event)">
        <div class="modal-content">
            <div class="modal-image-col">
                <img id="modalImg" src="" class="modal-img" alt="Pet Photo">
            </div>
            
            <div class="modal-info-col">
                <span class="close-btn" onclick="document.getElementById('petModal').style.display='none'">&times;</span>
                
                <h2 id="modalTitle" class="modal-title">Pet Name</h2>
                <div><span id="modalBadge" class="modal-badge">Status</span></div>
                
                <p id="modalDesc" class="modal-desc">Description goes here...</p>
                
                <div class="contact-box">
                    <h4><i class="fas fa-phone-alt"></i> Interested?</h4>
                    <p>Please visit our center or call <strong>(555) 123-4567</strong> to meet this pet!</p>
                </div>
            </div>
        </div>
    </div>

    <script>
        function openModal(title, statusText, statusClass, desc, imgSrc) {
            document.getElementById('modalTitle').innerText = title;
            document.getElementById('modalDesc').innerText = desc;
            document.getElementById('modalImg').src = imgSrc;
            
            const badge = document.getElementById('modalBadge');
            badge.innerText = statusText;
            
            // Set badge color based on class
            badge.className = 'modal-badge'; 
            if(statusClass.includes('st-center')) badge.style.backgroundColor = '#3498db';
            else badge.style.backgroundColor = '#2ecc71';

            document.getElementById('petModal').style.display = 'flex';
        }

        function closeModal(event) {
            // Close if clicking the dark background (outside the box)
            if (event.target.id === 'petModal') {
                document.getElementById('petModal').style.display = 'none';
            }
        }
    </script>

</body>
</html>