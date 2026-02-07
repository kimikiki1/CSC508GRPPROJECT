<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Logged Out - Petie Adoption System</title>
    <link rel="stylesheet" href="style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        .logout-container {
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            padding: 20px;
        }
        
        .logout-card {
            background: white;
            border-radius: var(--border-radius);
            padding: 40px;
            text-align: center;
            box-shadow: var(--box-shadow-lg);
            max-width: 500px;
            width: 100%;
        }
        
        .logout-icon {
            font-size: 80px;
            color: var(--pet-success);
            margin-bottom: 20px;
        }
        
        .auto-redirect {
            margin-top: 30px;
            padding: 15px;
            background: #f8f9fa;
            border-radius: var(--border-radius);
            font-size: 14px;
        }
        
        .countdown {
            font-weight: bold;
            color: var(--pet-primary);
            font-size: 18px;
        }
    </style>
    <script>
        // Auto-redirect to login page after 5 seconds
        let countdown = 5;
        
        function updateCountdown() {
            document.getElementById('countdown').textContent = countdown;
            if (countdown <= 0) {
                window.location.href = 'login.jsp';
            } else {
                countdown--;
                setTimeout(updateCountdown, 1000);
            }
        }
        
        document.addEventListener('DOMContentLoaded', function() {
            // Clear any existing session data
            if (sessionStorage) {
                sessionStorage.clear();
            }
            if (localStorage) {
                // Only clear app-specific data, not all localStorage
                localStorage.removeItem('userSessionData');
                localStorage.removeItem('sidebarState');
            }
            
            // Prevent back navigation
            history.pushState(null, null, location.href);
            window.onpopstate = function() {
                history.go(1);
            };
            
            // Start countdown
            setTimeout(updateCountdown, 1000);
        });
    </script>
</head>
<body>
    <div class="logout-container">
        <div class="logout-card">
            <div class="logout-icon">
                <i class="fas fa-sign-out-alt"></i>
            </div>
            <h1>Successfully Logged Out</h1>
            <p style="color: var(--pet-gray); margin: 20px 0;">
                You have been securely logged out of the Petie Adoption System.
            </p>
            
            <c:if test="${not empty sessionScope.logoutMessage}">
                <div class="alert alert-success" style="margin: 20px 0;">
                    <i class="fas fa-check-circle"></i> ${sessionScope.logoutMessage}
                    <c:if test="${not empty sessionScope.logoutTime}">
                        <br><small>Logout time: ${sessionScope.logoutTime}</small>
                    </c:if>
                </div>
            </c:if>
            
            <p style="margin: 20px 0;">
                For security reasons, please close your browser if you're using a public computer.
            </p>
            
            <div class="auto-redirect">
                <p>You will be redirected to the login page in <span id="countdown" class="countdown">5</span> seconds.</p>
                <p>Or click the button below to login immediately.</p>
            </div>
            
            <div style="margin-top: 30px;">
                <a href="login.jsp" class="btn btn-primary" style="padding: 12px 30px;">
                    <i class="fas fa-sign-in-alt"></i> Login Again
                </a>
                <a href="index.jsp" class="btn btn-outline" style="margin-left: 10px;">
                    <i class="fas fa-home"></i> Back to Home
                </a>
            </div>
            
            <div style="margin-top: 30px; padding-top: 20px; border-top: 1px solid var(--light-gray);">
                <p style="font-size: 12px; color: var(--gray);">
                    <i class="fas fa-shield-alt"></i> For security: All session data has been cleared.
                </p>
            </div>
        </div>
    </div>
</body>
</html>