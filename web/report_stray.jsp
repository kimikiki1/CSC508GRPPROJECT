<%-- 
    report_stray.jsp - Report Stray Animal Page
    Features:
    - Form to report stray animals with photo upload
    - Validation and user-friendly interface
    - Integration with sidebar navigation
    - Success/error message display
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
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
    <title>Report Stray Animal - Petie Adoption System</title>
    <link rel="stylesheet" href="style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        /* CSS Reset for report page */
        .report-container,
        .report-container * {
            box-sizing: border-box;
        }
        
        /* Main Content Area */
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
        
        /* Page-specific styles for report page */
        .report-container {
            max-width: 900px;
            margin: 0 auto;
            padding: 0;
        }
        
        /* Page Header */
        .page-header {
            background: linear-gradient(135deg, var(--pet-danger) 0%, #c0392b 100%);
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
        }
        
        .page-subtitle {
            color: rgba(255, 255, 255, 0.9);
            margin: 10px 0 0 0;
            font-size: 16px;
        }
        
        /* Form Container */
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
        }
        
        .form-header p {
            color: var(--pet-gray);
            margin: 10px 0 0 0;
        }
        
        /* Form Grid Layout */
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
        
        /* Form Group */
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
        
        .form-control::placeholder {
            color: #adb5bd;
        }
        
        textarea.form-control {
            resize: vertical;
            min-height: 120px;
        }
        
        /* File Upload Styling */
        .file-upload-container {
            position: relative;
            margin-top: 5px;
        }
        
        .file-upload-label {
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 40px 20px;
            border: 2px dashed var(--light-gray);
            border-radius: 8px;
            background-color: #f8f9fa;
            cursor: pointer;
            transition: all 0.3s;
            text-align: center;
        }
        
        .file-upload-label:hover {
            border-color: var(--pet-primary);
            background-color: #e9ecef;
        }
        
        .file-upload-icon {
            font-size: 48px;
            color: var(--pet-primary);
            margin-bottom: 15px;
        }
        
        .file-upload-text {
            color: var(--pet-gray);
            font-size: 14px;
        }
        
        .file-upload-text strong {
            color: var(--pet-primary);
        }
        
        .file-input {
            position: absolute;
            width: 0.1px;
            height: 0.1px;
            opacity: 0;
            overflow: hidden;
            z-index: -1;
        }
        
        .file-preview {
            margin-top: 15px;
            display: none;
        }
        
        .file-preview img {
            max-width: 100%;
            max-height: 200px;
            border-radius: 8px;
            border: 1px solid var(--light-gray);
        }
        
        .file-name {
            margin-top: 8px;
            font-size: 14px;
            color: var(--pet-gray);
            word-break: break-all;
        }
        
        /* Pet Type Select Styling */
        .pet-type-select {
            position: relative;
        }
        
        .pet-type-options {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(120px, 1fr));
            gap: 10px;
            margin-top: 10px;
        }
        
        .pet-type-option {
            padding: 12px;
            border: 2px solid var(--light-gray);
            border-radius: 8px;
            text-align: center;
            cursor: pointer;
            transition: all 0.3s;
            background: white;
        }
        
        .pet-type-option:hover {
            border-color: var(--pet-primary);
            background-color: #f8f9fa;
        }
        
        .pet-type-option.selected {
            border-color: var(--pet-primary);
            background-color: rgba(74, 144, 226, 0.1);
        }
        
        .pet-type-icon {
            font-size: 24px;
            margin-bottom: 8px;
            color: var(--pet-primary);
        }
        
        .pet-type-name {
            font-size: 14px;
            font-weight: 500;
            color: var(--pet-dark);
        }
        
        /* Location Input with Map Icon */
        .location-input {
            position: relative;
        }
        
        .location-icon {
            position: absolute;
            right: 15px;
            top: 50%;
            transform: translateY(-50%);
            color: var(--pet-primary);
            pointer-events: none;
        }
        
        /* Date Input Styling */
        .date-input {
            position: relative;
        }
        
        /* Situation Textarea */
        .situation-counter {
            text-align: right;
            font-size: 12px;
            color: var(--pet-gray);
            margin-top: 5px;
        }
        
        .situation-counter.warning {
            color: var(--pet-secondary);
        }
        
        .situation-counter.danger {
            color: var(--pet-danger);
        }
        
        /* Form Actions */
        .form-actions {
            display: flex;
            gap: 15px;
            justify-content: flex-end;
            margin-top: 40px;
            padding-top: 20px;
            border-top: 1px solid var(--light-gray);
        }
        
        .btn-submit {
            background: linear-gradient(135deg, var(--pet-danger) 0%, #c0392b 100%);
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
        
        .btn-submit:hover {
            background: linear-gradient(135deg, #c0392b 0%, #a93226 100%);
            transform: translateY(-2px);
            box-shadow: 0 4px 15px rgba(231, 76, 60, 0.3);
        }
        
        .btn-submit:disabled {
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
        
        /* Tips Section */
        .tips-section {
            background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
            border-radius: var(--border-radius);
            padding: 25px;
            margin-top: 40px;
            border-left: 5px solid var(--pet-secondary);
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
            color: var(--pet-secondary);
            margin-top: 3px;
        }
        
        /* Message Display */
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
        
        /* Loading Animation */
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
    </style>
</head>
<body>
    <!-- Include Navigation Sidebar -->
    <%@include file="navbar.jsp" %>
    
    <!-- Main Content Area -->
    <div class="main-content">
        <div class="report-container">
            <!-- Page Header -->
            <div class="page-header">
                <h1>
                    <i class="fas fa-exclamation-triangle"></i> Report a Stray Animal
                </h1>
                <p class="page-subtitle">
                    Help save a life by reporting stray animals in need. Your report could be their ticket to safety.
                </p>
            </div>
            
            <!-- Message Display -->
            <div class="message-container">
                <c:if test="${not empty msg}">
                    <div class="alert-success">
                        <i class="fas fa-check-circle"></i> ${msg}
                    </div>
                </c:if>
                
                <c:if test="${not empty error}">
                    <div class="alert-error">
                        <i class="fas fa-exclamation-circle"></i> ${error}
                    </div>
                </c:if>
            </div>
            
            <!-- Form Container -->
            <div class="form-container">
                <!-- Form Header -->
                <div class="form-header">
                    <h2>
                        <i class="fas fa-paw"></i> Animal Details
                    </h2>
                    <p>Please provide as much information as possible to help our rescue team.</p>
                </div>
                
                <!-- Report Form -->
                <form action="ReportStrayServlet" method="post" enctype="multipart/form-data" id="reportForm" onsubmit="return validateForm()">
                    <div class="form-grid">
                        <!-- Photo Upload -->
                        <div class="form-group full-width">
                            <label class="form-label">
                                Upload Photo <span class="required">*</span>
                                <span class="hint">(Max 5MB, JPG/PNG only)</span>
                            </label>
                            <div class="file-upload-container">
                                <label for="petPhoto" class="file-upload-label">
                                    <div>
                                        <div class="file-upload-icon">
                                            <i class="fas fa-camera"></i>
                                        </div>
                                        <div class="file-upload-text">
                                            <strong>Click to upload</strong> or drag and drop
                                            <br>
                                            <span>Clear photos help identify the animal</span>
                                        </div>
                                    </div>
                                </label>
                                <input type="file" id="petPhoto" name="petPhoto" class="file-input" accept="image/*" required>
                                
                                <div class="file-preview" id="filePreview">
                                    <img id="previewImage" src="" alt="Preview">
                                    <div class="file-name" id="fileName"></div>
                                </div>
                            </div>
                            <div class="error-message" id="photoError"></div>
                        </div>
                        
                        <!-- Pet Type -->
                        <div class="form-group">
                            <label class="form-label">
                                Pet Type <span class="required">*</span>
                            </label>
                            <input type="text" 
                                   id="petType" 
                                   name="petType" 
                                   class="form-control" 
                                   placeholder="e.g., Dog, Cat, Rabbit, Bird"
                                   required>
                            <div class="error-message" id="petTypeError"></div>
                            
                            <!-- Quick Selection Options -->
                            <div class="pet-type-options">
                                <div class="pet-type-option" data-type="Dog">
                                    <div class="pet-type-icon">
                                        <i class="fas fa-dog"></i>
                                    </div>
                                    <div class="pet-type-name">Dog</div>
                                </div>
                                <div class="pet-type-option" data-type="Cat">
                                    <div class="pet-type-icon">
                                        <i class="fas fa-cat"></i>
                                    </div>
                                    <div class="pet-type-name">Cat</div>
                                </div>
                                <div class="pet-type-option" data-type="Rabbit">
                                    <div class="pet-type-icon">
                                        <i class="fas fa-paw"></i>
                                    </div>
                                    <div class="pet-type-name">Rabbit</div>
                                </div>
                                <div class="pet-type-option" data-type="Bird">
                                    <div class="pet-type-icon">
                                        <i class="fas fa-dove"></i>
                                    </div>
                                    <div class="pet-type-name">Bird</div>
                                </div>
                                <div class="pet-type-option" data-type="Other">
                                    <div class="pet-type-icon">
                                        <i class="fas fa-question"></i>
                                    </div>
                                    <div class="pet-type-name">Other</div>
                                </div>
                            </div>
                        </div>
                        
                        <!-- Location -->
                        <div class="form-group">
                            <label class="form-label">
                                Location Found <span class="required">*</span>
                            </label>
                            <div class="location-input">
                                <input type="text" 
                                       id="location" 
                                       name="location" 
                                       class="form-control" 
                                       placeholder="e.g., Jalan Ampang, KLCC Park"
                                       required>
                                <i class="fas fa-map-marker-alt location-icon"></i>
                            </div>
                            <div class="error-message" id="locationError"></div>
                        </div>
                        
                        <!-- Date Found -->
                        <div class="form-group">
                            <label class="form-label">
                                Date Found <span class="required">*</span>
                            </label>
                            <div class="date-input">
                                <input type="date" 
                                       id="dateFound" 
                                       name="dateFound" 
                                       class="form-control" 
                                       required>
                            </div>
                            <div class="error-message" id="dateError"></div>
                        </div>
                        
                        <!-- Situation Description -->
                        <div class="form-group full-width">
                            <label class="form-label">
                                Situation Description <span class="required">*</span>
                                <span class="hint">(Describe condition, behavior, injuries, etc.)</span>
                            </label>
                            <textarea 
                                id="situation" 
                                name="situation" 
                                class="form-control" 
                                placeholder="Please describe:
• Is the animal injured or sick?
• Is it friendly or scared?
• Any visible tags or collars?
• Approximate size and color
• Any other important details..."
                                rows="5"
                                required
                                maxlength="1000"
                                oninput="updateCharacterCount()"></textarea>
                            <div class="situation-counter" id="charCount">0/1000 characters</div>
                            <div class="error-message" id="situationError"></div>
                        </div>
                    </div>
                    
                    <!-- Form Actions -->
                    <div class="form-actions">
                        <a href="report_stray.jsp" class="btn-cancel">
                            <i class="fas fa-times"></i> Cancel
                        </a>
                        <button type="submit" class="btn-submit" id="submitBtn">
                            <i class="fas fa-paper-plane"></i> Submit Report
                            <div class="loading-spinner" id="loadingSpinner"></div>
                        </button>
                    </div>
                </form>
            </div>
            
            <!-- Tips Section -->
            <div class="tips-section">
                <h3>
                    <i class="fas fa-lightbulb"></i> Tips for Reporting
                </h3>
                <ul class="tips-list">
                    <li>
                        <i class="fas fa-camera"></i>
                        <span>Take clear photos from multiple angles if possible</span>
                    </li>
                    <li>
                        <i class="fas fa-map-pin"></i>
                        <span>Be as specific as possible about the location (landmarks, street names)</span>
                    </li>
                    <li>
                        <i class="fas fa-shield-alt"></i>
                        <span>Do not approach if the animal seems aggressive or dangerous</span>
                    </li>
                    <li>
                        <i class="fas fa-clock"></i>
                        <span>Report as soon as possible - time is critical for rescue operations</span>
                    </li>
                    <li>
                        <i class="fas fa-notes-medical"></i>
                        <span>Note any visible injuries, limping, or signs of distress</span>
                    </li>
                </ul>
            </div>
        </div>
    </div>
    
    <!-- JavaScript for Interactive Features -->
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            // Initialize date field with today's date
            const today = new Date().toISOString().split('T')[0];
            document.getElementById('dateFound').value = today;
            
            // Initialize character counter
            updateCharacterCount();
            
            // File upload preview
            const fileInput = document.getElementById('petPhoto');
            const filePreview = document.getElementById('filePreview');
            const previewImage = document.getElementById('previewImage');
            const fileName = document.getElementById('fileName');
            
            fileInput.addEventListener('change', function(e) {
                const file = e.target.files[0];
                
                if (file) {
                    // Validate file type and size
                    if (!file.type.match('image.*')) {
                        showError('photoError', 'Please upload an image file (JPG, PNG, etc.)');
                        fileInput.value = '';
                        return;
                    }
                    
                    if (file.size > 5 * 1024 * 1024) { // 5MB limit
                        showError('photoError', 'File size must be less than 5MB');
                        fileInput.value = '';
                        return;
                    }
                    
                    // Show file name
                    fileName.textContent = file.name;
                    
                    // Show image preview
                    const reader = new FileReader();
                    reader.onload = function(e) {
                        previewImage.src = e.target.result;
                        filePreview.style.display = 'block';
                    }
                    reader.readAsDataURL(file);
                    
                    // Clear any previous errors
                    clearError('photoError');
                } else {
                    filePreview.style.display = 'none';
                }
            });
            
            // Pet type quick selection
            document.querySelectorAll('.pet-type-option').forEach(option => {
                option.addEventListener('click', function() {
                    const petType = this.getAttribute('data-type');
                    document.getElementById('petType').value = petType;
                    
                    // Update selection UI
                    document.querySelectorAll('.pet-type-option').forEach(opt => {
                        opt.classList.remove('selected');
                    });
                    this.classList.add('selected');
                    
                    // Clear error
                    clearError('petTypeError');
                });
            });
            
            // Real-time validation
            document.getElementById('petType').addEventListener('input', function() {
                if (this.value.trim().length > 0) {
                    clearError('petTypeError');
                }
            });
            
            document.getElementById('location').addEventListener('input', function() {
                if (this.value.trim().length > 0) {
                    clearError('locationError');
                }
            });
            
            document.getElementById('dateFound').addEventListener('change', function() {
                const selectedDate = new Date(this.value);
                const today = new Date();
                
                if (selectedDate > today) {
                    showError('dateError', 'Date cannot be in the future');
                } else {
                    clearError('dateError');
                }
            });
            
            document.getElementById('situation').addEventListener('input', function() {
                if (this.value.trim().length > 0) {
                    clearError('situationError');
                }
            });
        });
        
        // Update character counter for situation field
        function updateCharacterCount() {
            const situation = document.getElementById('situation');
            const charCount = document.getElementById('charCount');
            const currentLength = situation.value.length;
            const maxLength = 1000;
            
            charCount.textContent = `${currentLength}/${maxLength} characters`;
            
            // Update color based on length
            if (currentLength > maxLength * 0.9) {
                charCount.className = 'situation-counter danger';
            } else if (currentLength > maxLength * 0.75) {
                charCount.className = 'situation-counter warning';
            } else {
                charCount.className = 'situation-counter';
            }
        }
        
        // Show error message
        function showError(elementId, message) {
            const errorElement = document.getElementById(elementId);
            const inputElement = document.getElementById(elementId.replace('Error', ''));
            
            errorElement.textContent = message;
            errorElement.classList.add('show');
            inputElement.classList.add('error');
        }
        
        // Clear error message
        function clearError(elementId) {
            const errorElement = document.getElementById(elementId);
            const inputElement = document.getElementById(elementId.replace('Error', ''));
            
            errorElement.textContent = '';
            errorElement.classList.remove('show');
            inputElement.classList.remove('error');
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
            
            // Validate photo
            const photoInput = document.getElementById('petPhoto');
            if (!photoInput.files || photoInput.files.length === 0) {
                showError('photoError', 'Please upload a photo of the animal');
                isValid = false;
            }
            
            // Validate pet type
            const petType = document.getElementById('petType').value.trim();
            if (!petType) {
                showError('petTypeError', 'Please specify the type of animal');
                isValid = false;
            }
            
            // Validate location
            const location = document.getElementById('location').value.trim();
            if (!location) {
                showError('locationError', 'Please provide the location where the animal was found');
                isValid = false;
            }
            
            // Validate date
            const dateFound = document.getElementById('dateFound').value;
            if (!dateFound) {
                showError('dateError', 'Please select the date when the animal was found');
                isValid = false;
            }
            
            // Validate situation
            const situation = document.getElementById('situation').value.trim();
            if (!situation) {
                showError('situationError', 'Please describe the situation');
                isValid = false;
            } else if (situation.length < 20) {
                showError('situationError', 'Please provide more details (minimum 20 characters)');
                isValid = false;
            }
            
            // If form is valid, show loading spinner
            if (isValid) {
                const submitBtn = document.getElementById('submitBtn');
                const loadingSpinner = document.getElementById('loadingSpinner');
                
                submitBtn.disabled = true;
                loadingSpinner.style.display = 'block';
                submitBtn.innerHTML = '<i class="fas fa-paper-plane"></i> Submitting...';
                submitBtn.insertBefore(loadingSpinner, submitBtn.firstChild);
            }
            
            return isValid;
        }
        
        // Sidebar toggle event listener
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
</body>
</html>