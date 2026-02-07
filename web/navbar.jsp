<%@page import="com.petie.bean.UserBean"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<%
    // Get user session information
    UserBean navUser = (UserBean) session.getAttribute("userSession");
    String role = (navUser != null) ? navUser.getRole() : "";
    String username = (navUser != null) ? navUser.getUsername() : "";
    String fullName = (navUser != null) ? navUser.getFullName() : "";
    
    // Set variables for JSTL usage
    pageContext.setAttribute("navUser", navUser);
    pageContext.setAttribute("role", role);
    pageContext.setAttribute("username", username);
    pageContext.setAttribute("fullName", fullName);
%>

<style>
    /* Sidebar Container */
    .sidebar-container {
        position: fixed;
        left: 0;
        top: 0;
        bottom: 0;
        width: 280px;
        /* CHANGED: Lighter blue gradient */
        background: linear-gradient(180deg, #6cb2eb 0%, #3490dc 100%);
        color: white;
        z-index: 1000;
        box-shadow: 5px 0 15px rgba(0, 0, 0, 0.1);
        transition: all 0.3s ease;
        overflow-y: auto;
        overflow-x: hidden;
    }
    
    /* Collapsed state */
    .sidebar-container.collapsed {
        width: 70px;
    }
    
    .sidebar-container.collapsed .sidebar-content {
        opacity: 0;
        pointer-events: none;
    }
    
    .sidebar-container.collapsed .logo-text,
    .sidebar-container.collapsed .user-name,
    .sidebar-container.collapsed .link-text,
    .sidebar-container.collapsed .section-title,
    .sidebar-container.collapsed .user-role {
        display: none;
    }
    
    .sidebar-container.collapsed .toggle-btn i {
        transform: rotate(180deg);
    }
    
    /* Sidebar Content */
    .sidebar-content {
        padding: 25px 20px;
        transition: opacity 0.3s ease;
    }
    
    /* Logo Section */
    .logo-section {
        display: flex;
        align-items: center;
        gap: 15px;
        margin-bottom: 40px;
        padding-bottom: 20px;
        border-bottom: 1px solid rgba(255, 255, 255, 0.15);
    }
    
    .logo-icon {
        font-size: 28px;
        color: white;
        min-width: 30px;
        text-align: center;
    }
    
    .logo-text {
        font-size: 22px;
        font-weight: 700;
        color: white;
    }
    
    /* User Profile Section */
    .user-profile {
        display: flex;
        align-items: center;
        gap: 15px;
        margin-bottom: 40px;
        padding: 15px;
        background: rgba(255, 255, 255, 0.12);
        border-radius: var(--border-radius);
    }
    
    .user-avatar {
        width: 50px;
        height: 50px;
        background: rgba(255, 255, 255, 0.15);
        border-radius: 50%;
        display: flex;
        align-items: center;
        justify-content: center;
        font-size: 20px;
        flex-shrink: 0;
    }
    
    .user-details {
        flex: 1;
        min-width: 0; /* For text truncation */
    }
    
    .user-name {
        font-weight: 600;
        font-size: 16px;
        margin-bottom: 4px;
        white-space: nowrap;
        overflow: hidden;
        text-overflow: ellipsis;
    }
    
    .user-role {
        display: inline-block;
        padding: 3px 10px;
        background: rgba(255, 255, 255, 0.15);
        border-radius: 12px;
        font-size: 11px;
        text-transform: uppercase;
        font-weight: 600;
    }
    
    /* Role-specific colors */
     .role-admin { 
        background-color: rgba(231, 76, 60, 0.8); 
    }
    .role-staff { 
        background-color: rgba(243, 156, 18, 0.8); 
    }
    .role-user { 
        background-color: rgba(255, 255, 255, 0.25); 
    }
    
    /* Navigation Links */
    .nav-section {
        margin-bottom: 30px;
    }
    
    .section-title {
        font-size: 12px;
        text-transform: uppercase;
        color: rgba(255, 255, 255, 0.7);
        margin-bottom: 15px;
        padding-left: 10px;
        font-weight: 600;
        letter-spacing: 1px;
    }
    
    .nav-list {
        list-style: none;
        padding: 0;
        margin: 0;
    }
    
    .nav-item {
        margin-bottom: 8px;
    }
    
    .nav-link {
        display: flex;
        align-items: center;
        gap: 15px;
        color: rgba(255, 255, 255, 0.8);
        text-decoration: none;
        padding: 12px 15px;
        border-radius: var(--border-radius);
        transition: all 0.3s ease;
        position: relative;
    }
    
    .nav-link:hover {
        background: rgba(255, 255, 255, 0.15);
        color: white;
        padding-left: 20px;
    }
    
    .nav-link.active {
        background: rgba(255, 255, 255, 0.2);
        color: white;
        font-weight: 500;
    }
    
    .nav-link.active::before {
        content: '';
        position: absolute;
        left: 0;
        top: 50%;
        transform: translateY(-50%);
        width: 4px;
        height: 50%;
        background: white;
        border-radius: 0 4px 4px 0;
    }
    
    .nav-icon {
        font-size: 18px;
        min-width: 25px;
        text-align: center;
    }
    
    .link-text {
        flex: 1;
        font-size: 15px;
    }
    
    /* Notification Badge */
    .notification-badge {
        background: var(--danger);
        color: white;
        font-size: 11px;
        padding: 2px 8px;
        border-radius: 10px;
        font-weight: 600;
    }
    
    /* Logout Section */
    .logout-section {
        margin-top: auto;
        padding-top: 20px;
        border-top: 1px solid rgba(255, 255, 255, 0.1);
    }
    
    .logout-link {
        display: flex;
        align-items: center;
        gap: 15px;
        color: rgba(255, 255, 255, 0.8);
        text-decoration: none;
        padding: 12px 15px;
        border-radius: var(--border-radius);
        transition: all 0.3s ease;
        background: rgba(220, 53, 69, 0.2);
    }
    
    .logout-link:hover {
        background: red;
        color: white;
        padding-left: 20px;
    }
    
    /* Toggle Button */
    .toggle-btn {
        position: absolute;
        top: 20px;
        right: 6px;
        width: 24px;
        height: 24px;
        background: white;
        border-radius: 50%;
        display: flex;
        align-items: center;
        justify-content: center;
        cursor: pointer;
        box-shadow: 0 2px 8px rgba(0, 0, 0, 0.2);
        z-index: 1001;
        border: none;
        color: var(--primary);
        font-size: 14px;
        transition: all 0.3s ease;
    }
    
    .toggle-btn:hover {
        transform: scale(1.1);
        box-shadow: 0 4px 12px rgba(0, 0, 0, 0.3);
    }
    
    /* Login/Register Section (when no user) */
    .auth-section {
        margin-top: 40px;
    }
    
    .auth-link {
        display: flex;
        align-items: center;
        gap: 15px;
        color: white;
        text-decoration: none;
        padding: 12px 15px;
        margin-bottom: 10px;
        border-radius: var(--border-radius);
        transition: all 0.3s ease;
    }
    
    .login-link {
        background: rgba(46, 204, 113, 0.2);
    }
    
    .register-link {
        background: rgba(52, 152, 219, 0.2);
    }
    
    .auth-link:hover {
        background: rgba(255, 255, 255, 0.2);
        padding-left: 20px;
    }
    
    /* REMOVE THIS SECTION - Let each page define its own main-content styles */
    /*
    .main-content {
        margin-left: 280px;
        transition: margin-left 0.3s ease;
        padding: 20px;
        min-height: 100vh;
    }
    
    .sidebar-container.collapsed ~ .main-content {
        margin-left: 70px;
    }
    */
    
    /* Mobile Responsive */
    @media (max-width: 992px) {
        .sidebar-container {
            transform: translateX(-100%);
            width: 280px;
        }
        
        .sidebar-container.mobile-open {
            transform: translateX(0);
        }
        
        .sidebar-container.collapsed {
            transform: translateX(-100%);
            width: 280px;
        }
        
        /* REMOVE THIS - Each page will handle mobile styles */
        /*
        .main-content {
            margin-left: 0;
        }
        */
        
        .mobile-menu-toggle {
            position: fixed;
            top: 20px;
            left: 20px;
            z-index: 999;
            background: var(--primary);
            color: white;
            border: none;
            border-radius: 6px;
            width: 45px;
            height: 45px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 20px;
            cursor: pointer;
            box-shadow: var(--box-shadow);
        }
        
        .mobile-menu-toggle.active {
            left: 300px;
        }
        
        .sidebar-overlay {
            position: fixed;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: rgba(0, 0, 0, 0.5);
            z-index: 999;
            display: none;
        }
        
        .sidebar-overlay.active {
            display: block;
        }
    }
    
    /* Custom Scrollbar */
    .sidebar-container::-webkit-scrollbar {
        width: 5px;
    }
    
    .sidebar-container::-webkit-scrollbar-track {
        background: rgba(255, 255, 255, 0.1);
    }
    
    .sidebar-container::-webkit-scrollbar-thumb {
        background: rgba(255, 255, 255, 0.3);
        border-radius: 10px;
    }
    
    .sidebar-container::-webkit-scrollbar-thumb:hover {
        background: rgba(255, 255, 255, 0.5);
    }
</style>

<!-- Mobile Menu Toggle Button (only visible on mobile) -->
<button class="mobile-menu-toggle" id="mobileMenuToggle">
    <i class="fas fa-bars"></i>
</button>

<!-- Sidebar Overlay for Mobile -->
<div class="sidebar-overlay" id="sidebarOverlay"></div>

<!-- Sidebar Container -->
<div class="sidebar-container" id="sidebarContainer">
    <!-- Toggle Button for Collapsing -->
    <button class="toggle-btn" id="toggleBtn">
        <i class="fas fa-chevron-left"></i>
    </button>
    
    <div class="sidebar-content">
        <!-- Logo Section -->
        <div class="logo-section">
            <div class="logo-icon">
                <i class="fas fa-paw"></i>
            </div>
            <div class="logo-text">Petie Adoptie</div>
        </div>
        
        <!-- User Profile Section -->
        <c:if test="${not empty navUser}">
            <div class="user-profile">
                <div class="user-avatar">
                    <i class="fas fa-user"></i>
                </div>
                <div class="user-details">
                    <div class="user-name">${fullName}</div>
                    <div class="user-role role-${role.toLowerCase()}">${role}</div>
                </div>
            </div>
        </c:if>
        
        <!-- Navigation Links -->
        <div class="nav-section">
            <div class="section-title">Main Menu</div>
            <ul class="nav-list">
                <!-- Home Link for All Users -->
                <li class="nav-item">
                    <a href="home.jsp" class="nav-link">
                        <div class="nav-icon">
                            <i class="fas fa-home"></i>
                        </div>
                        <div class="link-text">Dashboard</div>
                    </a>
                </li>
                
                <!-- ADMIN Navigation -->
                <c:if test="${role == 'ADMIN'}">
                    <li class="nav-item">
                        <a href="admin_dashboard.jsp" class="nav-link">
                            <div class="nav-icon">
                                <i class="fas fa-tachometer-alt"></i>
                            </div>
                            <div class="link-text">Admin Panel</div>
                        </a>
                    </li>
                    <li class="nav-item">
                        <a href="manage_users.jsp" class="nav-link">
                            <div class="nav-icon">
                                <i class="fas fa-users"></i>
                            </div>
                            <div class="link-text">Manage Users</div>
                        </a>
                    </li>
                    <li class="nav-item">
                        <a href="admin_checklist.jsp" class="nav-link">
                            <div class="nav-icon">
                                <i class="fas fa-clipboard-list"></i>
                            </div>
                            <div class="link-text">Stray Reports</div>
                            <c:if test="${not empty pendingReports && pendingReports > 0}">
                                <span class="notification-badge">${pendingReports}</span>
                            </c:if>
                        </a>
                    </li>
                </c:if>
                
                <!-- STAFF Navigation -->
                <c:if test="${role == 'STAFF' || role == 'ADMIN'}">
                    <li class="nav-item">
                        <a href="manage_reports.jsp" class="nav-link">
                            <div class="nav-icon">
                                <i class="fas fa-clipboard-check"></i>
                            </div>
                            <div class="link-text">Process Reports</div>
                            <c:if test="${not empty pendingReports && pendingReports > 0}">
                                <span class="notification-badge">${pendingReports}</span>
                            </c:if>
                        </a>
                    </li>
                    <li class="nav-item">
                        <a href="manage_pets.jsp" class="nav-link">
                            <div class="nav-icon">
                                <i class="fas fa-paw"></i>
                            </div>
                            <div class="link-text">Manage Pets</div>
                        </a>
                    </li>
                </c:if>
                
                <!-- USER Navigation (visible to all logged in users) -->
                <c:if test="${not empty navUser}">
                    <li class="nav-item">
                        <a href="adopt_me.jsp" class="nav-link">
                            <div class="nav-icon">
                                <i class="fas fa-search"></i>
                            </div>
                            <div class="link-text">Adopt a Pet</div>
                        </a>
                    </li>
                    <li class="nav-item">
                        <a href="report_stray.jsp" class="nav-link">
                            <div class="nav-icon">
                                <i class="fas fa-exclamation-circle"></i>
                            </div>
                            <div class="link-text">Report Stray</div>
                        </a>
                    </li>
                    <li class="nav-item">
                        <a href="my_applications.jsp" class="nav-link">
                            <div class="nav-icon">
                                <i class="fas fa-heart"></i>
                            </div>
                            <div class="link-text">My Applications</div>
                            <c:if test="${not empty pendingApplications && pendingApplications > 0}">
                                <span class="notification-badge">${pendingApplications}</span>
                            </c:if>
                        </a>
                    </li>
                    <li class="nav-item">
                        <a href="my_reports.jsp" class="nav-link">
                            <div class="nav-icon">
                                <i class="fas fa-file-alt"></i>
                            </div>
                            <div class="link-text">My Reports</div>
                        </a>
                    </li>
                </c:if>
            </ul>
        </div>
        
        <!-- Account Section -->
        <c:if test="${not empty navUser}">
            <div class="nav-section">
                <div class="section-title">Account</div>
                <ul class="nav-list">
                    <li class="nav-item">
                        <a href="account_settings.jsp" class="nav-link">
                            <div class="nav-icon">
                                <i class="fas fa-cog"></i>
                            </div>
                            <div class="link-text">Settings</div>
                        </a>
                    </li>
                </ul>
            </div>
        </c:if>
        
        <!-- Authentication Section (when no user) -->
        <c:if test="${empty navUser}">
            <div class="auth-section">
                <a href="login.jsp" class="auth-link login-link">
                    <div class="nav-icon">
                        <i class="fas fa-sign-in-alt"></i>
                    </div>
                    <div class="link-text">Login</div>
                </a>
                <a href="register.jsp" class="auth-link register-link">
                    <div class="nav-icon">
                        <i class="fas fa-user-plus"></i>
                    </div>
                    <div class="link-text">Register</div>
                </a>
            </div>
        </c:if>
        
        <!-- Logout Section -->
        <c:if test="${not empty navUser}">
            <div class="logout-section">
                <a href="LogoutServlet" class="logout-link">
                    <div class="nav-icon">
                        <i class="fas fa-sign-out-alt"></i>
                    </div>
                    <div class="link-text">Logout</div>
                </a>
            </div>
        </c:if>
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

<!-- Main Content Wrapper - REMOVE THIS COMMENTED OUT DIV -->
<!-- <div class="main-content" id="mainContent"> -->
    <!-- Your page content goes here -->
    
<script>
    document.addEventListener('DOMContentLoaded', function() {
        const sidebar = document.getElementById('sidebarContainer');
        const toggleBtn = document.getElementById('toggleBtn');
        const mobileToggle = document.getElementById('mobileMenuToggle');
        const sidebarOverlay = document.getElementById('sidebarOverlay');
        // REMOVE: const mainContent = document.getElementById('mainContent');
        
        // Force a reflow to prevent animation delay
        if (sidebar) {
            sidebar.offsetHeight; // Trigger reflow
        }
        
        // Collapse/Expand toggle for desktop
        if (toggleBtn) {
            toggleBtn.addEventListener('click', function() {
                // Add transition class if not present
                if (!sidebar.classList.contains('transitioning')) {
                    sidebar.classList.add('transitioning');
                    setTimeout(() => {
                        sidebar.classList.remove('transitioning');
                    }, 300);
                }
                
                // Toggle collapsed state
                sidebar.classList.toggle('collapsed');
                
                // Save state to localStorage
                const isCollapsed = sidebar.classList.contains('collapsed');
                localStorage.setItem('sidebarCollapsed', isCollapsed);
                
                // Trigger custom event for pages to listen to
                const event = new CustomEvent('sidebarToggle', { 
                    detail: { collapsed: isCollapsed } 
                });
                window.dispatchEvent(event);
            });
            
            // Load saved state
            const savedState = localStorage.getItem('sidebarCollapsed');
            if (savedState === 'true') {
                sidebar.classList.add('collapsed');
            }
        }
        
        // Mobile menu toggle
        if (mobileToggle && sidebarOverlay) {
            mobileToggle.addEventListener('click', function() {
                sidebar.classList.toggle('mobile-open');
                mobileToggle.classList.toggle('active');
                sidebarOverlay.classList.toggle('active');
                
                // Prevent body scroll when sidebar is open
                document.body.style.overflow = sidebar.classList.contains('mobile-open') ? 'hidden' : '';
            });
            
            // Close sidebar when clicking overlay
            sidebarOverlay.addEventListener('click', function() {
                sidebar.classList.remove('mobile-open');
                mobileToggle.classList.remove('active');
                sidebarOverlay.classList.remove('active');
                document.body.style.overflow = '';
            });
            
            // Close sidebar when clicking on a link (mobile)
            sidebar.querySelectorAll('.nav-link').forEach(link => {
                link.addEventListener('click', function() {
                    if (window.innerWidth <= 992) {
                        sidebar.classList.remove('mobile-open');
                        mobileToggle.classList.remove('active');
                        sidebarOverlay.classList.remove('active');
                        document.body.style.overflow = '';
                    }
                });
            });
        }
        
        // Highlight active page
        const currentPage = window.location.pathname.split('/').pop();
        const navLinks = document.querySelectorAll('.nav-link');
        
        navLinks.forEach(link => {
            const linkHref = link.getAttribute('href');
            if (linkHref === currentPage || 
                (currentPage === '' && linkHref === 'home.jsp') ||
                (currentPage === 'index.jsp' && linkHref === 'home.jsp')) {
                link.classList.add('active');
            }
        });
        
        // Auto-collapse on mobile
        function handleResize() {
            if (window.innerWidth <= 992) {
                sidebar.classList.remove('collapsed');
                sidebar.classList.remove('mobile-open');
                mobileToggle.classList.remove('active');
                sidebarOverlay.classList.remove('active');
                document.body.style.overflow = '';
            } else {
                // Restore collapsed state on desktop
                const savedState = localStorage.getItem('sidebarCollapsed');
                if (savedState === 'true') {
                    sidebar.classList.add('collapsed');
                } else {
                    sidebar.classList.remove('collapsed');
                }
            }
        }
        
        // Listen for window resize
        window.addEventListener('resize', handleResize);
        handleResize(); // Initial check
        
        // Keyboard shortcuts
        document.addEventListener('keydown', function(e) {
            // Ctrl + B to toggle sidebar (when not typing)
            if (e.ctrlKey && e.key === 'b' && !e.target.matches('input, textarea, select')) {
                e.preventDefault();
                if (window.innerWidth > 992) {
                    toggleBtn.click();
                }
            }
            
            // Escape to close mobile sidebar
            if (e.key === 'Escape' && window.innerWidth <= 992 && 
                sidebar.classList.contains('mobile-open')) {
                sidebar.classList.remove('mobile-open');
                mobileToggle.classList.remove('active');
                sidebarOverlay.classList.remove('active');
                document.body.style.overflow = '';
            }
        });
    });
</script>