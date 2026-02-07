<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Create Account - Petie Adoptie System</title>
    <link rel="stylesheet" href="style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        /* Page-specific styles for registration */
        .register-container {
            width: 100%;
            max-width: 500px;
            margin: 0 auto;
        }
        
        /* Two-column layout for form fields on larger screens */
        .form-row {
            display: flex;
            gap: 15px;
            margin-bottom: 15px;
        }
        
        .form-group-half {
            flex: 1;
        }
        
        /* Password strength indicator */
        .password-strength {
            height: 5px;
            background-color: #e9ecef;
            border-radius: 3px;
            margin-top: 5px;
            overflow: hidden;
        }
        
        .strength-bar {
            height: 100%;
            width: 0%;
            transition: width 0.3s, background-color 0.3s;
        }
        
        .strength-weak { background-color: #e74c3c; width: 33%; }
        .strength-medium { background-color: #f39c12; width: 66%; }
        .strength-strong { background-color: #2ecc71; width: 100%; }
        
        .strength-text {
            font-size: 12px;
            margin-top: 3px;
            color: var(--gray);
        }
        
        /* Terms and conditions checkbox */
        .terms-container {
            background-color: #f8f9fa;
            border-radius: 8px;
            padding: 15px;
            margin: 20px 0;
            border-left: 4px solid var(--primary);
        }
        
        .terms-text {
            font-size: 13px;
            color: var(--gray);
            margin-top: 10px;
            max-height: 100px;
            overflow-y: auto;
            padding: 10px;
            background: white;
            border-radius: 5px;
            border: 1px solid var(--light-gray);
        }
        
        /* Required field indicator */
        .required::after {
            content: " *";
            color: var(--danger);
        }
        
        /* Decorative elements */
        .paw-decoration {
            position: fixed;
            font-size: 30px;
            opacity: 0.1;
            z-index: -1;
        }
    </style>
</head>
<body>
    <!-- Decorative paw prints in background -->
    <div class="paw-decoration" style="top: 10%; left: 5%;">🐾</div>
    <div class="paw-decoration" style="top: 20%; right: 10%;">🐾</div>
    <div class="paw-decoration" style="bottom: 30%; left: 15%;">🐾</div>
    <div class="paw-decoration" style="bottom: 20%; right: 5%;">🐾</div>
    
    <div class="container">
        <div class="register-container">
            <div class="card">
                <!-- Registration Header Section -->
                <div class="card-header">
                    <div class="logo">
                        <i class="fas fa-paw logo-icon"></i>
                        <span class="logo-text">Petie Adoptie</span>
                    </div>
                    <p>Create your account to start adopting or helping pets</p>
                </div>
                
                <div class="card-body">
                    <!-- Error Message Display -->
                    <%-- Check if there's an error message from servlet --%>
                    <c:if test="${not empty errMessage}">
                        <div class="alert alert-danger">
                            <i class="fas fa-exclamation-circle"></i> ${errMessage}
                        </div>
                    </c:if>
                    
                    <!-- Success Message Display (e.g., from login page redirect) -->
                    <c:if test="${not empty successMessage}">
                        <div class="alert alert-success">
                            <i class="fas fa-check-circle"></i> ${successMessage}
                        </div>
                    </c:if>
                    
                    <!-- Registration Illustration -->
                    <div class="text-center mb-4">
                        <i class="fas fa-user-plus" style="font-size: 60px; color: var(--primary);"></i>
                        <h3>Join Our Community</h3>
                        <p style="color: var(--gray); font-size: 14px;">Help pets find loving homes or report strays in need</p>
                    </div>
                    
                    <!-- Registration Form -->
                    <form action="RegisterServlet" method="post" id="registerForm" onsubmit="return validateForm()">
                        <!-- Username Field -->
                        <div class="form-group">
                            <label for="username" class="required">
                                <i class="fas fa-user"></i> Username
                            </label>
                            <input 
                                type="text" 
                                id="username" 
                                name="username" 
                                class="form-control" 
                                placeholder="Choose a username" 
                                required
                                value="${param.username}"
                                oninput="checkUsernameAvailability()"
                            >
                            <small style="font-size: 12px; color: var(--gray);">
                                Letters, numbers, and underscores only (3-20 characters)
                            </small>
                            <div id="usernameFeedback" style="font-size: 12px; margin-top: 5px;"></div>
                        </div>
                        
                        <!-- Email Field -->
                        <div class="form-group">
                            <label for="email" class="required">
                                <i class="fas fa-envelope"></i> Email Address
                            </label>
                            <input 
                                type="email" 
                                id="email" 
                                name="email" 
                                class="form-control" 
                                placeholder="Enter your email" 
                                required
                                value="${param.email}"
                            >
                            <small style="font-size: 12px; color: var(--gray);">
                                We'll send a confirmation email to this address
                            </small>
                        </div>
                        
                        <!-- Two-column layout for Name and Phone -->
                        <div class="form-row">
                            <div class="form-group-half">
                                <label for="fullname" class="required">
                                    <i class="fas fa-id-card"></i> Full Name
                                </label>
                                <input 
                                    type="text" 
                                    id="fullname" 
                                    name="fullname" 
                                    class="form-control" 
                                    placeholder="Your full name" 
                                    required
                                    value="${param.fullname}"
                                >
                            </div>
                            
                            <div class="form-group-half">
                                <label for="phone" class="required">
                                    <i class="fas fa-phone"></i> Phone Number
                                </label>
                                <input 
                                    type="text" 
                                    id="phone" 
                                    name="phone" 
                                    class="form-control" 
                                    placeholder="e.g., 0123456789" 
                                    required
                                    value="${param.phone}"
                                >
                            </div>
                        </div>
                        
                        <!-- Password Field with Strength Indicator -->
                        <div class="form-group">
                            <label for="password" class="required">
                                <i class="fas fa-lock"></i> Password
                            </label>
                            <input 
                                type="password" 
                                id="password" 
                                name="password" 
                                class="form-control" 
                                placeholder="Create a strong password" 
                                required
                                onkeyup="checkPasswordStrength()"
                            >
                            <!-- Password strength indicator -->
                            <div class="password-strength">
                                <div class="strength-bar" id="strengthBar"></div>
                            </div>
                            <div class="strength-text" id="strengthText">
                                Password strength: None
                            </div>
                            <small style="font-size: 12px; color: var(--gray);">
                                Minimum 8 characters with at least 1 letter and 1 number
                            </small>
                        </div>
                        
                        <!-- Confirm Password Field -->
                        <div class="form-group">
                            <label for="confirmPassword" class="required">
                                <i class="fas fa-lock"></i> Confirm Password
                            </label>
                            <input 
                                type="password" 
                                id="confirmPassword" 
                                name="confirmPassword" 
                                class="form-control" 
                                placeholder="Re-enter your password" 
                                required
                            >
                            <div id="passwordMatch" style="font-size: 12px; margin-top: 5px;"></div>
                        </div>
                        
                        <!-- Terms and Conditions -->
                        <div class="terms-container">
                            <div style="display: flex; align-items: flex-start; gap: 10px;">
                                <input 
                                    type="checkbox" 
                                    id="terms" 
                                    name="terms" 
                                    required
                                    style="margin-top: 3px;"
                                >
                                <label for="terms" style="font-size: 14px;">
                                    I agree to the <a href="terms.jsp" class="link" target="_blank">Terms and Conditions</a> 
                                    and <a href="privacy.jsp" class="link" target="_blank">Privacy Policy</a>
                                </label>
                            </div>
                            <div class="terms-text">
                                <strong>By creating an account, you agree to:</strong><br>
                                1. Provide accurate information<br>
                                2. Treat animals with care and respect<br>
                                3. Follow adoption procedures<br>
                                4. Allow staff to conduct home visits if required<br>
                                5. Not use the platform for commercial breeding
                            </div>
                        </div>
                        
                        <!-- Submit Button -->
                        <button type="submit" class="btn btn-primary btn-block mb-3">
                            <i class="fas fa-user-plus"></i> Create Account
                        </button>
                        
                        <!-- Alternative Registration Options -->
                        <div class="text-center mb-3" style="color: var(--gray); font-size: 14px;">
                            — or register with —
                        </div>
                        
                    </form>
                    
                    <!-- Login Link -->
                    <div class="register-link text-center">
                        <p>Already have an account?</p>
                        <a href="login.jsp" class="btn btn-outline btn-block">
                            <i class="fas fa-sign-in-alt"></i> Login to Existing Account
                        </a>
                    </div>
                    
                    <!-- Footer Links -->
                    <div class="footer-links">
                        <a href="index.jsp" class="link"><i class="fas fa-home"></i> Home</a>
                        <a href="about.jsp" class="link"><i class="fas fa-info-circle"></i> About</a>
                        <a href="contact.jsp" class="link"><i class="fas fa-phone"></i> Contact</a>
                    </div>
                </div>
            </div>
            
            <!-- Page Footer -->
            <div class="text-center mt-4" style="color: rgba(255,255,255,0.8); font-size: 13px;">
                <p>© 2023 Petie Adoptie System. All rights reserved.</p>
                <p>Creating happy endings for pets and humans</p>
            </div>
        </div>
    </div>
    
    <!-- JavaScript for Form Validation and Interactive Features -->
    <script>
        // Function to check password strength
        function checkPasswordStrength() {
            const password = document.getElementById('password').value;
            const strengthBar = document.getElementById('strengthBar');
            const strengthText = document.getElementById('strengthText');
            
            // Reset
            strengthBar.className = 'strength-bar';
            strengthText.textContent = 'Password strength: None';
            
            if (password.length === 0) return;
            
            // Calculate strength
            let strength = 0;
            
            // Length check
            if (password.length >= 8) strength += 1;
            if (password.length >= 12) strength += 1;
            
            // Character variety checks
            if (/[a-z]/.test(password)) strength += 1;
            if (/[A-Z]/.test(password)) strength += 1;
            if (/[0-9]/.test(password)) strength += 1;
            if (/[^A-Za-z0-9]/.test(password)) strength += 1;
            
            // Update UI based on strength
            if (strength <= 2) {
                strengthBar.className = 'strength-bar strength-weak';
                strengthText.textContent = 'Password strength: Weak';
                strengthText.style.color = '#e74c3c';
            } else if (strength <= 4) {
                strengthBar.className = 'strength-bar strength-medium';
                strengthText.textContent = 'Password strength: Medium';
                strengthText.style.color = '#f39c12';
            } else {
                strengthBar.className = 'strength-bar strength-strong';
                strengthText.textContent = 'Password strength: Strong';
                strengthText.style.color = '#2ecc71';
            }
            
            // Check password match
            checkPasswordMatch();
        }
        
        // Function to check if passwords match
        function checkPasswordMatch() {
            const password = document.getElementById('password').value;
            const confirmPassword = document.getElementById('confirmPassword').value;
            const matchDiv = document.getElementById('passwordMatch');
            
            if (confirmPassword.length === 0) {
                matchDiv.textContent = '';
                return;
            }
            
            if (password === confirmPassword) {
                matchDiv.innerHTML = '<span style="color: #2ecc71;"><i class="fas fa-check-circle"></i> Passwords match</span>';
            } else {
                matchDiv.innerHTML = '<span style="color: #e74c3c;"><i class="fas fa-times-circle"></i> Passwords do not match</span>';
            }
        }
        
        // Function to simulate username availability check
        function checkUsernameAvailability() {
            const username = document.getElementById('username').value;
            const feedbackDiv = document.getElementById('usernameFeedback');
            
            if (username.length < 3) {
                feedbackDiv.innerHTML = '<span style="color: #f39c12;">Username must be at least 3 characters</span>';
                return;
            }
            
            // Simple validation
            if (!/^[a-zA-Z0-9_]+$/.test(username)) {
                feedbackDiv.innerHTML = '<span style="color: #e74c3c;">Only letters, numbers, and underscores allowed</span>';
                return;
            }
            
            // Simulate checking against common usernames
            const takenUsernames = ['admin', 'staff', 'mike', 'test', 'user'];
            if (takenUsernames.includes(username.toLowerCase())) {
                feedbackDiv.innerHTML = '<span style="color: #e74c3c;"><i class="fas fa-times-circle"></i> Username is taken</span>';
            } else {
                feedbackDiv.innerHTML = '<span style="color: #2ecc71;"><i class="fas fa-check-circle"></i> Username is available</span>';
            }
        }
        
        // Function to validate entire form before submission
        function validateForm() {
            const password = document.getElementById('password').value;
            const confirmPassword = document.getElementById('confirmPassword').value;
            const terms = document.getElementById('terms').checked;
            
            // Check password match
            if (password !== confirmPassword) {
                alert('Passwords do not match!');
                document.getElementById('confirmPassword').focus();
                return false;
            }
            
            // Check password strength
            if (password.length < 8) {
                alert('Password must be at least 8 characters long!');
                document.getElementById('password').focus();
                return false;
            }
            
            // Check terms agreement
            if (!terms) {
                alert('You must agree to the Terms and Conditions!');
                return false;
            }
            
            // Check phone number format (simple validation)
            const phone = document.getElementById('phone').value;
            const phoneRegex = /^[0-9]{10,15}$/;
            if (!phoneRegex.test(phone.replace(/[\s\-\(\)]/g, ''))) {
                alert('Please enter a valid phone number (10-15 digits)');
                document.getElementById('phone').focus();
                return false;
            }
            
            return true; // Form is valid
        }
        
        // Initialize form validation on load
        document.addEventListener('DOMContentLoaded', function() {
            // Add event listeners for real-time validation
            document.getElementById('confirmPassword').addEventListener('keyup', checkPasswordMatch);
            
            // Animate card appearance
            const card = document.querySelector('.card');
            card.style.opacity = '0';
            card.style.transform = 'translateY(20px)';
            
            setTimeout(() => {
                card.style.transition = 'opacity 0.5s ease, transform 0.5s ease';
                card.style.opacity = '1';
                card.style.transform = 'translateY(0)';
            }, 100);
            
            // Focus on first input field
            document.getElementById('username').focus();
        });
    </script>
</body>
</html>