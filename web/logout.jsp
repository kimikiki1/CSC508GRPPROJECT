<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Logged Out</title>
    <meta http-equiv="refresh" content="3;url=login.jsp" />
    <style>
        body { 
            font-family: Arial, sans-serif; 
            background-color: #87ceeb; 
            text-align: center; 
            padding-top: 100px; 
        }
        .message-box {
            background-color: white;
            width: 400px;
            margin: auto;
            padding: 40px;
            border-radius: 10px;
            box-shadow: 0 4px 10px rgba(0,0,0,0.2);
        }
        h1 { color: #003366; }
        a { color: #28a745; font-weight: bold; text-decoration: none; }
    </style>
</head>
<body>

    <div class="message-box">
        <h1>You have been logged out.</h1>
        <p>Thank you for visiting Petie Adoptie!</p>
        <p>Redirecting to login page in 3 seconds...</p>
        <br>
        <a href="login.jsp">Click here if not redirected</a>
    </div>

</body>
</html>