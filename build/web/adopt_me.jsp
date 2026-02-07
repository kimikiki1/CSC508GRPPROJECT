<%-- 
    adopt_me.jsp - Browse Adoptable Pets Page
    Features:
    - Displays all stray reports as adoptable pets
    - Responsive grid layout with filter options
    - Pet cards with detailed information
    - Integration with sidebar navigation
    - Database connection for dynamic content
--%>

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
    pageContext.setAttribute("userRole", user.getRole());
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
        /* CSS Reset for adopt page to prevent gaps */
        .adopt-container,
        .adopt-container * {
            box-sizing: border-box;
        }
        
        /* Main Content Area - FIXED WIDTH */
        .main-content {
            margin-left: 280px;
            transition: margin-left 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            padding: 20px;
            min-height: 100vh;
            will-change: margin-left;
            width: calc(100% - 280px);
            box-sizing: border-box;
        }
        
        .sidebar-container.collapsed ~ .main-content {
            margin-left: 70px;
            width: calc(100% - 70px);
        }
        
        /* On mobile, no margin */
        @media (max-width: 992px) {
            .main-content {
                margin-left: 0 !important;
                width: 100% !important;
                padding: 15px !important;
            }
        }
        
        /* Page-specific styles for adopt me page */
        .adopt-container {
            padding: 0;
            width: 100%;
            max-width: none;
        }
        
        /* Page Header - FIXED: Remove auto margins */
        .page-header {
            background: linear-gradient(135deg, var(--pet-secondary) 0%, #e67e22 100%);
            color: white;
            border-radius: var(--border-radius);
            padding: 25px 30px;
            margin-bottom: 30px;
            box-shadow: var(--box-shadow-lg);
            width: 100%;
        }
        
        .page-header h1 {
            margin: 0;
            display: flex;
            align-items: center;
            gap: 15px;
        }
        
        .page-subtitle {
            color: rgba(255, 255, 255, 0.9);
            margin: 10px 0 0 0;
            font-size: 16px;
        }
        
        /* Filter Section - FIXED: Remove auto margins */
        .filter-section {
            background: white;
            border-radius: var(--border-radius);
            padding: 20px;
            margin-bottom: 30px;
            box-shadow: var(--box-shadow);
            display: flex;
            flex-wrap: wrap;
            gap: 15px;
            align-items: center;
            justify-content: space-between;
            width: 100%;
        }

        .filter-group {
            display: flex;
            gap: 10px;
            align-items: center;
            flex-wrap: wrap;
        }
        
        .filter-label {
            font-weight: 600;
            color: var(--pet-dark);
            font-size: 14px;
        }
        
        .filter-select {
            padding: 8px 15px;
            border: 2px solid var(--light-gray);
            border-radius: 8px;
            background: white;
            font-size: 14px;
            min-width: 150px;
            transition: border-color 0.3s;
        }
        
        .filter-select:focus {
            outline: none;
            border-color: var(--pet-primary);
        }
        
        .search-box {
            flex: 1;
            max-width: 300px;
            padding: 10px 15px;
            border: 2px solid var(--light-gray);
            border-radius: 8px;
            font-size: 14px;
        }
        
        .search-box:focus {
            outline: none;
            border-color: var(--pet-primary);
        }
        
        .filter-btn {
            background: var(--light-gray);
            color: black;
            border: none;
            padding: 10px 20px;
            border-radius: 8px;
            cursor: pointer;
            font-weight: 600;
            display: flex;
            align-items: center;
            gap: 8px;
            transition: all 0.3s;
        }
        
        .filter-btn:hover {
            background: #dee2e6;
            transform: translateY(-2px);
        }
        
        .reset-btn {
            background: var(--light-gray);
            color: var(--pet-dark);
            border: none;
            padding: 10px 20px;
            border-radius: 8px;
            cursor: pointer;
            font-weight: 600;
            display: flex;
            align-items: center;
            gap: 8px;
            transition: all 0.3s;
        }
        
        .reset-btn:hover {
            background: #dee2e6;
            transform: translateY(-2px);
        }
        
        /* Stats Bar - FIXED: Remove auto margins */
        .stats-bar {
            display: flex;
            gap: 20px;
            margin-bottom: 20px;
            flex-wrap: wrap;
            width: 100%;
        }
        
        .stat-item {
            background: white;
            padding: 15px 20px;
            border-radius: var(--border-radius);
            box-shadow: var(--box-shadow);
            display: flex;
            align-items: center;
            gap: 10px;
            flex: 1;
            min-width: 150px;
        }
        
        .stat-icon {
            font-size: 24px;
            color: var(--pet-primary);
            background: rgba(74, 144, 226, 0.1);
            width: 50px;
            height: 50px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        
        .stat-text {
            flex: 1;
        }
        
        .stat-number {
            font-size: 24px;
            font-weight: 700;
            color: var(--pet-dark);
        }
        
        .stat-label {
            font-size: 13px;
            color: var(--pet-gray);
        }
        
        /* Pets Grid - FIXED: Remove auto margins */
        .pets-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
            gap: 25px;
            margin-bottom: 40px;
            width: 100%;
        }
        
        .pet-card {
            background: white;
            border-radius: var(--border-radius);
            overflow: hidden;
            box-shadow: var(--box-shadow);
            transition: all 0.3s ease;
            display: flex;
            flex-direction: column;
            height: 100%;
        }
        
        .pet-card:hover {
            transform: translateY(-10px);
            box-shadow: var(--box-shadow-lg);
        }
        
        .pet-image-container {
            position: relative;
            height: 200px;
            overflow: hidden;
        }
        
        .pet-image {
            width: 100%;
            height: 100%;
            object-fit: cover;
            transition: transform 0.5s ease;
        }
        
        .pet-card:hover .pet-image {
            transform: scale(1.05);
        }
        
        .pet-status {
            position: absolute;
            top: 15px;
            right: 15px;
            background: var(--pet-success);
            color: white;
            padding: 5px 12px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
            text-transform: uppercase;
        }
        
        .pet-status.pending {
            background: var(--pet-secondary);
        }
        
        .pet-status.rescued {
            background: var(--pet-success);
        }
        
        .pet-status.urgent {
            background: var(--pet-danger);
        }
        
        .pet-info {
            padding: 20px;
            flex: 1;
            display: flex;
            flex-direction: column;
        }
        
        .pet-name {
            font-size: 20px;
            font-weight: 700;
            color: var(--pet-dark);
            margin-bottom: 10px;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .pet-type-icon {
            color: var(--pet-primary);
        }
        
        .pet-details {
            margin: 8px 0;
            display: flex;
            align-items: center;
            gap: 8px;
            color: var(--pet-gray);
            font-size: 14px;
        }
        
        .pet-detail-icon {
            color: var(--pet-primary);
            width: 20px;
            text-align: center;
        }
        
        .pet-description {
            margin: 15px 0;
            color: var(--pet-dark);
            font-size: 14px;
            line-height: 1.5;
            flex: 1;
        }
        
        .pet-footer {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-top: 15px;
            padding-top: 15px;
            border-top: 1px solid var(--light-gray);
        }
        
        .pet-date {
            font-size: 12px;
            color: var(--pet-gray);
        }
        
        .adopt-btn {
            background: linear-gradient(135deg, var(--pet-success) 0%, #27ae60 100%);
            color: white;
            padding: 10px 20px;
            border-radius: 8px;
            text-decoration: none;
            font-weight: 600;
            font-size: 14px;
            display: flex;
            align-items: center;
            gap: 8px;
            transition: all 0.3s;
            border: none;
            cursor: pointer;
        }
        
        .adopt-btn:hover {
            background: linear-gradient(135deg, #27ae60 0%, #219653 100%);
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(39, 174, 96, 0.3);
        }
        
        .adopt-btn:disabled {
            background: var(--light-gray);
            color: var(--pet-gray);
            cursor: not-allowed;
            transform: none;
            box-shadow: none;
        }
        
        /* Empty State - FIXED: Remove auto margins */
        .empty-state {
            text-align: center;
            padding: 60px 20px;
            background: white;
            border-radius: var(--border-radius);
            box-shadow: var(--box-shadow);
            margin: 40px 0;
            width: 100%;
        }
        
        .empty-icon {
            font-size: 80px;
            color: var(--light-gray);
            margin-bottom: 20px;
        }
        
        /* Pagination - FIXED: Remove auto margins */
        .pagination {
            display: flex;
            justify-content: center;
            gap: 10px;
            margin-top: 40px;
            width: 100%;
        }
        
        .page-btn {
            padding: 8px 15px;
            border: 2px solid var(--light-gray);
            background: white;
            border-radius: 6px;
            cursor: pointer;
            color: var(--pet-dark);
            font-weight: 600;
            transition: all 0.3s;
        }
        
        .page-btn:hover {
            border-color: var(--pet-primary);
            color: var(--pet-primary);
        }
        
        .page-btn.active {
            background: var(--pet-primary);
            color: white;
            border-color: var(--pet-primary);
        }
        
        /* Responsive Design */
        @media (max-width: 768px) {
            .filter-section {
                flex-direction: column;
                align-items: stretch;
            }
            
            .search-box {
                max-width: 100%;
            }
            
            .pets-grid {
                grid-template-columns: 1fr;
            }
            
            .stats-bar {
                flex-direction: column;
            }
            
            .stat-item {
                min-width: 100%;
            }
        }
        
        /* Loading Animation */
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }
        
        .pet-card {
            animation: fadeIn 0.5s ease forwards;
        }
        
        /* Staggered animations for cards */
        .pet-card:nth-child(1) { animation-delay: 0.1s; }
        .pet-card:nth-child(2) { animation-delay: 0.2s; }
        .pet-card:nth-child(3) { animation-delay: 0.3s; }
        .pet-card:nth-child(4) { animation-delay: 0.4s; }
        .pet-card:nth-child(5) { animation-delay: 0.5s; }
        .pet-card:nth-child(6) { animation-delay: 0.6s; }
        
        /* Force remove any inherited margins that cause gaps */
        .main-content .adopt-container,
        .main-content .adopt-container > * {
            margin-left: 0 !important;
            margin-right: 0 !important;
        }
        
        /* Ensure all content elements use full width */
        .adopt-container > * {
            width: 100% !important;
            max-width: 100% !important;
        }
    </style>
</head>
<body>
    <!-- Include Navigation Sidebar -->
    <%@include file="navbar.jsp" %>
    
    <!-- Main Content Area -->
    <div class="main-content">
        <div class="adopt-container">
            <!-- Page Header -->
            <div class="page-header">
                <h1>
                    <i class="fas fa-paw"></i> Find Your Forever Friend
                </h1>
                <p class="page-subtitle">
                    Browse adorable pets waiting for a loving home. Each adoption creates a happy ending!
                </p>
            </div>
            
            <!-- Stats Bar -->
            <div class="stats-bar">
                <div class="stat-item">
                    <div class="stat-icon">
                        <i class="fas fa-dog"></i>
                    </div>
                    <div class="stat-text">
                        <div class="stat-number" id="totalPets">0</div>
                        <div class="stat-label">Total Pets Available</div>
                    </div>
                </div>
                
                <div class="stat-item">
                    <div class="stat-icon">
                        <i class="fas fa-home"></i>
                    </div>
                    <div class="stat-text">
                        <div class="stat-number" id="adoptedPets">0</div>
                        <div class="stat-label">Successfully Adopted</div>
                    </div>
                </div>
                
                <div class="stat-item">
                    <div class="stat-icon">
                        <i class="fas fa-heart"></i>
                    </div>
                    <div class="stat-text">
                        <div class="stat-number" id="urgentPets">0</div>
                        <div class="stat-label">Need Urgent Homes</div>
                    </div>
                </div>
            </div>
            
            <!-- Filter Section -->
            <div class="filter-section">
                <div class="filter-group">
                    <span class="filter-label">Filter by:</span>
                    <select class="filter-select" id="filterType">
                        <option value="">All Pets</option>
                        <option value="Dog">Dogs</option>
                        <option value="Cat">Cats</option>
                        <option value="Rabbit">Rabbits</option>
                        <option value="Bird">Birds</option>
                        <option value="Other">Other</option>
                    </select>
                    
                    <select class="filter-select" id="filterStatus">
                        <option value="">All Status</option>
                        <option value="AVAILABLE">Available</option>
                        <option value="PENDING">Pending</option>
                        <option value="ADOPTED">Adopted</option>
                    </select>
                    
                    <select class="filter-select" id="filterLocation">
                        <option value="">All Locations</option>
                        <!-- Location options will be populated by JavaScript -->
                    </select>
                </div>
                
                <div class="filter-group">
                    <input type="text" class="search-box" id="searchBox" placeholder="Search by pet type or location...">
                    <button class="filter-btn" id="applyFilters">
                        <i class="fas fa-filter"></i> Apply Filters
                    </button>
                    <button class="reset-btn" id="resetFilters">
                        <i class="fas fa-redo"></i> Reset
                    </button>
                </div>
            </div>
            
            <!-- Pets Grid -->
            <div class="pets-grid" id="petsGrid">
                <% 
                    Connection con = null;
                    int petCount = 0;
                    try {
                        con = DBConnection.createConnection();
                        // Select all stray reports that are available for adoption
                        String sql = "SELECT * FROM STRAY_REPORT WHERE STATUS = 'PENDING' OR STATUS = 'AVAILABLE' ORDER BY DATE_FOUND DESC"; 
                        PreparedStatement ps = con.prepareStatement(sql);
                        ResultSet rs = ps.executeQuery();
                        
                        while(rs.next()) {
                            petCount++;
                            String strayId = rs.getString("STRAY_ID");
                            String type = rs.getString("PET_TYPE");
                            String location = rs.getString("LOCATION_FOUND");
                            String situation = rs.getString("SITUATION");
                            String date = rs.getString("DATE_FOUND");
                            String photo = rs.getString("PET_PHOTO"); 
                            String status = rs.getString("STATUS");
                            
                            // Format date for display
                            String displayDate = date;
                            try {
                                java.sql.Date sqlDate = rs.getDate("DATE_FOUND");
                                if (sqlDate != null) {
                                    java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("MMM dd, yyyy");
                                    displayDate = sdf.format(sqlDate);
                                }
                            } catch (Exception e) {
                                // Keep original date format if parsing fails
                            }
                            
                            // Determine status badge color and text
                            String statusClass = "pending";
                            String statusText = "Available";
                            if ("PENDING".equals(status)) {
                                statusClass = "pending";
                                statusText = "Needs Home";
                            } else if ("AVAILABLE".equals(status)) {
                                statusClass = "rescued";
                                statusText = "Ready for Adoption";
                            }
                            
                            // Truncate situation if too long
                            String shortSituation = situation;
                            if (situation.length() > 150) {
                                shortSituation = situation.substring(0, 150) + "...";
                            }
                %>
                <div class="pet-card" data-type="<%= type %>" data-location="<%= location %>" data-status="<%= status %>">
                    <div class="pet-image-container">
                        <img src="uploads/<%= (photo != null && !photo.isEmpty()) ? photo : "default-pet.jpg" %>" 
                             class="pet-image" 
                             alt="<%= type %> found in <%= location %>"
                             onerror="this.src='https://images.unsplash.com/photo-1543466835-00a7907e9de1?ixlib=rb-4.0.3&auto=format&fit=crop&w=600&q=80'">
                        <span class="pet-status <%= statusClass %>"><%= statusText %></span>
                    </div>
                    
                    <div class="pet-info">
                        <div class="pet-name">
                            <i class="fas fa-dog pet-type-icon"></i>
                            <%= type %>
                        </div>
                        
                        <div class="pet-details">
                            <i class="fas fa-map-marker-alt pet-detail-icon"></i>
                            <span>Found in: <%= location %></span>
                        </div>
                        
                        <div class="pet-details">
                            <i class="far fa-calendar-alt pet-detail-icon"></i>
                            <span>Found on: <%= displayDate %></span>
                        </div>
                        
                        <div class="pet-details">
                            <i class="fas fa-info-circle pet-detail-icon"></i>
                            <span>Condition: <%= status %></span>
                        </div>
                        
                        <p class="pet-description">
                            <%= shortSituation %>
                        </p>
                        
                        <div class="pet-footer">
                            <span class="pet-date">Report ID: #<%= strayId %></span>
                            
                            <% if ("AVAILABLE".equals(status) || "PENDING".equals(status)) { %>
                                <button class="adopt-btn" onclick="showAdoptionModal(<%= strayId %>, '<%= type %>')">
                                    <i class="fas fa-heart"></i> Adopt Me
                                </button>
                            <% } else { %>
                                <button class="adopt-btn" disabled>
                                    <i class="fas fa-check"></i> Already Adopted
                                </button>
                            <% } %>
                        </div>
                    </div>
                </div>
                <% 
                        }
                        
                        if (petCount == 0) {
                %>
                <!-- Empty State -->
                <div class="empty-state">
                    <div class="empty-icon">
                        <i class="fas fa-paw"></i>
                    </div>
                    <h3>No Pets Available for Adoption</h3>
                    <p>All pets have found their forever homes! Check back soon for new arrivals.</p>
                    <a href="report_stray.jsp" class="btn btn-primary" style="margin-top: 20px;">
                        <i class="fas fa-exclamation-circle"></i> Report a Stray Animal
                    </a>
                </div>
                <% 
                        }
                        
                        con.close();
                    } catch (Exception e) {
                        out.println("<div class='alert alert-danger'>Error loading pets: " + e.getMessage() + "</div>");
                        e.printStackTrace();
                    }
                %>
            </div>
            
            <!-- Pagination -->
            <div class="pagination" id="pagination">
                <!-- Pagination will be generated by JavaScript -->
            </div>
        </div>
    </div>
    
    <!-- Adoption Modal (Hidden by default) -->
    <div id="adoptionModal" class="modal" style="display: none;">
        <div class="modal-content">
            <h3>Adoption Application</h3>
            <p id="modalPetInfo"></p>
            <form id="adoptionForm">
                <div class="form-group">
                    <label>Why do you want to adopt this pet?</label>
                    <textarea rows="4" required></textarea>
                </div>
                <div class="form-group">
                    <label>Do you have experience with pets?</label>
                    <textarea rows="3" required></textarea>
                </div>
                <div class="form-actions">
                    <button type="button" class="btn btn-secondary" onclick="closeModal()">Cancel</button>
                    <button type="submit" class="btn btn-primary">Submit Application</button>
                </div>
            </form>
        </div>
    </div>
    
    <!-- JavaScript for Interactive Features -->
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            // Initialize stats
            updatePetStats();
            
            // Initialize filter functionality
            initializeFilters();
            
            // Initialize pagination
            initializePagination();
            
            // Function to update pet statistics
            function updatePetStats() {
                const petCards = document.querySelectorAll('.pet-card');
                document.getElementById('totalPets').textContent = petCards.length;
                
                // Count adopted pets (you would get this from database in real app)
                document.getElementById('adoptedPets').textContent = Math.floor(petCards.length * 0.3);
                
                // Count urgent pets (status = PENDING)
                const urgentPets = Array.from(petCards).filter(card => 
                    card.getAttribute('data-status') === 'PENDING'
                ).length;
                document.getElementById('urgentPets').textContent = urgentPets;
            }
            
            // Function to initialize filters
            function initializeFilters() {
                const filterType = document.getElementById('filterType');
                const filterStatus = document.getElementById('filterStatus');
                const filterLocation = document.getElementById('filterLocation');
                const searchBox = document.getElementById('searchBox');
                const applyBtn = document.getElementById('applyFilters');
                const resetBtn = document.getElementById('resetFilters');
                
                // Populate location filter with unique locations from pets
                const locations = new Set();
                document.querySelectorAll('.pet-card').forEach(card => {
                    const location = card.getAttribute('data-location');
                    if (location) locations.add(location);
                });
                
                // Add location options
                locations.forEach(location => {
                    const option = document.createElement('option');
                    option.value = location;
                    option.textContent = location;
                    filterLocation.appendChild(option);
                });
                
                // Apply filters function
                function applyFilters() {
                    const typeFilter = filterType.value.toLowerCase();
                    const statusFilter = filterStatus.value;
                    const locationFilter = filterLocation.value.toLowerCase();
                    const searchText = searchBox.value.toLowerCase();
                    
                    let visibleCount = 0;
                    
                    document.querySelectorAll('.pet-card').forEach(card => {
                        const type = card.getAttribute('data-type').toLowerCase();
                        const status = card.getAttribute('data-status');
                        const location = card.getAttribute('data-location').toLowerCase();
                        const cardText = card.textContent.toLowerCase();
                        
                        const typeMatch = !typeFilter || type.includes(typeFilter);
                        const statusMatch = !statusFilter || status === statusFilter;
                        const locationMatch = !locationFilter || location.includes(locationFilter);
                        const searchMatch = !searchText || cardText.includes(searchText);
                        
                        if (typeMatch && statusMatch && locationMatch && searchMatch) {
                            card.style.display = 'flex';
                            visibleCount++;
                        } else {
                            card.style.display = 'none';
                        }
                    });
                    
                    // Show empty state if no pets match filters
                    const emptyState = document.querySelector('.empty-state');
                    if (visibleCount === 0) {
                        if (!emptyState) {
                            const grid = document.getElementById('petsGrid');
                            const emptyStateHTML = `
                                <div class="empty-state">
                                    <div class="empty-icon">
                                        <i class="fas fa-search"></i>
                                    </div>
                                    <h3>No Pets Match Your Filters</h3>
                                    <p>Try adjusting your search criteria or reset the filters.</p>
                                </div>
                            `;
                            grid.innerHTML = emptyStateHTML;
                        }
                    } else if (emptyState) {
                        emptyState.remove();
                    }
                    
                    updatePetStats();
                }
                
                // Event listeners
                applyBtn.addEventListener('click', applyFilters);
                
                searchBox.addEventListener('keyup', function(e) {
                    if (e.key === 'Enter') applyFilters();
                });
                
                resetBtn.addEventListener('click', function() {
                    filterType.value = '';
                    filterStatus.value = '';
                    filterLocation.value = '';
                    searchBox.value = '';
                    
                    // Show all pets
                    document.querySelectorAll('.pet-card').forEach(card => {
                        card.style.display = 'flex';
                    });
                    
                    // Remove empty state if exists
                    const emptyState = document.querySelector('.empty-state');
                    if (emptyState && emptyState.parentNode) {
                        emptyState.parentNode.removeChild(emptyState);
                    }
                    
                    updatePetStats();
                });
                
                // Auto-apply filters when select changes
                [filterType, filterStatus, filterLocation].forEach(select => {
                    select.addEventListener('change', applyFilters);
                });
            }
            
            // Function to initialize pagination
            function initializePagination() {
                const petsPerPage = 6;
                const petCards = document.querySelectorAll('.pet-card');
                const pageCount = Math.ceil(petCards.length / petsPerPage);
                
                if (pageCount > 1) {
                    const pagination = document.getElementById('pagination');
                    pagination.innerHTML = '';
                    
                    // Previous button
                    const prevBtn = document.createElement('button');
                    prevBtn.className = 'page-btn';
                    prevBtn.innerHTML = '<i class="fas fa-chevron-left"></i>';
                    prevBtn.addEventListener('click', () => changePage(currentPage - 1));
                    pagination.appendChild(prevBtn);
                    
                    // Page buttons
                    for (let i = 1; i <= pageCount; i++) {
                        const pageBtn = document.createElement('button');
                        pageBtn.className = 'page-btn';
                        pageBtn.textContent = i;
                        pageBtn.addEventListener('click', () => changePage(i));
                        pagination.appendChild(pageBtn);
                    }
                    
                    // Next button
                    const nextBtn = document.createElement('button');
                    nextBtn.className = 'page-btn';
                    nextBtn.innerHTML = '<i class="fas fa-chevron-right"></i>';
                    nextBtn.addEventListener('click', () => changePage(currentPage + 1));
                    pagination.appendChild(nextBtn);
                    
                    let currentPage = 1;
                    
                    function changePage(page) {
                        if (page < 1 || page > pageCount) return;
                        
                        currentPage = page;
                        
                        // Update active button
                        document.querySelectorAll('#pagination .page-btn').forEach((btn, index) => {
                            if (index === page) {
                                btn.classList.add('active');
                            } else {
                                btn.classList.remove('active');
                            }
                        });
                        
                        // Show/hide pets based on page
                        const startIndex = (page - 1) * petsPerPage;
                        const endIndex = startIndex + petsPerPage;
                        
                        petCards.forEach((card, index) => {
                            if (index >= startIndex && index < endIndex) {
                                card.style.display = 'flex';
                            } else {
                                card.style.display = 'none';
                            }
                        });
                    }
                    
                    // Initialize first page
                    changePage(1);
                }
            }
            
            // Adoption modal functions
            window.showAdoptionModal = function(strayId, petType) {
                const modal = document.getElementById('adoptionModal');
                const petInfo = document.getElementById('modalPetInfo');
                
                petInfo.textContent = `You're applying to adopt a ${petType} (Report ID: #${strayId}). Please fill out the application form below.`;
                
                modal.style.display = 'block';
                
                // Store current pet info for form submission
                modal.dataset.strayId = strayId;
                modal.dataset.petType = petType;
            };
            
            window.closeModal = function() {
                document.getElementById('adoptionModal').style.display = 'none';
            };
            
            // Handle adoption form submission
            document.getElementById('adoptionForm').addEventListener('submit', function(e) {
                e.preventDefault();
                
                const modal = document.getElementById('adoptionModal');
                const strayId = modal.dataset.strayId;
                const petType = modal.dataset.petType;
                
                // In a real application, you would submit this to a servlet
                alert(`Thank you for your application to adopt the ${petType}! Our team will contact you within 2-3 business days.`);
                
                // Close modal
                closeModal();
                
                // Update button status (in a real app, this would be done via AJAX)
                const adoptBtn = document.querySelector(`.pet-card[data-stray-id="${strayId}"] .adopt-btn`);
                if (adoptBtn) {
                    adoptBtn.disabled = true;
                    adoptBtn.innerHTML = '<i class="fas fa-check"></i> Application Submitted';
                }
            });
            
            // Close modal when clicking outside
            window.addEventListener('click', function(e) {
                const modal = document.getElementById('adoptionModal');
                if (e.target === modal) {
                    closeModal();
                }
            });
        });
        
        // Listen for sidebar toggle events
window.addEventListener('sidebarToggle', function(e) {
    const sidebarCollapsed = e.detail.collapsed;
    const mainContent = document.querySelector('.main-content');
    
    if (mainContent) {
        if (sidebarCollapsed) {
            mainContent.style.marginLeft = '70px';
            mainContent.style.width = 'calc(100% - 70px)';
        } else {
            mainContent.style.marginLeft = '280px';
            mainContent.style.width = 'calc(100% - 280px)';
        }
    }
});

// Initial setup
document.addEventListener('DOMContentLoaded', function() {
    const sidebar = document.querySelector('.sidebar-container');
    const mainContent = document.querySelector('.main-content');
    
    if (sidebar && mainContent) {
        if (sidebar.classList.contains('collapsed')) {
            mainContent.style.marginLeft = '70px';
            mainContent.style.width = 'calc(100% - 70px)';
        } else {
            mainContent.style.marginLeft = '280px';
            mainContent.style.width = 'calc(100% - 280px)';
        }
    }
    
    // Mobile check
    if (window.innerWidth <= 992) {
        if (mainContent) {
            mainContent.style.marginLeft = '0';
            mainContent.style.width = '100%';
        }
    }
});

// Handle window resize
window.addEventListener('resize', function() {
    const mainContent = document.querySelector('.main-content');
    
    if (mainContent) {
        if (window.innerWidth <= 992) {
            mainContent.style.marginLeft = '0';
            mainContent.style.width = '100%';
        } else {
            const sidebar = document.querySelector('.sidebar-container');
            if (sidebar.classList.contains('collapsed')) {
                mainContent.style.marginLeft = '70px';
                mainContent.style.width = 'calc(100% - 70px)';
            } else {
                mainContent.style.marginLeft = '280px';
                mainContent.style.width = 'calc(100% - 280px)';
            }
        }
    }
});
    </script>
    
    <!-- Modal Styles -->
    <style>
        .modal {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: rgba(0, 0, 0, 0.5);
            z-index: 2000;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        
        .modal-content {
            background: white;
            padding: 30px;
            border-radius: var(--border-radius);
            max-width: 500px;
            width: 90%;
            max-height: 90vh;
            overflow-y: auto;
        }
        
        .modal-content h3 {
            margin-top: 0;
            color: var(--pet-dark);
        }
        
        .modal-content .form-group {
            margin-bottom: 20px;
        }
        
        .modal-content label {
            display: block;
            margin-bottom: 8px;
            font-weight: 600;
            color: var(--pet-dark);
        }
        
        .modal-content textarea {
            width: 100%;
            padding: 10px;
            border: 2px solid var(--light-gray);
            border-radius: 8px;
            font-family: inherit;
            resize: vertical;
        }
        
        .modal-content textarea:focus {
            outline: none;
            border-color: var(--pet-primary);
        }
        
        .form-actions {
            display: flex;
            gap: 10px;
            justify-content: flex-end;
            margin-top: 20px;
        }
    </style>
</body>
</html>