<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="com.petie.bean.UserBean"%>
<%
    UserBean user = (UserBean) session.getAttribute("userSession");
    if (user == null) { 
        response.sendRedirect("login.jsp"); 
        return; 
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Account Settings - Petie Adoption System</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        /* CSS Variables - Same as report_stray.jsp */
        :root {
            --pet-primary: #4a90e2;
            --pet-secondary: #2ecc71;
            --pet-danger: #e74c3c;
            --pet-warning: #f39c12;
            --pet-info: #3498db;
            --pet-dark: #2c3e50;
            --pet-gray: #7f8c8d;
            --light-gray: #ecf0f1;
            --border-radius: 10px;
            --box-shadow-sm: 0 2px 5px rgba(0,0,0,0.1);
            --box-shadow-md: 0 4px 10px rgba(0,0,0,0.1);
            --box-shadow-lg: 0 8px 20px rgba(0,0,0,0.15);
        }
        
        /* Reset and Base Styles */
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #f5f7fa;
            color: #333;
            min-height: 100vh;
        }
        
        /* Main Content Area - Same structure as report_stray.jsp */
        .main-content {
            margin-left: 280px;
            transition: margin-left 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            padding: 20px;
            min-height: 100vh;
            width: calc(100% - 280px);
        }
        
        .sidebar-container.collapsed ~ .main-content {
            margin-left: 70px;
            width: calc(100% - 70px);
        }
        
        @media (max-width: 992px) {
            .main-content {
                margin-left: 0 !important;
                width: 100% !important;
                padding: 15px !important;
            }
        }
        
        /* Settings Container */
        .settings-container {
            max-width: 800px;
            margin: 0 auto;
            padding: 0;
        }
        
        /* Page Header - Matching report_stray.jsp style */
        .page-header {
            background: linear-gradient(135deg, var(--pet-secondary) 0%, #27ae60 100%);
            color: white;
            border-radius: var(--border-radius);
            padding: 25px 30px;
            margin-bottom: 30px;
            box-shadow: var(--box-shadow-lg);
        }
        
        .page-header h1 {
            margin: 0;
            display: flex;
            align-items: center;
            gap: 15px;
            font-size: 28px;
        }
        
        .page-subtitle {
            color: rgba(255, 255, 255, 0.9);
            margin: 10px 0 0 0;
            font-size: 16px;
        }
        
        /* Form Container - Same as report_stray.jsp */
        .form-container {
            background: white;
            border-radius: var(--border-radius);
            padding: 40px;
            box-shadow: var(--box-shadow-lg);
            margin-bottom: 40px;
        }
        
        .form-header {
            margin-bottom: 30px;
            padding-bottom: 20px;
            border-bottom: 2px solid var(--light-gray);
        }
        
        .form-header h2 {
            color: var(--pet-dark);
            margin: 0;
            display: flex;
            align-items: center;
            gap: 10px;
            font-size: 24px;
        }
        
        .form-header p {
            color: var(--pet-gray);
            margin: 10px 0 0 0;
        }
        
        /* Form Grid - Same layout as report_stray.jsp */
        .form-grid {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 25px;
        }
        
        @media (max-width: 768px) {
            .form-grid {
                grid-template-columns: 1fr;
            }
        }
        
        /* Form Group - Consistent styling */
        .form-group {
            margin-bottom: 20px;
        }
        
        .form-group.full-width {
            grid-column: 1 / -1;
        }
        
        .form-label {
            display: block;
            margin-bottom: 8px;
            font-weight: 600;
            color: var(--pet-dark);
            font-size: 14px;
        }
        
        .form-label .required {
            color: var(--pet-danger);
            margin-left: 3px;
        }
        
        .form-label .hint {
            color: var(--pet-gray);
            font-weight: normal;
            font-size: 12px;
            margin-left: 5px;
        }
        
        .form-control {
            width: 100%;
            padding: 12px 15px;
            border: 2px solid var(--light-gray);
            border-radius: 8px;
            font-size: 16px;
            transition: all 0.3s;
            background-color: #f8f9fa;
            font-family: inherit;
        }
        
        .form-control:focus {
            outline: none;
            border-color: var(--pet-primary);
            background-color: white;
            box-shadow: 0 0 0 3px rgba(74, 144, 226, 0.1);
        }
        
        .form-control:read-only {
            background-color: #e9ecef;
            color: #6c757d;
            cursor: not-allowed;
        }
        
        .form-control:disabled {
            background-color: #e9ecef;
            color: #6c757d;
            cursor: not-allowed;
        }
        
        /* Profile Picture Styling - Enhanced */
        .profile-picture-container {
            text-align: center;
            margin-bottom: 30px;
        }
        
        .profile-picture {
            width: 150px;
            height: 150px;
            border-radius: 50%;
            object-fit: cover;
            border: 5px solid white;
            box-shadow: var(--box-shadow-lg);
            margin-bottom: 15px;
        }
        
        .profile-picture-upload {
            position: relative;
            display: inline-block;
        }
        
        .profile-picture-overlay {
            position: absolute;
            top: 0;
            left: 0;
            width: 150px;
            height: 150px;
            border-radius: 50%;
            background: rgba(0, 0, 0, 0.5);
            display: flex;
            align-items: center;
            justify-content: center;
            opacity: 0;
            transition: opacity 0.3s;
            cursor: pointer;
        }
        
        .profile-picture-overlay:hover {
            opacity: 1;
        }
        
        .profile-picture-icon {
            color: white;
            font-size: 24px;
        }
        
        /* Form Actions - Same buttons as report_stray.jsp */
        .form-actions {
            display: flex;
            gap: 15px;
            justify-content: flex-end;
            margin-top: 40px;
            padding-top: 20px;
            border-top: 1px solid var(--light-gray);
        }
        
        .btn-save {
            background: linear-gradient(135deg, var(--pet-secondary) 0%, #27ae60 100%);
            color: white;
            border: none;
            padding: 14px 30px;
            border-radius: 8px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            display: flex;
            align-items: center;
            gap: 10px;
            transition: all 0.3s;
        }
        
        .btn-save:hover {
            background: linear-gradient(135deg, #27ae60 0%, #219653 100%);
            transform: translateY(-2px);
            box-shadow: 0 4px 15px rgba(39, 174, 96, 0.3);
        }
        
        .btn-save:disabled {
            background: var(--light-gray);
            color: var(--pet-gray);
            cursor: not-allowed;
            transform: none;
            box-shadow: none;
        }
        
        .btn-cancel {
            background: white;
            color: var(--pet-dark);
            border: 2px solid var(--light-gray);
            padding: 14px 30px;
            border-radius: 8px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            display: flex;
            align-items: center;
            gap: 10px;
            transition: all 0.3s;
            text-decoration: none;
        }
        
        .btn-cancel:hover {
            border-color: var(--pet-gray);
            background-color: #f8f9fa;
        }
        
        /* Loading Animation - Same as report_stray.jsp */
        .loading-spinner {
            display: none;
            width: 20px;
            height: 20px;
            border: 2px solid rgba(255, 255, 255, 0.3);
            border-radius: 50%;
            border-top-color: white;
            animation: spin 1s ease-in-out infinite;
        }
        
        @keyframes spin {
            to { transform: rotate(360deg); }
        }
        
        /* Message Display - Same styling */
        .message-container {
            margin-bottom: 30px;
        }
        
        .alert-success {
            background: linear-gradient(135deg, #d4edda 0%, #c3e6cb 100%);
            border: 1px solid #c3e6cb;
            color: #155724;
            padding: 15px 20px;
            border-radius: 8px;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .alert-error {
            background: linear-gradient(135deg, #f8d7da 0%, #f5c6cb 100%);
            border: 1px solid #f5c6cb;
            color: #721c24;
            padding: 15px 20px;
            border-radius: 8px;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        /* Validation Styles */
        .form-control.error {
            border-color: var(--pet-danger);
        }
        
        .error-message {
            color: var(--pet-danger);
            font-size: 12px;
            margin-top: 5px;
            display: none;
        }
        
        .error-message.show {
            display: block;
        }
        
        /* Tips Section - Similar to report_stray.jsp */
        .tips-section {
            background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
            border-radius: var(--border-radius);
            padding: 25px;
            margin-top: 40px;
            border-left: 5px solid var(--pet-primary);
        }
        
        .tips-section h3 {
            color: var(--pet-dark);
            margin-bottom: 15px;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .tips-list {
            list-style: none;
            padding: 0;
            margin: 0;
        }
        
        .tips-list li {
            padding: 8px 0;
            color: var(--pet-gray);
            display: flex;
            align-items: flex-start;
            gap: 10px;
        }
        
        .tips-list li i {
            color: var(--pet-primary);
            margin-top: 3px;
        }
        
        /* Responsive adjustments */
        @media (max-width: 576px) {
            .form-container {
                padding: 25px 20px;
            }
            
            .page-header {
                padding: 20px;
            }
            
            .page-header h1 {
                font-size: 24px;
            }
            
            .form-actions {
                flex-direction: column;
            }
            
            .btn-save, .btn-cancel {
                width: 100%;
                justify-content: center;
            }
        }
    </style>
</head>
<body>
    <!-- Include Navigation Sidebar (same as report_stray.jsp) -->
    <%@include file="navbar.jsp" %>
    
    <!-- Main Content Area (same structure as report_stray.jsp) -->
    <div class="main-content">
        <div class="settings-container">
            <!-- Page Header -->
            <div class="page-header">
                <h1>
                    <i class="fas fa-user-cog"></i> Account Settings
                </h1>
                <p class="page-subtitle">
                    Manage your profile information and preferences
                </p>
            </div>
            
            <!-- Message Display -->
            <div class="message-container" id="messageContainer">
                <!-- Messages will be shown here via JavaScript -->
            </div>
            
            <!-- Form Container -->
            <div class="form-container">
                <!-- Form Header -->
                <div class="form-header">
                    <h2>
                        <i class="fas fa-user-edit"></i> Profile Information
                    </h2>
                    <p>Update your personal details and profile picture</p>
                </div>
                
                <!-- Profile Picture -->
                <div class="profile-picture-container">
                    <div class="profile-picture-upload">
                        <img src="https://ui-avatars.com/api/?name=<%= java.net.URLEncoder.encode(user.getFullName(), "UTF-8") %>&background=4a90e2&color=fff&size=150" 
                             class="profile-picture" 
                             alt="Profile Picture"
                             id="profilePicture">
                        <div class="profile-picture-overlay" onclick="document.getElementById('profilePictureInput').click()">
                            <i class="fas fa-camera profile-picture-icon"></i>
                        </div>
                        <input type="file" 
                               id="profilePictureInput" 
                               name="profilePicture" 
                               class="file-input" 
                               accept="image/*"
                               style="display: none;"
                               onchange="handleProfilePictureUpload(event)">
                    </div>
                    <p style="text-align: center; color: var(--pet-gray); font-size: 14px; margin-top: 10px;">
                        Click on the picture to upload a new profile photo
                    </p>
                </div>
                
                <!-- Profile Form -->
                <form action="UpdateProfileServlet" method="post" id="profileForm">
                    <div class="form-grid">
                        <!-- Full Name -->
                        <div class="form-group">
                            <label class="form-label">
                                Full Name <span class="required">*</span>
                            </label>
                            <input type="text" 
                                   id="fullName" 
                                   name="fullname" 
                                   class="form-control" 
                                   value="<%= user.getFullName() %>" 
                                   required>
                            <div class="error-message" id="fullNameError"></div>
                        </div>
                        
                        <!-- Username -->
                        <div class="form-group">
                            <label class="form-label">
                                Username <span class="required">*</span>
                            </label>
                            <input type="text" 
                                   id="username" 
                                   name="username" 
                                   class="form-control" 
                                   value="<%= user.getUsername() %>" 
                                   required>
                            <div class="error-message" id="usernameError"></div>
                        </div>
                        
                        <!-- Email -->
                        <div class="form-group">
                            <label class="form-label">
                                Email Address
                            </label>
                            <input type="email" 
                                   id="email" 
                                   name="email" 
                                   class="form-control" 
                                   value="<%= user.getEmail() %>" 
                                   readonly>
                            <span class="hint">Email cannot be changed</span>
                        </div>
                        
                        <!-- Phone Number -->
                        <div class="form-group">
                            <label class="form-label">
                                Phone Number
                            </label>
                            <input type="text" 
                                   id="phone" 
                                   name="phone" 
                                   class="form-control" 
                                   value="<%= user.getPhoneNumber() != null ? user.getPhoneNumber() : "" %>" 
                                   placeholder="Enter your phone number">
                            <div class="error-message" id="phoneError"></div>
                        </div>
                    </div>
                    
                    <!-- Form Actions -->
                    <div class="form-actions">
                        <a href="account_settings.jsp" class="btn-cancel">
                            <i class="fas fa-times"></i> Cancel
                        </a>
                        <button type="submit" class="btn-save" id="saveProfileBtn">
                            <i class="fas fa-save"></i> Save Changes
                            <div class="loading-spinner" id="loadingSpinner"></div>
                        </button>
                    </div>
                </form>
            </div>
            
            <!-- Tips Section -->
            <div class="tips-section">
                <h3>
                    <i class="fas fa-lightbulb"></i> Profile Tips
                </h3>
                <ul class="tips-list">
                    <li>
                        <i class="fas fa-check-circle"></i>
                        <span>Keep your profile information up-to-date for better communication</span>
                    </li>
                    <li>
                        <i class="fas fa-check-circle"></i>
                        <span>A clear profile photo helps build trust with other users</span>
                    </li>
                    <li>
                        <i class="fas fa-check-circle"></i>
                        <span>Ensure your phone number is correct for urgent notifications</span>
                    </li>
                    <li>
                        <i class="fas fa-check-circle"></i>
                        <span>Contact support if you need to change your email address</span>
                    </li>
                </ul>
            </div>
        </div>
    </div>
    
    <!-- JavaScript for Interactive Features -->
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            // Initialize real-time validation
            document.getElementById('fullName').addEventListener('input', function() {
                if (this.value.trim().length >= 2) {
                    clearError('fullNameError');
                }
            });
            
            document.getElementById('username').addEventListener('input', function() {
                const username = this.value.trim();
                if (username.length >= 3 && /^[a-zA-Z0-9_]+$/.test(username)) {
                    clearError('usernameError');
                }
            });
            
            document.getElementById('phone').addEventListener('input', function() {
                const phone = this.value.trim();
                if (phone === '' || /^[\d\s\-\+\(\)]+$/.test(phone)) {
                    clearError('phoneError');
                }
            });
            
            // Form submission
            document.getElementById('profileForm').addEventListener('submit', function(e) {
                e.preventDefault();
                
                // Validate form
                if (validateForm()) {
                    // Show loading state
                    const submitBtn = document.getElementById('saveProfileBtn');
                    const loadingSpinner = document.getElementById('loadingSpinner');
                    
                    submitBtn.disabled = true;
                    loadingSpinner.style.display = 'block';
                    submitBtn.innerHTML = '<i class="fas fa-save"></i> Saving...';
                    submitBtn.insertBefore(loadingSpinner, submitBtn.firstChild);
                    
                    // Simulate save for demo
                    setTimeout(() => {
                        showMessage('success', 'Profile updated successfully!');
                        
                        // Reset button state
                        submitBtn.disabled = false;
                        loadingSpinner.style.display = 'none';
                        submitBtn.innerHTML = '<i class="fas fa-save"></i> Save Changes';
                        
                        // In production, uncomment this to actually submit the form
                        // this.submit();
                    }, 1500);
                }
            });
            
            // Check for URL parameters for messages
            const urlParams = new URLSearchParams(window.location.search);
            if (urlParams.has('msg')) {
                showMessage('success', decodeURIComponent(urlParams.get('msg')));
            }
            if (urlParams.has('error')) {
                showMessage('error', decodeURIComponent(urlParams.get('error')));
            }
        });
        
        // Handle profile picture upload
        function handleProfilePictureUpload(event) {
            const file = event.target.files[0];
            const preview = document.getElementById('profilePicture');
            
            if (file) {
                // Validate file type and size
                if (!file.type.match('image.*')) {
                    showMessage('error', 'Please upload an image file (JPG, PNG, etc.)');
                    return;
                }
                
                if (file.size > 2 * 1024 * 1024) { // 2MB limit
                    showMessage('error', 'File size must be less than 2MB');
                    return;
                }
                
                // Preview image
                const reader = new FileReader();
                reader.onload = function(e) {
                    preview.src = e.target.result;
                }
                reader.readAsDataURL(file);
                
                showMessage('success', 'Profile picture updated! Click "Save Changes" to apply.');
            }
        }
        
        // Show message function
        function showMessage(type, text) {
            const container = document.getElementById('messageContainer');
            const message = document.createElement('div');
            
            let icon = 'exclamation-circle';
            if (type === 'success') {
                icon = 'check-circle';
                message.className = 'alert-success';
            } else {
                message.className = 'alert-error';
            }
            
            message.innerHTML = '<i class="fas fa-' + icon + '"></i> ' + text;
            container.innerHTML = '';
            container.appendChild(message);
            
            // Auto-hide after 5 seconds
            setTimeout(() => {
                message.style.opacity = '0';
                message.style.transition = 'opacity 0.5s';
                setTimeout(() => message.remove(), 500);
            }, 5000);
        }
        
        // Show error message
        function showError(elementId, message) {
            const errorElement = document.getElementById(elementId);
            const inputElement = document.getElementById(elementId.replace('Error', ''));
            
            errorElement.textContent = message;
            errorElement.classList.add('show');
            if (inputElement) {
                inputElement.classList.add('error');
            }
        }
        
        // Clear error message
        function clearError(elementId) {
            const errorElement = document.getElementById(elementId);
            const inputElement = document.getElementById(elementId.replace('Error', ''));
            
            errorElement.textContent = '';
            errorElement.classList.remove('show');
            if (inputElement) {
                inputElement.classList.remove('error');
            }
        }
        
        // Form validation
        function validateForm() {
            let isValid = true;
            
            // Reset all errors
            document.querySelectorAll('.error-message').forEach(el => {
                el.classList.remove('show');
            });
            document.querySelectorAll('.form-control').forEach(el => {
                el.classList.remove('error');
            });
            
            // Validate full name
            const fullName = document.getElementById('fullName').value.trim();
            if (fullName.length < 2) {
                showError('fullNameError', 'Full name must be at least 2 characters');
                isValid = false;
            }
            
            // Validate username
            const username = document.getElementById('username').value.trim();
            if (username.length < 3) {
                showError('usernameError', 'Username must be at least 3 characters');
                isValid = false;
            } else if (!/^[a-zA-Z0-9_]+$/.test(username)) {
                showError('usernameError', 'Username can only contain letters, numbers, and underscores');
                isValid = false;
            }
            
            // Validate phone (optional)
            const phone = document.getElementById('phone').value.trim();
            if (phone && !/^[\d\s\-\+\(\)]+$/.test(phone)) {
                showError('phoneError', 'Please enter a valid phone number');
                isValid = false;
            }
            
            return isValid;
        }
        
        // Sidebar integration (same as report_stray.jsp)
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
        
        // Initial setup for responsive layout
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
                    if (sidebar && sidebar.classList.contains('collapsed')) {
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
</body>
</html>