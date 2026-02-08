<%@page import="com.petie.bean.UserBean"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<%
    UserBean navUser = (UserBean) session.getAttribute("userSession");
    String role = (navUser != null) ? navUser.getRole() : "";
    String username = (navUser != null) ? navUser.getUsername() : "";
    String fullName = (navUser != null) ? navUser.getFullName() : "";
    
    pageContext.setAttribute("navUser", navUser);
    pageContext.setAttribute("role", role);
    pageContext.setAttribute("username", username);
    pageContext.setAttribute("fullName", fullName);
%>

<style>
    .sidebar-container {
        position: fixed; left: 0; top: 0; bottom: 0; width: 280px;
        background: linear-gradient(180deg, #6cb2eb 0%, #3490dc 100%);
        color: white; z-index: 1000;
        box-shadow: 5px 0 15px rgba(0, 0, 0, 0.1);
        transition: all 0.3s ease; overflow-y: auto; overflow-x: hidden;
    }
    .sidebar-container.collapsed { width: 70px; }
    .sidebar-container.collapsed .sidebar-content { opacity: 0; pointer-events: none; }
    .sidebar-container.collapsed .toggle-btn i { transform: rotate(180deg); }
    .sidebar-content { padding: 25px 20px; transition: opacity 0.3s ease; }
    
    .logo-section { display: flex; align-items: center; gap: 15px; margin-bottom: 40px; padding-bottom: 20px; border-bottom: 1px solid rgba(255, 255, 255, 0.15); }
    .logo-icon { font-size: 28px; color: white; min-width: 30px; text-align: center; }
    .logo-text { font-size: 22px; font-weight: 700; color: white; }
    
    .user-profile { display: flex; align-items: center; gap: 15px; margin-bottom: 40px; padding: 15px; background: rgba(255, 255, 255, 0.12); border-radius: 8px; }
    .user-avatar { width: 50px; height: 50px; background: rgba(255, 255, 255, 0.15); border-radius: 50%; display: flex; align-items: center; justify-content: center; font-size: 20px; flex-shrink: 0; }
    .user-details { flex: 1; min-width: 0; }
    .user-name { font-weight: 600; font-size: 16px; margin-bottom: 4px; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }
    .user-role { display: inline-block; padding: 3px 10px; background: rgba(255, 255, 255, 0.15); border-radius: 12px; font-size: 11px; text-transform: uppercase; font-weight: 600; }
    
    .role-admin { background-color: rgba(231, 76, 60, 0.8); }
    .role-staff { background-color: rgba(243, 156, 18, 0.8); }
    .role-user { background-color: rgba(255, 255, 255, 0.25); }
    
    .nav-section { margin-bottom: 30px; }
    .section-title { font-size: 12px; text-transform: uppercase; color: rgba(255, 255, 255, 0.7); margin-bottom: 15px; padding-left: 10px; font-weight: 600; letter-spacing: 1px; }
    .nav-list { list-style: none; padding: 0; margin: 0; }
    .nav-item { margin-bottom: 8px; }
    .nav-link { display: flex; align-items: center; gap: 15px; color: rgba(255, 255, 255, 0.8); text-decoration: none; padding: 12px 15px; border-radius: 8px; transition: all 0.3s ease; position: relative; }
    .nav-link:hover { background: rgba(255, 255, 255, 0.15); color: white; padding-left: 20px; }
    .nav-link.active { background: rgba(255, 255, 255, 0.2); color: white; font-weight: 500; }
    .nav-link.active::before { content: ''; position: absolute; left: 0; top: 50%; transform: translateY(-50%); width: 4px; height: 50%; background: white; border-radius: 0 4px 4px 0; }
    .nav-icon { font-size: 18px; min-width: 25px; text-align: center; }
    .link-text { flex: 1; font-size: 15px; }
    
    .notification-badge { background: #dc3545; color: white; font-size: 11px; padding: 2px 8px; border-radius: 10px; font-weight: 600; }
    
    .logout-section { margin-top: auto; padding-top: 20px; border-top: 1px solid rgba(255, 255, 255, 0.1); }
    .logout-link { display: flex; align-items: center; gap: 15px; color: rgba(255, 255, 255, 0.8); text-decoration: none; padding: 12px 15px; border-radius: 8px; transition: all 0.3s ease; background: rgba(220, 53, 69, 0.2); }
    .logout-link:hover { background: red; color: white; padding-left: 20px; }
    
    .toggle-btn { position: absolute; top: 20px; right: 6px; width: 24px; height: 24px; background: white; border-radius: 50%; display: flex; align-items: center; justify-content: center; cursor: pointer; box-shadow: 0 2px 8px rgba(0, 0, 0, 0.2); z-index: 1001; border: none; color: #3490dc; font-size: 14px; transition: all 0.3s ease; }
    .toggle-btn:hover { transform: scale(1.1); box-shadow: 0 4px 12px rgba(0, 0, 0, 0.3); }
    
    .auth-section { margin-top: 40px; }
    .auth-link { display: flex; align-items: center; gap: 15px; color: white; text-decoration: none; padding: 12px 15px; margin-bottom: 10px; border-radius: 8px; transition: all 0.3s ease; }
    .login-link { background: rgba(46, 204, 113, 0.2); }
    .register-link { background: rgba(52, 152, 219, 0.2); }
    .auth-link:hover { background: rgba(255, 255, 255, 0.2); padding-left: 20px; }
    
    @media (max-width: 992px) {
        .sidebar-container { transform: translateX(-100%); width: 280px; }
        .sidebar-container.mobile-open { transform: translateX(0); }
        .mobile-menu-toggle { position: fixed; top: 20px; left: 20px; z-index: 999; background: #3490dc; color: white; border: none; border-radius: 6px; width: 45px; height: 45px; display: flex; align-items: center; justify-content: center; font-size: 20px; cursor: pointer; }
        .sidebar-overlay { position: fixed; top: 0; left: 0; right: 0; bottom: 0; background: rgba(0, 0, 0, 0.5); z-index: 999; display: none; }
        .sidebar-overlay.active { display: block; }
    }
</style>

<button class="mobile-menu-toggle" id="mobileMenuToggle"><i class="fas fa-bars"></i></button>
<div class="sidebar-overlay" id="sidebarOverlay"></div>

<div class="sidebar-container" id="sidebarContainer">
    <button class="toggle-btn" id="toggleBtn"><i class="fas fa-chevron-left"></i></button>
    
    <div class="sidebar-content">
        <div class="logo-section">
            <div class="logo-icon"><i class="fas fa-paw"></i></div>
            <div class="logo-text">Petie Adoptie</div>
        </div>
        
        <c:if test="${not empty navUser}">
            <div class="user-profile">
                <div class="user-avatar"><i class="fas fa-user"></i></div>
                <div class="user-details">
                    <div class="user-name">${fullName}</div>
                    <div class="user-role role-${role.toLowerCase()}">${role}</div>
                </div>
            </div>
        </c:if>
        
        <div class="nav-section">
            <div class="section-title">Main Menu</div>
            <ul class="nav-list">
                <li class="nav-item">
                    <a href="home.jsp" class="nav-link">
                        <div class="nav-icon"><i class="fas fa-home"></i></div>
                        <div class="link-text">Dashboard</div>
                    </a>
                </li>
                
                <c:if test="${role == 'STAFF'}">
                    <li class="nav-item">
                        <a href="manage_reports.jsp" class="nav-link">
                            <div class="nav-icon"><i class="fas fa-clipboard-check"></i></div>
                            <div class="link-text">Process Reports</div>
                            <c:if test="${not empty pendingReports && pendingReports > 0}">
                                <span class="notification-badge">${pendingReports}</span>
                            </c:if>
                        </a>
                    </li>
                </c:if>
                <c:if test="${role == 'ADMIN'}">
                    <li class="nav-item">
                        <a href="manage_users.jsp" class="nav-link">
                            <div class="nav-icon"><i class="fas fa-users"></i></div>
                            <div class="link-text">Manage Users</div>
                        </a>
                    </li>
                    <li class="nav-item">
                        <a href="admin_checklist.jsp" class="nav-link">
                            <div class="nav-icon"><i class="fas fa-clipboard-list"></i></div>
                            <div class="link-text">Process Reports</div>
                            <c:if test="${not empty pendingReports && pendingReports > 0}">
                                <span class="notification-badge">${pendingReports}</span>
                            </c:if>
                        </a>
                    </li>
                </c:if>
                
                <c:if test="${role == 'USER'}">
                    <li class="nav-item">
                        <a href="adopt_me.jsp" class="nav-link">
                            <div class="nav-icon"><i class="fas fa-search"></i></div>
                            <div class="link-text">Adopt a Pet</div>
                        </a>
                    </li>
                    <li class="nav-item">
                        <a href="report_stray.jsp" class="nav-link">
                            <div class="nav-icon"><i class="fas fa-exclamation-circle"></i></div>
                            <div class="link-text">Report Stray</div>
                        </a>
                    </li>
                    <li class="nav-item">
                        <a href="my_reports.jsp" class="nav-link">
                            <div class="nav-icon"><i class="fas fa-file-alt"></i></div>
                            <div class="link-text">My Reports</div>
                        </a>
                    </li>
                </c:if>
            </ul>
        </div>
        
        <c:if test="${not empty navUser}">
            <div class="nav-section">
                <div class="section-title">Account</div>
                <ul class="nav-list">
                    <li class="nav-item">
                        <a href="account_settings.jsp" class="nav-link">
                            <div class="nav-icon"><i class="fas fa-cog"></i></div>
                            <div class="link-text">Settings</div>
                        </a>
                </ul>
            </div>
        </c:if>
        
        <c:if test="${empty navUser}">
            <div class="auth-section">
                <a href="login.jsp" class="auth-link login-link">
                    <div class="nav-icon"><i class="fas fa-sign-in-alt"></i></div>
                    <div class="link-text">Login</div>
                </a>
                <a href="register.jsp" class="auth-link register-link">
                    <div class="nav-icon"><i class="fas fa-user-plus"></i></div>
                    <div class="link-text">Register</div>
                </a>
            </div>
        </c:if>
        
        <c:if test="${not empty navUser}">
            <div class="logout-section">
                <a href="LogoutServlet" class="logout-link">
                    <div class="nav-icon"><i class="fas fa-sign-out-alt"></i></div>
                    <div class="link-text">Logout</div>
                </a>
            </div>
        </c:if>
    </div>
</div>

<script>
    document.addEventListener('DOMContentLoaded', function() {
        const sidebar = document.getElementById('sidebarContainer');
        const toggleBtn = document.getElementById('toggleBtn');
        const mobileToggle = document.getElementById('mobileMenuToggle');
        const sidebarOverlay = document.getElementById('sidebarOverlay');
        
        if (sidebar) sidebar.offsetHeight; 
        
        if (toggleBtn) {
            toggleBtn.addEventListener('click', function() {
                if (!sidebar.classList.contains('transitioning')) {
                    sidebar.classList.add('transitioning');
                    setTimeout(() => sidebar.classList.remove('transitioning'), 300);
                }
                sidebar.classList.toggle('collapsed');
                localStorage.setItem('sidebarCollapsed', sidebar.classList.contains('collapsed'));
            });
            if (localStorage.getItem('sidebarCollapsed') === 'true') sidebar.classList.add('collapsed');
        }
        
        if (mobileToggle) {
            mobileToggle.addEventListener('click', () => {
                sidebar.classList.toggle('mobile-open');
                sidebarOverlay.classList.toggle('active');
            });
            sidebarOverlay.addEventListener('click', () => {
                sidebar.classList.remove('mobile-open');
                sidebarOverlay.classList.remove('active');
            });
        }
    });
</script>