<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="com.petie.util.DBConnection"%>
<%@page import="java.sql.*"%>
<%@page import="com.petie.bean.UserBean"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<%
    // Check if user is logged in
    UserBean user = (UserBean) session.getAttribute("userSession");
    if (user == null) { 
        response.sendRedirect("login.jsp"); 
        return; 
    }
    
    // Set user attributes for JSTL usage
    pageContext.setAttribute("user", user);
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Adopt a Pet - Petie Adoption System</title>
    <link rel="stylesheet" href="style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <style>
        /* --- CSS STYLES --- */
        .adopt-container, .adopt-container * { box-sizing: border-box; }
        
        /* Layout Adjustments */
        .main-content { margin-left: 280px; transition: margin-left 0.3s cubic-bezier(0.4, 0, 0.2, 1); padding: 20px; min-height: 100vh; width: calc(100% - 280px); }
        .sidebar-container.collapsed ~ .main-content { margin-left: 70px; width: calc(100% - 70px); }
        @media (max-width: 992px) { .main-content { margin-left: 0 !important; width: 100% !important; padding: 15px !important; } }
        
        /* Header */
        .page-header { background: linear-gradient(135deg, var(--pet-secondary, #f39c12) 0%, #e67e22 100%); color: white; border-radius: 12px; padding: 25px 30px; margin-bottom: 30px; box-shadow: 0 4px 6px rgba(0,0,0,0.1); }
        .page-header h1 { margin: 0; display: flex; align-items: center; gap: 15px; }
        
        /* Stats Bar */
        .stats-bar { display: flex; gap: 20px; margin-bottom: 20px; flex-wrap: wrap; }
        .stat-item { background: white; padding: 15px 20px; border-radius: 12px; box-shadow: 0 4px 6px rgba(0,0,0,0.05); display: flex; align-items: center; gap: 10px; flex: 1; min-width: 150px; }
        .stat-icon { font-size: 24px; color: #4a90e2; background: rgba(74, 144, 226, 0.1); width: 50px; height: 50px; border-radius: 50%; display: flex; align-items: center; justify-content: center; }
        .stat-number { font-size: 24px; font-weight: 700; color: #333; }
        
        /* Filter Section */
        .filter-section { background: white; border-radius: 12px; padding: 20px; margin-bottom: 30px; box-shadow: 0 4px 6px rgba(0,0,0,0.05); display: flex; flex-wrap: wrap; gap: 15px; align-items: center; justify-content: space-between; }
        .filter-group { display: flex; gap: 10px; align-items: center; flex-wrap: wrap; }
        .filter-select, .search-box { padding: 8px 15px; border: 2px solid #e9ecef; border-radius: 8px; outline: none; }
        .filter-btn { background: #e9ecef; color: #333; border: none; padding: 10px 20px; border-radius: 8px; cursor: pointer; font-weight: 600; display: flex; align-items: center; gap: 8px; }
        .filter-btn:hover { background: #dee2e6; }
        
        /* Pets Grid */
        .pets-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(300px, 1fr)); gap: 25px; margin-bottom: 40px; }
        
        /* Pet Card */
        .pet-card { background: white; border-radius: 12px; overflow: hidden; box-shadow: 0 4px 6px rgba(0,0,0,0.05); transition: all 0.3s ease; display: flex; flex-direction: column; }
        .pet-card:hover { transform: translateY(-10px); box-shadow: 0 10px 20px rgba(0,0,0,0.1); }
        
        .pet-image-container { position: relative; height: 200px; overflow: hidden; }
        .pet-image { width: 100%; height: 100%; object-fit: cover; transition: transform 0.5s; }
        .pet-card:hover .pet-image { transform: scale(1.05); }
        
        .pet-status { position: absolute; top: 15px; right: 15px; color: white; padding: 5px 12px; border-radius: 20px; font-size: 12px; font-weight: 600; text-transform: uppercase; }
        .status-foster { background: #2ecc71; }
        .status-center { background: #3498db; }
        
        .pet-info { padding: 20px; flex: 1; display: flex; flex-direction: column; }
        .pet-name { font-size: 20px; font-weight: 700; color: #333; margin-bottom: 10px; text-transform: capitalize; }
        .pet-details { margin: 8px 0; display: flex; align-items: center; gap: 8px; color: #666; font-size: 14px; }
        .pet-details i { color: #4a90e2; width: 20px; text-align: center; }
        
        .pet-description { margin: 15px 0; color: #333; font-size: 14px; line-height: 1.5; flex: 1; display: -webkit-box; -webkit-line-clamp: 3; -webkit-box-orient: vertical; overflow: hidden; }
        
        .pet-footer { display: flex; justify-content: space-between; align-items: center; margin-top: 15px; padding-top: 15px; border-top: 1px solid #eee; }
        .pet-id { font-size: 12px; color: #999; }
        
        .adopt-btn { background: linear-gradient(135deg, #27ae60 0%, #2ecc71 100%); color: white; padding: 10px 20px; border-radius: 8px; border: none; cursor: pointer; font-weight: 600; text-decoration: none; display: inline-flex; align-items: center; gap: 5px; }
        .adopt-btn:hover { opacity: 0.9; transform: translateY(-2px); }
        
        /* Modal */
        .modal { display: none; position: fixed; top: 0; left: 0; right: 0; bottom: 0; background: rgba(0, 0, 0, 0.5); z-index: 2000; align-items: center; justify-content: center; }
        .modal-content { background: white; padding: 30px; border-radius: 12px; max-width: 500px; width: 90%; }
        .form-group { margin-bottom: 15px; }
        .form-group label { display: block; margin-bottom: 5px; font-weight: 600; }
        .form-group textarea { width: 100%; padding: 10px; border: 1px solid #ccc; border-radius: 5px; resize: vertical; }
        .form-actions { display: flex; justify-content: flex-end; gap: 10px; margin-top: 20px; }
        .btn-cancel { background: #6c757d; color: white; border: none; padding: 10px 20px; border-radius: 5px; cursor: pointer; }
        .btn-submit { background: #007bff; color: white; border: none; padding: 10px 20px; border-radius: 5px; cursor: pointer; }
    </style>
</head>
<body>

    <jsp:include page="navbar.jsp" />

    <div class="main-content">
        <div class="adopt-container">
            
            <div class="page-header">
                <h1><i class="fas fa-paw"></i> Find Your Forever Friend</h1>
                <p>Browse adoptable pets. Every adoption saves a life.</p>
            </div>

            <div class="stats-bar">
                <div class="stat-item">
                    <div class="stat-icon"><i class="fas fa-dog"></i></div>
                    <div class="stat-text"><div class="stat-number" id="totalPets">0</div><div class="stat-label">Total Available</div></div>
                </div>
                <div class="stat-item">
                    <div class="stat-icon"><i class="fas fa-home"></i></div>
                    <div class="stat-text"><div class="stat-number" id="fosterPets">0</div><div class="stat-label">In Foster Care</div></div>
                </div>
            </div>

            <div class="filter-section">
                <div class="filter-group">
                    <span style="font-weight:600;">Filter:</span>
                    <select class="filter-select" id="filterType">
                        <option value="">All Types</option>
                        <option value="Dog">Dog</option>
                        <option value="Cat">Cat</option>
                        <option value="Rabbit">Rabbit</option>
                    </select>
                </div>
                <div class="filter-group">
                    <input type="text" class="search-box" id="searchBox" placeholder="Search (e.g., 'Golden Retriever')...">
                    <button class="filter-btn" id="applyFilters"><i class="fas fa-filter"></i> Apply</button>
                    <button class="filter-btn" id="resetFilters" style="background:#fff; border:1px solid #ddd;"><i class="fas fa-redo"></i> Reset</button>
                </div>
            </div>

            <div class="pets-grid" id="petsGrid">
                <% 
                    Connection con = null;
                    PreparedStatement ps = null;
                    ResultSet rs = null;
                    int petCount = 0;
                    int fosterCount = 0;

                    try {
                        con = DBConnection.createConnection();
                        
                        // --- UPDATED QUERY FOR YOUR TABLE STRUCTURE ---
                        // 1. We select all columns from STRAY_REPORT
                        // 2. We filter where STATUS is 'FOSTER' or 'CENTER'
                        // 3. We order by newest first
                        String sql = "SELECT * FROM STRAY_REPORT WHERE STATUS IN ('FOSTER', 'CENTER') ORDER BY DATE_FOUND DESC"; 
                        
                        ps = con.prepareStatement(sql);
                        rs = ps.executeQuery();
                        
                        while(rs.next()) {
                            petCount++;
                            
                            // --- CRITICAL FIX: USING 'STRAY_ID' ---
                            int strayId = rs.getInt("STRAY_ID"); 
                            
                            String type = rs.getString("PET_TYPE");
                            String location = rs.getString("LOCATION_FOUND");
                            String situation = rs.getString("SITUATION");
                            Date sqlDate = rs.getDate("DATE_FOUND");
                            String photo = rs.getString("PET_PHOTO"); 
                            String status = rs.getString("STATUS");

                            // Logic for location display based on Status
                            String displayLocation = "Petie Adoption Center";
                            String badgeClass = "status-center";
                            String statusText = "At Center";

                            if("FOSTER".equals(status)) {
                                displayLocation = "Foster Home (" + location + ")";
                                badgeClass = "status-foster";
                                statusText = "In Foster";
                                fosterCount++;
                            }
                %>
                
                <div class="pet-card" data-type="<%= type %>">
                    <div class="pet-image-container">
                        <img src="uploads/<%= (photo != null && !photo.isEmpty()) ? photo : "default.jpg" %>" 
                             class="pet-image" 
                             alt="<%= type %>"
                             onerror="this.src='https://via.placeholder.com/300x200?text=No+Image'">
                        <span class="pet-status <%= badgeClass %>"><%= statusText %></span>
                    </div>
                    
                    <div class="pet-info">
                        <div class="pet-name"><%= type %></div>
                        
                        <div class="pet-details">
                            <i class="fas fa-map-marker-alt"></i> <%= displayLocation %>
                        </div>
                        <div class="pet-details">
                            <i class="far fa-calendar-alt"></i> Found: <%= sqlDate %>
                        </div>
                        
                        <div class="pet-description">
                            <%= situation %>
                        </div>
                        
                        <div class="pet-footer">
                            <span class="pet-id">ID: #<%= strayId %></span>
                            <button class="adopt-btn" onclick="showAdoptionModal(<%= strayId %>, '<%= type %>')">
                                <i class="fas fa-heart"></i> Adopt Me
                            </button>
                        </div>
                    </div>
                </div>

                <% 
                        } // End While Loop

                        if (petCount == 0) {
                %>
                    <div style="grid-column: 1/-1; text-align: center; padding: 60px; color: #777;">
                        <i class="fas fa-search" style="font-size: 48px; margin-bottom: 20px; color: #ddd;"></i>
                        <h3>No pets available for adoption right now.</h3>
                        <p>All our rescues have found homes! Please check back later.</p>
                    </div>
                <% 
                        }
                    } catch (Exception e) {
                        e.printStackTrace();
                        out.println("<p style='color:red; grid-column:1/-1;'>Error loading pets: " + e.getMessage() + "</p>");
                    } finally {
                        // Close resources safely
                        if(rs!=null) rs.close();
                        if(ps!=null) ps.close();
                        if(con!=null) con.close();
                    }
                %>
            </div> </div>
    </div>

    <div id="adoptionModal" class="modal">
        <div class="modal-content">
            <h3><i class="fas fa-paw" style="color:#e67e22;"></i> Adoption Application</h3>
            <p id="modalPetInfo" style="color:#666; margin-bottom:20px;"></p>
            
            <form id="adoptionForm">
                <input type="hidden" id="modalStrayId" name="strayId">
                
                <div class="form-group">
                    <label>Why do you want to adopt this pet?</label>
                    <textarea rows="3" required placeholder="Tell us about your home environment..."></textarea>
                </div>
                
                <div class="form-group">
                    <label>Do you have other pets?</label>
                    <textarea rows="2" required placeholder="Yes/No..."></textarea>
                </div>
                
                <div class="form-actions">
                    <button type="button" class="btn-cancel" onclick="closeModal()">Cancel</button>
                    <button type="submit" class="btn-submit">Submit Application</button>
                </div>
            </form>
        </div>
    </div>

    <script>
        // Update Stats from Java variables
        document.getElementById('totalPets').innerText = "<%= petCount %>";
        document.getElementById('fosterPets').innerText = "<%= fosterCount %>";

        // 1. Filter Logic
        document.getElementById('applyFilters').addEventListener('click', function() {
            const typeFilter = document.getElementById('filterType').value.toLowerCase();
            const searchFilter = document.getElementById('searchBox').value.toLowerCase();
            const cards = document.querySelectorAll('.pet-card');

            cards.forEach(card => {
                const cardType = card.getAttribute('data-type').toLowerCase();
                const cardText = card.innerText.toLowerCase();
                
                const matchesType = (typeFilter === "" || cardType === typeFilter);
                const matchesSearch = (searchFilter === "" || cardText.includes(searchFilter));

                if (matchesType && matchesSearch) {
                    card.style.display = "flex";
                } else {
                    card.style.display = "none";
                }
            });
        });

        // 2. Reset Logic
        document.getElementById('resetFilters').addEventListener('click', function() {
            document.getElementById('filterType').value = "";
            document.getElementById('searchBox').value = "";
            document.querySelectorAll('.pet-card').forEach(c => c.style.display = "flex");
        });

        // 3. Modal Logic
        function showAdoptionModal(id, type) {
            document.getElementById('modalPetInfo').innerText = "You are applying to adopt a " + type + " (ID: #" + id + ").";
            document.getElementById('modalStrayId').value = id;
            document.getElementById('adoptionModal').style.display = 'flex';
        }

        function closeModal() {
            document.getElementById('adoptionModal').style.display = 'none';
        }

        // 4. Form Submission (Client Side Alert)
        document.getElementById('adoptionForm').addEventListener('submit', function(e) {
            e.preventDefault(); // Prevent actual submit for now
            const petId = document.getElementById('modalStrayId').value;
            alert("✅ Success! Your application for Pet #" + petId + " has been sent to our staff.");
            closeModal();
        });

        // Close modal if clicking outside
        window.onclick = function(event) {
            const modal = document.getElementById('adoptionModal');
            if (event.target == modal) {
                closeModal();
            }
        }
    </script>
</body>
</html>