<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="com.petie.bean.UserBean"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<%
    // 1. Security Check
    UserBean user = (UserBean) session.getAttribute("userSession");
    if (user == null) { 
        response.sendRedirect("login.jsp"); 
        return; 
    }
    
    // 2. Get Messages for Notification
    String msg = request.getParameter("msg");
    String error = request.getParameter("error");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Report Stray - Petie Adoptie</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <style>
        /* --- 1. THEME VARIABLES (Matches Dashboard) --- */
        :root {
            --pet-primary: #4a90e2;       
            --pet-secondary: #f39c12;    
            --pet-success: #2ecc71;      
            --pet-danger: #e74c3c;       
            --pet-dark: #34495e;         
            --pet-gray: #95a5a6;         
            --border-radius: 12px;
            --box-shadow: 0 4px 6px rgba(0,0,0,0.05);
            --box-shadow-lg: 0 10px 15px rgba(0,0,0,0.1);
        }

        body { font-family: 'Segoe UI', sans-serif; background-color: #f4f6f9; margin: 0; }

        /* --- 2. LAYOUT WRAPPER (Fixes Sidebar & Button Cutoff) --- */
        .main-content {
            margin-left: 280px;
            padding: 30px;
            padding-bottom: 100px; /* EXTRA PADDING so button is never hidden */
            transition: margin-left 0.3s ease;
            min-height: 100vh;
        }

        .container { max-width: 900px; margin: 0 auto; }

        /* --- 3. PAGE HEADER (Red Gradient for Reporting) --- */
        .page-header {
            background: linear-gradient(135deg, var(--pet-danger) 0%, #c0392b 100%);
            color: white;
            padding: 30px;
            border-radius: var(--border-radius);
            margin-bottom: 30px;
            box-shadow: var(--box-shadow-lg);
            display: flex;
            align-items: center;
            justify-content: space-between;
            position: relative;
            overflow: hidden;
        }
        
        /* Subtle texture */
        .page-header::before {
            content: ""; position: absolute; top: -50%; right: -50%; width: 300%; height: 200%;
            background: radial-gradient(circle, rgba(255,255,255,0.1) 1px, transparent 1px);
            background-size: 20px 20px; opacity: 0.2;
        }

        .header-content { position: relative; z-index: 1; }
        .header-content h1 { margin: 0; font-size: 1.8rem; }
        .header-content p { margin: 5px 0 0; opacity: 0.9; }

        /* --- 4. NOTIFICATIONS --- */
        .alert {
            padding: 15px; border-radius: 8px; margin-bottom: 20px;
            display: flex; align-items: center; gap: 10px; font-weight: 500;
            box-shadow: var(--box-shadow);
            animation: slideDown 0.5s ease-out;
        }
        @keyframes slideDown { from { transform: translateY(-10px); opacity: 0; } to { transform: translateY(0); opacity: 1; } }

        .alert-success { background: #d4edda; color: #155724; border-left: 5px solid #28a745; }
        .alert-error   { background: #f8d7da; color: #721c24; border-left: 5px solid #dc3545; }

        /* --- 5. FORM CARD --- */
        .form-card {
            background: white;
            border-radius: var(--border-radius);
            padding: 40px;
            box-shadow: var(--box-shadow);
        }

        .form-title {
            margin-bottom: 30px; border-bottom: 2px solid #f0f0f0; padding-bottom: 15px;
            color: var(--pet-dark); font-size: 1.4rem; font-weight: 600;
        }

        /* --- 6. INPUT STYLES --- */
        .form-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 25px; }
        .full-width { grid-column: span 2; }

        .form-group label { display: block; margin-bottom: 8px; font-weight: 600; color: var(--pet-dark); }
        
        .form-control {
            width: 100%; padding: 12px; border: 2px solid #e0e0e0;
            border-radius: 8px; font-size: 15px; box-sizing: border-box;
            transition: border-color 0.3s;
        }
        .form-control:focus { border-color: var(--pet-danger); outline: none; }

        /* File Upload */
        .file-upload-box {
            border: 2px dashed #ccc; padding: 30px; text-align: center;
            border-radius: 8px; cursor: pointer; background: #fafafa;
            transition: all 0.3s;
        }
        .file-upload-box:hover { border-color: var(--pet-danger); background: #fff5f5; }
        
        .preview-img {
            max-width: 100%; height: 250px; object-fit: cover; 
            border-radius: 8px; margin-top: 15px; display: none;
            border: 1px solid #ddd; box-shadow: var(--box-shadow);
        }

        /* --- 7. BUTTONS --- */
        .form-actions {
            margin-top: 30px; padding-top: 20px; border-top: 1px solid #eee;
            display: flex; justify-content: flex-end; gap: 15px;
        }

        .btn {
            padding: 12px 25px; border-radius: 8px; font-size: 16px; font-weight: 600;
            cursor: pointer; border: none; display: inline-flex; align-items: center; gap: 8px;
            text-decoration: none; transition: transform 0.2s;
        }

        .btn-submit {
            background: linear-gradient(135deg, var(--pet-danger) 0%, #c0392b 100%);
            color: white; box-shadow: 0 4px 10px rgba(231, 76, 60, 0.3);
        }
        .btn-submit:hover { transform: translateY(-2px); box-shadow: 0 6px 15px rgba(231, 76, 60, 0.4); }

        .btn-cancel { background: white; border: 2px solid #ddd; color: #666; }
        .btn-cancel:hover { background: #f5f5f5; }

        /* Mobile */
        @media (max-width: 992px) {
            .main-content { margin-left: 0; padding-bottom: 100px; }
            .form-grid { grid-template-columns: 1fr; }
            .full-width { grid-column: span 1; }
        }
    </style>
</head>
<body>

    <jsp:include page="navbar.jsp" />

    <div class="main-content">
        <div class="container">
            
            <div class="page-header">
                <div class="header-content">
                    <h1>Report a Stray</h1>
                    <p>Help us save a life. Provide details below.</p>
                </div>
                <div style="font-size: 40px; opacity: 0.3;"><i class="fas fa-bullhorn"></i></div>
            </div>

            <% if(msg != null) { %>
                <div class="alert alert-success">
                    <i class="fas fa-check-circle"></i> <%= msg %>
                </div>
            <% } %>
            
            <% if(error != null) { %>
                <div class="alert alert-error">
                    <i class="fas fa-exclamation-triangle"></i> <%= error %>
                </div>
            <% } %>

            <div class="form-card">
                <div class="form-title"><i class="fas fa-paw"></i> Animal Details</div>

                <form action="ReportStrayServlet" method="post" enctype="multipart/form-data">
                    
                    <div class="form-grid">
                        
                        <div class="form-group full-width">
                            <label>Upload Photo *</label>
                            <label for="petPhoto" class="file-upload-box">
                                <i class="fas fa-camera" style="font-size: 30px; color: var(--pet-gray);"></i>
                                <p style="margin: 10px 0 0; color: #777;">Click to upload image (Max 5MB)</p>
                            </label>
                            <input type="file" id="petPhoto" name="petPhoto" accept="image/*" style="display:none;" onchange="previewFile()" required>
                            <img id="imgPreview" class="preview-img" alt="Pet Preview">
                        </div>

                        <div class="form-group">
                            <label>Pet Type *</label>
                            <select name="petType" class="form-control" required>
                                <option value="" disabled selected>Select Type</option>
                                <option value="Cat">Cat</option>
                                <option value="Dog">Dog</option>
                                <option value="Bird">Bird</option>
                                <option value="Rabbit">Rabbit</option>
                                <option value="Other">Other</option>
                            </select>
                        </div>

                        <div class="form-group">
                            <label>Date Found *</label>
                            <input type="date" name="dateFound" class="form-control" required>
                        </div>

                        <div class="form-group full-width">
                            <label>Location Found *</label>
                            <input type="text" name="location" class="form-control" placeholder="e.g. Near Central Park, Main Street..." required>
                        </div>

                        <div class="form-group full-width">
                            <label>Situation / Description *</label>
                            <textarea name="situation" class="form-control" rows="5" placeholder="Describe the animal's condition, behavior, or injuries..." required></textarea>
                        </div>

                    </div>

                    <div class="form-actions">
                        <a href="home.jsp" class="btn btn-cancel">Cancel</a>
                        <button type="submit" class="btn btn-submit">
                            <i class="fas fa-paper-plane"></i> Submit Report
                        </button>
                    </div>

                </form>
            </div>

        </div>
    </div>

    <script>
        function previewFile() {
            const preview = document.getElementById('imgPreview');
            const file = document.querySelector('input[type=file]').files[0];
            const reader = new FileReader();

            reader.addEventListener("load", function () {
                preview.src = reader.result;
                preview.style.display = 'block';
            }, false);

            if (file) {
                reader.readAsDataURL(file);
            }
        }
    </script>

</body>
</html>