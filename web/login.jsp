<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - Petie Adoption System</title>
    <link rel="stylesheet" href="style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        /* Additional styles for login page */
        .login-container {
            width: 100%;
            max-width: 450px;
            margin: 0 auto;
        }
        
        .login-illustration {
            text-align: center;
            margin-bottom: 25px;
        }
        
        .login-illustration i {
            font-size: 70px;
            color: var(--primary);
            margin-bottom: 10px;
        }
        
        .forgot-password {
            display: block;
            text-align: right;
            margin-top: 5px;
            font-size: 13px;
        }
        
        .register-link {
            margin-top: 25px;
            padding-top: 20px;
            border-top: 1px solid var(--light-gray);
            font-size: 14px;
        }
        
        .demo-accounts {
            background-color: #f8f9fa;
            border-radius: 8px;
            padding: 15px;
            margin-top: 25px;
            border-left: 4px solid var(--secondary);
        }
        
        .demo-accounts h4 {
            color: var(--dark);
            margin-bottom: 10px;
            font-size: 14px;
        }
        
        .demo-account {
            display: flex;
            justify-content: space-between;
            margin-bottom: 8px;
            font-size: 13px;
        }
        
        .role-badge {
            background-color: var(--primary);
            color: white;
            padding: 2px 8px;
            border-radius: 12px;
            font-size: 11px;
            font-weight: 600;
        }
        
        .role-badge.admin {
            background-color: var(--danger);
        }
        
        .role-badge.staff {
            background-color: var(--secondary);
        }
        
        .paw-decoration {
            position: fixed;
            font-size: 30px;
            opacity: 0.1;
            z-index: -1;
        }
    </style>
</head>
<body>
    <!-- Decorative paw prints -->
    <div class="paw-decoration" style="top: 10%; left: 10%;">🐾</div>
    <div class="paw-decoration" style="top: 15%; right: 15%;">🐾</div>
    <div class="paw-decoration" style="bottom: 20%; left: 20%;">🐾</div>
    <div class="paw-decoration" style="bottom: 15%; right: 10%;">🐾</div>
    
    <div class="container">
        <div class="login-container">
            <div class="card">
                <div class="card-header">
                    <div class="logo">
                        <i class="fas fa-paw logo-icon"></i>
                        <span class="logo-text">Petie Adoptie</span>
                    </div>
                    <p>Welcome back! Please login to continue</p>
                </div>
                
                <div class="card-body">
                    <%-- Display error message if exists --%>
                    <c:if test="${not empty errMessage}">
                        <div class="alert alert-danger">
                            <i class="fas fa-exclamation-circle"></i> ${errMessage}
                        </div>
                    </c:if>
                    
                    <%-- Success message for registration --%>
                    <c:if test="${not empty successMessage}">
                        <div class="alert alert-success">
                            <i class="fas fa-check-circle"></i> ${successMessage}
                        </div>
                    </c:if>
                   
                    <c:if test="${not empty param.logout and param.logout == 'success'}">
                        <div class="alert alert-success">
                            <i class="fas fa-check-circle"></i> You have been successfully logged out.
                        </div>
                    </c:if>
                    
                    <div class="login-illustration">
                        <i class="fas fa-dog"></i>
                        <h3>Find Your Forever Friend</h3>
                        <p style="color: var(--gray); font-size: 14px;">Login to browse adoptable pets or report strays</p>
                    </div>
                    
                    <form action="LoginServlet" method="post">
                        <div class="form-group">
                            <label for="email">
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
                        </div>
                        
                        <div class="form-group">
                            <label for="password">
                                <i class="fas fa-lock"></i> Password
                            </label>
                            <input 
                                type="password" 
                                id="password" 
                                name="password" 
                                class="form-control" 
                                placeholder="Enter your password" 
                                required
                            >
                        </div>
                        
                        <button type="submit" class="btn btn-primary btn-block mb-4">
                            <i class="fas fa-sign-in-alt"></i> Login to Your Account
                        </button>
                    </form>
                    
                    <div class="register-link text-center">
                        <p>Don't have an account yet?</p>
                        <a href="register.jsp" class="btn btn-outline btn-block">
                            <i class="fas fa-user-plus"></i> Create New Account
                        </a>
                    </div>
                    
                    <!-- Demo Accounts (Remove in production) -->
                    <div class="demo-accounts">
                        <h4><i class="fas fa-vial"></i> Demo Accounts (For Testing)</h4>
                        <div class="demo-account">
                            <span><strong>Admin:</strong> admin@petie.com</span>
                            <span class="role-badge admin">ADMIN</span>
                        </div>
                        <div class="demo-account">
                            <span><strong>Staff:</strong> staff@petie.com</span>
                            <span class="role-badge staff">STAFF</span>
                        </div>
                        <div class="demo-account">
                            <span><strong>User:</strong> mike@gmail.com</span>
                            <span class="role-badge">USER</span>
                        </div>
                        <div style="font-size: 12px; color: var(--gray); margin-top: 5px;">
                            <i class="fas fa-info-circle"></i> Password: 123 (for all accounts)
                        </div>
                    </div>
                    
                    <div class="footer-links">
                        <a href="index.jsp" class="link"><i class="fas fa-home"></i> Home</a>
                        <a href="about.jsp" class="link"><i class="fas fa-info-circle"></i> About</a>
                        <a href="contact.jsp" class="link"><i class="fas fa-phone"></i> Contact</a>
                    </div>
                </div>
            </div>
            
            <div class="text-center mt-4" style="color: rgba(255,255,255,0.8); font-size: 13px;">
                <p>© 2023 Petie Adoptie System. All rights reserved.</p>
                <p>Helping pets find loving homes since 2023</p>
            </div>
        </div>
    </div>
    
    <script>
        // Simple animation on load
        document.addEventListener('DOMContentLoaded', function() {
            const card = document.querySelector('.card');
            card.style.opacity = '0';
            card.style.transform = 'translateY(20px)';
            
            setTimeout(() => {
                card.style.transition = 'opacity 0.5s ease, transform 0.5s ease';
                card.style.opacity = '1';
                card.style.transform = 'translateY(0)';
            }, 100);
            
            // Add focus effect to form inputs
            const inputs = document.querySelectorAll('.form-control');
            inputs.forEach(input => {
                input.addEventListener('focus', function() {
                    this.parentElement.style.transform = 'scale(1.02)';
                });
                
                input.addEventListener('blur', function() {
                    this.parentElement.style.transform = 'scale(1)';
                });
            });
        });
    </script>
</body>
</html>